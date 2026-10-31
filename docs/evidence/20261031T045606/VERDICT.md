**Merge readiness: NOT READY** — a patch number collides with another open pull request.

- suites on `pr`: smoke ✓ · boundary ✓ · cutin ✓ · perf ✓ · soak ✓
- replies: 19/19 identical to the control
- performance against the control (each with its own noise band): decode +2% (±9%) · prefill -0% (±3%) · aggregate +1% (±12%) · cut-in +1% (±3%)
- second opinion: NO REGRESSION SHOWN, CLAIM NOT TESTED
- patch numbers: COLLISION: patch 0037 is added by #20 #27
- restore: live restored

_A person merges. READY: the evidence supports the claim. SAFE, UNVERIFIED: nothing broke, but the change itself was not exercised. NOT READY: something failed or is unexplained. RERUN: the measurement is not trustworthy._
