1. **Recomputed results.** Boundary: zero comparisons available, so identical hashes are **0/0, untested**. Cut-in medians: unavailable for both targets. Soak: no requests or error measurements recorded. Smoke arithmetic, greedy-repeat equality, stream equality, and JSON mode: all untested. The report correctly lists these suites as absent.

   Performance medians across repetition medians, candidate/base: decode **57.8/59.2**, prefill **3141.2/3103.85**, aggregate **134.0/134.85** tokens/s. Changes round to **−2.4%, +1.2%, −0.6%**, matching the report. Every per-repetition median and range matches; all eight performance error lists are empty. Reproduction exits are candidate **0/0/0/0**, base **1/1/1/1**. Startup values also match.

   One report discrepancy: “adds or changes no test file under `tests/`” is false; the patch adds `tests/repro-issue-14.sh`. Empty host-test discovery does not establish absence of tests.

2. **Changed paths and coverage.** Patch `0047` changes DSML envelope selection and streaming text filtering in `tool_parse`/`reply_text`. It walks invoke/parameter structure and accepts an extended interpretation only when it recovers more calls. It also adds template detection in `tool_grammar`, wires it through `chat`, and disables incremental `<tool_call>` parsing for DSML templates in `tool_stream`.

   Reproduction explicitly forces a V4.1 value containing the block closer, whole and streamed. A second case forces two calls, with the first value containing both the closer and `<tool_call>` markup. These exercise the repaired failure path and streaming integration. Ordinary performance prompts do not verify those behaviors.

   Alternate DSML spelling, malformed/truncated blocks, fallback branches, template-detection failures, and non-DSML compatibility lack executed coverage. The workflow’s new mergeability-wait loop also lacks verification.

3. **PR claims.**

   - **Supported:** the tested closer-containing V4.1 call survives intact, finishes with `tool_calls`, and leaks no closers; the base exhibits the described failure. The two-call mixed-markup case also passes.
   - **Partially supported:** ordinary behavior remains unchanged—the plain-call controls pass, but broad compatibility is untested.
   - **Not tested:** alternate spelling, separate blocks with intervening prose, streaming prose timing, real long-session leak rates, sampling explanations, mutation canaries, and the claimed CPU/Python test totals.
   - **Stale description:** “last closer before next opener,” unconditional holding until reply completion, and opener-containing values still splitting blocks do not describe the submitted implementation. These discrepancies follow from code inspection, not measured failures.
   - Think splitting, diagnostics, and `TOP_P` are unchanged in the diff; their behavior was not independently tested.

4. **Limits.** Four counterbalanced repetitions, matching performance prompt keys/settings, complete perf/repro matrices, healthy plain-call controls, and recorded successful restoration strengthen this comparison. Image identifiers consistently identify the stated candidate/base, although build provenance is not independently established. Repeated deterministic examples add little input diversity. Smoke, boundary, cut-in, soak, fault, concurrency, endurance, and benchmark suites were omitted. The broader claim script and Zig tests present in the patch were not recorded as executed.

5. **Oracles.**

CLAIM TEST: SOUND

The executed script matches the added reproduction script and requires exact calls, intact arguments, correct finish reasons, no leaked closers, and working plain-call controls; rejection cannot pass.

AUTHOR TESTS: NONE

`hosttests.json` contains no files or executions; the reproduction script is assessed above.

EVIDENCE SUPPORTS THE CLAIM — The targeted V4.1 failure is directly exercised by a sound oracle; all four candidate runs pass while all four base runs reproduce it; ordinary-call controls pass on both.
