**Merge readiness: NOT READY** — a patch number collides with another open pull request.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode -1% (±2%) · prefill -0% (±2%) · aggregate -3% (±6%) · cut-in -8% (±3%, 0.03 s apart, below the 0.2 s floor: not called) · startup +6% (±10%, one sample a side: not called)
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: NONE
- patch numbers: COLLISION: patch 0047 is added by #27 #41
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 0fda670e, base fcef6cf2; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
