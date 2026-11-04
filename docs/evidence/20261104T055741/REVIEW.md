1. **Recomputed results:** Boundary hashes match **38/38**: 19/19 in each repetition, with matching prompt labels and token counts and no errors.

   Cut-in medians in seconds, shown as short/long:

   | Target | Repetition 0 | Repetition 1 |
   |---|---:|---:|
   | Candidate | 0.524 / 20.115 | 0.393 / 20.290 |
   | Base | 0.337 / 19.959 | 0.388 / 20.279 |

   Pooled short medians are 0.4175 and 0.3745 respectively. All 12 rounds admitted the short request during long prefill.

   Soak completions/aborts were candidate **162/123, 161/125**; base **162/123, 160/122**. Totals: candidate **323/248**, base **322/245**. Every repetition recorded zero errors and 57 canaries with zero mismatches.

   Arithmetic, greedy-repeat equality, stream equality and JSON-object checks all passed for both targets in both repetitions, without errors. Smoke response bodies are absent, so these recorded booleans cannot be independently reassessed.

   **No numerical discrepancies** in these report sections, allowing for rounding. One reporting error: “no test file under `tests/`” contradicts the added `tests/repro-issue-14.sh`; empty host-test discovery does not establish absence.

2. **Changed paths:** `0047` changes DSML boundary recognition and streaming filtering in `reply_text`, envelope selection in `tool_parse`, template detection in `tool_grammar`, and streaming initialization/dispatch in `chat` and `tool_stream`. The parser compares original and extended parses, retaining the extended interpretation only when it yields more calls. DSML templates disable incremental `<tool_call>` extraction.

   Repro actually exercised whole and streamed V4.1 requests containing a closer inside a value, plus two invokes where the first value also contains `<tool_call>` markup. Both candidate repetitions passed; both base repetitions failed the four affected cases while passing plain-call controls.

   Alternate DSML spelling, malformed/truncated fallbacks, separate blocks, prose timing, template-detection failures and call limits lack executed coverage. General suites show regression evidence, not verification of those paths. Workflow mergeability polling also changes, without a targeted test.

3. **PR claims:** Preserving the closer-containing value, returning intended calls and preventing leaked closers are **supported** for the executed V4.1 cases. Plain-call preservation is supported narrowly; universal unchanged behavior is **not tested**.

   Both spellings, multiple blocks with intervening prose, post-block timing, Qwen/Gemma behavior, thinking, diagnostics and sampling effects are **not tested**. Historical unit-test, mutation, pytest and deep-context sampling results are not independently verified here.

   The description is stale relative to the patch: it describes last-closer-before-next-opener parsing and holding everything until reply end; the implementation structurally walks invokes and can release a completed block earlier. Its opener limitation and prose-loss discussion likewise do not describe this implementation. These are source discrepancies, not measured failures of the core fix.

4. **Limits:** Two counterbalanced repetitions, matching public settings, a complete suite matrix and verified restore strengthen the comparison. No control mismatch is apparent, although image labels are not independent build provenance. Endurance, fault and external benchmark suites did not run. The broader claim script and embedded Zig tests were not executed here. Synthetic forced replies do not establish the cause or frequency of real-session leaks.

CLAIM TEST: SOUND

It requires exact calls and arguments, `finish_reason=tool_calls`, no leaked closers, completed streams and working plain-call controls; rejection cannot pass.

AUTHOR TESTS: NONE

`hosttests.json` contains no files or execution outputs; the reproduction script is assessed above.

EVIDENCE SUPPORTS THE CLAIM — the core V4.1 failure reproduces on the healthy base, passes twice on the candidate, and is checked by a sound behavioral oracle.
