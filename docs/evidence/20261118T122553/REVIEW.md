1. **Recomputed results:** The requested numerical results agree with `report.md`; there are no numerical discrepancies.

   | Check | Candidate | Base |
   |---|---:|---:|
   | Boundary hashes identical | 19/19 paired comparisons | Same labels and token counts |
   | Cut-in short median | 1.818 s | 1.733 s |
   | Cut-in long median | 45.487 s | 45.267 s |
   | Soak completions / aborts | 118 / 85 | 120 / 90 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 37 / 0 | 39 / 0 |

   Reported cut-in medians round correctly to 1.82/1.73 s and 45.49/45.27 s. Both targets recorded admission in 3/3 rounds. Arithmetic, greedy-repeat equality, streaming equality, and JSON-object checks are all `true` on both, with no smoke errors; streaming first-token times are 0.101/0.099 s. Smoke replies and individual soak events are absent, so these checks and counts can be reconciled with the stored results, but not independently reconstructed from response transcripts.

   The report’s **“confirmed”** author-test characterization is unjustified as behavioral verification; see item 5.

2. **Changed paths:** The engine patch replaces the constant body limit with mutable state, adds environment parsing and MiB conversion, and calls initialization during startup before serving. Documentation and an offline test file also change.

   Startup and ordinary `/chat/completions` requests ran, exercising startup and acceptance of small bodies. Neither target records `TF_DS_MAX_BODY_MIB`. Even the 64,000-word cut-in prompts are far below 32 MiB. No suite sends a body near or above the ceiling, configures a larger ceiling, or exercises invalid-value fallback. The oversized-body refusal path and configurable acceptance remain untested. These runs demonstrate ordinary-request regression coverage, not that the new setting works.

3. **Claims:**
   - **Configurable whole-MiB ceiling, startup-only reading, forwarding to every rank, and rank-zero-only HTTP:** not behaviorally tested. Source inspection supports the initialization placement; static tests check strings and the forwarding namespace.
   - **Unchanged default behavior:** supported for the ordinary requests exercised; the exact 32 MiB boundary, refusal message, status, and framing are not tested.
   - **Non-numeric, zero, and negative values preserve the default:** not tested at runtime.
   - **Larger image requests work with a 64 MiB setting, including behind a proxy:** not tested.
   - **Offline tests pass:** supported by five candidate passes. **Zig 0.17.0 AST checks:** not evidenced here.
   
   No runtime claim is contradicted by these measurements.

4. **Evidence limits:** There is one repetition, candidate first, without counterbalancing. The recorded matrix is complete, both targets appear healthy, settings match, and restoration is recorded as verified. Boundary identities and performance prompt keys match. Soak is time-limited and completes different amounts of its seeded workload. Repro, fault, endurance, and external benchmark suites did not run. Image identifiers agree across metadata and `run.txt`, but the bundle supplies no independent build provenance proving the control corresponds to the stated base.

5. **Oracles:**

CLAIM TEST: NONE  
No executed claim script is present.

AUTHOR TESTS: UNSOUND  
The five tests inspect patch text and filenames rather than runtime behavior, and all five base failures occur in setup because the new patch file is missing.

6. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — Healthy paired measurements show ordinary-request parity; no configured or oversized-body case ran; author-test failures on the base are setup failures.
