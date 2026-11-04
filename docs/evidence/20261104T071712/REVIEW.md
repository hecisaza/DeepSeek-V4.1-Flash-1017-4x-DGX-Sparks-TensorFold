1. **Recomputed results.** Boundary: **0 comparisons available**, so identical hashes are **0/0, unmeasured**. Cut-in medians: unavailable for both targets. Soak counts and errors: unavailable. All four smoke checks—arithmetic, greedy repeat equality, streaming equality, JSON mode—were unrun. The report correctly identifies these omissions.

   Performance medians over repetitions, candidate/base, are **57.70/58.80** decode, **3128.90/3126.45** prefill, and **133.90/133.05** aggregate tokens/s: **−1.9%, +0.1%, +0.6%**. All per-repetition medians and ranges match; recorded performance errors total zero. Reproduction exits are candidate **0/0/0/0**, base **1/1/1/1**, matching the report.

   **One report discrepancy:** “no test file under `tests/`” is false: the patch adds `tests/repro-issue-14.sh`, which exactly matches `executed-script.sh`. Empty host-test discovery was incorrectly presented as absence of tests.

2. **Changed paths and coverage.** The patch changes DSML envelope selection and streaming text filtering, adds template detection, and disables incremental `<tool_call>` extraction for DSML templates. Parsing compares original and extended envelopes, accepting extension only when it yields more calls. It also changes workflow mergeability polling and adds tests/documentation.

   Reproduction directly exercises the rare failure: forced V4.1 DSML with a block closer inside a parameter, both whole and streamed. Its two-call case additionally embeds `<tool_call>` markup and exercises the streaming suppression. These paths **did run**. Performance requests contain no tools and principally provide regression evidence.

   V4 spelling, malformed/truncated blocks, mixed spellings, call limits, template-detection failures, and workflow polling are not verified by these suites.

3. **PR claims.**
   - **Supported:** the demonstrated closer-containing value survives intact, returns the intended call(s) with `finish_reason: tool_calls`, and leaks no closing tags. Plain calls also remain functional.
   - **Not tested:** general compatibility, both DSML spellings, prose timing, multiple separate blocks, unchanged thinking/diagnostics, other model families, historical CPU/Python test totals and mutation canaries, sampling statistics, real-session leak rates, or the cause of the original incidents.
   - **Stale descriptions contradicted by the patch, not by measured requests:** this is no longer simply “last closer before next opener.” Structural scanning and call-count guards govern extension; complete blocks can release following prose before reply completion, and openers inside values can survive. The stated prose-loss trade-off likewise does not describe the current implementation. The run contains no counterexample to the central repair.

4. **Evidence limits.** Four counterbalanced repetitions, matching public settings, matching prompt construction, functional plain-call controls, and recorded successful restoration strengthen the comparison. No incomplete executed matrix or prompt mismatch appears. Image identities are recorded, but their source provenance cannot independently be reconstructed here. Deterministic repetitions add little input diversity. Smoke, boundary, cut-in, soak, fault, concurrency, endurance, and benchmark suites were omitted; host-test outputs are absent.

CLAIM TEST: SOUND

The script forces the relevant structure, asserts exact calls and arguments, finish reason and absence of leaked closers, and requires functioning plain-call controls; rejecting requests cannot pass.

AUTHOR TESTS: NONE

`hosttests.json` names no files and contains no execution output; the authored reproduction script was inspected and verified separately above.

EVIDENCE SUPPORTS THE CLAIM — The narrow closer-in-value repair passes a sound oracle in all four candidate runs; the base exhibits the targeted failure in all four; plain-call capability remains intact on both.
