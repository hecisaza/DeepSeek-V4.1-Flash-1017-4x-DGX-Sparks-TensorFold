1. **Recomputed results:** No numerical discrepancies in the requested report entries, allowing for rounding.

- Boundary: **38/38** valid, error-free hash matches: 19/19 per repetition, with matching labels and token counts.
- Cut-in medians, seconds:

| Target / repetition | Short | Long |
|---|---:|---:|
| PR / 0 | 0.395 | 20.023 |
| PR / 1 | 0.373 | 20.032 |
| Base / 0 | 0.415 | 20.132 |
| Base / 1 | 0.414 | 20.132 |

Pooled short medians: PR **0.380**, base **0.4145**. All 12 rounds satisfy admission even after accounting for the three-second launch delay; no errors.

- Soak, completions/aborts/canaries: PR repetitions **161/123/57**, **162/126/57**; base **159/123/56**, **161/122/57**. Totals: PR **323/249/114**, base **320/245/113**. Every error and canary-mismatch count is zero.
- Smoke: arithmetic, greedy-repeat equality, stream equality and JSON-object checks are all true for both targets in both repetitions; no errors. Stream first-token times match the report. Original responses are absent, so these stored checks cannot be independently reconstructed.

2. **Changed paths and coverage:**

- `0047`: history-length calculation and template string concatenation. Single-message requests exercise rendering and tail calculation, but no suite supplies a multi-message history. Successful in-place resizing is unobserved.
- `0048`: template scratch allocation, tokenizer encode/decode scratch, and connection-arena retention. Ordinary requests exercise rendering/tokenization; the client does not reuse connections to test retained memory after large requests.
- `0049`: larger attention/compressor row tables and optional decode scheduling/copy controls. Chunk size remains 2048; neither optional switch is enabled. Long prompts span chunks and do not test an 8192-row pass.
- `0050`: validates Engram row IDs before allocating AIO buffers. No executed suite supplies invalid IDs. Client aborts do not exercise this failure path.

These executions establish ordinary-path regression evidence, not verification of the memory fixes.

3. **PR claims:**

- Unchanged throughput: **supported within this workload’s resolution**. Recomputed decode/prefill/aggregate differences are approximately **0.0%/+0.8%/−1.1%**.
- Long-term OOM prevention, reduced anonymous blocks, flat memory, available-memory improvement and device-memory figures: **not tested**.
- Allocation mechanisms, keep-alive cap, expanded row capacity and optional-switch behavior: **not behaviorally verified**.
- Claimed suffix-mismatch fallback: **contradicted by the patch**, though not measured: successful tail rendering sets `tried_tail=true`; a suffix mismatch consequently bypasses the fallback.
- Invalid-row leak fix: **not tested by this run**.
- Unchanged defaults are consistent with the diff; exact patch-application history, upstream equivalence and production measurements are **not established** by this bundle.

4. **Limits:** Two counterbalanced repetitions, a complete six-suite matrix, matching comparison prompts, no recorded errors and verified restoration support regression validity. However, each soak lasts only ten minutes. The base has one recorded startup versus two for the candidate, introducing different process warmth. Container-memory samples do not isolate anonymous allocations. Build provenance is recorded through image labels/IDs without build logs. Fault, repro and external benchmark suites did not run.

5. **Oracles:**

CLAIM TEST: NONE

No execution script is present.

AUTHOR TESTS: NONE

`hosttests.json` records no executions; the embedded AIO test checks invalid-ID rejection and subsequent valid reads, but has no candidate/base output.

6. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — matched boundary replies; error-free regression suites; no executed oracle verifies the claimed memory improvements.
