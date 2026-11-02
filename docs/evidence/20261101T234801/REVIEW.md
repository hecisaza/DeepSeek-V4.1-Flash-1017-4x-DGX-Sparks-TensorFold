1. **Recomputed results:** No numerical discrepancies in `report.md`; cut-in medians are correctly rounded.

   | Metric | Candidate | Base |
   |---|---:|---:|
   | Identical boundary hashes | 19/19 against base | Same labels and token counts |
   | Cut-in short median | 0.379 s | 0.388 s |
   | Cut-in long median | 20.107 s | 20.151 s |
   | Admission | 3/3 | 3/3 |
   | Soak completions | 162 | 161 |
   | Intentional client aborts | 123 | 125 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 57 / 0 | 57 / 0 |

   Arithmetic, greedy repeat equality, streaming equality, and JSON-object checks are all `true` on both targets; smoke error lists are empty. Stream first-token times are 0.090/0.095 s. Performance medians, percentage differences, and startup timings also match the report.

2. **Changed paths:** The sole runtime modification sets `conn.quiet_log = true` upon entering `health`, before either the keyed response or the open response. Other changes are documentation. Exercising it requires a `/health` request; verifying it requires observing access logs alongside the successful response.

   No supplied suite requests `/health` or inspects its access logs. Requests target chat completions; readiness helpers use `/models`. Thus even this ordinary route, rather than a rare failure path, is untested. The run supports regression screening, not the logging fix.

3. **Claims in `PR.md`:**
   - **Health access lines disappear:** Not tested.
   - **Ungated access, HTTP 200, keyed minimal body, open model/memory body, and authentication behavior remain unchanged:** Not tested.
   - **Existing response logging consumes the flag:** Consistent with the proposed change, but that implementation and runtime observation are absent.
   - **Key-enabled polling produces misleading authentication labels, including 1,440 daily polls; the recipe starts without keys:** Not tested. Successful unauthenticated chat requests do not establish recipe configuration.
   - **Clean application to the specified upstream revision with earlier patches, with and without `0044`:** Not established by the supplied image identifiers or inference results.
   - **Number allocation and interaction with pending patches:** Not tested.
   - **README, credits, and changelog additions:** Supported by the diff. Compatibility with the other proposed README insertion is not demonstrated.

   No central claim is contradicted; none is behaviorally verified.

4. **Evidence limits:** One candidate-first repetition cannot separate changes from order, temperature, or load effects. Both targets have the same recorded model, chunk size, and environment; boundary prompts match, and other fixed comparison prompts use matching seeds. Soak uses seeded, time-limited workers, so executed request counts differ naturally.

   The matrix is complete for the selected suites, errors are empty, and restoration is recorded as verified. Fault, external benchmark, and reproduction suites did not run. Image IDs identify distinct artifacts but do not independently prove their source revisions. Raw responses are absent, so smoke assertions cannot be independently replayed from this bundle.

5. **Oracles**

CLAIM TEST: NONE

No `executed-script.sh` or reproduction results are supplied.

AUTHOR TESTS: NONE

`hosttests.json` lists no test files or runs, and the patch adds no tests.

6. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — Both targets pass the recorded regression checks; boundary hashes match 19/19; no test observes `/health` responses and access logging.
