1. Recomputed results agree with `report.md`; **no numerical discrepancies found**.

Boundary hashes match **38/38**: 19/19 in each repetition, with identical prompt labels and token counts and no errors.

Cut-in medians in seconds, before report rounding:

| Target / repetition | Short | Long |
|---|---:|---:|
| PR / 0 | 0.447 | 20.390 |
| PR / 1 | 0.414 | 20.370 |
| Base / 0 | 0.370 | 19.928 |
| Base / 1 | 0.336 | 19.925 |

Pooling six rounds per target gives PR **0.4305 / 20.3800**, base **0.3530 / 19.9265**. All 12 short requests arrived before their corresponding long request’s first token, including the three-second launch delay.

| Target / repetition | Completions | Aborts | Errors | Canaries / mismatches |
|---|---:|---:|---:|---:|
| PR / 0 | 163 | 125 | 0 | 57 / 0 |
| PR / 1 | 163 | 126 | 0 | 57 / 0 |
| Base / 0 | 161 | 124 | 0 | 57 / 0 |
| Base / 1 | 164 | 127 | 0 | 58 / 0 |

Totals: PR 326 completions, 251 aborts, 114 canaries; base 325, 251, 115. No errors or mismatches.

Arithmetic, greedy-repeat equality, stream equality and JSON-object checks are true in all four smoke rows; errors are empty. Stream first-token times are PR 0.089/0.092 seconds, base 0.089/0.099. Smoke replies themselves are absent, so these booleans cannot be independently reconstructed from response content.

2. The executable change calls existing `discardBody` before GET routing and DELETE response handling in `dispatch`; POST is unchanged. Other changes are documentation and attribution.

The repro directly exercises Content-Length-bearing GET `/models`, DELETE of an unknown response, and DELETE of a newly stored response, followed by requests on the same socket. Bodyless controls also run. Ordinary inference suites exercise POST and provide regression coverage, not verification of body draining. Chunked, malformed, incomplete and uncertain-framing paths never run; their safety remains unverified.

3. Claim assessment:

- **Supported:** valid Content-Length GET/DELETE bodies no longer contaminate subsequent requests, while route functionality and connection reuse survive. Candidate passes twice; base fails twice with probe bytes incorporated into the next method.
- **Supported behaviorally:** bodyless requests remain usable; zero internal reads are not measured.
- **Not tested:** uncertain framing closes safely; nginx pooling, authentication, streaming/timeouts and handshake retry guidance; clean patch application to the stated engine pin; upstream equivalence; three weeks of deployment reliability.
- The historical **400** is not reproduced literally: this probe produces **501** on base, demonstrating the same desynchronization mechanism.
- The listed documentation additions are visible in the patch.

4. Two counterbalanced repetitions, matching public settings, complete suite pairs and recorded successful restore strengthen the evidence. Limitations include short observation, truncated repro logs, absent build-provenance verification, unequal startup counts, and skipped fault/benchmark suites. Soak workloads are duration-limited rather than identical completed request lists. Cut-in latency is consistently higher on PR; this deserves follow-up, not a causal performance conclusion.

CLAIM TEST: SOUND

It asserts initial response status/content, successful deletion and subsequent same-socket responses, with bodyless capability controls; rejection or connection closure cannot pass.

AUTHOR TESTS: NONE

`hosttests.json` lists no test files or executions.

EVIDENCE SUPPORTS THE CLAIM — The sound repro passes twice on candidate, fails through body contamination twice on base, and preserves route functionality plus connection reuse for the tested framing.
