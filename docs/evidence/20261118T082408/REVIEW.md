1. **Recomputed results:** No numerical discrepancies in the requested report entries.

   - Boundary: **19/19** nonempty reply hashes identical; labels and token counts also match.
   - Cut-in medians, candidate/base: short **0.871/1.678 s**; long **45.538/45.138 s**. Report rounding is correct. Both admitted the short request before the long request’s first token in **3/3** rounds, including the actual three-second delay.
   - Soak, candidate/base: **117/103** ordinary completions, **85/74** aborts, **37/32** canary checks; **0/0** errors and mismatches. Error lists are empty.
   - Smoke: arithmetic, greedy repeat equality, streaming equality and JSON-object checks are all true on both targets; streaming first-token times are **0.103/0.098 s**.

   Smoke replies and individual soak events are absent, so their recorded checks/counts can be reconciled, not independently reconstructed. The report’s broader “confirmed” author-test conclusion exceeds what its numerical summaries establish.

2. **Changed paths and coverage:** The patch adds allocator interval accounting, mutation-triggered observations, invalidation/placement counters, classified snapshot failures, CUDA wiring, `/health` serialization, `/metrics` families and longer histogram buckets. It also changes launcher argument validation, budget forwarding, post-readiness checks, documentation and build tests.

   Boundary prefix repeat/diverge/extend requests exercise cache-related inference; cut-in, soak and concurrency exercise reservations, release and cancellation. None records or asserts the resulting telemetry. Snapshot save/restore failures, peer-forget failures and exhausted-pool counters require specific failures or pressure; their occurrence is not demonstrated. These suites establish regression coverage, not telemetry correctness.

   Author tests exercise launcher paths using fabricated health responses, including mismatch warnings, strict failures, overrides and retries.

3. **Claims in `PR.md`:**

   - **Supported narrowly:** mocked effective-configuration reporting, old-engine compatibility, pool-mismatch continuation, strict rejection, disabled-store warnings, one HTTP-500 retry, argument refusals, fractional truncation and tested leading-zero budgets.
   - **Present in the diff; not verified live:** budget forwarding/banner changes, shared-pool categories, store counters, health/metric contracts and documented units.
   - **Not independently tested here:** historical patch-stack application/build assertions, exact CPU-test counts, the full 200-test suite, shell syntax checks, deployment/rebuild behavior, engine-selected stream count and engine arithmetic beyond mocked expectations. No build logs substantiate these claims.
   - **Retry claim has a source-level contradiction:** HTTP 200 ends the retry loop before examining an `error` object, so that response fails after one read. Tests check rejection but not the promised retries.
   - The documented zero-budget capability also conflicts with validation: zero reaches the “below one byte” rejection. No zero-budget acceptance test covers it.

4. **Evidence limits:** One repetition, candidate first; no counterbalancing. All six requested hardware suites have both targets and no recorded errors. Boundary inputs and performance prompt keys match; the time-limited soak processes different quantities and cannot establish a paired throughput improvement. Restore is recorded successful. Image identifiers agree across records, but source provenance is not independently attested. Fault, endurance, benchmark and reproduction suites did not run. Author output contains only tails, without individual base assertion failures.

CLAIM TEST: NONE
No reproduction script is bundled.

AUTHOR TESTS: SOUND
For the covered launcher behaviors, tests require successful launches as well as specific refusals; the base reaches launch successfully, and its missing health request is a behavioral difference, although truncated output prevents attributing every failure.

NO REGRESSION SHOWN, CLAIM NOT TESTED — paired inference checks pass; author tests verify selected mocked launcher behaviors; live telemetry accounting and failure counters remain unverified.
