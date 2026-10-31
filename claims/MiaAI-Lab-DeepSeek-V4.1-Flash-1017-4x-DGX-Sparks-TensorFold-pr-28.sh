#!/usr/bin/env bash
# claim: PR #28 "0039 a reply grammar that cannot start fails only its own request" --
#   When a request's reply grammar cannot be BUILT AT ADMISSION (LaneHost.constraint: xgrammar
#   matcher build throws, or OOM creating the Constraint / duplicating the ban list), the base
#   build's `setup` returns drop()'s `true` -- reporting SUCCESS for a job it just freed -- and the
#   callers then use the freed job (job.began, loneFits, addStream, fillStream): a use-after-free on
#   the single engine host thread that serves every request. The patch makes `setup` return `false`
#   so the failure is contained to its own request and the server keeps serving.
#
# Exercised by: a `tool_choice:"required"` structured request (REVIEW.md s2's untested
#   "required/named tool request"). Of every admission grammar path this is the heaviest: it builds a
#   structural-tag reply grammar AND a ban list at admission -- the two allocations the changed code
#   guards. We stream it (an admission drop arrives MID-stream, after a 200/SSE opens; a preflight
#   refusal is a clean 400 BEFORE the stream -- 0028: "preflight refusals never enter the generation
#   loop"), then re-check server health. "Holds" = an admission grammar-build failure was returned to
#   its own request as a clean error AND the server still serves afterwards (no use-after-free).
#
# From REVIEW.md s2: the decisive condition is "a structured request passing preflight but failing
#   grammar creation at admission, or successful grammar creation followed by Stream.init failure ...
#   no injected compile/matcher/allocation failure, no required/named tool request". That condition is
#   an INJECTED admission failure; it is not reachable through the public API with safe, deterministic
#   inputs (every malformed grammar is caught at preflight, a path the patch does not touch; every
#   well-formed grammar builds its matcher at admission; the only admission failures are allocation
#   failures that would require exhausting memory on a shared live service, which we do not do). So on
#   a build where that failure cannot be observed to be contained -- the base, and any endpoint the
#   fault cannot be injected into -- the containment evidence is absent and the script prints
#   `CLAIM: does not hold`. It prints `CLAIM: holds` only if a contained admission-build failure is
#   actually observed.
set -u
API=${1:?usage: claim.sh API MODEL}
MODEL=${2:?usage: claim.sh API MODEL}

python3 - "$API" "$MODEL" <<'PY'
import json, sys, urllib.request, urllib.error
API, MODEL = sys.argv[1], sys.argv[2]
API = API.rstrip("/")

def post(body, timeout=120):
    """Return (http_status, raw_text). http_status is None on a transport failure."""
    req = urllib.request.Request(API + "/chat/completions",
                                 json.dumps(body).encode(), {"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read().decode(errors="ignore")
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode(errors="ignore")
    except (urllib.error.URLError, OSError, ValueError) as e:
        return None, f"{type(e).__name__}: {e}"

def classify(status, text):
    """How did this structured request resolve?"""
    if status is None:
        return "transport", text
    if "could not start (xgrammar)" in text or '"message": "out of memory"' in text:
        return "admission-drop", text            # <- the path the patch changes
    if "GrammarDeadEnd" in text:
        return "fill-deadend", text              # generation-time, not the changed path
    if status == 400 and '"error"' in text:
        return "preflight-400", text             # unchanged path
    if status == 200:
        return "ok", text
    return "other", text

def healthy():
    """A plain greedy completion returns content: the host thread is still serving."""
    st, txt = post({"model": MODEL, "temperature": 0, "max_tokens": 8,
                    "messages": [{"role": "user", "content": "say hi"}],
                    "chat_template_kwargs": {"thinking": False, "enable_thinking": False}}, timeout=60)
    if st != 200:
        return False, f"status={st} body={txt[:160]}"
    try:
        c = (json.loads(txt)["choices"][0]["message"].get("content") or "")
    except Exception as e:
        return False, f"unparseable reply: {e}"
    return (len(c.strip()) > 0), f"content={c!r}"

def err(why):
    print(f"CLAIM: error {why}"); sys.exit(2)

# --- 0. the server must be up and serving before we start, or the check is impossible ---
ok, info = healthy()
if not ok:
    # distinguish "down" (can't check) from "up but not answering" (also can't check)
    err(f"base API not serving a plain completion before the test ({info})")
print(f"health before: ok ({info})")

# --- 1. drive the admission grammar-build path; a required tool call is the on-point request ---
TOOLS = [{"type": "function", "function": {
    "name": "get_weather",
    "parameters": {"type": "object",
                   "properties": {"city": {"type": "string"}, "unit": {"type": "string", "enum": ["c", "f"]}},
                   "required": ["city"]}}}]
probes = [
    ("tool_choice required (structural tag + ban list at admission)",
     {"tool_choice": "required", "tools": TOOLS}),
    ("tool_choice named function",
     {"tool_choice": {"type": "function", "function": {"name": "get_weather"}}, "tools": TOOLS}),
    ("guided_grammar (reply grammar at admission)",
     {"guided_grammar": "root ::= \"yes\" | \"no\""}),
    ("response_format json_schema",
     {"response_format": {"type": "json_schema", "json_schema":
        {"name": "p", "schema": {"type": "object", "properties": {"n": {"type": "string"}}, "required": ["n"]}}}}),
    ("guided_choice", {"guided_choice": ["yes", "no"]}),
]

saw_admission_drop = False
for label, extra in probes:
    body = {"model": MODEL, "temperature": 0, "max_tokens": 16, "stream": True,
            "messages": [{"role": "user", "content": "weather in Paris?"}],
            "chat_template_kwargs": {"thinking": False, "enable_thinking": False}}
    body.update(extra)
    st, txt = post(body, timeout=120)
    kind, _ = classify(st, txt)
    print(f"probe [{kind}] {label}  (http {st})")
    if kind == "transport":
        err(f"request to the base API failed: {txt[:160]}")
    if kind == "admission-drop":
        saw_admission_drop = True

# --- 2. did driving that path leave the host thread alive? (a use-after-free would wedge it) ---
ok_after, info_after = healthy()
print(f"health after: {'ok' if ok_after else 'WEDGED'} ({info_after})")

# --- 3. verdict -------------------------------------------------------------------------------
if saw_admission_drop and ok_after:
    # an admission grammar-build failure was returned to its own request, and the server survived:
    # exactly the containment the patch provides (setup returned false; no use of a freed job).
    print("evidence: an admission-time grammar-build failure was contained to its own request; "
          "the server kept serving -- no use-after-free")
    print("CLAIM: holds"); sys.exit(0)

if saw_admission_drop and not ok_after:
    # the failure fired but the host thread is gone: the base's setup reported success for a freed
    # job and the callers used it -- the use-after-free this patch removes.
    print("evidence: an admission-time grammar-build failure was followed by a wedged server "
          "(use-after-free on the host thread)")
    print("CLAIM: does not hold"); sys.exit(1)

# No admission grammar-build failure could be elicited: every structured request either succeeded or
# was rejected at preflight (the unchanged path), so the condition the patch changes never ran and its
# containment cannot be observed. This is the base's result, and REVIEW.md s2's injected failure is
# not reachable through the public API with safe deterministic inputs.
print("evidence: no admission-time grammar-build failure could be elicited through the API "
      "(malformed grammars stop at preflight; well-formed grammars build at admission); "
      "the patched containment path was not exercised, so the claim is not demonstrated here")
print("CLAIM: does not hold"); sys.exit(1)
PY

# ---------------------------------------------------------------------------------------------
# Run against the base build (model DeepSeek-V4.1-Flash-1017), 2026-10-31:
#
#   health before: ok (content='Hi! 👋 How can I help')
#   probe [ok] tool_choice required (structural tag + ban list at admission)  (http 200)
#   probe [ok] tool_choice named function  (http 200)
#   probe [ok] guided_grammar (reply grammar at admission)  (http 200)
#   probe [ok] response_format json_schema  (http 200)
#   probe [ok] guided_choice  (http 200)
#   health after: ok (content='Hi! 👋 How can I help')
#   evidence: no admission-time grammar-build failure could be elicited through the API (malformed
#     grammars stop at preflight; well-formed grammars build at admission); the patched containment
#     path was not exercised, so the claim is not demonstrated here
#   CLAIM: does not hold
#   exit=1
#
# As required against the base: every structured request reaches the admission grammar build and
# succeeds, so the use-after-free path the patch removes never fires and its fix cannot be observed
# -> "does not hold". Reaching that path needs an injected matcher/allocation failure at admission
# (REVIEW.md s2), which is not producible through the public API with safe, deterministic inputs.
