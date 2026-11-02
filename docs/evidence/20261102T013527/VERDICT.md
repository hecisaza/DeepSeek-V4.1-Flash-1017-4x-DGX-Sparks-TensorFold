**Merge readiness: RERUN** — a slowdown in a single repetition is timing uncertainty, not a defect: rerun counterbalanced (reps=2): prefill -2% (band ±2%); also observed: a patch number collides with another open pull request.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode -0% (±2%) · prefill -2% (±2%, slower) · aggregate +1% (±6%) · cut-in -39% (±3%, 0.13 s apart, below the 0.2 s floor: not called) · startup +1% (±10%, one sample a side: not called)
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: NONE
- patch numbers: COLLISION: patch 0047 is added by #27 #41
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 00ff6fc2, base fcef6cf2; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
