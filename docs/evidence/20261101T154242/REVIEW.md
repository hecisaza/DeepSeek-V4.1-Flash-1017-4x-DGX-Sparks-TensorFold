1. **Recomputed results:** The requested metrics match `report.md`; no numerical discrepancies.

   | Metric | Candidate | Control |
   |---|---:|---:|
   | Identical boundary hashes | **19/19** paired matches | Same labels and token counts |
   | Cut-in median, short | 17.070 s | 17.094 s |
   | Cut-in median, long | 19.759 s | 19.845 s |
   | Soak completions | 171 | 173 |
   | Client aborts | 130 | 128 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 61 / 0 | 58 / 0 |

   The report’s two-decimal cut-in values follow `report.py`’s Python rounding, including 19.845 → 19.84. Both targets record all four smoke checks as true: arithmetic, greedy repeat equality, streaming equality, and JSON-object mode. Smoke first-token times are 0.090/0.089 s; error lists are empty.

   **Evidence discrepancy:** the report additionally declares the PR’s own tests “confirmed,” with candidate success and control failure. Those results are absent from `results.json`. The generator reads them from `hosttests.json`, which is missing. That declaration cannot be independently verified here.

2. **Changed paths and coverage:** `pr.patch` adds `launcher`, changes prepare’s completion hint, start’s already-running hint, the missing/stale local-copy warning, and the LIVE restart hint. It also records which workers use local weights and selects loading text for zero, one, two, or three local copies. Tests and CHANGELOG change too; inference code does not.

   Exercising these paths requires completing prepare with ring/mesh detection; starting with all containers already running; restarting with matching or missing local copies under `RANK_LOCAL=1`; and reaching the loading/LIVE messages.

   Smoke, boundary, cut-in, performance, and soak requests do not assert these paths. Startup timings establish API readiness, without launcher transcripts or local-copy conditions. In particular, the missing-copy warning is not demonstrated by hardware evidence.

   The added `LauncherHint` and `StartRestart` tests explicitly target these conditions, including both launcher choices and all loading wordings. Their reported execution is relevant, but its underlying evidence is missing. The independently checkable hardware results therefore show no observed regression, not that the message changes work.

3. **PR claims:**

   - **Fabric-appropriate hints and accurate loading-source wording:** consistent with the patch; not independently tested by the supplied raw results.
   - **Local loading takes approximately 35–43 seconds:** not tested. Startup measures switch-to-API readiness, 101.4/100.8 seconds, a different interval.
   - **Messages only; no command, flag, or default changes:** supported by patch inspection; added bookkeeping serves message selection.
   - **167/167 Linux tests pass:** unverified. The report instead quotes 61 tests and 31 subtests; that does not establish 167/167.
   - **New test coverage and CHANGELOG update:** present in the patch.
   - **macOS GNU `stat` requirement:** not tested.

4. **Evidence limits:** One candidate-first repetition permits order, temperature, and cache effects; three rounds are not independent repeated deployments. Recorded settings match, boundary prompts match, and cut-in/performance use matching seeds. Soak is time-limited, so workloads differ despite seeded generators. No recorded suite errors or restore problem appear. Fault, repro, and benchmark suites did not run. Image identifiers consistently label the control as base, but build provenance is absent. Smoke retains booleans rather than replies; arithmetic only checks for substring `391`.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary matches and clean recorded checks; API suites do not validate launcher text; targeted script-test evidence is missing.
