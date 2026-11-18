**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown beyond the band; the claim is verified (the pull request's own tests fail on the base and pass on the pull request, and the second opinion inspected them and found them sound), but the candidate is the head on its merge-base, not the pull request integrated with the current base: not current readiness.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode -0.7% (±1%, paired by prompt, 3 rounds) · prefill +0.5% (±1%, paired by prompt, 3 rounds) · aggregate -0.1% (±3%, paired by prompt, 3 rounds) · cut-in +0.5% (±1%, medians) · startup -0.3% (±10%, medians, one sample a side: not called) · aggregate@16 -1.4% (±3%, medians)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +96.3 MB, control +88.1 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: confirmed (1 file(s): on the PR passes, on the base with the PR's tests fails)
- second opinion: EVIDENCE SUPPORTS THE CLAIM; claim test: NONE; author tests: SOUND
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate head against its merge-base d24e79ee (the PR does not merge cleanly onto the current base); head d6b62cf3, base d24e79ee; engine switches: defaults

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
