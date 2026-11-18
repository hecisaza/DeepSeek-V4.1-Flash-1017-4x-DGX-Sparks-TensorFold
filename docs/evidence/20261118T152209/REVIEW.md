1. **Recomputed results:** Boundary hashes match **19/19**, with identical labels and token counts and no errors. Cut-in medians:

| Target | Short first token | Long first token |
|---|---:|---:|
| PR | 1.839 s | 45.464 s |
| Base | 1.763 s | 45.411 s |

Both admitted the short request in 3/3 rounds. Soak: PR **118 completions, 85 aborts, 37 canaries**; base **108 completions, 78 aborts, 34 canaries**. Both recorded zero errors and zero canary mismatches.

Both smoke runs record arithmetic, greedy repeat equality, streaming equality, and JSON-object checks as true, with no errors; streaming first-token times are 0.101 s and 0.100 s. The stored booleans agree with the report, but underlying smoke responses are absent, preventing independent re-evaluation.

**No numerical discrepancies in these results.** The report’s author-test label **“confirmed” is unjustified**: the base failures are setup failures.

2. **Changed paths:** `scripts/config.sh` adds `HEAD_RANK_DIR`, path expansion, and prepared-marker tracking. `scripts/prepare.sh` adds rank-0 copying, stale-file cleanup, timestamp preservation, reuse, and insufficient-space handling. `start.sh` adds matching-copy selection, mount/environment configuration, fallback warnings, and loading-status accounting.

These require preparation or launch with `RANK_LOCAL=1`, plus matching, missing, stale, or insufficient-space conditions. Inference requests cannot trigger them. Hardware metadata records no enabling override or evidence of the selected weight path; the option defaults to zero. Thus hardware coverage of the feature is **not demonstrated**. Author tests exercise simulated launch commands and small-file preparation, but their base comparison fails before behavioral assertions.

3. **Claims in `PR.md`:**

- Rank-0 copy, cleanup, matching-copy mount, stale/missing fallback, and loading-status behavior: candidate unit tests provide limited support; the comparative run does **not verify** them.
- Default directory relationship: supported by patch inspection. Changing that directory automatically reruns preparation: **not tested** by the shown assertions.
- “63 tests pass”: **supported**, with 31 subtests also passing.
- Full-size copy, sampled byte integrity, preserved metadata, and four-rank warning-free dry run: **not tested** by this bundle.
- Startup benefit and cited transfer rate: **not tested** under the claimed conditions. Observed startup is 97.9 s versus 97.5 s.
- Disk-space fallback and “no new failure mode”: **not established**. Inspection shows copy/move failures call `die`, limiting that broad assurance.
- Ring behavior with the feature enabled: **not established** despite the hardware run using a ring.

4. **Limitations:** One repetition, candidate first, without counterbalancing. Boundary inputs and performance prompt keys match; soak is time-limited and completes different workload counts. All recorded hardware suites are healthy, and restoration is recorded as verified. Image identifiers agree across metadata and `run.txt`, but source ancestry is not independently established. Reproduction, fault, endurance, and external benchmark suites did not run.

CLAIM TEST: NONE

No `executed-script.sh` is present.

AUTHOR TESTS: UNSOUND

The assertions inspect relevant behavior, but all seven base failures arise from undefined `HEAD_RANK_DIR` or consequent fixture unpacking errors, rather than reaching the claimed behavior.

NO REGRESSION SHOWN, CLAIM NOT TESTED — Hardware checks pass with matching boundary outputs; feature-enabled hardware coverage is undocumented; the author-test differential is caused by setup failures.
