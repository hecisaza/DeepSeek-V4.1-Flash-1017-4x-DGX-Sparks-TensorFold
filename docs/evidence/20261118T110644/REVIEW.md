1. **Recomputed results**

| Check | PR | Base |
|---|---:|---:|
| Boundary hashes identical | 19/19 paired comparisons | Same labels and token counts |
| Cut-in median, short | 42.133 s | 42.210 s |
| Cut-in median, long | 44.837 s | 44.906 s |
| Soak completions / aborts | 144 / 106 | 144 / 108 |
| Soak errors | 0 | 0 |
| Canary checks / mismatches | 47 / 0 | 48 / 0 |

Arithmetic, greedy-repeat equality, streaming equality and JSON-object checks are all recorded as true on both targets, with no errors. Their streaming first-token times are 0.100 and 0.101 seconds. Raw replies are absent, so these booleans cannot be independently reassessed.

The report transcribes these results correctly, including rounding. **One substantive discrepancy:** “admitted during prefill in 3 of 3 rounds” is unsupported on both targets. `cutin()` starts the short request three seconds later but checks `short < long - 1`. Accounting for the nominal three-second offset gives **0/3** short replies before the long reply; they arrive approximately 0.275–0.312 seconds later. Actual admission itself is not instrumented.

2. **Changed paths and coverage**

The only production change adds `ablit_revision=$ABLIT_REVISION` to `prepared_state()` when `ABLIT=1`. It changes marker comparison and consequently the launcher’s preparation decision. Other changes are tests and changelog text.

The triggering condition is an existing revision-A marker followed by startup with revision B, overlay enabled and rank-local storage disabled. No inference request exercises that transition. The hardware suites therefore demonstrate regression coverage only.

The author tests do exercise it: they compare revision-dependent markers and run `start.sh` against an earlier revision’s marker, with preparation replaced by a recorder.

3. **Claims**

- **Supported:** changing the enabled overlay revision changes the marker and invokes preparation; retaining the revision skips preparation. Tests require successful startup as well as preparation-state assertions.
- **Supported:** with `ABLIT=0`, changing revision leaves the marker equal to the default marker.
- **Partially supported:** existing overlay installations prepare once after updating. The added field establishes invalidation, but the supplied new tests do not explicitly demonstrate migration from an old-format overlay marker followed by two starts.
- **Not tested:** actual overlay checkpoint/cache creation, subsequent real distributed loading, the rank-local explanation, compatibility with #44, and historical macOS results. This run instead reports 60 passing author tests plus 31 subtests; the control reports two failures, 58 passes and 31 subtests.
- No central functional claim is contradicted.

4. **Evidence limits**

One repetition, always candidate first, limits performance conclusions. Both targets have matching public settings, paired boundary inputs and matching performance prompt keys; all recorded suite error lists are empty. Restore is recorded successful. Artifact identifiers agree across the bundle, although independent source-to-image provenance is unavailable.

Repro, fault, endurance and benchmark suites did not run. Soak is time-bounded, so its unequal request totals are expected. Author-test fixtures stub preparation and infrastructure; the retained control output is only a tail.

CLAIM TEST: NONE

No executed claim script is present.

AUTHOR TESTS: SOUND

The inspected assertions directly test marker invalidation and successful preparation dispatch, preserve unchanged-revision and disabled-overlay controls, and the base output shows a behavioral marker-equality failure rather than setup failure.

EVIDENCE SUPPORTS THE CLAIM — direct author tests verify the preparation decision; the base fails behaviorally while the candidate passes; real overlay preparation remains unverified, and the unrelated cut-in admission conclusion is invalid.
