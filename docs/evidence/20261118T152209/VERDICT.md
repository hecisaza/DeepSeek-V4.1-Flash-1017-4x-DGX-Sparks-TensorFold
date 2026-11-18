**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown beyond the band; the pull request's own tests pass on the PR and fail on the base: tested by the author, oracle not independently inspected (second opinion: UNSOUND).

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode -0.2% (±1%, paired by prompt, 3 rounds) · prefill +0.3% (±1%, paired by prompt, 3 rounds) · aggregate +2.6% (±3%, paired by prompt, 3 rounds) · cut-in -4.3% (±1%, medians, 0.08 s apart, below the 0.2 s floor: not called) · startup -0.4% (±10%, medians, one sample a side: not called) · aggregate@16 +0.1% (±3%, medians)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +82.9 MB, control +69.7 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: confirmed (1 file(s): on the PR passes, on the base with the PR's tests fails)
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: UNSOUND
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head c9890c32, base 8ffa67d5; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
