**Merge readiness: READY** — every suite green, no slowdown, the pull request's own tests fail on the base and pass on the pull request.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (each with its own noise band): decode -2% (±8%) · prefill -0% (±3%) · aggregate -1% (±11%) · cut-in -0% (±3%) · startup +0% (±3%)
- the PR's own tests: confirmed (3 file(s): on the PR passes, on the base with the PR's tests fails)
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)

_A person merges. READY: the evidence supports the claim. SAFE, UNVERIFIED: nothing broke, but the change itself was not exercised. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
