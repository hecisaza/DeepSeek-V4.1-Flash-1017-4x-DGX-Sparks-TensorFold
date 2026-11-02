**Issue outcome: OUT OF SCOPE** (label `issue:out-of-scope`)

- triage: feature: The issue is "a question before a PR": would the maintainer take a small scripts PR that rejects stray *.safetensors in a worker's Engram directory and gives the packer only the index's files, and do they want SHA-256 checks of Engram caches at all, and at what start cost? The findings come from reading the code and from CPU fixtures; the maintainer has already answered (yes to (1) and (2), hash checks only as an opt-in prepare step, ENGRAM_VERIFY=1, measured on a Spark first), so the next step is the contributor's PR.

Facts:

- triage: feature (medium confidence)
- patches named: 0003, scripts/prepare.sh, zig/src/families/dsv41/engram_io.zig

_FIXED means the fix is verified on hardware, not merged. NEEDS THE LAB and REPRODUCED are for a person to pick up._
