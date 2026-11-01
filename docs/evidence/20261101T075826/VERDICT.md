**Merge readiness: SAFE, UNVERIFIED** — no regression, no slowdown; the changed path was not exercised by any suite (second opinion: claim not tested).

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 38/38 identical to the control
- performance against the control (each with its own noise band): decode +1% (±11%) · prefill +1% (±7%) · aggregate -0% (±14%) · cut-in +3% (±3%) · startup +1% (±10%, one sample a side: not called)
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED
- patch numbers: no collision with another open pull request
- restore: live restored (verified: API answers, running artifact is live's)

_A person merges. READY: the evidence supports the claim. SAFE, UNVERIFIED: nothing broke, but the change itself was not exercised. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
