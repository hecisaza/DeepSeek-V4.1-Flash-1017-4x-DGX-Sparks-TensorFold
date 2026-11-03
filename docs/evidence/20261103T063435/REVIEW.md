1. **Recomputed results.** Boundary hashes match in **19/19** comparisons; case labels and prompt-token counts also match.

   | Measurement | Candidate | Base |
   |---|---:|---:|
   | Cut-in median, short | 0.370 s | 0.386 s |
   | Cut-in median, long | 20.156 s | 20.127 s |
   | Short admitted before long’s first token | 3/3 | 3/3 |
   | Soak completions / aborts | 160 / 122 | 164 / 127 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 57 / 0 | 58 / 0 |

   Both targets record arithmetic, greedy-repeat equality, streaming equality and JSON mode as **true**, with empty error lists; streaming first-token times are **0.090/0.091 s**. These figures match `report.md`, including its rounding. Smoke responses and individual soak outcomes are absent, so only their recorded checks/counts can be verified.

   One reporting discrepancy: “adds or changes no test file under `tests/`” is false—the patch adds `tests/repro-issue-14.sh`.

2. **Changed paths and coverage.** Patch `0047` introduces `reply_text.blockEnd`, selecting the last DSML closer before the next opener of the same spelling. Both DSML branches in `tool_parse.envelopes` use it. `hideInto` also uses it and suppresses DSML output until completion. The patch adds Zig assertions, the reproduction script, and documentation.

   The repro explicitly forces a V4.1 `write` call containing `</｜DSML｜ calls>` inside its string value, in whole and streamed responses. Thus this rare failure path **did run**: the base drops the call; the candidate preserves it. Ordinary suites provide regression coverage but do not deliberately trigger this condition. V4 spelling, multiple blocks and trailing-prose timing lack executed coverage here.

3. **Claims assessed.**

   - **Supported:** the forced V4.1 closer-in-value call survives intact, without leaked closing tags, in both modes. Candidate exits 0; base exits 1 with the described failure.
   - **Supported narrowly:** plain-value calls still work in both modes, and the 19 ordinary boundary outputs remain identical.
   - **Not tested:** both-spelling generality; the next-opener boundary; multiple-block prose preservation; delayed trailing prose; quoted-closer prose absorption; opener-in-value behavior.
   - **Not independently verified here:** reported CPU/Python totals, mutation canaries, historical sampling counts and build checks.
   - **Not tested:** causation of the original long-session incidents, real-session leak rates or a `TOP_P` effect. The PR explicitly limits those claims.
   - Unchanged Qwen/Gemma behavior, thinking handling and diagnostics lack targeted runtime checks; their implementations and sampling defaults are untouched by the shown diff.

4. **Evidence limits.** One candidate-first repetition lacks counterbalancing. Fault, endurance, external benchmark and golden-parity testing are absent. Fixed comparison prompts match by construction; timed soak workers execute differing counts without retaining request inventories. Smoke arithmetic checks only for substring `391`; JSON mode checks only for an object. Metadata and `run.txt` agree on image identities, public settings and successful restoration, but do not independently prove build provenance. No unexpected suite errors or missing target rows appear.

5. **Oracles.**

CLAIM TEST: SOUND
It requires the exact intact call, `finish_reason=tool_calls`, no leaked closers and successful plain-value controls in both modes; rejection cannot pass.

AUTHOR TESTS: NONE
`hosttests.json` lists no files or executions; the added Zig assertions have no paired raw results here.

EVIDENCE SUPPORTS THE CLAIM — the targeted V4.1 reproduction passes a sound oracle on the candidate, fails behaviorally on the base, and preserves ordinary tool-call capability.
