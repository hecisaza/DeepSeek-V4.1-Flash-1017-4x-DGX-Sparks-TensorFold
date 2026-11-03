**Merge readiness: NOT READY** — host memory grows on the candidate after a drain (+1071.1 MB) beyond the control (+14.3 MB).

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (calibration of 2026-11-02): decode +1% (±1%, faster) · prefill -1% (±1%) · aggregate -1% (±3%) · cut-in +3% (±1%, 0.01 s apart, below the 0.2 s floor: not called) · startup +0% (±10%, one sample a side: not called) · aggregate@16 -0% (±3%)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +1071.1 MB, control +14.3 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 285fa127, base 97fdffb9; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
