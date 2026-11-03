**Merge readiness: NOT READY** — the second opinion contradicts the claim; 13 of 19 replies differ from the control and the second opinion does not confirm that as the claim.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 6/19 identical to the control
- performance against the control (calibration of 2026-11-02): decode +0% (±1%) · prefill +0% (±1%) · aggregate +1% (±3%) · cut-in -6% (±1%, 0.02 s apart, below the 0.2 s floor: not called) · startup +1% (±10%, one sample a side: not called) · aggregate@16 -1% (±3%)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +20.5 MB, control +59.4 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: EVIDENCE CONTRADICTS THE CLAIM; claim test: NONE; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 9d895e74, base 97fdffb9; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
