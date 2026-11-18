1. **Recomputed results:** No discrepancies in the requested report figures.

   | Measurement | PR | Base |
   |---|---:|---:|
   | Boundary hashes identical | 19/19 paired comparisons | |
   | Cut-in short median | 0.770 s | 1.677 s |
   | Cut-in long median | 45.325 s | 44.747 s |
   | Soak completions | 118 | 119 |
   | Client aborts | 89 | 89 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 39 / 0 | 39 / 0 |

   Report rounding is correct. Both targets recorded arithmetic, greedy-repeat equality, streaming equality and JSON-object checks as true, with empty error lists. Streaming first-token times were 0.098/0.100 seconds. Boundary labels and token counts match. All three cut-in rounds per target satisfy admission even after accounting for the short request’s three-second delay.

   Smoke responses and individual soak events are absent: their recorded booleans and counters can be checked against the report, but not independently reconstructed.

2. **Changed paths:** `scripts/prepare.sh` adds worker-directory validation before copying and redirects packed Engram input through a rebuilt directory of relative links. `scripts/config.sh` versions prepared-state markers with `checks=2`. The remaining changes are tests and changelog text.

   No inference request triggers these preparation branches. They require extra files, an invalid directory, packed preparation or an outdated marker. The hardware suites exercise inference, so they show no regression—not that preparation works. The author tests separately execute the relevant shell paths using simulated dependencies.

3. **Claims:**
   - **Supported by author tests:** reject and name ordinary/hidden unexpected files without deleting them; compare whole filenames; stop before copying into the affected directory; reject a non-directory; allow missing directories, replacement copies and ignored non-table files.
   - **Supported by author tests:** packer receives only indexed Engram files; relative links resolve to expected bytes; stock tables remain selected with `ABLIT=1`; existing packed shards and complete copies are retained.
   - **Supported in simulation:** versioned markers trigger preparation; current markers, `PREPARE=0`, dry-run and already-running-service behavior remain appropriate.
   - **Not tested here:** permission-denied directory listing—the relevant test was skipped; real distributed preparation, real-marker migration and repeated migration convergence; the separately claimed CPU packer experiment and byte-identical packed output; historical platform-specific suite totals and snapshot-header failure behavior.
   - The no-table-reading claim agrees with the patch, but its test merely excludes several command strings and is not a comprehensive read detector. No substantive claim is contradicted.

4. **Limitations:** One repetition, always candidate first, limits timing conclusions. Recorded settings match; the control identifier matches the stated base; the matrix is complete for selected suites; restore succeeded. No recorded runtime errors or comparative prompt mismatch appears. Soak is time-limited, producing slightly different request counts. Reproduction, fault, endurance and external benchmark suites did not run. Author-test output is only a tail, and dependency simulation does not verify actual packing or distributed mounts.

5. **Oracles**

CLAIM TEST: NONE

No executed claim script is supplied.

AUTHOR TESTS: SOUND

The inspected tests assert rejection, diagnostics, preservation, successful clean preparation and exact packer inputs; visible base failures concern those behaviors rather than setup, while the candidate passes.

6. EVIDENCE SUPPORTS THE CLAIM — sound author tests verify the principal script behaviors; visible base failures are behavioral; hardware comparisons show no regression, with real preparation and permission-denied coverage still absent.
