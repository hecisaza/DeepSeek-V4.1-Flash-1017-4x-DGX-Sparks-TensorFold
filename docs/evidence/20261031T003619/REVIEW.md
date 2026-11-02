1. **Recomputed results**

`report.md` correctly reports the requested values, including rounding; **no numerical discrepancies**:

| Check | Candidate | Base |
|---|---:|---:|
| Boundary hashes identical | **19/19** against base | Same prompt labels and token counts |
| Cut-in short-request median | **0.373 s** | **17.101 s** |
| Cut-in long-request median | **20.084 s** | **19.771 s** |
| Soak completions | 163 | 170 |
| Client aborts | 126 | 125 |
| Errors / canary mismatches | 0 / 0 | 0 / 0 |
| Canary checks | 57 | 57 |
| Smoke arithmetic | Pass | Pass |
| Smoke greedy repeat equality | Pass | Pass |
| Smoke streaming equality | Pass | Pass |
| Smoke JSON object | Pass | Pass |
| Smoke streaming first token | 0.092 s | 0.091 s |

All recorded error lists are empty. Smoke results are stored booleans, and soak results are counters: individual replies/events are absent, so those checks cannot be independently reconstructed beyond checking the recorded results.

One prose discrepancy: the report says throughput and latency against a control were not shown because `bench` did not run. That is too broad: `perf` and `cutin` supply those comparisons.

2. **Changed paths and coverage**

The sole executable change adds `: "${TF_DS_PREFILL_YIELD:=1}"; export TF_DS_PREFILL_YIELD` in `scripts/config.sh`: unset or empty values become `1`; an explicit `0` survives. Other changes update README wording and add historical evidence. Patches 0023/0031/0032 themselves are unchanged.

`cutin` directly exercises the relevant condition: a streaming long prompt, followed three seconds later by “What is 17 times 23? Number only.” Three rounds ran per target. This tests admission/service during prefill, rather than merely checking ordinary requests. Boundary tests cover chunk boundaries and prefix-cache cases; soak adds concurrent work and connection aborts.

This is not an untriggered failure-path change. However, there is no scheduler trace proving individual internal branches executed, and explicit `0` on the candidate was not tested.

3. **PR claims**

- **Default enabled and README updated:** supported by the diff; observed behavior is consistent with activation.
- **Setting `0` disables it:** supported by shell assignment semantics, but **not tested operationally**.
- **Other requests progress between prefill chunks:** supported by the cut-in behavior.
- **Approximately 0.35 s instead of 17 s:** supported in magnitude; this run measured **0.373 versus 17.101 s**, approximately **46× faster**. These are first-token times, not complete-answer times.
- **Long prompt time unchanged:** contradicted literally for measured first-token latency: **+0.313 s (+1.58%)**, with nonoverlapping three-round ranges. Total completion time was not retained.
- **All 19 boundary replies identical:** supported by all 19 recorded hash comparisons.
- **Evidence publication:** historical evidence files appear in the patch; posting this run is not tested.

4. **Evidence limitations**

One candidate-first repetition cannot separate order effects from small performance differences. Boundary/cut-in prompts match between targets; timed soak workloads differ in completed counts. No faults, `repro`, or `bench` ran. Restore succeeded. Distinct image IDs and the stated base tag agree across metadata and `run.txt`, although independent build provenance is absent.

Cut-in token counts/cache-hit data are not retained. Soak available memory fell by 1,149 MB versus 1,464 MB; these samples cannot establish leak freedom. The earliest historical report compares identical image IDs, so it cannot establish the default-change benefit.

5. **EVIDENCE SUPPORTS THE CLAIM** — the relevant cut-in condition ran and improved approximately 46×; all 19 hashes matched; “long prompt unchanged” needs qualification.
