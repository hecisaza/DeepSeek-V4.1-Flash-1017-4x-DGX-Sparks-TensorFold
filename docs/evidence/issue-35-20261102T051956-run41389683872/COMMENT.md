**Triage** (automated): feature, nothing to reproduce on this lab.

The issue is "a question before a PR": would the maintainer take a small scripts PR that rejects stray *.safetensors in a worker's Engram directory and gives the packer only the index's files, and do they want SHA-256 checks of Engram caches at all, and at what start cost? The findings come from reading the code and from CPU fixtures; the maintainer has already answered (yes to (1) and (2), hash checks only as an opt-in prepare step, ENGRAM_VERIFY=1, measured on a Spark first), so the next step is the contributor's PR.
