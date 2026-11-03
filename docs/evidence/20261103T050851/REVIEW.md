1. **Recomputed results.** All requested numerical results agree with `report.md`:

   - Boundary: **19/19** nonempty hashes match; prompt labels and token counts also match.
   - Cut-in medians, short/long: candidate **0.427/20.412 s**; base **0.415/20.097 s**. The report’s rounded values are correct. Both admitted the short request in **3/3** rounds.
   - Soak, each target: **161 completions, 123 aborts, 0 errors, 57 canary checks, 0 mismatches**; error lists are empty.
   - Smoke, each target: arithmetic, greedy repetition, stream equality and JSON-object checks are all recorded as true, with no errors. Streaming first-token times are **0.094 s** and **0.088 s**.

   Smoke responses and individual soak outcomes were not retained, so their recorded checks/counts cannot be independently reconstructed further. One reporting discrepancy: “adds or changes no test file under `tests/`” is false—the patch adds `tests/repro-issue-14.sh`.

2. **Changed paths and coverage.** Patch `0047` changes DSML envelope extraction in `tool_parse.envelopes` and streaming suppression in `reply_text.hideInto`. New `blockEnd` selects the last closer before the next same-spelling opener; unfinished DSML blocks remain hidden until completion. Both DSML spellings change.

   The repro explicitly exercises the V4.1 failure path: `guided_regex` forces a `write` call whose string value contains `</｜DSML｜ calls>`, in whole and streamed responses. Candidate returns the intact call; base drops it and leaks markup. Thus this rare path **was exercised**. Ordinary suites provide regression evidence; they do not deliberately trigger it. The alternate spelling, multiple-block boundary and surrounding-prose timing lack executed coverage here.

3. **PR claims.**

   - **Supported:** the demonstrated closer-in-value failure is fixed in both response modes; the exact value survives, tool-call completion is reported, and closing tags do not leak.
   - **Supported narrowly:** ordinary plain-value tool calls still work in both modes; sampled ordinary responses remain unchanged.
   - **Not tested fully:** both-spelling generality, stopping at the next opener, arbitrary unchanged ordinary parsing, delayed trailing prose, and prose containing another closer.
   - **Consistent with the diff, not independently behavior-tested:** unchanged other markup families, think splitting, diagnostics and sampling defaults.
   - **Not verified by this run:** reported CPU/Python test totals, mutation canaries, earlier long-context sampling results, the original incident’s cause, or real-session leak rates. The PR explicitly limits its causal claim. No demonstrated functional claim is contradicted.

4. **Evidence limits.** There is one candidate-first repetition, without counterbalancing. Fault, endurance, external benchmark and golden-parity coverage are absent. Fixed regression prompts match by construction; soak uses seeded workers but retains no request inventory proving identical workloads. Metadata consistently identifies the stated base image, equal public settings and successful restoration; it does not independently establish image build provenance. No unexpected suite errors appear.

CLAIM TEST: SOUND

The executed script matches the added script, requires the exact intact call and completion reason, rejects leaked closers and request failures, and preserves a passing plain-value control on both builds.

AUTHOR TESTS: NONE

`hosttests.json` contains no files or candidate/base outputs; the embedded Zig assertions are readable, but their execution is unverified here.

EVIDENCE SUPPORTS THE CLAIM — the specific failure reproduces on base, the candidate satisfies the sound whole/stream oracle, and ordinary-call controls pass on both builds.
