1. **Recomputed results**

- Boundary: **38/38 identical hashes**, comprising 19 matched prompts per repetition; token counts also match, with no errors.
- Cut-in medians, seconds, shown as **short / long**:

| Target | Repetition 0 | Repetition 1 | All six rounds |
|---|---:|---:|---:|
| Candidate | 0.358 / 20.180 | 0.382 / 20.123 | 0.379 / 20.1515 |
| Base | 0.372 / 20.483 | 0.369 / 20.671 | 0.3705 / 20.5725 |

- Soak candidate: **163/164 completions**, **126/126 aborts**, **57/57 canaries** across repetitions. Base: **159/162 completions**, **120/125 aborts**, **56/57 canaries**. Every repetition records **zero errors and zero canary mismatches**.
- Smoke: arithmetic, greedy repeat equality, streaming equality, and JSON-object checks are all true for both targets in both repetitions; no errors. First-token times are candidate **0.092/0.091 s**, base **0.090/0.089 s**.

These numerical statements match `report.md`, including rounding. Smoke responses themselves were not retained, so their recorded booleans cannot be independently reconstructed.

One reporting discrepancy: “adds or changes no test file under `tests/`” is false; the patch adds `tests/repro-issue-14.sh`.

2. **Changed paths and exercised coverage**

Patch `0047` introduces `reply_text.blockEnd`, choosing the last DSML closer before the next opener of the same spelling. Both DSML branches in `tool_parse.envelopes` use it. `hideInto` also uses it and holds streamed DSML content until completion.

The repro explicitly forces a V4.1 `write` call whose value contains `</｜DSML｜ calls>`, streamed and non-streamed. Thus the rare failure path **was exercised**. Both candidate repetitions preserve the exact arguments and tool-call finish reason; both base repetitions drop the call and expose markup.

The alternate spelling, next-opener limit, multiple blocks, and surrounding-prose timing lack executed coverage. The broader added claim script did **not** run. General suites establish regression coverage only.

The workflow also adds polling while mergeability is unknown; no supplied test demonstrates that condition.

3. **PR claims**

- **Supported:** the specific closer-in-value failure and its V4.1 fix, including preventing leaked closing tags in streamed content.
- **Supported within sampled cases:** ordinary plain-value calls still work; general replies show no detected regression.
- **Not tested:** both-spelling generality, multiple-block preservation, prose buffering timing and consumption, opener-containing values, and comprehensive unchanged behavior for other markup, reasoning, or diagnostics.
- **Not independently verified:** reported CPU/Python test totals, mutation canaries, historical long-context sampling, or causation of the original incident. No sampling-default comparison ran.
- No observed result contradicts the demonstrated fix.

4. **Evidence limits**

All seven requested suites have two repetitions per target, with recorded AB/BA order, matching public settings, consistent image identifiers, and successful restore. Deterministic prompt construction matches targets; soak is duration-limited and completes different workload counts. Only two repetitions, unequal startup counts, and skipped endurance, fault, and external benchmark suites limit broader conclusions. Image-to-source provenance is recorded rather than independently established.

5. **Oracles**

CLAIM TEST: SOUND

The executed script forces the triggering value, requires exact intact calls and finish reasons in both modes, rejects leaked closers, and preserves plain-call controls; request rejection cannot pass.

AUTHOR TESTS: NONE

`hosttests.json` contains no selected files or paired execution output; added Zig assertions were readable but have no independently recorded execution here.

EVIDENCE SUPPORTS THE CLAIM — the targeted V4.1 oracle is sound, passes twice on the candidate, and reproduces the behavioral failure twice on a functioning base.
