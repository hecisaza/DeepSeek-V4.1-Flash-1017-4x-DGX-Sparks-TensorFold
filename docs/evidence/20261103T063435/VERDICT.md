**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown beyond the band; the claim is verified (the repro script fails on the base and passes on the candidate, and the second opinion found its oracle sound), but the candidate is the head on its merge-base, not the pull request integrated with the current base: not current readiness.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 19/19 identical to the control
- repro script: confirmed (1 repetition(s))
- performance against the control (calibration of 2026-11-02): decode +3% (±1%, faster) · prefill +1% (±1%) · aggregate +2% (±3%) · cut-in +4% (±1%, 0.02 s apart, below the 0.2 s floor: not called) · startup +1% (±10%, one sample a side: not called) · aggregate@16 +1% (±3%)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +20.4 MB, control +49.2 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: EVIDENCE SUPPORTS THE CLAIM; claim test: SOUND; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate head against its merge-base 57c739cb (the PR does not merge cleanly onto the current base); head 6f0de334, base 57c739cb; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
