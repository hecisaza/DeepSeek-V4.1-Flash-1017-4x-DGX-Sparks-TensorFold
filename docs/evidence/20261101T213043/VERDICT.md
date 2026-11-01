**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown beyond the band; the claim is verified (the claim script fails on the base and passes on the candidate, and the second opinion found its oracle sound), but the candidate is the head on its merge-base, not the pull request integrated with the current base: not current readiness.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 38/38 identical to the control
- claim script: confirmed (2 repetition(s))
- performance against the control (provisional calibration): decode -0% (±2%) · prefill -1% (±2%) · aggregate -1% (±6%) · cut-in -22% (±3%, 0.08 s apart, below the 0.2 s floor: not called) · startup +0% (±10%, one sample a side: not called)
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: EVIDENCE SUPPORTS THE CLAIM; claim test: SOUND; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate head against its merge-base 476bbc77 (the PR does not merge cleanly onto the current base); head 0430154e, base 476bbc77; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
