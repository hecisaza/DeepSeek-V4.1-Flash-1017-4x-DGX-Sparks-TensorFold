1. **Recomputed results:** No numerical discrepancies with `report.md`.

   - Boundary: **19/19** valid hashes identical; labels and token counts also match.
   - Cut-in medians, candidate/base: short **0.443/0.378 s**, long **20.229/20.233 s**. The report rounds correctly. All three rounds per target satisfy admission even after accounting for the short request’s three-second delay.
   - Soak, candidate/base: **164/162 completions**, **126/125 aborts**, **57/57 canary checks**, **0/0 errors**, **0/0 mismatches**; error lists empty.
   - Smoke: arithmetic, greedy repeat equality, stream equality and JSON mode are all recorded `true` on both targets; no errors. Streaming first-token times are **0.092/0.090 s**. Original smoke responses are absent, so those assertions cannot be independently re-evaluated.
   - Performance medians and startup times also match. Repro exits are correctly reported as candidate **0**, base **1**. However, “gone on the candidate” overstates what the incomplete oracle establishes.

2. **Changed paths:** The engine patch adds `discardBody(conn, a)` before GET routing and DELETE response routing. POST dispatch is unchanged; remaining changes are documentation.

   Repro actually exercises both branches: a Content-Length-bearing GET to `/v1/models` and DELETE to a nonexistent stored response, each followed by GET `/v1/models` on the same socket. Candidate follow-up requests return 200; base follow-ups return 501 with the probe bytes embedded in the parsed method. Bodyless reuse also runs successfully.

   Smoke, boundary, cut-in, performance and soak use POST chat requests and provide regression coverage, not verification of this fix. Uncertain framing, chunked bodies, interrupted body reads and successful deletion are untested.

3. **PR claims:**

   - **Supported narrowly by recorded responses:** draining ordinary Content-Length GET/DELETE bodies prevents the observed next-request corruption; bodyless GET reuse remains functional.
   - **Not tested:** bodyless requests perform no reads; uncertain framing closes safely; behavior across other routes, authentication and successful deletion.
   - **Not tested:** nginx pooling, timeout/retry recommendations, handshake diagnosis, streaming through that proxy and key configuration.
   - **Not independently verified:** clean application against the specified engine revision, patch-number availability, upstream equivalence, deployment history and three weeks without recurrence.
   - **Confirmed by the diff:** the described patch and documentation entries exist.
   - The historical **400** symptom is not reproduced literally: this run produces **501** on the base. That supports the desynchronization mechanism without verifying the historical diagnosis.

4. **Evidence limitations:** One candidate-first repetition cannot separate order effects from performance differences. Public model/chunk/environment settings match; boundary and timed-suite prompts match, while duration-limited soak workloads finish different counts. Fault and external benchmark suites did not run. Restoration is recorded successful, without independent restore logs. Image identifiers are recorded consistently, but source-to-image provenance is not independently established.

5. **Oracles:**

CLAIM TEST: UNSOUND

The script targets same-socket corruption and retains a bodyless control, but accepts any nonmissing first response, allowing rejection of body-bearing requests to pass, and never verifies successful deletion.

AUTHOR TESTS: NONE

`hosttests.json` lists no files or executions, and the patch adds no tests.

NO REGRESSION SHOWN, CLAIM NOT TESTED — General suites pass; raw responses support the narrow framing fix; the claim oracle does not enforce preserved first-request behavior or successful deletion.
