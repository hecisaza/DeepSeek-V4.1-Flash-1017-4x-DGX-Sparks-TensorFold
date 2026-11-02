1. **Recomputed results:** No numerical discrepancies, allowing for report rounding.

   | Check | Candidate | Base |
   |---|---:|---:|
   | Identical boundary hashes | **19/19**, matching labels and token counts | |
   | Cut-in median, short | 0.475 s | 0.342 s |
   | Cut-in median, long | 20.176 s | 20.035 s |
   | Admitted during prefill | 3/3 | 3/3 |
   | Soak completions / aborts | 160 / 122 | 162 / 124 |
   | Soak errors / canary mismatches | 0 / 0 | 0 / 0 |
   | Canary checks | 57 | 57 |

   Arithmetic, greedy repeat equality, streaming equality, and JSON-object checks are all recorded true on both targets; smoke errors are empty, with streaming first-token times 0.088/0.095 s. The bundle retains check results, not response bodies, so their underlying assertions cannot be independently replayed.

2. **Changed paths and coverage:**

   - `0047` changes template string concatenation and prompt-history calculation. Ordinary chat requests enter rendering/preparation, but no suite checks allocator resize success or `history_len`. All requests are single-message conversations; none reproduces the many-message growth mechanism.
   - **Description/code mismatch:** `tried_tail` becomes true whenever tail rendering succeeds. A suffix mismatch then leaves `history_len=0` and skips the promised full-history fallback. No test asserts this condition.
   - `0048` changes render/tokenizer scratch allocation and connection-arena retention. Tokenization/rendering ran, but the clients do not reuse a persistent connection across requests, so retained capacity after a large request was not tested.
   - `0049` expands row tables and adds optional decode switches. Both targets use 2048-row chunks and empty environment overrides: neither larger-pass capacity nor enabled switches was tested.
   - `0050` validates negative/out-of-range Engram IDs before allocating batch buffers. No suite supplies invalid IDs. Normal inference therefore shows no regression, **not that this failure-path fix works**.

3. **PR claims:**

   - **Not tested:** preventing long-term memory growth/OOM; the reported anonymous-memory, largest-block, device-memory and available-memory figures; elimination of quadratic allocation and retained scratch.
   - **Supported narrowly:** similar default throughput. Recomputed candidate changes are decode −0.35%, prefill −1.99%, aggregate +1.43%; this is consistent with the claim, without establishing statistical equivalence.
   - **Not tested:** enabled switch behavior, 8192-row operation, invalid-row leak prevention, and fallback correctness. The fallback wording conflicts with the patch as described above.
   - **Partially supported:** candidate startup and successful inference establish a runnable artifact. Clean application of the entire patch series, older-baseline wiring, upstream equivalence, and every unchanged-default assertion lack direct verification.

4. **Evidence limits:** One candidate-first repetition confounds timing with order. The default soak lasts ten minutes, not hours/days; it records available memory, not allocation ownership or anonymous memory. Available memory falls by 895/1045 MB, which proves neither leakage nor its repair. Fixed benchmark prompts match; soak uses seeded, time-limited workloads with slightly different completion counts. Fault, repro and external benchmark suites did not run. The matrix is complete, errors absent, and restore recorded successful. Image identities agree across metadata and run notes, but build provenance is not independently established.

CLAIM TEST: NONE

No reproduction script is present.

AUTHOR TESTS: NONE

`hosttests.json` records no executed tests; the patch’s embedded Zig test checks invalid-row rejection and subsequent valid reads, but has no candidate/base output establishing execution or failure cause.

NO REGRESSION SHOWN, CLAIM NOT TESTED — Matching outputs and error-free suites support regression coverage; long-term memory behavior and invalid-row cleanup remain unverified.
