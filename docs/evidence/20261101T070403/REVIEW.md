1. **Recomputed results**

No discrepancies in the requested report figures.

| Measurement | Candidate | Base |
|---|---:|---:|
| Boundary hashes identical | 19/19 across targets | |
| Cut-in median, short | 17.498 s | 17.139 s |
| Cut-in median, long | 20.204 s | 19.860 s |
| Soak completions | 169 | 171 |
| Client aborts | 126 | 128 |
| Soak errors | 0 | 0 |
| Canary checks / mismatches | 61 / 0 | 61 / 0 |

The report correctly rounds cut-in medians to 17.50/20.20 and 17.14/19.86 seconds. Boundary labels and token counts match; neither target records boundary errors.

Both targets record all four smoke checks as true: arithmetic, greedy repeat equality, stream/content equality, and JSON mode. Errors are empty; streaming first-token times are 0.091/0.092 seconds. However, smoke responses are absent: these booleans cannot be independently re-evaluated. Soak likewise retains counters rather than individual outcomes.

2. **Changed paths and coverage**

The patch adds response-channel classification in `chat.prepare`, propagated through generation and replies. For JSON structures it disables tool streaming and associated hiding, bypasses streaming visibility filtering and non-thinking Harmony parsing, skips `attachCalls`, and changes OpenAI streaming tool handling. Prompt rendering is not edited. Three documentation files also change.

Recorded `repro` output exercises the central bug: `json_schema` whole/streamed and `guided_json` whole answers shaped like tool calls. On the base, all three become tool calls; whole content becomes null. On the candidate, all retain JSON content, report zero tool calls, and finish with `stop`. An ordinary tool call succeeds on both.

Smoke additionally exercises whole `json_object` without tools. Generic suites exercise ordinary generation. Quoted DSML/Harmony markers, thinking, compaction/context refusals, and allocation failures lack demonstrated coverage. For those conditions, this run does not establish correctness.

3. **Claims in `PR.md`**

- **Supported, within recorded cases:** JSON answers remain content beside offered tools; ordinary tool calling still works.
- **Not tested:** `json_object` with tools, `structured_outputs`, quoted-marker preservation, Unicode/chunk invariance, reasoning preservation, exact prompt-hash equality, token IDs and usage.
- **Not tested:** required/named policies, schema-policy 400 refusals, guided regex/choice/custom grammars, and existing unstructured fallback differences.
- **Not tested:** allocation-free/cancellation guarantees, four OOM/cancel cases, historical CPU matrices and their counts, or 70 passing server tests.
- **Not tested:** historical 25-check results, validation/reference replies, needle results, quoted throughput workloads, and compatibility with other patch combinations. This run’s performance workloads differ; their numbers do not contradict those claims.

No PR claim is contradicted by the supplied results.

4. **Evidence limits**

One candidate-first repetition cannot separate timing effects from order, cache or thermal effects. Boundary/cut-in/performance prompts are reproducible across targets; time-limited soak completes different request counts.

`claim.sh` is missing, leaving exact reproduction requests and assertions unauditable; only output tails and exit statuses remain. The common client does not validate tool-call payloads, so generic suites cannot replace that reproduction.

No unexpected errors or restore failure are recorded. Fault and external benchmark suites did not run. Control tagging matches the stated base prefix `476bbc7`, but image IDs alone do not independently establish source provenance.

5. **EVIDENCE SUPPORTS THE CLAIM** — three recorded structured-output cases fail on the base and pass on the candidate; ordinary tool calling survives; 19/19 boundary hashes match.
