**Merge readiness: RERUN** — a slowdown in a single repetition is timing uncertainty, not a defect: rerun counterbalanced (reps=2): cut-in -17% (band ±3%).

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 19/19 identical to the control
- claim script: confirmed (1 repetition(s))
- performance against the control (provisional calibration): decode +0% (±2%) · prefill +1% (±2%) · aggregate +1% (±6%) · cut-in -17% (±3%, slower) · startup -2% (±10%, one sample a side: not called)
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: UNSOUND; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate head against its merge-base 476bbc77 (the PR does not merge cleanly onto the current base); head 0430154e, base 476bbc77; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
