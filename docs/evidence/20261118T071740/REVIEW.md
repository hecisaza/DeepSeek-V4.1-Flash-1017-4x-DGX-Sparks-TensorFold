1. **Recomputed results:** No discrepancies in the requested report figures.

   | Measurement | PR | Base |
   |---|---:|---:|
   | Boundary hashes identical | 19/19 paired comparisons | |
   | Cut-in median, short | 0.711 s | 1.734 s |
   | Cut-in median, long | 45.853 s | 45.271 s |
   | Soak completions | 113 | 119 |
   | Client aborts | 81 | 88 |
   | Canary checks / mismatches | 37 / 0 | 39 / 0 |
   | Soak errors | 0 | 0 |

   Boundary labels and token counts match. Both targets admit the short request in all three rounds, including the three-second launch delay. Reported medians are correctly rounded. Arithmetic, greedy-repeat equality, stream equality and JSON-mode checks are all recorded as true on both targets, with no errors; streaming first-token times are 0.097/0.100 s. Smoke responses and individual soak transactions are absent, so their recorded checks/counters cannot be independently reconstructed.

2. **Changed paths:** The patch changes three claim scripts, adds `tests/test_claims.py`, and updates documentation. It changes no inference-engine code.

   `0042` rejects error-bearing whole replies and stream events. `0043` validates comparison statistics, rejects errors, and takes diagnostics from the finish-reason event. `0044` rejects error-bearing successful model-list, deletion and creation replies.

   The hardware suites never invoke these scripts or inject those malformed replies; they show no regression only. The author tests do invoke them with missing statistics, misplaced diagnostics, error-bearing chat replies, and error-bearing GET/DELETE/create responses.

3. **Claims assessed:**

   - **Supported:** `0042` rejects HTTP-200 error envelopes, including stream-only errors, while preserving valid replies and `error: null`.
   - **Supported:** `0043` exits 2 for absent statistics and error envelopes; rejects diagnostics taken from the wrong event; still exits 1 for differing statistics or missing warnings.
   - **Supported:** `0044` distinguishes body-case failures (exit 1) from control/create failures (exit 2), preserves expected 404s and `error: null`, and still detects undrained bodies.
   - **Not tested:** `0043`’s missing-finish-event branch, empty/wrong-type statistics, and independently missing fields on each side; `0044`’s new non-200 creation diagnostic; universal preservation of other output/exit behavior.
   - **Supported:** 22 candidate tests pass; base reports 11 failures and 11 passes. **Not tested here:** the historical full-suite/macOS results and earlier live-script execution. No demonstrated contradiction.

4. **Limits:** One repetition, always candidate first, prevents attributing timing differences to the patch. The six-suite matrix is complete, recorded errors are empty, settings match, performance prompt identities match, and restoration is recorded as verified. The control identifies the stated base `8ffa67d5`, although source-to-image provenance cannot be independently established here. Soak uses matching seeded generators but duration-limited workloads complete different request counts. Repro, fault, endurance and benchmark suites did not run.

   The shared hardware client itself ignores error envelopes beside valid choices. Boundary hashes cover reply text, not token IDs. Author-test output is truncated; the visible base failure is a behavioral assertion (`0 != 2`), not setup failure.

CLAIM TEST: NONE  
No `executed-script.sh` is present.

AUTHOR TESTS: SOUND  
The inspected tests assert specific exit codes and diagnostics, retain successful capability controls, and expose a behavioral false positive on the base.

EVIDENCE SUPPORTS THE CLAIM — sound author tests verify the central script fixes; all 22 pass on the candidate versus 11 failures on the base; hardware results provide additional regression coverage.
