**Merge readiness: NOT READY** — slower than the control over counterbalanced repetitions: decode -4% (band ±1%); the second opinion contradicts the claim.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 38/38 identical to the control
- performance against the control (calibration of 2026-11-02): decode -4% (±1%, slower) · prefill -1% (±1%) · aggregate -3% (±3%) · cut-in +5% (±1%, 0.02 s apart, below the 0.2 s floor: not called) · startup +1% (±10%, one sample a side: not called) · aggregate@16 -3% (±3%)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +122.9 MB, control +48.2 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: EVIDENCE CONTRADICTS THE CLAIM; claim test: NONE; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 1ffce947, base 97fdffb9; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
