1. **Recomputed results.** Boundary: **19/19** nonempty reply hashes match, with matching labels and token counts and no errors. Cut-in medians, short/long: **PR 42.228/44.915 s; base 42.344/45.034 s**. Soak: PR **139 completions, 105 aborts**; base **146 completions, 109 aborts**; each has **0 errors, 47 canary checks, 0 mismatches**. Both record arithmetic, greedy-repeat equality, streaming equality and JSON-object checks as true, with **0 errors** and **0.098 s** streaming first-token time.

   These values match `report.md` after rounding. Smoke replies themselves are absent, so their recorded booleans cannot be independently validated.

   Two report conclusions are unsupported:
   - “Admitted during prefill in 3/3 rounds” uses `short < long − 1`, despite launching the short request three seconds later. Adding that nominal delay puts its first token **0.269–0.313 s after** the long request’s in every round. Exact launch timestamps are absent.
   - Author tests are labelled “confirmed,” although the base failures occur during setup.

2. **Changed paths and coverage.** `scripts/config.sh` adds `HEAD_RANK_DIR`, path expansion and the prepared-marker field. `scripts/prepare.sh` adds rank-0 copying, timestamp preservation, cleanup, reuse and insufficient-space handling. `start.sh` selects the local mount/cache or warning fallback and updates loading counts.

   Exercising these paths requires preparation/restart with `RANK_LOCAL=1`, appropriate local files, and explicit stale/missing/low-space conditions. Hardware metadata records defaults and no overrides; the option defaults to zero. API smoke, boundary, cut-in, performance, soak and concurrency requests cannot activate these preparation paths. Startup timings do not establish that they ran.

   Author tests exercise simulated launches and tiny-file copying on the candidate, but their base comparison never reaches the relevant assertions. The hardware run shows no regression, not successful operation of the new option.

3. **PR claims.**
   - **Supported:** the candidate test file reports **63 passed, 31 subtests passed**.
   - **Not verified by this run:** rank-0 copying/cleanup, matching-file mounting, fallback warnings, directory defaults/overrides, marker invalidation and loading-count behavior. Candidate assertions provide partial evidence, but the differential oracle is unsound.
   - **Not tested:** the claimed **80,303,105,512-byte** copy, sampled byte equality, four-rank dry run, disk-space cost/fallback, and expected startup improvement. These are historical statements or expectations without corresponding raw evidence here.
   - The PR explicitly declines a startup-speed claim; **98.2 versus 98.3 s** does not contradict it. The patch’s separate historical startup comparison is also unverified.
   - No functional claim is directly contradicted by the hardware results.

4. **Limitations.** One repetition, candidate first, prevents order balancing. Boundary prompts and performance keys match; the matrix is complete for recorded suites, the control appears healthy, image identifiers agree across records, and restoration reports success. Image ancestry is not independently proved. Repro, fault, endurance and benchmark suites did not run. Soak is time-limited with unequal request counts; smoke preserves only summaries. Cut-in admission classification is defective.

CLAIM TEST: NONE  
No reproduction script is present.

AUTHOR TESTS: UNSOUND  
Useful behavior assertions exist, but all seven base failures arise from fixtures expecting undefined `HEAD_RANK_DIR`, producing shell or unpacking errors before behavior checks.

NO REGRESSION SHOWN, CLAIM NOT TESTED — Healthy paired inference results; no demonstrated hardware activation of `RANK_LOCAL=1`; author-test differentiation fails during setup.
