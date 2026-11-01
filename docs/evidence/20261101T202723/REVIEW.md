1. Recomputed results agree with the report’s numerical summaries; there are no numerical discrepancies.

   - **Boundary:** 19/19 identical hashes per repetition, **38/38 total**; matching labels and token counts, no errors.
   - **Cut-in medians**, seconds, short/long:

     | Target | Rep 0 | Rep 1 | All six rounds |
     |---|---:|---:|---:|
     | Candidate | 0.374 / 20.817 | 0.387 / 20.174 | 0.380 / 20.291 |
     | Base | 0.361 / 20.056 | 0.356 / 20.324 | 0.3575 / 20.059 |

     The report correctly rounds its per-repetition medians. All 12 rounds satisfy admission even after accounting for the three-second launch delay.
   - **Soak:** candidate repetitions each have 163 completions, with 125/126 aborts; base repetitions each have 163 completions and 126 aborts. Each has 57 canaries, zero errors and zero mismatches. Totals: **652 completions, 503 aborts, 228 canaries**.
   - **Smoke:** arithmetic, greedy-repeat equality, stream equality and JSON-object checks are true in all four runs, with no recorded errors. Stream first-token times are candidate 0.091/0.093 seconds, base 0.089/0.087. Original responses are absent, so these Boolean checks cannot be independently re-evaluated.

2. The executable change inserts `discardBody` before GET routing and DELETE response routing in `dispatch`; POST is unchanged. Other changes are documentation.

   The repro exercises both changed branches: a Content-Length-bearing GET `/models` and DELETE `/responses/<unknown-id>`, each followed by GET `/models` on the same socket. Both repetitions show candidate follow-ups succeeding and base follow-ups failing with probe-prefixed method names. Ordinary inference suites exercise POST, providing regression coverage rather than verification of this fix. Uncertain-framing, chunked-body, interrupted-body and drain-failure paths were not exercised.

3. Claims assessed:

   - **Prevent leftover-body contamination:** supported by the observed fixed-length cases, but incompletely asserted by the oracle.
   - **Preserve bodyless requests:** bodyless GET reuse is supported; bodyless DELETE and the internal “reads nothing” mechanism are not tested.
   - **Close connections on uncertain framing:** not tested.
   - **Historical cross-session 400s:** the mechanism is reproduced, but the observed status is 501; this does not contradict the historical account.
   - **Safe nginx pooling, timeout/retry improvements, streaming configuration and key setup:** not tested through that configuration.
   - **Clean patch application to the stated engine pin, upstream equivalence, patch numbering/rebase requirements and three-week deployment success:** not independently established. The described documentation additions are visible in the diff.

4. There are two counterbalanced repetitions, matching public settings and deterministic boundary prompts, and a recorded successful restore. No unexpected suite errors appear. Limitations include few repetitions, duration-driven soak workloads, no fault or benchmark suite, and no successful stored-response deletion. Image identifiers agree across the bundle, but image-to-source provenance is not independently established. The report’s “gone on the candidate” wording exceeds the oracle’s guarantees.

CLAIM TEST: UNSOUND

The script checks the second response and bodyless reuse, but accepts any first-response status, so rejecting body-bearing requests while keeping the connection usable could pass without preserving GET/DELETE behavior.

AUTHOR TESTS: NONE

`hosttests.json` lists no test files or executions, and the patch adds none.

EVIDENCE UNRELIABLE — for full-claim verification: the claim oracle permits rejection-only implementations, uncertain-framing behavior is untested, and no author tests close those gaps.
