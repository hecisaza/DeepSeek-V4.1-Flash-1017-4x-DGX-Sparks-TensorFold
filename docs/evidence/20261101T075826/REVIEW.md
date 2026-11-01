1. **Recomputed results:** No numerical discrepancies in the requested figures; report rounding is correct.

   Boundary: **38/38** hashes identical, 19/19 per repetition; labels and prompt-token counts match, with no errors.

   Cut-in medians in seconds, shown as short/long:

   | Target | Rep 0 | Rep 1 | All six rounds |
   |---|---:|---:|---:|
   | pr | 16.946 / 19.664 | 16.995 / 19.750 | 16.9545 / 19.682 |
   | base | 17.432 / 20.167 | 17.433 / 20.173 | 17.4325 / 20.170 |

   Soak:

   | Target/rep | Completions | Aborts | Errors | Canaries | Mismatches |
   |---|---:|---:|---:|---:|---:|
   | pr/0 | 169 | 127 | 0 | 61 | 0 |
   | pr/1 | 177 | 132 | 0 | 61 | 0 |
   | base/0 | 172 | 128 | 0 | 58 | 0 |
   | base/1 | 176 | 131 | 0 | 63 | 0 |

   Totals: pr 346 completions, 259 aborts, 122 canaries; base 348, 259, 121. Both have zero recorded errors or mismatches.

   Smoke: arithmetic, greedy-repeat equality, streaming-content equality and JSON-object checks are all `true` for both targets in both repetitions: **16/16**, no errors. Streaming first-token times match the report: pr 0.092/0.095 seconds; base 0.093/0.099. Original replies are absent, so these stored booleans cannot be independently re-evaluated.

2. **Changed paths:** The patch removes `errdefer exec.deinit()` in `round.Graphs.run` and `draft.PassGraphs.run`, retaining cache insertion before first launch. Other changes are documentation.

   The decisive condition is successful capture/instantiation and insertion followed by a failing first `exec.launchOn`. A subsequent matching-key request and teardown would expose stale-handle use and duplicate destruction on the base.

   Ordinary generation requests ran, but there is no graph-level coverage trace. No suite injected that launch failure or counted executable destruction. Soak client disconnects do not establish CUDA launch failures. Neither `fault` nor `repro` ran. **This demonstrates no observed regression, not that the ownership fix works.**

3. **PR claims:**

   - Cache ownership survives first-launch failure, preventing stale launches/double destruction: **not tested**.
   - Successful behavior remains unchanged: **supported narrowly** by matching boundary hashes and passing checks.
   - Unchanged pre-insertion cleanup, insertion/launch order, kernels, keys and collectives; no added allocation or retry: **consistent with the diff**, not independently established by runtime instrumentation.
   - CPU 20-case results, six unpatched failures, 32 GPU probes and historical 52-request A/B/A equality: **not tested here**.
   - Historical combined-patch validation, eight reference replies, needle results and quoted throughput: **not tested here**.
   - Compatibility with the listed patch combinations and byte-identical earlier sources: **not tested**.
   - Lost-context/collective recovery is explicitly unclaimed; this run supplies no evidence for it. No claim is contradicted.

4. **Limits:** Two counterbalanced repetitions, not one fixed-order run; matching public settings and deterministic boundary/cut-in prompts; no recorded restore problem. Image identifiers agree across metadata and `run.txt`, but source/build provenance is not independently verifiable. Soak is time-bounded with differing completed workloads. Hashes cover only response content, truncated to 12 hexadecimal characters—not token IDs, reasoning or tools. The report omits the crucial untested ownership failure path.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 38/38 matching hashes; passing smoke and zero recorded soak errors; no first-launch failure injection or destruction-count verification.
