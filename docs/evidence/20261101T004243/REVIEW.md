1. **Recomputed results**

| Check | Candidate | Control |
|---|---:|---:|
| Identical boundary hashes | **19/19 paired matches** | Same prompt labels and token counts |
| Cut-in median, short | 16.927 s | 17.114 s |
| Cut-in median, long | 19.642 s | 19.796 s |
| Soak completions | 169 | 167 |
| Soak client aborts | 127 | 127 |
| Soak errors | 0 | 0 |
| Canary checks / mismatches | 61 / 0 | 56 / 0 |
| Arithmetic | Pass | Pass |
| Greedy repeat equality | Pass | Pass |
| Streaming equality | Pass | Pass |
| JSON object mode | Pass | Pass |
| Smoke streaming first token | 0.093 s | 0.090 s |

**No numerical discrepancies** in these report entries; cut-in values are correctly rounded. Recorded error lists are empty. Performance medians and startup times also match.

However, smoke results contain only check booleans, and soak contains aggregate counters: original responses and individual outcomes are unavailable for independent verification. The report’s separate “own tests confirmed” assertion is not backed by `results.json`; `report.py` reads that section from `hosttests.json`, which is absent from this bundle. That is an evidence gap, not a demonstrated numerical error.

2. **Changed paths and coverage**

`pr.patch` changes four image selections in `scripts/prepare.sh`: both kit-verification invocations, worker NFS file/size inventory, and worker Engram shard copying. Each substitutes `$IMAGE` for `$BASE_IMAGE`. It also adds offline regression tests.

The relevant trigger is preparation with the runtime image available and the base image unavailable; copying additionally requires reaching the shard-copy branch. No inference request exercises these preparation commands. The recorded smoke, boundary, cut-in, performance and soak suites do not invoke them. Startup measurements establish API availability, not execution of those commands under the missing-base condition.

The added tests extract the actual shell commands and mock image availability, including matching and permitted bias-difference kit cases. The report says they passed on the candidate and failed on the control, but their raw execution evidence is missing. **The hardware results establish observed runtime non-regression, not successful preparation without the base image.**

3. **PR claims**

- **Four utilities now use the runtime image:** supported by direct patch inspection; operational effectiveness is not tested by the recorded hardware suites.
- **Avoids the extra base-image dependency:** consistent with the substitutions; real preparation with the base unavailable is not tested.
- **Build-base uses, engine, checkpoint, manifest acceptance, copy/rename behavior and defaults remain unchanged:** supported by the patch’s narrow scope; runtime results provide limited corroboration.
- **Offline regression covers four subcases:** supported by test-source inspection. Candidate-pass/control-fail execution is asserted only by the report.
- **91 unit tests, shell syntax and whitespace checks pass:** not independently evidenced here.
- **Direct stated-base ancestry, independence from related changes, and prior validation using no real deployment:** not established by this run. The control tag matches the stated base prefix; ancestry is unverified.

4. **Evidence limits**

One repetition, candidate first, prevents separating order effects from small timing differences. Fixed-request suites use matching prompts; time-limited soak produces unequal workloads despite seeded generators. Fault, benchmark and reproduction suites did not run. No recorded errors or restore problem appear; restoration is reported verified. Image identifiers are recorded, but build provenance is absent. Missing offline-test artifacts are the decisive coverage gap.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary matches and clean recorded checks; preparation’s missing-base condition was not exercised by the hardware suites; claimed offline confirmation lacks raw evidence.
