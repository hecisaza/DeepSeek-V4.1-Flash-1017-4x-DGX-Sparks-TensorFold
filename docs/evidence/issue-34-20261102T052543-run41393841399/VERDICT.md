**Issue outcome: OUT OF SCOPE** (label `issue:out-of-scope`)

- triage: feature: The issue is titled "Idea" and asks a design question before any code: an opt-in SLIM_CHECKPOINT=1 that drops the ~284 GiB of checkpoint shards only prepare.sh reads once the four weight files exist. Nothing has been built or start-tested, and the maintainer left it open as a feature request.

Facts:

- triage: feature (high confidence)
- patches named: scripts/prepare.sh, scripts/config.sh, verify_kit.sh, zig/src/families/dsv41/engram_io.zig

_FIXED means the fix is verified on hardware, not merged. NEEDS THE LAB and REPRODUCED are for a person to pick up._
