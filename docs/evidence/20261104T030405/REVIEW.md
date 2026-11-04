1. **Recomputed results.** Boundary hashes match **38/38**: 19/19 in each repetition, with matching labels and token counts and no errors.

| Target / repetition | Cut-in median short / long (s) | Soak completions / aborts / canaries |
|---|---:|---:|
| Candidate / 0 | 0.414 / 20.349 | 159 / 125 / 56 |
| Candidate / 1 | 0.376 / 20.025 | 157 / 119 / 55 |
| Base / 0 | 0.408 / 20.333 | 163 / 126 / 58 |
| Base / 1 | 0.411 / 20.560 | 163 / 126 / 58 |

Pooled cut-in medians: candidate **0.3815 / 20.0255 s**, base **0.4095 / 20.3685 s**. Accounting for the three-second launch delay confirms admission in all six rounds per target.

Soak totals: candidate **316 completions, 244 aborts, 111 canaries**; base **326, 252, 116**. Every repetition records **zero errors and zero canary mismatches**.

Arithmetic, greedy-repeat equality, stream equality and JSON-object checks are all true in all four smoke records, with no errors. Smoke responses and individual soak events are absent, so their recorded checks/counts cannot be independently reconstructed.

The requested numerical results match `report.md`, including its rounding. **One discrepancy:** “adds or changes no test file under `tests/`” is false; the patch adds `tests/repro-issue-14.sh`.

2. **Changed paths and coverage.** Patch `0047` changes DSML boundary detection in `reply_text.blockEnd`, streaming suppression in `hideInto`, and both DSML envelope branches. Final parsing compares original and extended envelopes, accepting extension only when it yields more calls.

The reproduction forces a V4.1 `write` call containing the block closer inside a parameter, whole and streamed. **This rare failure path ran:** both candidate repetitions preserve the exact call; both base repetitions drop it and expose markup. Other suites provide ordinary regression coverage.

V4 spelling, malformed/truncated blocks, nested tags, multiple blocks, call limits and surrounding-prose timing lack executed coverage. Added Zig tests and the broader `claims/` script have no execution results here. The workflow’s new mergeability polling also lacks a targeted test.

3. **PR claims.**

- **Supported:** the specific V4.1 embedded-closer failure is fixed in whole and streamed responses; plain-value calls remain functional.
- **Supported narrowly:** ordinary replies remain unchanged for the tested boundary prompts and smoke checks.
- **Not tested:** both-spelling generality, multiple-block/prose behavior, real-session leak rates, sampling explanations, historical CPU/pytest/mutation results and golden parity.
- **Description conflicts with the patch:** the implementation uses structural boundaries, not universally the “last closer before the next opener”; completed blocks need not remain hidden until reply end; openers inside values need not split blocks; trailing prose quoting a closer is intended to remain content. These behaviors were not measured here.
- Unchanged sampling defaults, diagnostics and non-DSML handling are supported by inspection, not dedicated behavioral tests.

4. **Limitations.** Two counterbalanced AB/BA repetitions cover every requested suite; settings and image identifiers agree across metadata, and restoration succeeded. Build provenance is not independently established. Fixed comparison prompts match by construction; timed soak workers complete different workload counts. Startup has two candidate samples versus one base sample. Fault, endurance and external benchmarks did not run.

5. **Oracles.**

CLAIM TEST: SOUND

The executed script requires exact arguments, tool-call completion, no leaked closers and working plain-call controls; rejection cannot pass.

AUTHOR TESTS: NONE

`hosttests.json` records no files or executions; the separately executed reproduction is assessed above.

EVIDENCE SUPPORTS THE CLAIM — narrowly: the targeted failure occurs twice on base, the sound oracle passes twice on candidate, and ordinary-call controls pass on both.
