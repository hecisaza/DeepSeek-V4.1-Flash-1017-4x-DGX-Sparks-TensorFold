**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown beyond the band; the pull request's own tests pass on the PR and fail on the base: tested by the author, oracle not independently inspected (second opinion: UNSOUND).

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode -0.5% (±1%, paired by prompt, 3 rounds) · prefill -0.5% (±1%, paired by prompt, 3 rounds) · aggregate -0.4% (±3%, paired by prompt, 3 rounds) · cut-in +0.3% (±1%, medians) · startup +0.1% (±10%, medians, one sample a side: not called) · aggregate@16 -1.2% (±3%, medians)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +43.0 MB, control +88.1 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: confirmed (1 file(s): on the PR passes, on the base with the PR's tests fails)
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: UNSOUND
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head c9890c32, base 8ffa67d5; engine switches: defaults

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
