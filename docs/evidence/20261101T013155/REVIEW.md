1. **Recomputed results**

No numerical discrepancies with `report.md`.

| Check | Candidate | Control |
|---|---:|---:|
| Boundary hashes identical | **19/19**, matching labels and token counts | |
| Cut-in median, short | 16.987 s → **16.99 s** | 17.023 s → **17.02 s** |
| Cut-in median, long | 19.709 s → **19.71 s** | 19.768 s → **19.77 s** |
| Soak completions | 176 | 173 |
| Intentional client aborts | 130 | 128 |
| Soak errors | 0 | 0 |
| Canary checks / mismatches | 64 / 0 | 58 / 0 |

Both targets record all four smoke checks as true: arithmetic, greedy repeat equality, streaming equality, and JSON-object parsing. Both have empty error lists; streaming first-token times are **0.093 s** and **0.090 s**.

The smoke results contain booleans rather than response transcripts, so their reporting can be verified, but the assertions cannot independently be rerun from this bundle. Soak likewise supplies counters rather than individual request records.

2. **Changed paths and coverage**

The sole runtime change is in `status_routes.zig`: `health()` sets `conn.quiet_log = true` before either the keys-enabled response or the open response. The other changes document the patch.

A request to **`/health`**, followed through response logging, would exercise the change. Verifying its purpose requires comparing access logs, especially with API keys enabled.

None of the executed suites requests `/health`. They issue chat-completion requests; the supplied readiness helpers query `/models`. No health responses, access-log comparisons, authentication matrix, or rejected gated requests are recorded. The PR-specific `repro` suite did not run.

This is an ordinary route that the suites miss, rather than a rare failure path. These results show no observed regression in the tested workloads; they do not demonstrate the logging fix.

3. **Claims in `PR.md`**

- **Health polls cease producing access lines, eliminating misleading authentication labels:** **not tested**. The assignment is consistent with the intended mechanism, but the logging consumer is not supplied or exercised.
- **Health remains ungated, returns 200, preserves keyed/open bodies, and leaves authentication behavior unchanged:** **not tested**. The diff leaves the existing body-selection statements intact; that is static evidence, not runtime verification.
- **The existing `/stats` flag is consumed before request logging:** **not tested**; those implementation paths are absent from the bundle.
- **The reported daily poll volume, deployment configuration, recipe key settings, and key-dependent suffix behavior:** **not tested**.
- **Patch numbering, clean application to the specified upstream revision with and without `0044`, and the anticipated README rebase:** **not tested** by this run.
- **README, credits, and changelog additions:** visible in the diff; style consistency is a document-review judgment, not a hardware-test result.

No central behavioral claim is contradicted by the recorded run.

4. **Evidence limitations**

There is only one repetition, always candidate before control. Timing differences cannot establish a reliable performance effect. Boundary prompts match; cut-in and performance prompts use fixed seeds. The time-limited soak executes unequal workload counts.

No errors or restore failure are recorded; restoration is reported as verified. Image identifiers agree across metadata and `run.txt`, but the bundle lacks independent provenance proving the control is the stated base.

`fault`, `bench`, and `repro` did not run. Most importantly, the report’s limitations omit the complete absence of health/logging verification.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 boundary hashes match; recorded checks pass; `/health` and access-log suppression were never tested.
