#!/usr/bin/env bash
# claim: 0047: a DSML block closes at its last closer, so a value holding the closer stays in the call (#14).
# Claim tested (PR.md, table rows 1 and 2): a DSML tool call whose string value contains the block's own closer
# `</｜DSML｜ calls>` comes back, whole and streamed, as one `write` call with the value intact, finish_reason
# `tool_calls`, and no DSML closer in the content. On the base the block is cut at the inner closer: no call,
# finish `stop`, the whole block as text (whole) or only the trailing closers (stream).
# How: the reply's text is forced with guided_regex (structured output), temperature 0, thinking off, a `write` tool
# offered, so the run is deterministic and the parser reads exactly that text. A control call with a plain value must
# parse in both modes first (both builds should pass it); otherwise the server cannot judge and the script exits 2.
# From REVIEW.md §2: "guided_regex forces a write call whose string value contains </｜DSML｜ calls>, in whole and
# streamed responses. Candidate returns the intact call; base drops it and leaks markup."
API=$1; MODEL=$2
if [ -z "$API" ] || [ -z "$MODEL" ]; then echo "usage: $0 API MODEL [LOGCMD]" >&2; echo "CLAIM: error missing arguments"; exit 2; fi
exec python3 - "$API" "$MODEL" <<'PY'
import json, re, sys, urllib.error, urllib.request
api, model = sys.argv[1].rstrip("/"), sys.argv[2]
D = "｜DSML｜"
CLOSER = "</" + D
TOOLS = [{"type": "function", "function": {"name": "write", "description": "Write a file",
          "parameters": {"type": "object", "properties": {"path": {"type": "string"}, "content": {"type": "string"}},
                         "required": ["path", "content"]}}}]

def block(value):
    return (f"<{D} calls>\n<{D} invoke name=\"write\">\n<{D} parameter name=\"path\" string=\"true\">notes.md</{D} parameter>\n"
            f"<{D} parameter name=\"content\" string=\"true\">{value}</{D} parameter>\n</{D} invoke>\n</{D} calls>")

def error(msg):
    print(f"CLAIM: error {msg}"[:300]); sys.exit(2)

def ask(text, stream):
    body = {"model": model, "temperature": 0, "max_tokens": 256, "tools": TOOLS, "guided_regex": re.escape(text),
            "messages": [{"role": "user", "content": "Write notes.md with the write tool."}],
            "chat_template_kwargs": {"thinking": False, "enable_thinking": False}}
    if stream: body["stream"] = True
    req = urllib.request.Request(api + "/chat/completions", json.dumps(body).encode(), {"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=180) as r:
            status = r.status
            if not stream:
                o = json.load(r); c = o["choices"][0]
                calls = [(t["function"]["name"], json.loads(t["function"]["arguments"])) for t in c["message"].get("tool_calls") or []]
                return dict(status=status, content=c["message"].get("content") or "", calls=calls, finish=c.get("finish_reason"))
            content, finish, parts, done = "", None, {}, False
            for line in r:
                if not line.startswith(b"data: "): continue
                if line.strip() == b"data: [DONE]": done = True; break
                for c in json.loads(line[6:]).get("choices", []):
                    d = c.get("delta") or {}; content += d.get("content") or ""; finish = c.get("finish_reason") or finish
                    for t in d.get("tool_calls") or []:
                        p = parts.setdefault(t.get("index", 0), {"name": "", "arguments": ""})
                        f = t.get("function") or {}
                        p["name"] += f.get("name") or ""; p["arguments"] += f.get("arguments") or ""
            if not done: error("stream ended without [DONE]")
            calls = [(p["name"], json.loads(p["arguments"] or "{}")) for _, p in sorted(parts.items())]
            return dict(status=status, content=content, calls=calls, finish=finish)
    except urllib.error.HTTPError as e:
        error(f"HTTP {e.code}: {e.read()[:200].decode(errors='ignore')}")
    except (urllib.error.URLError, OSError, ValueError, KeyError, IndexError, TypeError) as e:
        error(f"{type(e).__name__}: {e}")

def good(r, value):
    return (r["status"] == 200 and r["calls"] == [("write", {"path": "notes.md", "content": value})]
            and r["finish"] == "tool_calls" and CLOSER not in r["content"])

def show(name, r):
    print(f"{name}: status={r['status']} finish={r['finish']} tool_calls={json.dumps(r['calls'], ensure_ascii=False)} "
          f"content={json.dumps(r['content'], ensure_ascii=False)}")

plain = "plain text"
for stream in (False, True):
    r = ask(block(plain), stream); show(f"control, {'stream' if stream else 'whole'}", r)
    if not good(r, plain): error("a plain DSML call does not parse; this server cannot judge the case")
held = f"end of block: </{D} calls>"
ok = True
for stream in (False, True):
    name = f"value holds the closer, {'stream' if stream else 'whole'}"
    r = ask(block(held), stream); show(name, r)
    if good(r, held):
        print(f"  ok {name}: one write call, value intact, finish=tool_calls, no closer in content")
    else:
        ok = False
        print(f"  FAIL {name}: expected one write call with content={json.dumps(held, ensure_ascii=False)}, "
              "finish=tool_calls and no DSML closer in content")
print("CLAIM: holds" if ok else "CLAIM: does not hold"); sys.exit(0 if ok else 1)
PY

# Run against the base build (2026-11-03):
# control, whole: status=200 finish=tool_calls tool_calls=[["write", {"path": "notes.md", "content": "plain text"}]] content=""
# control, stream: status=200 finish=tool_calls tool_calls=[["write", {"path": "notes.md", "content": "plain text"}]] content=""
# value holds the closer, whole: status=200 finish=stop tool_calls=[] content="<｜DSML｜ calls>\n<｜DSML｜ invoke name=\"write\">\n<｜DSML｜ parameter name=\"path\" string=\"true\">notes.md</｜DSML｜ parameter>\n<｜DSML｜ parameter name=\"content\" string=\"true\">end of block: </｜DSML｜ calls></｜DSML｜ parameter>\n</｜DSML｜ invoke>\n</｜DSML｜ calls>"
#   FAIL value holds the closer, whole: expected one write call with content="end of block: </｜DSML｜ calls>", finish=tool_calls and no DSML closer in content
# value holds the closer, stream: status=200 finish=stop tool_calls=[] content="</｜DSML｜ parameter>\n</｜DSML｜ invoke>\n</｜DSML｜ calls>"
#   FAIL value holds the closer, stream: expected one write call with content="end of block: </｜DSML｜ calls>", finish=tool_calls and no DSML closer in content
# CLAIM: does not hold
# exit=1
