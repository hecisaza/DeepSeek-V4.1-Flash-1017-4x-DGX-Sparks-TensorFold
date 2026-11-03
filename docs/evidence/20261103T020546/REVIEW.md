1. **Recomputed results:** No discrepancies in the requested report numbers.

   - Boundary: **19/19** valid hashes match; prompt labels and token counts also match.
   - Cut-in medians, short/long: candidate **0.359/20.174 s**, control **0.371/19.956 s**. The report correctly rounds these to **0.36/20.17** and **0.37/19.96 s**. Both show admission in **3/3** rounds.
   - Soak, each target: **162 completions, 125 client aborts, 0 errors, 57 canary checks, 0 mismatches**.
   - Smoke, each target: arithmetic, greedy repeat equality, streaming equality and JSON-object checks all `true`; no errors. Streaming first-token times are **0.094 s** and **0.090 s**.

   Smoke responses are not retained, so their recorded booleans cannot be independently re-evaluated against response text.

2. **Changed paths:** The PR adds a patch targeting `chat.zig`’s ordinary `generate()` path. Each successful allocation reserves and touches **8 MiB**, with no corresponding free; allocation failure is silently ignored. Normal chat requests in smoke, boundary, cut-in, performance, soak and concurrency exercise the intended path, assuming the image applied the patch. This is not an untriggered rare or failure path. Allocation failure itself was not tested.

3. **Claims:**

   - **8 MiB retained per request:** Supported by the code and approximately by the measurements; exact allocation attribution is not instrumented.
   - **About a gigabyte more growth than control after concurrency drain:** Supported. Across **128 successful requests**, the main serving container grows **1071.1 MiB** versus **14.3 MiB**: **1056.8 MiB excess**, close to the **1024 MiB** prediction. The report labels these binary-scaled quantities “MB.”
   - **Pipeline returns `NOT READY` for memory growth:** Not demonstrated. Concurrency records `ok: true` because its predicate checks errors and reply mismatches, not memory growth. Neither a memory rejection assertion nor a resulting `NOT READY` verdict is supplied.
   - **Close without merging:** A workflow intention, not tested here.

4. **Evidence limits:** There is one candidate-first repetition without counterbalancing. Recorded settings match, the suite matrix is complete for the declared run, all recorded error lists are empty, and restoration is recorded as verified. No prompt mismatch is apparent in the fixed workloads; the time-bounded soak does not retain individual requests to establish identical workloads. Image identifiers agree across metadata and `run.txt`, but independent build provenance tying the control to the stated base is absent. Fault, benchmark and reproduction suites did not run. Memory is an aggregate container measurement after a 30-second drain, not allocation tracing.

5. **Oracles:**

CLAIM TEST: NONE  
No `executed-script.sh` is present; the built-in concurrency suite measures growth but does not assert memory-based rejection.

AUTHOR TESTS: NONE  
`hosttests.json` lists no test files or executions, consistent with the patch.

6. NO REGRESSION SHOWN, CLAIM NOT TESTED — Functional comparisons pass; the intentional memory regression is measured; the claimed automatic `NOT READY` decision lacks an asserting oracle and recorded outcome.
