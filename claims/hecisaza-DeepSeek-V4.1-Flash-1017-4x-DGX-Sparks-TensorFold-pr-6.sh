#!/usr/bin/env bash
# claim: 0047: a DSML block closes at its last closer, so a value holding the closer stays in the call (#14).
# Claim tested (PR.md): a DSML tool call whose string value contains the block's own closer comes back as one tool call
# with the value intact, finish_reason "tool_calls", and no DSML closer in the content, both whole and streamed, in
# both spellings (V4.1 `<｜DSML｜ calls>` and V4 `<｜DSML｜tool_calls>`); two such blocks with prose between them stay
# two calls and keep the prose. On the base the call is dropped and the closers leak as content with finish "stop".
# How: the reply's text is forced with guided_regex (greedy, thinking off, a `write` tool offered), so the parser and
# the stream filter read exactly that text. A plain-value control in each spelling and mode must parse as one call
# with finish "tool_calls" on any build, or the check cannot judge (exit 2): a build that rejects or mangles ordinary
# calls cannot pass.
# From REVIEW.md §2: "guided_regex forces a `write` call containing `</｜DSML｜ calls>` inside its string value, both
# streamed and non-streamed. The base drops the call and leaks markup; the candidate preserves it." It also names the
# alternate spelling and multiple blocks as lacking executed coverage; both are exercised here.
API=$1; MODEL=$2
if [ -z "$API" ] || [ -z "$MODEL" ]; then echo "usage: $0 API MODEL [LOGCMD]"; echo "CLAIM: error missing arguments"; exit 2; fi
exec python3 - "$API" "$MODEL" <<'PY'
import json, re, sys, urllib.error, urllib.request
api, model = sys.argv[1].rstrip("/"), sys.argv[2]
D = "｜DSML｜"
TOOLS = [{"type": "function", "function": {"name": "write", "description": "Write a file",
          "parameters": {"type": "object", "properties": {"path": {"type": "string"}, "content": {"type": "string"}},
                         "required": ["path", "content"]}}}]
# (name, opener/closer word, separator between the marker and the tag name)
SPELLINGS = [("V4.1", "calls", " "), ("V4", "tool_calls", "")]

def block(sp, value):
    _, w, s = sp
    return (f"<{D}{s}{w}>\n<{D}{s}invoke name=\"write\">\n<{D}{s}parameter name=\"path\" string=\"true\">notes.md</{D}{s}parameter>\n"
            f"<{D}{s}parameter name=\"content\" string=\"true\">{value}</{D}{s}parameter>\n</{D}{s}invoke>\n</{D}{s}{w}>")

def closer(sp):
    return f"</{D}{sp[2]}{sp[1]}>"

def error(msg):
    print(f"CLAIM: error {msg}"); sys.exit(2)

def ask(text, stream):
    body = {"model": model, "temperature": 0, "max_tokens": 512, "tools": TOOLS, "guided_regex": re.escape(text),
            "messages": [{"role": "user", "content": "Write notes.md with the write tool."}],
            "chat_template_kwargs": {"thinking": False, "enable_thinking": False}}
    if stream: body["stream"] = True
    req = urllib.request.Request(api + "/chat/completions", json.dumps(body).encode(), {"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=300) as r:
            if not stream:
                o = json.load(r); c = o["choices"][0]
                calls = [(t["function"]["name"], json.loads(t["function"]["arguments"])) for t in c["message"].get("tool_calls") or []]
                return dict(content=c["message"].get("content") or "", calls=calls, finish=c.get("finish_reason"))
            content, finish, parts, done = "", None, {}, False
            for line in r:
                if not line.startswith(b"data: "): continue
                if line.strip() == b"data: [DONE]": done = True; break
                for c in json.loads(line[6:]).get("choices", []):
                    d = c.get("delta", {}); content += d.get("content") or ""; finish = c.get("finish_reason") or finish
                    for t in d.get("tool_calls") or []:
                        p = parts.setdefault(t.get("index", 0), {"name": "", "arguments": ""})
                        f = t.get("function") or {}
                        p["name"] += f.get("name") or ""; p["arguments"] += f.get("arguments") or ""
            if not done: error("stream ended without [DONE]")
            calls = [(p["name"], json.loads(p["arguments"] or "{}")) for _, p in sorted(parts.items())]
            return dict(content=content, calls=calls, finish=finish)
    except urllib.error.HTTPError as e:
        error(f"HTTP {e.code}: {e.read()[:200].decode(errors='ignore')}")
    except (urllib.error.URLError, OSError, ValueError, KeyError, IndexError, TypeError) as e:
        error(f"{type(e).__name__}: {e}"[:200])

def show(name, r):
    print(f"{name}: finish={r['finish']} tool_calls={json.dumps(r['calls'], ensure_ascii=False)} content={json.dumps(r['content'], ensure_ascii=False)[:400]}")

def one_call(r, value):
    return (r["calls"] == [("write", {"path": "notes.md", "content": value})] and r["finish"] == "tool_calls"
            and D not in r["content"])

ok = True
for sp in SPELLINGS:
    held = f"end of block: {closer(sp)}"
    for stream in (False, True):
        mode = "stream" if stream else "whole"
        r = ask(block(sp, "plain text"), stream); show(f"{sp[0]} control, {mode}", r)
        if not one_call(r, "plain text"): error(f"a plain {sp[0]} DSML call does not parse ({mode}); cannot judge")
        name = f"{sp[0]} value holds the closer, {mode}"
        r = ask(block(sp, held), stream); show(name, r)
        if not one_call(r, held):
            ok = False; print(f"  FAIL {name}: expected one write call with the value intact, finish=tool_calls, no DSML markup in content")
        # two blocks with prose between them: two calls, the prose kept, no markup
        name = f"{sp[0]} two blocks holding the closer, prose between, {mode}"
        r = ask(block(sp, held) + "\nThen.\n" + block(sp, held), stream); show(name, r)
        want = [("write", {"path": "notes.md", "content": held})] * 2
        if not (r["calls"] == want and r["finish"] == "tool_calls" and D not in r["content"] and r["content"].strip() == "Then."):
            ok = False; print(f"  FAIL {name}: expected two write calls with the value intact, finish=tool_calls, content 'Then.'")
print("CLAIM: holds" if ok else "CLAIM: does not hold"); sys.exit(0 if ok else 1)
PY

# Run against the base build (recipe main, patches 0001-0046), 2026-11-03T07:16Z, 14 s:
# V4.1 control, whole: finish=tool_calls tool_calls=[["write", {"path": "notes.md", "content": "plain text"}]] content=""
# V4.1 value holds the closer, whole: finish=stop tool_calls=[] content="<｜DSML｜ calls>\n<｜DSML｜ invoke name=\"write\">\n<｜DSML｜ parameter name=\"path\" string=\"true\">notes.md</｜DSML｜ parameter>\n<｜DSML｜ parameter name=\"content\" string=\"true\">end of block: </｜DSML｜ calls></｜DSML｜ parameter>\n</｜DSML｜ invoke>\n</｜DSML｜ calls>"
#   FAIL V4.1 value holds the closer, whole: expected one write call with the value intact, finish=tool_calls, no DSML markup in content
# V4.1 two blocks holding the closer, prose between, whole: finish=stop tool_calls=[] content="<｜DSML｜ calls>\n<｜DSML｜ invoke name=\"write\">\n<｜DSML｜ parameter name=\"path\" string=\"true\">notes.md</｜DSML｜ parameter>\n<｜DSML｜ parameter name=\"content\" string=\"true\">end of block: </｜DSML｜ calls></｜DSML｜ parameter>\n</｜DSML｜ invoke>\n</｜DSML｜ calls>\nThen.\n<｜DSML｜ calls>\n<｜DSML｜ invoke name=\"write\">\n<｜DSML｜ parameter name=\"path\" string=\"true\">notes.md</｜DSML｜ parameter>\n<｜DSML
#   FAIL V4.1 two blocks holding the closer, prose between, whole: expected two write calls with the value intact, finish=tool_calls, content 'Then.'
# V4.1 control, stream: finish=tool_calls tool_calls=[["write", {"path": "notes.md", "content": "plain text"}]] content=""
# V4.1 value holds the closer, stream: finish=stop tool_calls=[] content="</｜DSML｜ parameter>\n</｜DSML｜ invoke>\n</｜DSML｜ calls>"
#   FAIL V4.1 value holds the closer, stream: expected one write call with the value intact, finish=tool_calls, no DSML markup in content
# V4.1 two blocks holding the closer, prose between, stream: finish=stop tool_calls=[] content="</｜DSML｜ parameter>\n</｜DSML｜ invoke>\n</｜DSML｜ calls>\nThen.\n</｜DSML｜ parameter>\n</｜DSML｜ invoke>\n</｜DSML｜ calls>"
#   FAIL V4.1 two blocks holding the closer, prose between, stream: expected two write calls with the value intact, finish=tool_calls, content 'Then.'
# V4 control, whole: finish=tool_calls tool_calls=[["write", {"path": "notes.md", "content": "plain text"}]] content=""
# V4 value holds the closer, whole: finish=stop tool_calls=[] content="<｜DSML｜tool_calls>\n<｜DSML｜invoke name=\"write\">\n<｜DSML｜parameter name=\"path\" string=\"true\">notes.md</｜DSML｜parameter>\n<｜DSML｜parameter name=\"content\" string=\"true\">end of block: </｜DSML｜tool_calls></｜DSML｜parameter>\n</｜DSML｜invoke>\n</｜DSML｜tool_calls>"
#   FAIL V4 value holds the closer, whole: expected one write call with the value intact, finish=tool_calls, no DSML markup in content
# V4 two blocks holding the closer, prose between, whole: finish=stop tool_calls=[] content="<｜DSML｜tool_calls>\n<｜DSML｜invoke name=\"write\">\n<｜DSML｜parameter name=\"path\" string=\"true\">notes.md</｜DSML｜parameter>\n<｜DSML｜parameter name=\"content\" string=\"true\">end of block: </｜DSML｜tool_calls></｜DSML｜parameter>\n</｜DSML｜invoke>\n</｜DSML｜tool_calls>\nThen.\n<｜DSML｜tool_calls>\n<｜DSML｜invoke name=\"write\">\n<｜DSML｜parameter name=\"path\" string=\"true\">notes.md</｜DSML｜parameter>\
#   FAIL V4 two blocks holding the closer, prose between, whole: expected two write calls with the value intact, finish=tool_calls, content 'Then.'
# V4 control, stream: finish=tool_calls tool_calls=[["write", {"path": "notes.md", "content": "plain text"}]] content=""
# V4 value holds the closer, stream: finish=stop tool_calls=[] content="</｜DSML｜parameter>\n</｜DSML｜invoke>\n</｜DSML｜tool_calls>"
#   FAIL V4 value holds the closer, stream: expected one write call with the value intact, finish=tool_calls, no DSML markup in content
# V4 two blocks holding the closer, prose between, stream: finish=stop tool_calls=[] content="</｜DSML｜parameter>\n</｜DSML｜invoke>\n</｜DSML｜tool_calls>\nThen.\n</｜DSML｜parameter>\n</｜DSML｜invoke>\n</｜DSML｜tool_calls>"
#   FAIL V4 two blocks holding the closer, prose between, stream: expected two write calls with the value intact, finish=tool_calls, content 'Then.'
# CLAIM: does not hold
# exit=1
