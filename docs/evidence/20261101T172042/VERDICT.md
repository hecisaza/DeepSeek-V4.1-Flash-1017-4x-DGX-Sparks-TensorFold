**Merge readiness: NOT READY** — a patch number collides with another open pull request.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓ · startup ✓
- replies: 19/19 identical to the control
- performance against the control (each with its own noise band): decode +0% (±9%) · prefill +1% (±3%) · aggregate +1% (±10%) · cut-in +0% (±3%) · startup +0% (±10%, one sample a side: not called)
- the PR's own tests: no tests
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED
- patch numbers: COLLISION: patch 0047 is added by #27 #41
- restore: live restored (verified: API answers, running artifact is live's)

_A person merges. READY: the evidence supports the claim. SAFE, UNVERIFIED: nothing broke, but the change itself was not exercised. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
