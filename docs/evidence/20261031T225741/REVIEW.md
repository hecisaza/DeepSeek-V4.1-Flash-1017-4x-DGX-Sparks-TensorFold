1. **Recomputed results**

   | Check | PR | Base |
   |---|---:|---:|
   | Boundary hashes identical | **19/19 across targets** | |
   | Cut-in median, short request | 16.866 s | 17.074 s |
   | Cut-in median, long request | 19.588 s | 19.824 s |
   | Soak completions | 176 | 171 |
   | Soak client aborts | 130 | 130 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 64 / 0 | 61 / 0 |

   Both targets record all four smoke checks as true: arithmetic, greedy repeat equality, streaming equality, and JSON-object mode. Smoke errors are empty; streaming first-token times are 0.110 s and 0.091 s.

   **No numerical discrepancies** in these results; cut-in values round correctly in `report.md`. Performance medians, percentage differences, and startup times also match.

   One evidence discrepancy: the report declares the PR’s two tests “confirmed,” passing on the candidate and failing on the base. Those outcomes are absent from `results.json`. `report.py` obtains them from `hosttests.json`, which is missing from this bundle. That declaration cannot be independently checked. Smoke responses themselves are also absent, so their recorded booleans cannot be recomputed from response content.

2. **Changed paths and coverage**

   `scripts/nodes.sh` closes FDs 8/9 for SSH invoked through `worker()`, after its unavailable-worker guard. `start.sh` closes FD 8 in both children of the background Docker-log/sed pipeline. The patch also adds two offline tests targeting those actual code paths and parent-descriptor preservation.

   The critical condition is a child surviving its launcher while retaining an inherited lock, followed by another lifecycle invocation attempting to acquire that lock. None of the recorded inference suites creates or verifies that condition. Client request cancellation during soak is not launcher termination.

   Startup measurements show successful API readiness, without proving which launcher revision executed or inspecting descriptors. The report says the targeted offline checks ran, but their underlying results are unavailable. Thus the independently inspectable run shows inference non-regression, not successful lock isolation.

3. **PR claims**

   - **Persistent children can retain launcher locks and block later invocations:** not reproduced by the recorded suites.
   - **The closures prevent that inheritance while preserving parent descriptors:** consistent with the patch; not established by the supplied raw results.
   - **Two offline regression checks were added:** supported by the patch. **They fail on base and pass on PR:** reported, but not independently verifiable here.
   - **All 91 tests passed:** not tested by the supplied recorded run.
   - **No runtime/model changes or new dependencies:** supported by patch inspection; inference results show no observed regression.
   - **These closures were used in a four-device deployment:** not established by this bundle.
   - No claim is directly contradicted.

4. **Evidence limitations**

   One repetition, candidate first, leaves timing comparisons exposed to order effects. Boundary labels and token counts match; fixed prompt builders match across targets. Soak uses seeded workers but timing-dependent workloads, so completed request sets differ.

   No recorded errors or restore problem appear; restoration is recorded as verified. `fault`, `repro`, and `bench` did not run. Image identifiers agree between metadata and `run.txt`, but build provenance independently linking the control to the stated base is absent. Missing offline-test evidence is the decisive coverage gap.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 hashes match; no recorded inference errors; launcher-lock behavior lacks independently checkable test results.
