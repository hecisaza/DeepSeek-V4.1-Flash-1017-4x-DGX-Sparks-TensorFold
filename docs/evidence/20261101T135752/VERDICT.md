**Merge readiness: READY** — every suite green, no slowdown, the pull request's own tests fail on the base and pass on the pull request, the second opinion supports the claim.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (each with its own noise band): decode -4% (±9%) · prefill -2% (±3%) · aggregate -3% (±12%) · cut-in -1% (±3%) · startup +39% (±10%, one sample a side: not called)
- the PR's own tests: confirmed (7 file(s): on the PR passes, on the base with the PR's tests fails)
- second opinion: EVIDENCE SUPPORTS THE CLAIM
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)

_A person merges. READY: the evidence supports the claim. SAFE, UNVERIFIED: nothing broke, but the change itself was not exercised. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
