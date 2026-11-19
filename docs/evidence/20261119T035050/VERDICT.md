**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown beyond the band; faster than the control (cut-in +31%), noted but not counted: the PR does not claim performance.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 38/38 identical to the control
- performance against the control (calibration expired on 2026-11-18: floors apply): decode -0.5% (±3%, paired by prompt, 6 rounds) · prefill -0.4% (±3%, paired by prompt, 6 rounds) · aggregate -0.6% (±5%, paired by prompt, 6 rounds) · cut-in +31.4% (±3%, medians, faster) · startup +3.9% (±10%, medians, one sample a side: not called) · aggregate@16 -5.0% (±5%, medians)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +316.4 MB, control +58.3 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: NONE
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 01d2a891, base 8ffa67d5; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
