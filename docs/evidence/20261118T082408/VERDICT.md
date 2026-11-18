**Merge readiness: READY** — every suite green, no slowdown beyond the band; the pull request's own tests fail on the base and pass on the pull request, and the second opinion inspected them and found them sound.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode -0.5% (±1%, paired by prompt, 3 rounds) · prefill -0.1% (±1%, paired by prompt, 3 rounds) · aggregate +0.1% (±3%, paired by prompt, 3 rounds) · cut-in +48.1% (±1%, medians, faster) · startup -1.2% (±10%, medians, one sample a side: not called) · aggregate@16 -0.2% (±3%, medians)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +54.3 MB, control +97.3 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: confirmed (2 file(s): on the PR passes, on the base with the PR's tests fails)
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: SOUND
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 3120d7f5, base 8ffa67d5; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
