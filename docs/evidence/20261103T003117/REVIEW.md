1. **Recomputed results:** No numerical discrepancies in the requested report entries.

   - **Boundary:** 19/19 identical, non-error hashes per repetition; **38/38 total**. Prompt labels and token counts match.
   - **Cut-in:** Exact short/long medians, in seconds:

     | Target | Rep 0 | Rep 1 |
     |---|---|---|
     | Candidate | 0.380 / 20.179 | 0.375 / 20.239 |
     | Control | 0.367 / 20.093 | 0.338 / 20.052 |

     The report rounds these correctly. Pooled short medians are 0.3775 and 0.3545 seconds respectively. All 12 rounds satisfy admission even after accounting for the actual three-second launch delay.
   - **Soak:** Candidate repetitions recorded 161/160 completions, 123/122 aborts, and 57/57 canaries. Control recorded 158/162 completions, 122/123 aborts, and 56/57 canaries. All recorded error and mismatch counts are zero. Totals: candidate **321 completions, 245 aborts, 114 canaries**; control **320, 245, 113**.
   - **Smoke:** Arithmetic, greedy repeat equality, streaming equality, and JSON-object checks are true in all four runs; zero recorded errors. Stream first-token times match the report: candidate 0.108/0.091 seconds, control 0.093/0.089. Original responses are absent, so these assertions cannot independently be reconstructed.

2. **Changed paths:** The PR adds a patch inserting 400,000 volatile arithmetic iterations immediately after the engine step counter increments, before live-stream filtering. This is an unconditional ordinary execution path, not a failure path. All completion suites would traverse it if the patch was applied. Particularly relevant are the 256-token single-stream performance requests, four-stream batches, and concurrency stages at 1/4/8/16 streams. These ran. The bundle lacks build/application traces proving the embedded patch reached the executable; image identifiers alone do not establish that.

3. **Claims:**
   - **Approximately one millisecond per decode round:** Not directly tested; no step-level timing.
   - **Several-percent performance slowdown:** Supported descriptively for single-stream decode: **−3.72% and −4.22%**. Performance-suite aggregate changes are **−5.75% and −2.67%**; the reported overall −4.2% is correct, but repeatability beyond noise is not established.
   - **Concurrency slowdown:** Contradicted by the observed comparisons, though compromised by control instability. Rep 0 differences range from −2.24% to +0.33%; rep 1 shows the candidate **8.92–30.84% faster**.
   - **Two repetitions and expected NOT READY:** Two repetitions ran. No automated NOT READY decision or decision implementation is supplied. Single-repetition RERUN behavior is untested.
   - Closing without merging is a workflow intention, not tested here.

4. **Evidence limitations:** The control’s second concurrency run is unstable: its 16-stream median falls from **132.2 to 93.55 tokens/s**, with **522–533 MB** retained growth per sampled instance after drain, versus approximately 23–25 MB previously. The cause is unexplained. Counterbalanced order, matching public settings, complete suite matrices, and verified restore are positives. Startup counts indicate unequal restart exposure. Fault, repro, and external benchmark suites did not run. Base identity is labeled but lacks independent provenance.

5. **Oracles:**

CLAIM TEST: NONE  
No executed claim script is present.

AUTHOR TESTS: NONE  
The test manifest lists no files or executions, consistent with the patch.

6. EVIDENCE UNRELIABLE — The control’s concurrency throughput collapses in repetition two; substantial retained memory growth accompanies that collapse; these confound the claimed repeatable concurrency slowdown.
