#!/usr/bin/env bash
# claim: patches: 0044 GET and DELETE request bodies are drained, so a kept connection cannot hand one request's bytes
# to the next — "a body-carrying GET ... leaves its bytes in the socket ... at the next keep-alive reuse those bytes are
# glued onto the next request's request line"; with 0044 the body is read and dropped before the route.
# Exercised by: one raw HTTP/1.1 keep-alive connection per case. A GET /models (and a DELETE /responses/<unknown id>)
# carrying a Content-Length body, then a plain GET /models on the SAME connection; the second reply must be a 200 with
# the model list. A bodyless control pair first proves keep-alive reuse works at all. curl cannot pin both requests to
# one socket with a body on the GET, so this uses python3 sockets. No model call, so temperature does not apply.
# From REVIEW.md §2: "send a body-bearing GET or DELETE, then another request on the same persistent connection,
# checking that the second request parses correctly."
API=$1; MODEL=$2
[ -n "$API" ] && [ -n "$MODEL" ] || { echo "usage: claim.sh API MODEL"; echo "CLAIM: error missing arguments"; exit 2; }
exec python3 - "$API" "$MODEL" <<'PY'
import json, socket, sys, urllib.parse

api, model = sys.argv[1].rstrip("/"), sys.argv[2]
u = urllib.parse.urlsplit(api)
if u.scheme != "http":
    print("CLAIM: error only plain http APIs are supported"); sys.exit(2)
host, port, prefix = u.hostname, u.port or 80, u.path.rstrip("/")
PROBE = b"probe=0044&scanner=1"   # no CR/LF: left in the socket it becomes the start of the next request line


def req(method, path, body=b""):
    head = f"{method} {prefix}{path} HTTP/1.1\r\nHost: api\r\nAccept: application/json\r\nConnection: keep-alive\r\n"
    if body:
        head += f"Content-Type: application/x-www-form-urlencoded\r\nContent-Length: {len(body)}\r\n"
    return head.encode() + b"\r\n" + body


class Reader:
    def __init__(self, s): self.s, self.buf = s, b""
    def fill(self):
        d = self.s.recv(65536)
        if not d: raise EOFError("connection closed by server")
        self.buf += d
    def line(self):
        while b"\r\n" not in self.buf: self.fill()
        l, self.buf = self.buf.split(b"\r\n", 1); return l
    def take(self, n):
        while len(self.buf) < n: self.fill()
        d, self.buf = self.buf[:n], self.buf[n:]; return d
    def response(self):
        status = self.line().decode("latin-1")
        hdrs = {}
        while True:
            l = self.line()
            if not l: break
            k, _, v = l.decode("latin-1").partition(":"); hdrs[k.strip().lower()] = v.strip()
        if "chunked" in hdrs.get("transfer-encoding", "").lower():
            body = b""
            while True:
                n = int(self.line().split(b";")[0], 16)
                if n == 0:
                    while self.line(): pass
                    break
                body += self.take(n); self.take(2)
        else:
            body = self.take(int(hdrs.get("content-length", "0")))
        code = int(status.split()[1]) if len(status.split()) > 1 and status.split()[1].isdigit() else 0
        return code, hdrs, body


def pair(label, first):
    """Send `first`, read its reply, then GET /models on the same socket. Returns (first, second) as
    (code, text) or (None, error)."""
    s = socket.create_connection((host, port), timeout=30)
    r = Reader(s); out = []
    try:
        s.sendall(first)
        try:
            c, h, b = r.response(); out.append((c, b.decode("utf-8", "replace")))
        except (EOFError, OSError, ValueError) as e:
            return (None, f"no reply to the first request: {e}"), (None, "not sent")
        try:
            s.sendall(req("GET", "/models"))
            c, h, b = r.response(); out.append((c, b.decode("utf-8", "replace")))
        except (EOFError, OSError, ValueError) as e:
            out.append((None, f"no reply on the kept connection: {e}"))
        return out[0], out[1]
    finally:
        s.close()


def show(label, first, second):
    print(f"{label}: first  -> {first[0]} {first[1][:160]!r}")
    print(f"{label}: second -> {second[0]} {second[1][:160]!r}")


def models_ok(second):
    if second[0] != 200: return False
    try: return any(m.get("id") == model for m in json.loads(second[1]).get("data", []))
    except Exception: return False


# control: bodyless GET then GET on one connection must both answer, or keep-alive itself is broken
f, s2 = pair("control", req("GET", "/models"))
show("control (bodyless GET, then GET)", f, s2)
if f[0] != 200 or not models_ok(s2):
    print("CLAIM: error bodyless keep-alive reuse does not work, so the body case cannot be judged"); sys.exit(2)

cases = [
    ("GET with body, then GET", req("GET", "/models", PROBE)),
    ("DELETE with body, then GET", req("DELETE", "/responses/resp_claim0044_does_not_exist", PROBE)),
]
ok = True
for label, first in cases:
    f, s2 = pair(label, first)
    show(label, f, s2)
    if f[0] is None:
        print(f"{label}: the server did not answer the body-carrying request"); ok = False; continue
    if models_ok(s2):
        print(f"{label}: the next request on the kept connection parsed from its own request line")
    else:
        msg = [l.strip() for l in (s2[1] or "").splitlines() if "Message:" in l or "Unsupported" in l]
        if msg: print(f"{label}: error page says: {msg[0][:200]}")
        leaked = PROBE.decode()[:10] in (s2[1] or "")
        print(f"{label}: the next request on the kept connection failed" + (" with the probe's bytes in the reply" if leaked else ""))
        ok = False

print("CLAIM: holds" if ok else "CLAIM: does not hold")
sys.exit(0 if ok else 1)
PY

# Run against the base build (one run, 2026-10-31):
#   control (bodyless GET, then GET): first  -> 200 '{"object": "list", "data": [{"id": "DeepSeek-V4.1-Flash-1017", "object": "model", "created": 1793468636, "owned_by": "tensorfold"}]}'
#   control (bodyless GET, then GET): second -> 200 '{"object": "list", "data": [{"id": "DeepSeek-V4.1-Flash-1017", "object": "model", "created": 1793468636, "owned_by": "tensorfold"}]}'
#   GET with body, then GET: first  -> 200 '{"object": "list", "data": [{"id": "DeepSeek-V4.1-Flash-1017", "object": "model", "created": 1793468636, "owned_by": "tensorfold"}]}'
#   GET with body, then GET: second -> 501 '<!DOCTYPE HTML>\n<html lang="en">\n    <head>\n        <meta charset="utf-8">\n        <style type="text/css">\n            :root {\n                color-scheme: lig'
#   GET with body, then GET: error page says: <p>Message: Unsupported method ('probe=0044&amp;scanner=1GET').</p>
#   GET with body, then GET: the next request on the kept connection failed with the probe's bytes in the reply
#   DELETE with body, then GET: first  -> 404 '{"error": {"message": "no stored response has id \'resp_claim0044_does_not_exist\'", "type": "invalid_request_error", "param": "response_id", "code": null}}'
#   DELETE with body, then GET: second -> 501 '<!DOCTYPE HTML>\n<html lang="en">\n    <head>\n        <meta charset="utf-8">\n        <style type="text/css">\n            :root {\n                color-scheme: lig'
#   DELETE with body, then GET: error page says: <p>Message: Unsupported method ('probe=0044&amp;scanner=1GET').</p>
#   DELETE with body, then GET: the next request on the kept connection failed with the probe's bytes in the reply
#   CLAIM: does not hold
#   exit=1
