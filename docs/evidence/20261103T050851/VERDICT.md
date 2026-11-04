**Merge readiness: RERUN** — a slowdown in a single repetition is timing uncertainty, not a defect: rerun counterbalanced (reps=2): aggregate -6% (band ±3%).

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 19/19 identical to the control
- repro script: confirmed (1 repetition(s))
- performance against the control (calibration of 2026-11-02): decode +0% (±1%) · prefill +1% (±1%) · aggregate -6% (±3%, slower) · cut-in -3% (±1%, 0.01 s apart, below the 0.2 s floor: not called) · startup -3% (±10%, one sample a side: not called) · aggregate@16 -0% (±3%)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +45.1 MB, control +36.9 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: EVIDENCE SUPPORTS THE CLAIM; claim test: SOUND; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 94a778ed, base 57c739cb; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
