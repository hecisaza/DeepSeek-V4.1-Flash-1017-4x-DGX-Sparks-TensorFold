**Merge readiness: RERUN** — a slowdown in a single repetition is timing uncertainty, not a defect: rerun counterbalanced (reps=2): prefill -1% (band ±1%).

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode +0.5% (±1%, paired by prompt, 3 rounds) · prefill -1.1% (±1%, paired by prompt, 3 rounds, slower) · aggregate -0.3% (±3%, paired by prompt, 3 rounds) · cut-in +54.1% (±1%, medians, faster) · startup +1.2% (±10%, medians, one sample a side: not called) · aggregate@16 +0.5% (±3%, medians)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +83.0 MB, control +111.6 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: confirmed (1 file(s): on the PR passes, on the base with the PR's tests fails)
- second opinion: EVIDENCE SUPPORTS THE CLAIM; claim test: NONE; author tests: SOUND
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate head against its merge-base d24e79ee (the PR does not merge cleanly onto the current base); head d6b62cf3, base d24e79ee; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
