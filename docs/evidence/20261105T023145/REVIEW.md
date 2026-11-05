1. **Recomputed results:** No numerical discrepancies in the requested report entries.

| Target / repetition | Cut-in median short / long, seconds | Soak completions / aborts / canaries |
|---|---:|---:|
| Candidate 0 | 0.380 / 20.583 | 163 / 126 / 57 |
| Candidate 1 | 0.430 / 20.114 | 159 / 122 / 57 |
| Base 0 | 0.389 / 20.477 | 162 / 125 / 57 |
| Base 1 | 0.398 / 20.428 | 162 / 122 / 57 |

Boundary hashes match **38/38**, comprising 19/19 per repetition; prompt token counts also match. Pooled short-request medians are **0.405 s candidate**, **0.3955 s base**. All 12 cut-in rounds satisfy admission even after accounting for the three-second delay.

Soak totals: candidate **322 completions, 248 aborts**; base **324 completions, 247 aborts**. Each has **114 canaries, zero recorded errors and zero mismatches**.

Arithmetic, greedy-repeat equality, streaming equality and JSON-object checks are all true in all four smoke runs, with no errors. Stream first-token times are candidate 0.090/0.091 s and base 0.092/0.088 s. Underlying smoke replies and individual soak outcomes are not retained, so their assertions cannot be independently reconstructed beyond these stored results.

2. **Changed paths and coverage:** The patch adds launcher budget forwarding, argument validation and post-readiness configuration checking; engine observation publication, pool interval accounting, invalidation/placement counters, classified snapshot failures, health serialization, metrics and longer histogram buckets; plus documentation and build tests.

Boundary repeat/divergence/extension requests, concurrent inference and soak aborts exercise ordinary allocation, release and cache activity. They do **not assert telemetry correctness**. No hardware suite deliberately triggers keep/restore/peer-forget failures, inconsistent accounting or pool exhaustion. No suite scrapes and validates the new metrics. For those paths, this is regression evidence, not verification.

The author tests exercise launcher success, rejection and compatibility paths using synthetic health responses.

3. **Claims in `PR.md`:**

- **Supported for the launcher:** matching configuration reporting; old-engine continuation; mismatch/inconsistency/disabled-store rejection; explicit override continuation; argument precedence, fractional-budget truncation, invalid overrides and falsey health errors. Positive cases require successful launching, so indiscriminate rejection would fail.
- **Supported by inspection:** default budget wiring, banner additions, documentation and Dockerfile contract-test commands.
- **Not verified by this run:** live pool partitions, counter accuracy, health/metrics agreement, observation freshness and failure-stage accounting.
- **Not independently substantiated:** historical image builds, complete patch-stack application, the full 200-test suite, syntax checks, deployment state and engine-selected stream behavior. Only the two listed Python test files have execution results here.
- The advertised **5/6** statuses belong to the embedded checker; the launcher tests explicitly expect **exit 1** on rejection.

4. **Limitations:** Two counterbalanced repetitions, a complete six-suite matrix, matching performance prompt identities and recorded successful restoration support the comparison. Only image identifiers establish base provenance within this bundle. Base has one recorded startup versus two for candidate, limiting startup comparisons. Fault, endurance and reproduction suites did not run. Author-test output retains only a tail, preventing attribution of every base failure; it nevertheless shows execution reaching a successful launch, rather than an import/setup failure.

CLAIM TEST: NONE

No executed reproduction script is present.

AUTHOR TESTS: SOUND

The inspected tests assert launcher-specific outputs, successful controls and rejection behavior; base execution reaches launching, while the added mandatory health-request assertion directly distinguishes the new behavior.

EVIDENCE SUPPORTS THE CLAIM — the launcher check has a sound passing oracle; hardware regression measurements agree with the report; live telemetry accuracy remains unverified.
