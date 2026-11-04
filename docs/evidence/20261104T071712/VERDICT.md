**Merge readiness: NOT READY** — slower than the control over counterbalanced repetitions: decode -2% (band ±1%).

- suites on `pr`: perf ✓ · startup ✓
- repro script: confirmed (4 repetition(s))
- performance against the control (calibration of 2026-11-02): decode -2% (±1%, slower) · prefill +0% (±1%) · aggregate +0% (±3%) · startup +0% (±10%)
- the PR's own tests: no tests
- second opinion: EVIDENCE SUPPORTS THE CLAIM; claim test: SOUND; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head a12c134d, base 57c739cb; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
