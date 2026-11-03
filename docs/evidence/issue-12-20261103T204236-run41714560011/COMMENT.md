**Reproduction attempt** (automated, on the lab's live build `DeepSeek-V4.1-Flash-1017`): verdict **not-reproduced**.


## What the issue claims

On a TP4 serve, the first sampled (non-greedy) request after a long idle has a 70-165 s first token and then decodes
at about 38 tok/s, half speed. The next sampled request and every greedy request run at spec (0.1 s first token,
about 68 tok/s). The reporter ran a switched mesh, the Ablit build, and the image `native-3881d604d26b`. That image
predates `0034` (idle parking of the RDMA proxies).

## Conditions

- Four GB10 ranks, TP4, switchless ring, stock weights (not Ablit).
- Image built from recipe `fcef6cf`, which includes `0034` and `0040`. Defaults, drafts on, and the server's default
  sampling: `temperature 1.0, top_p 1.0, top_k 20`.
- The server had been up about 9 hours. Its log shows one request before mine: the startup check at 11:56:30 UTC,
  2 tokens, `rounds=1`. So the first request below was the **first sampled request of the server's life**. It came
  after **8 h 44 min of idle**. That covers both readings in the thread: a first-use cost and an after-idle cost.

## What I ran

`/tmp/r12/m.py` streams one chat completion and times it. The prompt is a short story about a lighthouse keeper,
`max_tokens 300`, thinking off through `chat_template_kwargs`, one stream. TTFT is measured to the first content
delta. Decode speed is (tokens − 1) divided by the time after the first token.

```
$ date -u; python3 m.py $API $MODEL 0.7; python3 m.py $API $MODEL 0.7; python3 m.py $API $MODEL 0
Tue Nov  3 08:40:50 PM UTC 2026
{"temp": "0.7", "ttft_s": 0.125, "total_s": 5.11, "tokens": 300, "decode_tok_s": 60.0}   <- first sampled, after 8h44m idle
{"temp": "0.7", "ttft_s": 0.131, "total_s": 5.06, "tokens": 300, "decode_tok_s": 60.7}
{"temp": "0",   "ttft_s": 0.119, "total_s": 5.28, "tokens": 300, "decode_tok_s": 57.9}

$ python3 m.py $API $MODEL unset; python3 m.py $API $MODEL 1.0
{"temp": "unset", "ttft_s": 0.123, "total_s": 5.14, "tokens": 300, "decode_tok_s": 59.6}
{"temp": "1.0",   "ttft_s": 0.122, "total_s": 5.11, "tokens": 300, "decode_tok_s": 59.9}
```

The head rank's log (`docker logs --timestamps`, read only) for the same requests. The drafter statistics for the
first sampled request match the second one:

```
11:56:30 done ... prompt=8  tokens=2   finish=stop   rounds=1   accepted=1/2      (startup check)
20:40:55 done ... prompt=20 tokens=300 finish=length rounds=164 accepted=135/232  (1st sampled, T 0.7)
20:41:00 done ... prompt=20 tokens=300 finish=length rounds=165 accepted=134/229  (2nd sampled, T 0.7)
20:41:05 done ... prompt=20 tokens=300 finish=length rounds=171 accepted=128/249  (greedy)
```

Before the test, `nvidia-smi` on the head rank showed `0 %` utilisation. The idle server was not spinning.

## Reading

The issue says the stall is on the sampled path and that warm-up does not survive idle. Neither shows on this build.
The first sampled request, cold in both senses, had a first token in 0.125 s at 60 tok/s. That is the same as the
warm sampled request and the greedy one. The drafter acceptance was also the same. In the code, the decode and
drafter graphs are captured lazily per shape key (`round.zig` `Graphs`, `draft.zig` `PassGraphs`). Nothing in the
patches evicts them on idle. A capture taking 70-165 s would also be far longer than any capture shows here. I found
no code path that matches the report, so I made no fix and wrote no repro script.

This agrees with the maintainer's ring result (0.12-0.14 s) and with SvangenStudios' data point (normal first token).
It does not explain their milder slowdown: about a third slower for the first two sampled replies, with thinking on,
512 tokens. I did not see that slowdown here either, with thinking off and 300 tokens.

## What this does not cover

- A switched mesh. The reporter's topology may matter, and I have no switched fabric.
- The Ablit build, and the reporter's pre-`0034` image `native-3881d604d26b`. The most likely explanation is that
  the image predates idle parking (`0034`), but I did not run that image to confirm it.
- Thinking on, or longer outputs. One run of each condition, so no spread is reported.
- Other ranks' logs and per-rank `nvidia-smi` during the requests. I read only the head rank.
- The repository's host tests: no code changed, so there was nothing to check them against.

The useful next step is still the one the maintainer asked for. The reporter runs current `main`, sends one sampled
request right after ready, then sends it again after an hour idle, and collects each rank's logs.
