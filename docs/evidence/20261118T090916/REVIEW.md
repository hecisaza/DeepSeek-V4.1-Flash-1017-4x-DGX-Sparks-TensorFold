1. Recomputed results match the report’s numerical summaries:

| Check | Candidate | Base |
|---|---:|---:|
| Boundary hashes identical | 19/19 paired comparisons | |
| Cut-in median, short | 42.172 s | 42.081 s |
| Cut-in median, long | 44.870 s | 44.773 s |
| Soak completions / aborts | 142 / 107 | 146 / 109 |
| Soak errors / canary mismatches | 0 / 0 | 0 / 0 |
| Canary checks | 47 | 47 |

Arithmetic, greedy-repeat equality, streaming equality and JSON-object checks are all true for both targets; smoke errors are empty and streaming TTFT is 0.099 s each. Original smoke responses are absent, so their predicates cannot be independently recalculated.

One substantive reporting discrepancy: “admitted during long prefill in 3 of 3” is unsupported. `cutin` delays the short request three seconds but compares `short < long - 1`. Adding the intended three-second offset puts short first tokens **0.267–0.315 s after** long first tokens across all six rounds. Exact launch timestamps are absent. The report faithfully copies an invalid admission flag.

2. The patch changes launcher argument validation, snapshot-budget forwarding, banners and post-readiness health checks; engine observation publication, interval accounting, invalidation/placement counters, classified snapshot failures, health serialization, metrics and histogram buckets; plus Dockerfile tests and documentation.

Ordinary completions exercise reservation/release and observation hooks. Boundary repeats, divergences and extensions exercise cache opportunities; soak adds abort/release traffic. None records cache accounts or scrapes metrics, so these demonstrate regression coverage, not correct telemetry. Placement exhaustion and keep/restore/peer-forget failures are not demonstrated. Launcher mismatch, strict-mode, legacy-engine and retry branches run against the author tests’ fake responder.

3. Claim assessment:

- **Supported within mocked launcher tests:** effective-configuration output, legacy unavailability, pool-mismatch warnings with continued service, strict failures, disabled-store warnings, overrides, truncation, malformed/unsafe argument refusals, decimal budgets `08`/`09.5`, and recovery after one HTTP failure.
- **Not verified live:** shared-pool partition correctness, classified counters, health/metrics agreement, configuration matching the real engine, and performance under telemetry scraping.
- **Not independently verified:** historical patch-stack application/builds, image labels, CPU-test totals, the full 200-test run, syntax checks, preparation behavior, and engine-selected concurrency. Dockerfile commands and documentation additions are present, but build logs are absent.
- **Contradicted by inspected implementation, not reproduced here:** the promised retry of an HTTP-200 health response containing an error never occurs—the loop exits before inspecting its body. An inconsistent account exits before printing the promised configuration summary. Additionally, the documented zero-budget disable setting hits the below-one-byte rejection.

4. Evidence limitations: one candidate-first repetition; no counterbalancing; no fault, endurance, benchmark or reproduction suite. Boundary identities/token counts and performance prompt keys match; soak is time-limited and produces unequal workload counts. The matrix is complete for declared suites, errors are empty, and restoration is reported successful. Artifact IDs agree across metadata and run notes, but source-to-image provenance is not independently established. Author-test output contains summaries and a truncated base tail, not individual failure traces.

CLAIM TEST: NONE

No reproduction script is bundled.

AUTHOR TESTS: SOUND

The inspected launcher tests assert specific behavior and preserve successful launches; the base reaches normal launch behavior, and its missing health request violates the new behavioral assertion, although the aggregate failures do not verify engine telemetry.

EVIDENCE CONTRADICTS THE CLAIM — inspected control flow contradicts the promised error-response retries and documented zero-budget support; passing hardware suites do not cover either condition.
