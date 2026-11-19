1. **Recomputed results:** No numerical discrepancies in the requested report figures.

   - Boundary: **38/38** nonempty hashes match: 19 corresponding prompts per repetition, with matching token counts and no errors.
   - Cut-in medians, seconds:

   | Target / repetition | Short | Long |
   |---|---:|---:|
   | Candidate 0 | 0.918 | 61.951 |
   | Candidate 1 | 1.764 | 45.329 |
   | Control 0 | 1.805 | 45.471 |
   | Control 1 | 1.754 | 45.446 |

   The report rounds these correctly. Pooled six-round medians are candidate **1.3525 / 46.553**, control **1.799 / 45.4635**. All 12 rounds satisfy admission even after accounting for the short request’s three-second delay.

   - Soak, completions/aborts: candidate **117/85**, **112/81**; control **114/82**, **114/82**. Totals: **229/166** versus **228/164**. Every repetition records **0 errors**, **37 canaries**, **0 mismatches**.
   - Smoke: arithmetic, greedy-repeat equality, streaming equality and JSON-object checks are all true in all four runs; error lists are empty. Streaming first-token times are candidate **0.098/0.100 s**, control **0.099/0.101 s**. The underlying replies are absent, so these booleans cannot be independently revalidated.

2. **Changed paths:** The new patch changes `thinkingFields` in `zig/src/server/fields.zig`: when kwargs supply no thinking switch, it parses the body’s `thinking`, overrides the effort-derived enable state, and clears effort `none` when enabled. It also adds parser tests and documentation.

   A request with top-level `thinking: {"type":"enabled"}` or `disabled`, without a kwargs switch, would exercise the new behavior. None ran. The shared client supplies both kwargs switches as false; soak abort requests omit top-level thinking entirely. This is an ordinary request-parsing branch that the suites bypass, not a failure path. The run demonstrates regression coverage only.

3. **PR claims:**
   - Top-level enable/disable, clearing effort `none`, precedence over `reasoning_effort`, and kwargs precedence against a conflicting body switch: **not tested**.
   - Unchanged behavior without top-level thinking: **supported for the exercised requests**, not universally verified.
   - Adaptive/malformed inputs and unchanged `/v1/messages`: **not tested**.
   - Six passing parser tests, clean patch application, and named build-time tests: **not independently verified**. Runnable images support build viability, but no corresponding build/test logs are supplied.
   - The historical thinking-token table, default-setting comparison, and every listed answer being 391: **not tested by this run**. Nothing here contradicts those claims.

4. **Limitations:** Two counterbalanced repetitions, matching performance prompt identities, a complete selected-suite matrix, empty error lists and recorded successful restoration support the comparison. However, effective thinking defaults are not recorded; image labels identify the stated base without independent build provenance. Startup samples are unequal, timing varies substantially, and the timed soak executes differing workload counts. Repro, fault, endurance and external benchmarks did not run.

5. **Oracles**

CLAIM TEST: NONE

No `executed-script.sh` or repro results are present.

AUTHOR TESTS: NONE

`hosttests.json` contains no files or executions; the embedded Zig assertions test relevant parser behavior, but have no recorded candidate/control output establishing a behavioral failure on base.

NO REGRESSION SHOWN, CLAIM NOT TESTED — matching boundary results and passing smoke/soak checks; no request exercises the new switch; no executed claim oracle.
