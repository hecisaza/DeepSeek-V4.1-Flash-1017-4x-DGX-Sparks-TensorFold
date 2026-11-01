1. **Recomputed results: no numerical discrepancies in `report.md`.**

   | Check | Candidate | Base |
   |---|---:|---:|
   | Boundary hashes identical | **19/19 paired cases** | Same labels and token counts |
   | Cut-in median, short request | 17.266 s | 17.279 s |
   | Cut-in median, long request | 19.995 s | 19.992 s |
   | Soak completions / aborts | 177 / 132 | 174 / 130 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 62 / 0 | 61 / 0 |

   The report rounds the cut-in medians correctly. Both targets record all four smoke checks as true: arithmetic, greedy-repeat equality, streaming-content equality, and JSON-object parsing. Streaming first-token times are 0.089/0.091 s; error lists are empty. Smoke responses and individual soak events are absent, so their recorded checks and counters cannot be independently reconstructed. Performance medians and reported percentage differences also agree with the data.

2. **Changed paths and coverage.** The patch adds an opt-in flag to `Lanes.init`, changes snapshot-position selection through `keepEnd`, caps `prefillStep` at that position, and relaxes `usable()` and `snapSaveFn` alignment from 2048 rows to 16 when enabled. It also adds a validation script, historical measurements, and documentation.

   Both targets have empty recorded environment overrides: **there is no evidence that `TF_DS_KEEP_AT_WINDOW=1` ran**. Under the documented default, the new behavior is disabled.

   Boundary requests `pfx_base_again` and `pfx_extend` exercised repeated and extended text prompts, but cache restoration was not recorded. Exercising the change requires enabling the flag, prefilling beyond the 128-row window, saving a non-2048-aligned snapshot, and replaying or extending that prefix. No suite demonstrates this. No image request ran. The newly accepted snapshot conditions and avoidance of `NotAChunkEnd` were therefore not demonstrated. This shows default-path regression coverage, not that the optimization works.

3. **Claims in `PR.md`.**

   - **Supported, narrowly:** default-off reply compatibility with this control: all 19 boundary output hashes match, and smoke/soak report no failures. The disabled branches also retain the old expressions.
   - **Not tested:** keeping live state exactly at the aligned window start; replaying only 128–143 rows; accepting earlier non-2048-aligned snapshots; fixing growing-history cold prefills; avoiding image re-encoding.
   - **Not tested:** enabled cold/warm token-hash equality across the cache floor, or equality against the historical 36-patch build. These suites hash decoded content, not token IDs.
   - **Not tested:** the quoted image timings, 11.4× replay ratio, cached-token positions, changed-picture miss, cache counters, and absence of named log errors.
   - **Not tested dynamically:** application of all 43 patches to the specified engine revision, unchanged rank/checkpoint behavior, and the offline replay limitation. Numbering and change scope are visible in the diff.
   
   None of the feature claims is contradicted by this run.

4. **Evidence limitations.** One repetition, always candidate before base, limits timing conclusions. Fixed suites use matching prompts; time-bounded soak executes different request counts. No recorded errors or restore problem appears. Image labels/IDs agree across metadata and `run.txt`, but do not independently prove source provenance. `repro`, `fault`, and `bench` did not run; neither did the added validator under `tools/`. Historical JSON embedded in the patch is separate evidence; some entries labeled “cold” already have cached tokens.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary hashes match; the opt-in flag was not recorded as enabled; image replay and non-chunk-aligned restoration were not demonstrated.
