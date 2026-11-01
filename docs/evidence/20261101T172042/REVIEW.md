1. **Recomputed results:** No numerical discrepancies in the requested report entries.

   - **Boundary:** 19/19 matching, nonempty reply hashes; identical labels and token counts; no row errors.
   - **Cut-in medians:** candidate short **17.084 s**, long **19.824 s**; control short **17.096 s**, long **19.846 s**. Report rounding is correct.
   - **Soak:** candidate **169 completions, 125 aborts, 0 errors, 59 canaries, 0 mismatches**; control **169 completions, 127 aborts, 0 errors, 61 canaries, 0 mismatches**. Error lists are empty.
   - **Smoke:** arithmetic, greedy-repeat equality, stream matching and JSON mode are all recorded `true` for both targets; no errors. Streaming first-token times are **0.091/0.092 s**.

   Smoke responses and individual soak events are absent, so their underlying checks/counts cannot be independently reconstructed. Boundary comparison verifies stored hashes, not their derivation from responses.

2. **Changed paths and coverage:**

   - **0047:** changes template string concatenation and history-length calculation. Chat requests exercise rendering and tokenization, but every suite request contains one message; none tests a growing conversation. Successful in-place resizing is not instrumented. **The advertised fallback is incorrect:** after a successful tail render, `tried_tail=true` even when the suffix fails to match; the fallback requires `!tried_tail`, so that case leaves `history_len=0`.
   - **0048:** changes rendering/tokenizer scratch allocation and connection-arena retention. Ordinary requests exercise scratch allocation. The client opens fresh connections, so repeated large/small requests on one retained connection were not tested.
   - **0049:** enlarges row tables and adds optional scheduling/copy switches. Both targets use chunk size **2048** and empty environment overrides. Long prompts span multiple chunks; they do not test a single pass exceeding 4096 rows. Neither opt-in behavior was exercised.
   - **0050:** validates negative/out-of-range Engram row IDs before batch allocation. No suite injects either condition. Client aborts do not establish this coverage. The patch includes an inline Zig regression test, but no execution result is supplied. The report’s “no test file under `tests/`” statement is narrowly correct but omits this test.

   The untriggered failure paths show no regression, not that the fixes work.

3. **PR claims:**

   - **Memory/OOM improvement and all quoted memory measurements:** not tested. No long-running conversation, anonymous-memory/block measurements, device-memory peak tracking, or reproduction of the control’s OOM.
   - **0047 optimization:** ordinary operation passes; multi-message benefit is untested. Its stated suffix-mismatch fallback is contradicted by the patch.
   - **0048 retention/scratch benefits:** not measured; allocation changes are visible in the diff.
   - **0049 expanded capacity and switches; 0050 leak fix:** not tested.
   - **Unchanged throughput:** supported narrowly. Recomputed median changes are **+0.35% decode, +0.66% prefill, +1.19% aggregate**, with overlapping round ranges.
   - **No default changes:** new switches default off; this run cannot establish unchanged behavior generally.
   - **Clean application/build and upstream relationship:** serving images support build viability; exact patch application, wiring and upstream equivalence are not independently evidenced.

4. **Evidence limits:** One fixed candidate-first repetition; approximately ten-minute soaks; different time-limited soak workloads. Boundary/cut-in/performance prompts match by construction. Available memory falls **1246/1174 MB**, which neither proves nor disproves the claimed anonymous-memory fix. No reported errors or restore problem. `fault`, `repro`, and `bench` did not run. Image IDs are recorded, but source-to-image/base provenance is not independently demonstrated.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary matches; no recorded suite errors; memory-lifetime and invalid-row fixes lack targeted validation.
