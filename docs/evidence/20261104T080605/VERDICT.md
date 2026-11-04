**Merge readiness: READY** — every suite green, no slowdown beyond the band; the repro script fails on the base and passes on the candidate, and the second opinion found its oracle sound.

- suites on `pr`: perf ✓ · startup ✓
- repro script: confirmed (4 repetition(s))
- performance against the control (provisional calibration): decode -0.5% (±1%, paired by prompt, 12 rounds) · prefill +0.2% (±1%, paired by prompt, 12 rounds) · aggregate -0.4% (±3%, paired by prompt, 12 rounds) · startup +1.0% (±10%, medians)
- the PR's own tests: no tests
- second opinion: EVIDENCE SUPPORTS THE CLAIM; claim test: SOUND; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head fd9137f0, base 57c739cb; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
