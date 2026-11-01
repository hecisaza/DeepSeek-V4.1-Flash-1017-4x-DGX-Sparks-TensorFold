1. **Recomputed results.** No discrepancies in the requested metrics:

   | Metric | Candidate | Control |
   |---|---:|---:|
   | Identical boundary hashes | 19/19 paired matches | Same labels and token counts |
   | Cut-in median, short | 17.163 s | 16.950 s |
   | Cut-in median, long | 19.861 s | 19.685 s |
   | Soak completions / aborts | 174 / 131 | 169 / 127 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 62 / 0 | 61 / 0 |

   Arithmetic, greedy-repeat equality, streaming equality, and JSON-object checks are all `true` on both targets; smoke error lists are empty. Report rounding matches `report.py`, including 19.685 → 19.68. Smoke responses themselves are absent, so those checks cannot be independently re-evaluated beyond their recorded booleans.

   Performance medians and percentages also match: decode −4.3%, prefill −2.0%, aggregate −2.9%. Startup was 101.8 versus 167.4 seconds: 65.6 seconds, or 39.2%, shorter.

2. **Changed paths and coverage.**

   - **0037:** NVFP4 checkpoint parsing, weight conversion/loading, expert kernels, activation quantization, and MXFP4 Engram decoding. Ordinary inference exercises shared code, but no NVFP4 configuration is recorded.
   - **0039:** grammar-setup failure handling and cleanup after stream initialization failure. JSON smoke exercises successful grammar setup; neither failure was induced.
   - **0040:** cached graph ownership when its first launch fails. No graph-launch failure was induced.
   - **0041:** grammar-test API compatibility. No Zig-test results are supplied.
   - **0042:** preservation of structured JSON, particularly with offered tools and marker-like content. Smoke sends nonstreaming `response_format=json_object`, but offers no tools; the distinguishing tool/JSON interaction and structured streaming were not tested.
   - **0043:** warnings for tool-enabled replies containing only orphan DSML closing tags. No suite supplies tools or triggers that output.
   - **0046:** rank-cache load prefetch. Startup measures the relevant loading operation, but lacks tracing or an isolated prefetch-on/off comparison.
   - Launcher/preparation changes cover locks, bootstrap selection, runtime-image utilities, failed index generation, local rank files, URL formatting, and start/stop response validation. Successful switching provides basic integration coverage; exceptional conditions, alternate topology, and opt-in storage paths are not demonstrated. Workflows, documentation, and claim scripts also change; no `repro` suite ran.

   For untriggered failure paths, this shows no observed regression—not that the fixes work.

3. **Claims in `PR.md`.**

   - Assembled-build comparison and limited functional nonregression: **supported** for the recorded workloads.
   - Faster startup: **supported as one observation**, without causal attribution or repeatability.
   - Fourteen-port/thirty-commit provenance and upstream revision correspondence: **not independently tested**. The control tag matches the stated base prefix; image tags alone do not establish source contents.
   - Candidate retained on every device: **not established**. Restore reports the live artifact, without identifying it per device.
   - Failure fixes remain unverified: **consistent with this run**.

4. **Evidence limitations.** One candidate-first repetition confounds timing with order/cache conditions. All throughput medians decrease, although ranges overlap. Fixed boundary/cut-in/performance prompts match; timed soak workloads differ in request counts and interleaving. Canaries compare against each target’s own reference. Fault, repro, and external benchmark suites are absent. Restore reports success. The report’s host-test “confirmed” claim cannot be audited: `hosttests.json` and complete logs are missing.

5. **EVIDENCE SUPPORTS THE CLAIM** — narrowly: 19/19 boundary replies match, recorded suites have zero errors, and the single candidate startup is 39.2% shorter.
