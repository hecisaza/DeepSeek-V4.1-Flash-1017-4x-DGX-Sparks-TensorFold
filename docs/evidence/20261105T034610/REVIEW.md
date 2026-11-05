1. **Recomputed results**

| Measurement | Candidate, repetitions 0 / 1 | Base, repetitions 0 / 1 |
|---|---|---|
| Boundary hashes identical | 19/19 / 19/19 | **38/38 total** |
| Cut-in short medians, seconds | 17.099 / 17.104 | 17.167 / 17.050 |
| Cut-in long medians, seconds | 19.850 / 19.842 | 19.868 / 19.769 |
| Soak completions | 175 / 175 | 178 / 178 |
| Client aborts | 132 / 129 | 132 / 132 |
| Canary checks | 60 / 58 | 64 / 63 |

All soak error and canary-mismatch counts are zero. Arithmetic, greedy-repeat equality, streaming equality and JSON-object checks are recorded true in all four smoke runs, with no errors. Smoke first-token times are 0.091/0.095 seconds versus 0.089/0.088.

The report reproduces these numbers correctly, including rounding. **Its admission interpretation is wrong:** `basic.py` delays the short request three seconds but tests `short < long − 1`. Adding the nominal three-second offset puts every short first token **0.248–0.334 seconds after** the long first token. The four “3 of 3 admitted during prefill” statements are unsupported; exact start timestamps were not retained.

2. **Changed paths and coverage**

The patch changes launcher argument validation, snapshot-budget forwarding, post-readiness `/health` checking and reporting; engine pool accounting, mutation-time observation, snapshot failure counters, health serialization, metrics and latency buckets; Dockerfile tests and documentation.

Boundary prefix repeats/divergences/extensions and concurrent requests traverse allocation, retention and release paths. Soak adds cancellations. None records or asserts the new telemetry. Exercising allocations does not verify their accounting.

Keep/restore/peer-forget failures, inconsistent accounting and placement exhaustion require specific conditions that these hardware suites do not demonstrate. `/metrics` output and long-latency buckets are untested. These runs establish regression evidence, not correctness of those additions.

3. **PR claims**

- **Supported by source inspection:** the new patch, configuration default, forwarding, documentation and Dockerfile test commands exist.
- **Supported by mocked author tests:** effective-configuration reporting, older-engine fallback, mismatch/inconsistency rejection, explicit override, argument guards, fractional truncation and tested zero-padded budgets.
- **Not verified on hardware:** accurate pool partitions, snapshot counters, metric families, telemetry consistency and actual engine-selected stream counts.
- **Not independently substantiated:** historical builds, patch-application totals, 200-test result, shell syntax checks and deployment state; corresponding raw logs are absent.
- **Exit-code qualification:** tests require launcher exit **1** for mismatches; **5/6** are internal checker statuses. The description is inaccurate if it promises those launcher exit codes.

4. **Evidence limits**

The six selected suites have complete two-repetition matrices, counterbalanced ordering, matching boundary cases and performance prompt keys, no recorded errors and a reported successful restore. Image identifiers agree across metadata and `run.txt`, but checkout provenance is not independently demonstrated.

The base has one startup measurement versus two for the candidate, permitting unequal process history. Fault, endurance and repro did not run. Smoke retains check results rather than response bodies. Author-test output is truncated, limiting individual failure attribution.

5. **Oracles**

CLAIM TEST: NONE  
No executed reproduction script is present.

AUTHOR TESTS: SOUND  
For launcher behavior, inspected tests require successful launches as well as specific refusals, and the base output reaches launch success rather than failing setup; they do not verify engine telemetry.

6. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — matched regression runs pass; mocked tests verify launcher behavior; the central engine-telemetry contract lacks recorded runtime assertions.
