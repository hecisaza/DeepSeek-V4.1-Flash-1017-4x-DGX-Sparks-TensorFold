**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown beyond the band; the pull request's own tests pass on the PR and fail on the base: tested by the author, oracle not independently inspected (second opinion: UNSOUND).

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · concurrency ✓ · startup ✓
- replies: 38/38 identical to the control
- performance against the control (calibration expired on 2026-11-18: floors apply): decode +1.7% (±3%, paired by prompt, 6 rounds) · prefill +0.2% (±3%, paired by prompt, 6 rounds) · aggregate +0.4% (±5%, paired by prompt, 6 rounds) · cut-in +31.4% (±3%, medians, faster) · startup +0.4% (±10%, medians, one sample a side: not called) · aggregate@16 +0.1% (±5%, medians)
- concurrency: batched-vs-serial mismatches candidate 0, control 0; largest host memory growth after a drain candidate +97.3 MB, control +70.6 MB
- cut-in admission (short request answered before the long prompt's first token): candidate yes, control yes
- the PR's own tests: confirmed (1 file(s): on the PR passes, on the base with the PR's tests fails)
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED; claim test: NONE; author tests: UNSOUND
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)
- run manifest: PR open at execution; candidate merged onto the current base; head 306ef0ee, base 8ffa67d5; engine switches: lab

_A person merges. READY: audited evidence verifies the claim. SAFE, UNVERIFIED: nothing broke, the claim is not verified to that standard. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
