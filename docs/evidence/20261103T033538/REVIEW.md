1. **Recomputed results:** No numerical discrepancies in the requested entries of `report.md`.

   - **Boundary:** 19/19 matching, non-error hashes in each repetition; **38/38 total**. Labels and prompt-token counts match.
   - **Cut-in medians**, seconds, before report rounding:

   | Target | Rep 0 short / long | Rep 1 short / long |
   |---|---:|---:|
   | Candidate | 0.369 / 20.731 | 0.379 / 20.141 |
   | Control | 0.421 / 20.117 | 0.383 / 20.196 |

   Pooled short medians: candidate **0.3745 s**, control **0.393 s**. All 12 rounds demonstrate admission even after accounting for the three-second launch delay.

   - **Soak**, completions / aborts / canaries: candidate **160/123/57**, **161/123/57**; control **161/125/57**, **164/126/58**. Totals: candidate **321/246/114**, control **325/251/115**. All error and canary-mismatch counts are zero.
   - **Smoke:** Arithmetic, greedy repeat equality, streaming equality, and JSON-object checks are true in all four runs, with no recorded errors. Streaming first-token times: candidate **0.100/0.096 s**, control **0.091/0.094 s**. These match the report; original responses are absent, preventing independent reconstruction of the assertions.

2. **Changed paths:** Besides older evidence documents, `pr.patch` adds an embedded engine patch performing **400,000 volatile arithmetic iterations** after incrementing the step counter, before filtering live streams. This is an ordinary execution path, not a rare or failure path. Completion suites exercise it if the patch reached the executable. Relevant executed requests include 256-token single-stream generation, four-stream performance batches, and concurrency stages at **1/4/8/16 streams**. Build/application traces establishing that inclusion are absent. The older results embedded in the patch are not this run’s measurements.

3. **Claims:**

   - **About one millisecond per decode round:** Not tested directly; no per-step timing.
   - **Several-percent decode slowdown:** Supported descriptively: **−4.07% and −4.21%**, overall **−4.14%**.
   - **Repeatable several-percent aggregate slowdown:** Contradicted by the observed performance comparisons: **−3.61% then +2.43%**, overall **−0.59%**.
   - **Concurrency slowdown:** Partially supported, not uniform. At 4 streams: **−3.01%/−2.97%**; at 16: **−3.02%/−2.36%**; at 8: **−2.52%/+0.95%**.
   - **Two repetitions:** Confirmed. Expected automated **NOT READY**, single-repetition **RERUN**, and eventual closure without merging are not tested by the supplied execution evidence.

4. **Limitations:** The six-suite matrix is complete, order is counterbalanced, public settings match, and restore is recorded as verified. However, only two repetitions ran; candidate restarted twice and control once. Concurrency throughput falls between repetitions on both targets, and retained memory growth varies substantially. Throughput arrays lack underlying response timings/token counts. Fixed benchmark prompt builders match between targets; time-limited soak executes different request counts. Fault, endurance, repro, and external benchmark suites did not run. Image labels identify the stated base, without independent build provenance. Cut-in’s admission predicate incorrectly uses a one-second allowance instead of three; recomputation shows this does not change these outcomes.

5. **Oracles:**

CLAIM TEST: NONE

No executed claim script is present.

AUTHOR TESTS: NONE

The manifest contains no test files or executions, consistent with the patch.

6. EVIDENCE CONTRADICTS THE CLAIM — Decode slows consistently, but performance aggregate throughput reverses direction in repetition two, and concurrency does not show the claimed uniform repeated slowdown.
