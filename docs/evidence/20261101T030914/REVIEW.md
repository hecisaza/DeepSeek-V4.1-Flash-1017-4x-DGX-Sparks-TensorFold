1. **Recomputed results:** No discrepancies in the requested figures.

   - **Boundary:** 19/19 hashes match; both targets have identical prompt labels and token counts, with no recorded errors.
   - **Cut-in medians**, short/long: candidate **17.084/19.758 s**; control **17.092/19.772 s**. The report correctly rounds these to 17.08/19.76 and 17.09/19.77.
   - **Soak:** candidate 171 completions, 125 aborts, 58 canaries; control 169 completions, 127 aborts, 62 canaries. Both record zero errors and zero canary mismatches.
   - **Smoke:** arithmetic, greedy repeat equality, streaming equality and JSON-object checks are all recorded as true on both targets; errors are empty and streaming first-token time is 0.091 s each.

   Smoke replies and individual soak events are absent: their stored flags/counts match the report, but cannot be independently reconstructed. Boundary hash comparisons and cut-in medians can.

2. **Changed paths and coverage:** The executable change is a new patch for `LaneHost.setup`; other changes are documentation. It moves grammar construction before `Stream.init`, returns `false` after grammar-construction failure instead of returning `drop`’s result, and frees an existing grammar when stream initialization fails.

   Smoke’s `response_format: {"type":"json_object"}` request exercises successful grammar setup. No suite injects admission-time grammar compilation failure, constraint allocation failure, or stream allocation failure after grammar creation. No required/named tool-choice or `guided_*` request runs. Long boundary requests exercise chunking generally, without establishing coverage of either changed failure branch through admission and fill.

   These results show no observed regression on exercised paths; they do **not** demonstrate the fix.

3. **Claims in `PR.md`:**

   - **Failed grammar setup safely rejects only its request; no use-after-free:** not tested. The diff implements the stated return-value change, but neither target encounters the triggering failure.
   - **Grammar cleanup after failed stream initialization:** not tested; no relevant allocation failure or allocator accounting.
   - **Same messages/order, no new allocation or flag:** consistent with patch inspection; not established by runtime failure-path evidence.
   - **Normal structured behavior unchanged:** supported narrowly by JSON-object smoke success. Exact structured-output equality, guided formats and tool calls are not tested.
   - **CPU harness: 24 passes, zero leaks, 12 failures without patch:** not tested here; harness and its results are absent.
   - **Server tests: 70 passes, two skips, separate compile fix:** not tested.
   - **Compatibility with the listed patch combinations:** not tested by this bundle.
   - **Earlier combined-image validation, eight reference replies, needle results and quoted throughput:** not tested here. These are different workloads/configurations; this run neither reproduces nor contradicts them.
   - **GPU failure path untested:** confirmed. No performance-equivalence claim needs adjudication.

4. **Evidence limitations:** One repetition runs candidate before control, without counterbalancing. Fixed smoke, boundary, cut-in and performance prompts match across targets; time-limited soak scheduling produces different request mixes despite seeded workers. `fault`, `repro` and `bench` did not run; the available fault suite targets read faults, not grammar setup.

   No errors or restore problem are recorded. Control tag `base-476bbc77` agrees with the stated base prefix; image IDs are recorded, but independent source/build provenance is absent. Smoke arithmetic merely checks for substring `391`; JSON mode checks object parsing, not required keys. Soak aborts establish client disconnects, not successful server cleanup; canaries compare against each target’s own reference.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary hashes match; recorded smoke and soak checks pass; neither repaired failure path was triggered.
