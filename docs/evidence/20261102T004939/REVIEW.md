1. **Recomputed results:** no numerical discrepancies in `report.md`; its cut-in values are rounded correctly.

   | Check | PR | Base |
   |---|---:|---:|
   | Identical boundary hashes | 19/19 matched | Same labels and token counts |
   | Cut-in median, short | 0.382 s | 0.353 s |
   | Cut-in median, long | 20.410 s | 20.122 s |
   | Short request admitted | 3/3 | 3/3 |
   | Soak completions / aborts | 162 / 122 | 158 / 120 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 57 / 0 | 55 / 0 |

   Arithmetic, greedy-repeat equality, streaming equality and JSON-object checks are all recorded true on both targets, with no errors; streaming first-token times are 0.092/0.091 s. Individual smoke responses are absent, so their truth cannot be independently reassessed. Performance medians and reported percentage differences also reconcile.

2. **Changed paths:** the nested patch changes lane initialization, snapshot-position selection (`keepEnd`), prefill chunk sizing, snapshot eligibility (`usable`) and saving (`snapSaveFn`). With `TF_DS_KEEP_AT_WINDOW=1`, a prompt longer than the window should stop at its 16-aligned window boundary; replay or extension should accept that saved state.

   Both targets record `env: {}`; the switch defaults off. Boundary repeats, divergences and extensions exercise ordinary text prefill/cache behavior, but there is no demonstrated execution of the new enabled branches or acceptance of non-2048-aligned snapshots. No image requests ran. This is default-mode regression evidence, not verification of the change.

3. **Claims in `PR.md`:**

   - **Default-off behavior remains unchanged:** supported for the tested text outputs, not exhaustively.
   - **Save while standing at the correct position; replay only 128–143 rows; accept earlier window-aligned states:** not tested.
   - **Avoid re-encoding earlier pictures; achieve the quoted replay times, cached counts and 11.4× speedup; miss after picture replacement:** not tested.
   - **Cold/warm token equality with the switch enabled, above and below the cache floor, and equality against the 36-patch build:** not tested. Boundary hashes cover response text, not server token IDs.
   - **Patch ordering/application, unchanged cache keys and rank behavior, clean cache counters/logs, and the offline replay limitation:** not verified by this run. Renumbering is visible in the diff.
   
   No enabled-feature claim is contradicted by these measurements.

4. **Limitations:** one repetition, always PR before base, limits performance attribution. Short cut-in latency is about 8.2% higher on PR, with nonoverlapping three-round ranges; that deserves repetition. The recorded matrix is complete, boundary prompts match, neither target records errors, and restoration succeeded. Image identifiers agree across the bundle, although build provenance is not independently proven. Fault, benchmark and reproduction suites did not run.

   Historical validation records embedded in the patch are separate evidence; several “cold” calls already have cached tokens. The unexecuted validation tool accepts two missing hashes as equal, never compares token IDs, and checks only increasing cache usage rather than the exact window boundary.

CLAIM TEST: NONE
No `executed-script.sh` or reproduction results are present.

AUTHOR TESTS: NONE
`hosttests.json` lists no files or executions; the added validation tool was not run by this harness.

NO REGRESSION SHOWN, CLAIM NOT TESTED — Default-mode boundary and smoke checks pass; the feature switch was not enabled; no executed oracle tests window-aligned image replay.
