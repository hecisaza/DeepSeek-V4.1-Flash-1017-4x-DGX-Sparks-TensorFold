1. Recomputed from `results.json`:

| Measurement | PR | Base |
|---|---:|---:|
| Boundary hashes identical | **19/19 paired comparisons** | |
| Cut-in median, short | 0.364 s | 0.379 s |
| Cut-in median, long | 19.932 s | 20.547 s |
| Soak completions | 161 | 159 |
| Client aborts | 124 | 120 |
| Soak errors | 0 | 0 |
| Canary checks / mismatches | 57 / 0 | 56 / 0 |

Both targets record arithmetic, greedy-repeat equality, streaming equality and JSON mode as passing, with no smoke errors. Smoke first-token times are 0.090/0.091 s. Actual timing comparisons support admission in all three cut-in rounds per target.

`report.md` states these correctly, including rounding. Smoke responses and individual soak events are absent, so their stored checks/counters cannot be independently reconstructed.

One reporting discrepancy: “no test file under `tests/`” is false—the patch adds `tests/repro-issue-14.sh`. Empty host-test discovery does not establish absence of tests.

2. Patch `0047` changes `reply_text.blockEnd`, streaming `hideInto`, and both DSML branches of `tool_parse.envelopes`. DSML blocks close at the last closer before the next same-spelling opener; unfinished streaming blocks remain hidden. Other changes add tests and documentation.

The `repro` suite exercised the rare closer-inside-a-string path using an exact `guided_regex` reply, both whole and streamed, with a plain-value control. The candidate returned the intact `write` call; the base dropped it and leaked markup. Thus this path was tested directly.

The generic suites provide regression evidence. They do not deliberately exercise the older DSML spelling, multiple blocks, trailing prose, or an opener inside a value. Added Zig tests cover several of these, but no execution results for them appear in `hosttests.json`.

3. Claims in `PR.md`:

- **Supported:** preservation of the embedded closer and successful V4.1 tool calls in whole/streamed replies; elimination of the reproduced closing-tag leak; preservation of the plain control call.
- **Partially supported:** ordinary replies remain unchanged—19 boundary comparisons and the smoke checks agree, but this is limited coverage.
- **Not tested:** older DSML spelling, next-opener separation, delayed trailing prose, prose containing another closer, opener-containing values, and other markup families.
- **Not independently verified:** reported CPU/Python test totals, mutation canaries, earlier deep-context sampling results, and historical build failures.
- **Not tested:** whether this mechanism caused the original incident, real-session leak rates, or any `TOP_P` effect. The description appropriately limits those claims.

No functional claim is contradicted by this run.

4. Evidence limitations: one repetition, candidate first, and no counterbalancing limit performance conclusions. Fixed comparison prompts/settings match; the timed soak naturally executes unequal request totals and is not a paired-output comparison. Endurance, fault and benchmark suites did not run. Metadata and `run.txt` agree on image identities and successful restoration, but the bundle lacks independent source-to-image provenance. No unexpected suite errors or incomplete target matrix appear.

CLAIM TEST: SOUND

The executed script matches the added script and requires exact arguments, `finish_reason=tool_calls`, no leaked closer, completed streaming, and successful plain controls; rejection cannot pass.

AUTHOR TESTS: NONE

`hosttests.json` contains no files or execution outputs; the reproduction script is assessed above.

EVIDENCE SUPPORTS THE CLAIM — the embedded-closer case fails behaviorally on the base and passes on the candidate; capability-preserving controls pass; the inspected oracle asserts successful calls with intact values.
