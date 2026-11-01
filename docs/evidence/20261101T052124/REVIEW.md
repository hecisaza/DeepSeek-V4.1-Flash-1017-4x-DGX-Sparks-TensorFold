1. **Recomputed results**

   - Boundary: **19/19 matching hashes**, with identical prompt labels and token counts.
   - Cut-in medians, short/long: candidate **17.363/20.111 s**; control **16.982/19.690 s**. The report rounds these correctly.
   - Soak: candidate **177 completions, 132 aborts, 0 errors, 64 canaries, 0 mismatches**; control **174 completions, 131 aborts, 0 errors, 58 canaries, 0 mismatches**.
   - Smoke: arithmetic, greedy-repeat equality, streaming equality and JSON mode are all recorded as **true** for both targets. Streaming first-token times are **0.141 s** and **0.092 s**; both error lists are empty.

   **No discrepancies in these reported metrics.** Smoke responses and individual soak events are absent, so their recorded checks/counters cannot be independently reconstructed.

   A separate evidence gap: the report labels the PR’s own tests “confirmed,” with candidate passing and control failing. `report.py` obtains that section from **`hosttests.json`**, which is absent; `results.json` contains no corresponding results. That assertion is unverifiable from this bundle.

2. **Changed paths and coverage**

   `pr.patch` adds two executable lines in `start.sh`: bracket an IPv6 value when constructing the readiness/smoke URL, and bracket an IPv6 value when printing the API URL. It also adds regression tests and a changelog entry.

   The first branch requires an explicit IPv6 bind value surviving wildcard normalization. The second requires an IPv6 display value, either explicitly selected or discovered under wildcard binding.

   The added tests would exercise readiness **GET `/v1/models`**, smoke **POST `/v1/chat/completions`**, displayed URLs, raw engine bind arguments and container launches.

   The recorded hardware suites send inference requests through a supplied API URL; they do not test launcher URL construction or printed output. Startup timings establish API availability, not which launcher branches ran. No recorded configuration establishes either IPv6 branch was exercised. The report claims separate launcher tests ran, but their underlying evidence is missing.

3. **PR claims**

   - **IPv6 readiness, smoke and printed URLs are fixed:** not independently tested by the available raw results; the patch implements the described transformation.
   - **Wildcard probe mapping, address selection and raw engine bind arguments remain unchanged:** consistent with the diff, but not directly verified by this run.
   - **Six new tests covering seven cases and the listed assertions:** supported by inspection of the added test source.
   - **All 95 tests pass, no IPv6 skip, and three cases fail on the base:** not verifiable here. The report’s abbreviated test summary does not establish the full-suite claim.
   - **Branch ancestry and merge compatibility:** not tested.
   - **No coverage of engine IPv6 binding or remote IPv6 reachability:** consistent with the available evidence.

4. **Limitations**

   One repetition, candidate first, prevents separating order effects from changes. Boundary prompts match; cut-in and performance prompts use shared deterministic seeds. Soak is time-limited and processes differing request counts. No recorded suite errors or restore failure appear. Fault, external benchmark and reproduction suites did not run. Image identifiers agree across metadata and `run.txt`, but build provenance and base ancestry are not independently established. The missing launcher-test artifact is the decisive coverage gap.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary matches; recorded smoke/soak checks pass; IPv6 launcher-test results lack their underlying artifact.
