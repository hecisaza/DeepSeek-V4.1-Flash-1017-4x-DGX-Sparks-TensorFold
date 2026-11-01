1. **Recomputed results:** No numerical discrepancies in `report.md`.

| Check | Candidate | Base |
|---|---:|---:|
| Boundary hashes identical | 19/19 paired matches | Same labels and token counts |
| Cut-in median, short | 0.432 s | 0.366 s |
| Cut-in median, long | 20.302 s | 20.093 s |
| Short admitted during prefill | 3/3 | 3/3 |
| Soak completions / aborts | 161 / 123 | 160 / 122 |
| Soak errors | 0 | 0 |
| Canary checks / mismatches | 57 / 0 | 56 / 0 |

Arithmetic, greedy-repeat equality, streaming equality and JSON-object checks are all `true` for both targets; smoke errors are empty and streaming first-token time is 0.092 s each. Reported cut-in numbers correctly round the medians. Throughput medians and startup times also match. Smoke responses and individual soak events are absent, so their recorded booleans and counters cannot be independently reconstructed.

2. **Changed paths:** `scripts/nodes.sh` adds `launcher`; preparation’s final message uses detected fabric. `start.sh` changes the already-running hint, missing-copy re-prepare warning, LIVE restart hint, and step 4 wording according to zero, one, two or three local worker copies. Tests and CHANGELOG also change.

No chat request exercises these message branches. Startup timing alone does not establish which launcher branches ran or what they printed. The hardware suites therefore establish regression evidence only. Separately, author tests exercise both launcher names, preparation’s final line for both fabrics, already-running and missing-copy conditions, and all four weight-source wordings. Preparation’s line is evaluated in isolation, not through complete preparation.

3. **Claims:**

- Fabric-appropriate launcher messages: **supported** by direct output assertions in the author tests.
- Step 4 describes all-local, partially local and NFS loading: **supported** under simulated copy conditions.
- Messages only, with no command, flag or default changes: **supported by patch inspection**, with hardware results consistent with no inference regression.
- Approximately 35–43 seconds for local loading: **not tested**; startup measurements include more than weight loading.
- “167 of 167” Linux tests: **not established** by this bundle, which records 61 tests plus 31 subtests passing.
- macOS/GNU `stat` qualification: **not tested**.
- CHANGELOG update: **confirmed** in the patch.

4. **Limitations:** One repetition, candidate first, cannot separate timing effects from order or drift. Fault, benchmark and repro suites did not run. Recorded settings and deterministic comparison prompts match; the matrix is complete for recorded suites, with no reported errors or restore problem. Time-limited soak workloads have slightly different counts. Image identifiers are consistent across metadata and the run record, but source-to-image provenance is not independently demonstrated. Author output is truncated, and fixture implementation is outside the patch. Cut-in’s admission predicate subtracts one second despite a three-second launch delay; these measurements still satisfy the stricter threshold.

5. **Oracles**

CLAIM TEST: NONE

No `executed-script.sh` is present.

AUTHOR TESTS: SOUND

The inspected tests require successful execution and the claimed messages while retaining mesh/NFS cases; the base fails an explicit old-message assertion, not merely the missing-helper check, although only output tails are available.

EVIDENCE SUPPORTS THE CLAIM — Direct author assertions verify the message changes; the base demonstrably retains incorrect wording; paired hardware results show no observed inference regression.
