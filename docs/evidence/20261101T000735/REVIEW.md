1. **Recomputed results**

| Check | Candidate | Control |
|---|---:|---:|
| Boundary hashes identical | **19/19 paired matches** | Same labels and token counts |
| Cut-in median, short | 17.109 s | 17.194 s |
| Cut-in median, long | 19.830 s | 19.930 s |
| Soak completions | 169 | 176 |
| Soak client aborts | 126 | 132 |
| Soak errors | 0 | 0 |
| Canary checks / mismatches | 61 / 0 | 61 / 0 |
| Smoke arithmetic | Pass | Pass |
| Smoke greedy repeat equality | Pass | Pass |
| Smoke streaming equality | Pass | Pass |
| Smoke JSON object | Pass | Pass |
| Smoke streaming first token | 0.089 s | 0.105 s |

These match `report.md`, including its rounded cut-in medians. Recorded error lists are empty. Performance medians and percentages, and startup times, also match.

The report’s separate **“confirmed”** test conclusion is overstated: its quoted control failure is an unpacking `ValueError` during setup, before the behavioral assertions. Moreover, the `hosttests.json` that `report.py` uses for this section is absent, so its claimed 35 passing tests cannot be independently verified. Smoke booleans and soak counters likewise lack individual responses/events for deeper recomputation.

2. **Changed paths and coverage**

The patch changes configuration defaults and `rank_file`; preparation’s worker-local weight copying, same-size skip, free-space fallback, and `.part` rename; and startup’s matching-file detection, read-only mount, NFS fallback, and `RANK_LOCAL=0` bypass. Both packed and unpacked startup branches use the selected directory. It also adds a simulated startup test and documentation.

Smoke, boundary, cut-in, performance, and soak issue inference requests against an already running service. None directly invokes preparation or checks weight mounts. Recorded startup switches establish availability, but provide no script revision, copy, mount, or storage-I/O evidence proving these branches ran.

Required conditions include matching, partial, missing, or insufficient-space copies; disabled local loading; and absent source files under `set -e`. The added test describes some conditions, but this bundle does not independently establish their execution. Failure and fallback paths remain untested by the hardware suites.

3. **PR claims**

- **Copy once, skip matching size, rename completed copies, handle insufficient space, mount matching copies, and disable through `RANK_LOCAL=0`:** consistent with patch inspection; not demonstrated by this run.
- **Missing-file `rank_file` returns success:** visible in code; the claimed regression test history is unverified.
- **Host-side only, no engine/image changes:** supported by the patch’s scope. Different built image IDs do not establish different engine behavior.
- **Replies unchanged:** supported narrowly by 19 matching boundary hashes and passing smoke checks; not established across local versus NFS loading.
- **315→96 s loading, 417→197 s power-on startup, and 32–36 s with read-ahead:** not tested. Switch-to-API timing was **174.0 versus 167.5 s**, 6.5 s slower for the candidate; this is a different measurement.
- **35 tests pass:** report-only, unverified. README and changelog updates are visible.

4. **Evidence limitations**

One fixed candidate-first repetition permits order/cache effects. Boundary and performance prompts match; timed soak executes different request counts and schedules. Fault, reproduction, and external benchmark suites did not run. No recorded errors or restore problem appear. Control identifiers agree across metadata and `run.txt`, but build provenance tying that image to the stated base is absent. Local-copy activation and startup phases are unrecorded.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary matches; zero recorded suite errors; local-weight activation and claimed loading speedups were not demonstrated.
