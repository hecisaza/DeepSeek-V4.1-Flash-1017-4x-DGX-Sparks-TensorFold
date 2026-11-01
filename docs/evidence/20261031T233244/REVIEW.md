1. **Recomputed results:** No discrepancies in the requested figures.

   | Measurement | PR | Base |
   |---|---:|---:|
   | Identical boundary hashes | 19/19 paired comparisons | Same labels and token counts |
   | Cut-in median, short | 17.072 s | 17.511 s |
   | Cut-in median, long | 19.825 s | 20.265 s |
   | Soak normal completions | 176 | 169 |
   | Client aborts | 131 | 125 |
   | Errors | 0 | 0 |
   | Canary checks / mismatches | 63 / 0 | 59 / 0 |

   Both targets record arithmetic, greedy-repeat equality, stream equality and JSON-object checks as true, with empty error lists and streaming first-token time of 0.091 s. The report’s cut-in rounding matches `report.py`.

   Limits: smoke replies and individual soak events are absent, so their recorded checks/counters cannot be independently reconstructed. The report’s additional “confirmed” offline-test result is unverifiable: `report.py` reads it from `hosttests.json`, which is absent.

2. **Changed paths and coverage:** `scripts/nodes.sh` changes TP>2 `pair_links`: intersect ranks’ RoCE subnets, select one globally by network version/address/prefix, then select each rank’s lowest local address within it. With no common subnet, retain the default-route fallback. `scripts/config.sh` changes only a comment; five offline test methods are added.

   The new selection branch requires startup with a subnet shared by every rank. The hardware run declares **ring** topology; no shared-subnet inventory or selected-interface trace establishes execution of that branch. Startup succeeded on both targets, providing limited fallback regression evidence.

   Smoke, boundary, cut-in, performance and soak send inference requests after startup; none forces switched-mesh discovery, reversed dual-rail inventory, missing default routes or explicit overrides. The added fixtures target those conditions, but their execution is supported only by the report’s unverified summary. This hardware run shows no observed regression, not that switched-mesh bootstrap works.

3. **PR claims:**

   - **Common-subnet selection and deterministic rail choice:** supported by patch inspection; not tested by the hardware run. Lowest-local-address tie-breaking lacks a dedicated multi-address fixture.
   - **Preserve HCA ordering, GID selection, peer discovery and ring graph:** relevant logic is unchanged in the diff; successful ring operation offers limited support, without direct assertions of these outputs.
   - **Preserve triangle/ring fallback:** ring operation supported indirectly; triangle not tested.
   - **Preserve explicit overrides; TP2 unchanged:** not tested by hardware; patch inspection shows no direct changes to those paths.
   - **Five fixtures, three failing on base, 94 tests passing:** five fixtures are visible; execution counts are not independently verifiable here.
   - **Historical bootstrap hang, contrasting all-reduce outcomes and running switched-fabric deployment:** not tested.
   - **No model/kernel changes:** supported by the diff. Independence from the lock-FD PR and operational restart claims are not established.

   No claim is directly contradicted.

4. **Evidence limitations:** One candidate-first repetition confounds timing with order and machine state. Boundary prompt sets match; cut-in/performance prompts use matching seeds. Soak uses seeded workers but time-limited execution produces different workload counts. No recorded errors or restore failure; restoration is reported verified. Control identifiers agree across metadata and `run.txt`, but image-to-source provenance is not independently demonstrated. Fault, reproduction and external benchmark suites did not run. Telemetry lacks per-rank bootstrap selections and resource counts needed to assess leaks.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary matches and no recorded errors; hardware used a ring; shared-fabric fixture execution lacks underlying evidence.
