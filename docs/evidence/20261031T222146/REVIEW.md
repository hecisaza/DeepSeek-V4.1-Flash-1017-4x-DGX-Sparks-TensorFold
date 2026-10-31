1. **Recomputed results:** The requested numerical results agree with `report.md`; there are no numerical discrepancies.

   | Measurement | Candidate | Base |
   |---|---:|---:|
   | Matching boundary hashes | **19/19**, with matching labels and token counts | |
   | Cut-in median, short request | 17.116 s | 17.084 s |
   | Cut-in median, long request | 19.842 s | 19.805 s |
   | Soak completions | 178 | 175 |
   | Soak client aborts | 132 | 131 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 64 / 0 | 59 / 0 |

   Both targets record **true** for arithmetic, greedy-repeat equality, streaming equality and JSON mode, with empty error lists. The report’s rounded cut-in values are consistent with its Python rounding. Smoke response bodies are absent, so the recorded check outcomes cannot be independently re-evaluated.

   One provenance discrepancy matters: the report’s “own tests: confirmed” section is **not backed by `results.json`**. `report.py` reads that evidence from `hosttests.json`, which is absent from this bundle. Its claim that the numbers come only from `results.json` is therefore incomplete.

2. **Changed paths and coverage:** `pr.patch` changes two runtime paths, plus regression tests and the changelog.

   - `stop.sh`: reads `/health`’s `live.connections`, validates HTTP status, error envelope and count, and distinguishes open requests from unknown activity. Exercising this requires invoking the script while requests are open, or supplying invalid/error/failed health responses. No included hardware suite does that.
   - `start.sh`: validates its completion’s HTTP status, error envelope, message role and text using explicit checks. Exercising the fixes requires running the script with such responses as HTTP 500 containing valid-looking choices, HTTP 200 with an error, or optimization enabled. The hardware smoke suite calls the API through its own client; it does not execute this validator.

   Startup timings show API availability, not script-validation coverage. Soak disconnects exercise server cancellation, not the scripts’ response-handling failures. The added regression tests target the relevant paths, but their execution is only asserted in the report.

3. **PR claims:**

   - Correct open-request counting, no double-counting of waiting requests, unknown-activity warnings, and `error: null` handling: **not tested by the recorded hardware run**.
   - Correct rejection/acceptance of startup responses, including absent roles and null errors: **not tested**.
   - Checks remaining effective under `PYTHONOPTIMIZE`: **not tested**.
   - Preserved stopping behavior, `DRY_RUN` behavior and exit status: **not tested**.
   - 132 passing tests, 43 additions, 53 failing base checks and the detailed case totals: **not independently verified**. The report’s 77-test subset is different evidence, not inherently a contradiction.
   - The described live warning and successful “OK” checks, repeated on final head: **not recorded here**.

   No PR claim is directly contradicted by the raw results.

4. **Evidence limitations:** One candidate-first repetition cannot separate target effects from order or thermal effects. Fixed boundary, cut-in and performance prompts match; time-limited concurrent soak workloads differ in completed work. `repro`, `fault` and `bench` did not run. No errors or restore problem are recorded. The control tag matches the stated base prefix, although build provenance is not independently supplied. Missing script-test results are the decisive coverage gap.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary matches; both targets pass recorded smoke and soak checks; the changed script paths lack independently auditable execution evidence.
