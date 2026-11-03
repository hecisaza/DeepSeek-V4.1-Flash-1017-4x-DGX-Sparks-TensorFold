1. **Recomputed results:** No numerical discrepancies in the requested report figures.

   - Boundary: **6/19 identical**, 13 different; labels and token counts match between targets, with no recorded request errors.
   - Cut-in medians, short/long: candidate **0.445/20.170 s**; control **0.421/20.336 s**. Reported values correctly round to 0.45/20.17 and 0.42/20.34. Both record admission in 3/3 rounds.
   - Soak: candidate **165 completions, 121 aborts, 58 canaries**; control **161 completions, 123 aborts, 57 canaries**. Both record **0 errors and 0 canary mismatches**.
   - Smoke: arithmetic, greedy repeat equality, streaming equality and JSON-object checks are all recorded true for both targets; error lists are empty. Stream first-token times are **0.098/0.089 s**. Underlying responses are absent, so these booleans cannot be independently re-evaluated.

2. **Changed paths:** The PR adds a patch targeting prompt-sequence initialization in `lanes.zig`. After copying token IDs, it replaces token index `chunk_rows` with the preceding token whenever `len > chunk_rows`.

   This is an ordinary long-prompt path, not an untriggered failure path. With the recorded chunk size of 2,048, boundary requests from `len2049` onward and all prefix cases meet the condition. Long cut-in and performance prompts also meet it; soak generates qualifying requests. Short smoke prompts do not. The bundle does not directly trace the internal token replacement or independently prove patch application.

3. **Claims:**

   - **Detectable differences confined to longer prompts: supported within the tested boundary set.** All 13 differences occur above 2,048 tokens; all three shorter/equal-length cases match.
   - **Every longer prompt produces a different reply: contradicted, if that is the intended meaning of “must see replies differ.”** Only 13/16 longer cases differ. `len4095`, `pfx_div3072` and `pfx_div4092` match. Token replacement need not change decoded output.
   - **Exact second-chunk token replacement:** consistent with the patch, but not directly verified by output hashes.
   - **Automatic NOT READY verdict:** not demonstrated. The report displays mismatches but contains no such verdict; boundary `ok` means no request errors, not reply equality.
   - **Never merging and later closing:** workflow intentions, not tested behavior.

4. **Evidence limits:** One repetition, candidate first, leaves order effects uncontrolled. Boundary comparisons use deterministic matching prompts; soak is time-bounded and produces different request counts, so its workload totals are not paired comparisons. Fault, benchmark and reproduction suites did not run. Restore is recorded successful, and the matrix is complete for the selected suites. Image IDs agree across metadata and `run.txt`, but build provenance is not independently established. Hashes cover only visible content; the candidate’s `len2049` hash represents empty content. The report’s reference to verdict thresholds is not implemented in the supplied report generator.

CLAIM TEST: NONE
No `executed-script.sh` is present.

AUTHOR TESTS: NONE
`hosttests.json` lists no test files or executions.

EVIDENCE CONTRADICTS THE CLAIM — read literally, three of sixteen longer prompts retain identical replies; the narrower sensitivity objective succeeds with thirteen differences; automatic NOT READY classification is not demonstrated.
