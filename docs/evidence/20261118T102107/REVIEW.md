1. **Recomputed results:** No discrepancies in the requested report metrics.

   | Measurement | PR | Base |
   |---|---:|---:|
   | Identical boundary hashes | 19/19 paired comparisons | |
   | Cut-in short median | 1.528 s | 1.740 s |
   | Cut-in long median | 47.313 s | 45.299 s |
   | Soak completions / aborts | 118 / 87 | 120 / 91 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 38 / 0 | 40 / 0 |

   Boundary labels and token counts match. All three cut-in rounds per target satisfy admission even after accounting for the short request’s three-second delay. Reported medians round correctly. Arithmetic, greedy repetition, streaming equality and JSON mode are all recorded as true on both targets, with no errors; streaming first-token times are 0.099/0.102 seconds. Smoke responses themselves are absent, so their recorded assertions cannot be independently reconstructed.

2. **Changed paths:** The only production change adds `ablit_revision=$ABLIT_REVISION` to `prepared_state` when `ABLIT=1`. This changes marker comparison and consequently whether startup invokes preparation. Other changes are tests and changelog text.

   Exercising the fix requires an existing marker for revision A followed by startup with revision B and `ABLIT=1`, particularly with `RANK_LOCAL=0`. None of the hardware inference suites performs that transition; they show no regression, not successful overlay preparation. The author tests do exercise marker generation and this startup condition, using a preparation stub.

3. **Claims:**

   - **Supported:** Changing the revision changes the enabled-overlay marker; repeating the revision preserves it; disabling the overlay preserves the default marker regardless of revision.
   - **Supported within the stubbed launcher tests:** A new revision invokes preparation and exits successfully; an unchanged revision skips preparation and reports readiness.
   - **Not tested end to end:** Creating usable overlay checkpoints/caches, launching real ranks after changing revisions, and migration from an old-format marker preparing exactly once.
   - **Not independently verified:** The historical macOS test totals and platform-specific failures, indirect invalidation with `RANK_LOCAL=1`, and compatibility with pull request #44. This bundle instead records 60 passing author tests plus 31 passing subtests on the candidate, versus two failures, 58 passes and 31 passing subtests on the base.
   - No inspected result contradicts the core fix.

4. **Limitations:** There is one repetition, candidate first, without counterbalancing. The recorded matrix is complete for the selected suites; performance prompt keys match, neither target records suite errors, and restoration is recorded as verified. Image identifiers consistently identify candidate and base, but the bundle does not independently attest their source ancestry. Repro, fault, endurance and external benchmark suites did not run. Timed soak workers produce unequal request totals, not identical request histories. Author-test output is truncated, limiting inspection of the second base failure.

CLAIM TEST: NONE

No `executed-script.sh` is present and no repro suite ran.

AUTHOR TESTS: SOUND

The inspected assertions require marker invalidation and successful preparation invocation while preserving unchanged-revision and overlay-disabled controls; the visible base failure is marker equality, not setup failure, although real preparation is stubbed.

EVIDENCE SUPPORTS THE CLAIM — Sound author tests verify the marker and launcher decision; the candidate passes while the base fails behaviorally; hardware results show no regression but do not verify real overlay preparation.
