**Merge readiness: READY** — every suite green, no slowdown, the claim or reproduction script fails on the base and passes on the candidate, the second opinion supports the claim.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓
- replies: 19/19 identical to the control
- claim script: confirmed (1 repetition(s))
- performance against the control (each with its own noise band): decode +0% (±10%) · prefill +0% (±3%) · aggregate -3% (±12%) · cut-in -0% (±3%)
- second opinion: EVIDENCE SUPPORTS THE CLAIM
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)

_A person merges. READY: the evidence supports the claim. SAFE, UNVERIFIED: nothing broke, but the change itself was not exercised. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
