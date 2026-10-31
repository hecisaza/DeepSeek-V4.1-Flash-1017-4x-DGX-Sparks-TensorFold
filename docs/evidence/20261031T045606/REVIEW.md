1. **Recomputed results**

   | Check | Candidate | Control |
   |---|---:|---:|
   | Boundary hashes identical | **19/19 paired comparisons** | |
   | Cut-in median, short request | 16.917 s | 17.018 s |
   | Cut-in median, long request | 19.643 s | 19.719 s |
   | Soak completions | 175 | 175 |
   | Client aborts | 130 | 131 |
   | Soak errors | 0 | 0 |
   | Canary checks / mismatches | 59 / 0 | 59 / 0 |
   | Arithmetic | Pass | Pass |
   | Greedy repeat equality | Pass | Pass |
   | Streaming matches nonstreaming | Pass | Pass |
   | JSON object parsing | Pass | Pass |
   | Streaming first token | 0.096 s | 0.091 s |

   **No numerical discrepancies:** `report.md` matches these results, including rounding. All recorded error lists are empty. Boundary labels and token counts match between targets.

   Smoke stores booleans rather than replies, and soak stores counters rather than individual events; those underlying checks cannot be independently reconstructed.

   One reporting inconsistency: the limitations say throughput and latency against a control were not shown because `bench` did not run, although `perf` and `cutin` provide such comparisons. Referenced SVG charts are absent from this bundle.

2. **Changed paths and coverage**

   The executable change is a new patch targeting `weights.zig`; README and changelog edits describe it. It adds optional prefetch state to rank-cache sources, advances an atomic position after successful tensor reads, starts eight prefetch threads during cache-backed loading, and stops/joins them during cleanup. Threads allocate buffers, claim chunks, wait behind the lead limit, perform positional reads, retry interruptions, and exit on other read failures.

   The trigger is **weight loading from a rank cache with `TF_DS_LOAD_PREFETCH` unset or not `"0"`**. Chat requests do not trigger it. Startup may have exercised it, but the bundle records neither loader source nor prefetch activity. The suites test inference after startup.

   No suite tests disabled prefetch, shard loading, allocation/thread failures, interrupted or failed reads, or cleanup during failed loading. `fault` did not run. This is a startup optimization, not principally a rare failure-path fix; its benefit remains unmeasured.

3. **PR claims**

   - **83.4 → 27.2–27.4 s loading; ring startup ~96 → 32–36 s:** not tested. No load timings or cold-file procedure are recorded.
   - **48.0 s whole-file pre-read, 84.8 s pinned buffers, NVMe bandwidth and NFS bottleneck:** not tested.
   - **Eight threads, 32 MiB chunks, cache warming and disable switch:** visible in code, not runtime-verified. The strict 4 GiB bound is imprecise: a chunk starting exactly at the limit can extend 32 MiB beyond it.
   - **Unchanged tensor hashes and 258 differing native tables:** not tested; no tensor dumps.
   - **Identical greedy replies:** supported for 19 short-output cases, not the claimed three 300-token prompts.
   - **Unchanged inference speed:** consistent with measured decode +1.96%, prefill −0.11%, aggregate +1.45%; overlapping round ranges prevent a strong equivalence claim.
   - **Host tests, known build failures, excluded grammar tests, application after 0036:** not independently tested here. Documentation additions are present.

4. **Evidence limits**

   One repetition, candidate first, permits order/cache effects. Fixed comparison prompts match; time-limited soak workloads differ slightly. Restore succeeded. Metadata consistently labels the control as base, but supplies no independent build provenance. `fault`, `repro`, and `bench` are absent. Memory availability falls similarly on both targets; limited samples cannot establish leak freedom.

5. **NO REGRESSION SHOWN, CLAIM NOT TESTED** — 19/19 matching boundary hashes; zero recorded errors; no cold-load timing or verified prefetch execution.
