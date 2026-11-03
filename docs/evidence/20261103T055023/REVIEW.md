1. **Recomputed results.** The requested numerical results agree with `report.md`:

   - Boundary: **19/19** nonempty hashes match; labels and token counts match.
   - Cut-in medians, short/long: candidate **0.403/20.215 s**; base **0.358/20.083 s**. Reported rounding is consistent with `report.py`. Both admit the short request before the long request’s first token in **3/3** rounds.
   - Soak, each target: **163 completions, 126 client aborts, 0 errors, 57 canary checks, 0 mismatches**.
   - Smoke, each target: arithmetic, greedy repetition, streaming equality and JSON-object checks are recorded as passing; error lists are empty. Streaming first-token times are **0.090/0.098 s**.

   Smoke responses and individual soak outcomes were not retained, so their recorded checks/counts cannot be independently reconstructed. One reporting discrepancy: “adds or changes no test file under `tests/`” is false—the patch adds `tests/repro-issue-14.sh`.

2. **Changed paths and coverage.** Patch `0047` changes `tool_parse.envelopes` and `reply_text.hideInto`. New `blockEnd` selects the last DSML closer before the next same-spelling opener; streaming suppresses DSML blocks until completion. Both DSML spellings change.

   The repro deliberately exercises the rare V4.1 path: `guided_regex` forces a `write` call containing `</｜DSML｜ calls>` inside its string value, both streamed and non-streamed. The base drops the call and leaks markup; the candidate preserves it. Other suites provide ordinary regression evidence, without deliberately exercising this condition. Alternate spelling, multiple blocks and surrounding-prose timing lack executed coverage.

3. **Claims in `PR.md`.**

   - **Supported:** the demonstrated closer-in-value failure is fixed in both response modes, preserving exact arguments and `finish_reason: tool_calls`, without leaked closers.
   - **Supported narrowly:** plain-value tool calls still work in both modes; tested ordinary boundary replies remain identical.
   - **Not fully tested:** both-spelling generality, next-opener boundaries, arbitrary ordinary-call compatibility, delayed trailing prose and absorption of prose containing another closer.
   - **Consistent with the diff, not behaviorally verified:** unchanged other markup families, think splitting, diagnostics and sampling defaults.
   - **Not verified here:** historical CPU/Python totals, mutation canaries, long-context sampling results, original-incident causation or real-session leak rates. No demonstrated functional claim is contradicted.

4. **Evidence limits.** One candidate-first repetition lacks counterbalancing. Fault, endurance, external benchmark and golden-parity coverage are absent. Fixed comparison prompts match by construction; timed soak workers retain no request inventory proving identical workloads. Metadata consistently identifies the stated base image, matching public settings and successful restoration, but does not independently prove build provenance. No unexpected suite errors appear. Candidate memory growth after concurrency drain is **58.3–59.4 MB**, versus **7.1–8.2 MB** on base; this deserves repetition before drawing resource-stability conclusions.

5. **Oracles.**

CLAIM TEST: SOUND

The executed script matches the patch, requires exact intact arguments and tool-call completion in both modes, rejects leaked closers and request rejection, and preserves passing plain-value controls on both builds.

AUTHOR TESTS: NONE

`hosttests.json` lists no files or outputs; embedded Zig assertions are readable, but their execution is unverified here.

EVIDENCE SUPPORTS THE CLAIM — the specific failure reproduces on base, the candidate passes the sound whole/stream oracle, and capability-preserving controls pass on both builds.
