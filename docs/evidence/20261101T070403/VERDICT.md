**Merge readiness: READY** — every suite green, no slowdown, the claim or reproduction script fails on the base and passes on the candidate, the second opinion supports the claim.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 19/19 identical to the control
- claim script: confirmed (1 repetition(s))
- performance against the control (each with its own noise band): decode +1% (±10%) · prefill -1% (±15%) · aggregate -1% (±12%) · cut-in -2% (±5%) · startup +1% (±10%, one sample a side: not called)
- the PR's own tests: no tests
- second opinion: EVIDENCE SUPPORTS THE CLAIM
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)

_A person merges. READY: the evidence supports the claim. SAFE, UNVERIFIED: nothing broke, but the change itself was not exercised. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
