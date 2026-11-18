1. **Recomputed results:** No discrepancies in the requested report figures.

| Check | PR | Base |
|---|---:|---:|
| Boundary hashes identical | 19/19 paired comparisons | |
| Cut-in median, short | 1.715 s | 1.719 s |
| Cut-in median, long | 45.442 s | 45.437 s |
| Short request finishes first-token wait during prefill | 3/3 | 3/3 |
| Soak completions / aborts | 122 / 92 | 107 / 77 |
| Soak errors / canaries / mismatches | 0 / 41 / 0 | 0 / 33 / 0 |

Both targets record arithmetic, greedy repeat equality, streaming equality, and JSON-object checks as true, with no smoke errors and 0.1 s streaming first-token time. The report’s rounded medians are correct. Smoke responses and individual soak events are absent, so their stored checks/counters cannot be independently reconstructed from response-level evidence.

2. **Changed paths and coverage:** The PR adds a patch changing `Rules`, `Store.marks()`, DSv41 snapshot configuration, and CUDA prompt-cache initialization. Rungs start at `from + 65,536`, strictly below `prompt.len - max(keep_slack, lookahead + 1)`; DSv41 supplies window-plus-chunk slack.

Startup and ordinary requests exercise initialization and existing cache behavior. Boundary requests reach only 12,289 tokens. Cut-in uses 64,000 generated words, without recording actual token counts; its intended size is below the first rung. Soak aborts use 6,000–30,000 words and disconnect after 1–6 seconds. They neither retry the cancelled prompt nor assert retained tokens.

No suite demonstrates creating a ladder checkpoint, cancelling after it, restoring it, and completing correctly. The critical cancellation/retry path is untested: these results establish limited regression coverage, not that checkpoint retention works.

3. **Claims in `PR.md`:**

- **Supported by inspection:** new rule fields, 65,536-token spacing, family-to-cache plumbing, default-disabled ladders, and no new retry/timeout controls.
- **Not tested:** rung retention through guards and eviction; checkpoint reproducibility; exact restoration with token/image matching; cross-rank snapshot mirroring.
- **Not tested:** cancellation convergence, seven retained rungs/458,752 tokens, subsequent 898-token completion in 240 seconds, and production retry/subsequent-turn timings.
- **Not tested:** byte-identical behavior for other families, approximately 13 additional snapshot copies at million-token scale, and production deployment/build history.
- **Supported narrowly:** short-request interleaving remains observable on both targets. Independence from bounded admission is not experimentally isolated.

No central claim is contradicted by this run.

4. **Limitations:** One repetition runs PR before base, without counterbalancing. Recorded settings and image IDs agree between metadata and `run.txt`; image-to-source provenance is not independently established. The control is healthy, the suite matrix is complete, performance prompt keys match, and restoration is recorded as verified. Repro, fault, endurance, and external benchmark suites did not run. Timed soak workloads complete different numbers of requests and are not paired performance comparisons.

One PR eight-stream round drops to 40.7 versus 89.4 tokens/s on base; post-drain memory growth is also larger, approximately 172–173 versus 69–71 MB per process. These warrant repetition, without proving a regression.

5. **Oracles**

CLAIM TEST: NONE

No `executed-script.sh` or repro results are present.

AUTHOR TESTS: NONE

`hosttests.json` lists no test files or executions, consistent with the patch.

6. NO REGRESSION SHOWN, CLAIM NOT TESTED — Paired boundary and smoke checks pass; no test verifies ladder cancellation and successful resume; no claim-specific oracle exists.
