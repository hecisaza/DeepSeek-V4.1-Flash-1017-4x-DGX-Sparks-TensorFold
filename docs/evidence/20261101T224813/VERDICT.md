**Merge readiness: READY** — every suite green, no slowdown beyond the band; the pull request's own tests fail on the base and pass on the pull request, and the second opinion inspected them and found them sound.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (provisional calibration): decode +1% (±2%) · prefill -0% (±2%) · aggregate -0% (±6%) · cut-in -18% (±3%, 0.07 s apart, below the 0.2 s floor: not called) · startup -1% (±10%, one sample a side: not called)
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: confirmed (1 file(s): on the PR passes, on the base with the PR's tests fails)
- second opinion: EVIDENCE SUPPORTS THE CLAIM; claim test: NONE; author tests: SOUND
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 78f1b064, base fcef6cf2; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
