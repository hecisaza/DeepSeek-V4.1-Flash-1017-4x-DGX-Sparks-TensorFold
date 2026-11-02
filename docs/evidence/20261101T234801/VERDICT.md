**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown beyond the band; the pull request does not merge cleanly onto its current base: tested as the head on its merge-base; a rebase is needed before current readiness can be judged.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode +1% (±2%) · prefill +1% (±2%) · aggregate +0% (±6%) · cut-in +2% (±3%) · startup -2% (±10%, one sample a side: not called)
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate head against its merge-base 476bbc77 (the PR does not merge cleanly onto the current base); head 1bb3caca, base 476bbc77; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
