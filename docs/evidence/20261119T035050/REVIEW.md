1. **Recomputed results:** The requested figures match `report.md`; there are no numerical discrepancies after its rounding.

Boundary: **38/38** valid, non-error reply hashes match, with matching prompt labels and token counts.

Cut-in medians in seconds, shown as short / long:

| Target | Rep 0 | Rep 1 | All six rounds |
|---|---|---|---|
| PR | 0.736 / 45.745 | 1.721 / 45.470 | 1.2285 / 45.5335 |
| Base | 1.825 / 45.355 | 1.788 / 45.395 | 1.791 / 45.3715 |

All 12 rounds satisfy admission before the long prompt’s first token, including the three-second launch delay; no errors.

Soak counts, shown as completions / aborts / canaries:

| Target | Rep 0 | Rep 1 | Total |
|---|---|---|---|
| PR | 107 / 77 / 33 | 119 / 88 / 39 | 226 / 165 / 72 |
| Base | 109 / 78 / 34 | 130 / 97 / 44 | 239 / 175 / 78 |

Every soak records zero errors and zero canary mismatches.

Arithmetic, greedy repeat equality, streaming equality, and JSON-object checks are all recorded true for both targets in both repetitions, with no errors. Stream first-token times match: PR 0.099/0.098 seconds; base 0.097/0.100. Smoke response bodies are absent, so these assertions cannot be independently rechecked.

2. **Changed paths:** The patch adds ladder planning to `Store.marks`, sets DSv41’s gap to 65,536 and slack to window plus chunk rows, and passes those settings into CUDA cache initialization. Existing restore, cancellation, and rank-mirroring implementations are unchanged.

A rung requires `from + 65536 < prompt_length − max(keep_slack, lookahead + 1)`. Verification requires crossing a rung, cancelling, then retrying the identical prefix and observing restoration and successful completion.

No suite performs that sequence. Cut-in uses 64,000 generated words and completes normally; boundary reaches 12,289 tokens; performance reaches 12,004. Soak aborts 6,000–30,000-word prompts after 1–6 seconds without retrying them. Initialization and ordinary cache paths ran, but no ladder retention/restoration is demonstrated. This establishes limited regression evidence, not that cancellation recovery works.

3. **Claims:**

- **Supported by patch inspection, not runtime verification:** rule defaults, family configuration, wiring, reuse of existing mark guards, and absence of new retry/timeout knobs.
- **Not tested:** retained rungs surviving cancellation; exact restoration, image-key matching and rank mirroring for those rungs; unchanged behavior across other families; approximately 13 extra snapshot copies at million-token scale.
- **Not tested:** every historical measurement in `PR.md`, including zero retention before, 458,752 tokens banked, 898-token completion in 240 seconds, production convergence, and 0.6–6-second subsequent turns.
- **Supported narrowly:** short-request interleaving still works. Independence from the cancellation fix is not experimentally established.
- No central claim is contradicted.

4. **Limitations:** Two counterbalanced repetitions and a complete six-suite matrix strengthen the comparison. Recorded restore succeeded; boundary identities and performance prompt keys match. Image identifiers agree across records, though build ancestry is not independently established.

The base remains running between repetitions, creating asymmetric cache history. Soak is duration-limited. Candidate memory growth exceeds base after concurrency drain, warranting follow-up without proving a leak. Repro, fault, endurance and benchmark suites did not run; the report omits repro from its missing-coverage list.

CLAIM TEST: NONE

No reproduction script is present.

AUTHOR TESTS: NONE

`hosttests.json` lists no test files or executions.

NO REGRESSION SHOWN, CLAIM NOT TESTED — ordinary checks pass against a healthy base; no ladder-crossing cancellation/retry ran; neither claim oracle exists.
