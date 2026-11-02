**Merge readiness: NOT READY** — a patch number collides with another open pull request.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 38/38 identical to the control
- performance against the control (calibration of 2026-11-02): decode -0% (±1%) · prefill +1% (±1%) · aggregate -2% (±3%) · cut-in +8% (±1%, 0.03 s apart, below the 0.2 s floor: not called) · startup +2% (±10%, one sample a side: not called) · aggregate@16 -3% (±3%)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +305.2 MB, control +304.2 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: NONE
- patch numbers: COLLISION: patch 0047 is added by #27 #41
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 00ff6fc2, base fcef6cf2; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
