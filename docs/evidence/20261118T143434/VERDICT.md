**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown beyond the band; the changed path was not exercised by any suite (second opinion: claim not tested).

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode +0.5% (±1%, paired by prompt, 3 rounds) · prefill +0.0% (±1%, paired by prompt, 3 rounds) · aggregate -1.1% (±3%, paired by prompt, 3 rounds) · cut-in +0.2% (±1%, medians) · startup +1.6% (±10%, medians, one sample a side: not called) · aggregate@16 -0.9% (±3%, medians)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +173.1 MB, control +70.7 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 01d2a891, base 8ffa67d5; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
