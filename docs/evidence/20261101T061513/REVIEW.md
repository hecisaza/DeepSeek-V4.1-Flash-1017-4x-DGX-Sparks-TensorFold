1. **Recomputed results**

| Measure | Candidate | Control |
|---|---:|---:|
| Identical boundary hashes | **19/19 paired matches** | Same labels and token counts |
| Cut-in median, short | 17.115 s | 16.990 s |
| Cut-in median, long | 19.872 s | 19.696 s |
| Soak completions | 176 | 175 |
| Client aborts | 130 | 132 |
| Soak errors | 0 | 0 |
| Canary checks / mismatches | 64 / 0 | 60 / 0 |
| Arithmetic | Pass | Pass |
| Greedy repeat equality | Pass | Pass |
| Stream/content equality | Pass | Pass |
| JSON mode | Pass | Pass |

Both smoke error lists are empty; streaming first-token times are 0.091/0.090 s. **No numerical discrepancies** in these report entries. Its cut-in figures follow `report.py`’s Python rounding, including 17.115 → 17.11.

Smoke responses themselves are absent, so their stored booleans cannot be independently revalidated. Soak totals likewise lack individual request records.

One interpretive overstatement: “Reproduced on the control and gone on the candidate” describes the missing diagnostic, **not disappearance of the malformed output**. Closing tags remain on both.

2. **Changed paths and coverage**

The patch adds `output_diagnostics.zig` and a call during chat response metadata construction. With active tools, a nonempty answer containing exclusively recognized V4/V4.1 closing tags and permitted whitespace receives `tensorfold.tool_parse_warning`; a log line records the request identifier and warning code. Documentation also changes.

Ordinary smoke, boundary, cut-in, performance and soak requests offer no tools, so they bypass the new diagnostic condition.

However, **`repro` does exercise the rare path**: its retained transcript records tools-enabled closing-tag replies, whole-response and final-SSE warning checks for both spellings, four candidate warning log lines, and absent control warnings. Candidate exits 0; control exits 1. No-tools closing tags and prose-before-closer remain unflagged. This therefore exceeds generic no-regression evidence, although the transcript is incomplete.

3. **PR claims**

- **Supported for recorded cases:** diagnostic field on whole/SSE replies, both tag spellings, tools gating, prose exclusion, and request-identifier/code logging without reply text.
- **Partially supported:** content remains closing tags, finish reason remains `stop`, and no tool call is invented. V4.1 token hashes and completion counts match across targets and delivery modes. Complete token/usage preservation is not established for every case.
- **Not tested comprehensively:** all whitespace combinations and excluded forms; reasoning/history interactions; real ≥300K contexts; retry absence; compatibility with unaware clients. Allocation-free recognition is supported by source inspection, not measurement.
- **Not independently verified here:** CPU positive/negative tests, 42 handler observations, 71 server tests, historical validation/reference replies, needle results, historical throughput, 25 ordinary/tool replies, and patch application order.
- No PR claim is conclusively contradicted. This run does not establish a fix or cause for issue #14; the PR explicitly claims neither.

4. **Evidence limits**

Only one repetition, always candidate then control; timing is vulnerable to order and cache effects. Fixed suites use matching prompts, but time-limited concurrent soak executes different request counts. `claim.sh`, complete requests/responses, and full logs are missing. Generic client hashes cover content, not token IDs or warning metadata. Fault and external benchmark suites did not run. No operational errors or restore failure are recorded. Control revision `476bbc77` agrees with the stated base prefix, but image labels alone cannot independently prove build provenance.

5. **EVIDENCE SUPPORTS THE CLAIM** — recorded positive whole/SSE diagnostics, absent control warnings, and passing negative cases support the narrow diagnostic claim; the missing reproduction script limits auditability.
