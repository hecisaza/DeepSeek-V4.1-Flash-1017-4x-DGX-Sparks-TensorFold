1. **Recomputed results:** No numerical discrepancies with `report.md`.

   - **Boundary:** 19/19 valid reply hashes match; prompt labels and token counts also match, with no errors.
   - **Cut-in medians, short/long:** candidate **17.022/19.716 s**; control **17.004/19.761 s**. The report correctly rounds these to 17.02/19.72 and 17.00/19.76 seconds.
   - **Soak:** candidate: **178 completions, 132 aborts, 63 canaries**; control: **174 completions, 130 aborts, 58 canaries**. Both record **zero errors and zero canary mismatches**.
   - **Smoke:** arithmetic, greedy repeat equality, streaming equality, and JSON-object mode all record `true` on both targets; error lists are empty. Streaming first-token times are **0.089/0.091 s**. Individual replies are absent, so these check outcomes cannot independently be revalidated.
   - Performance medians and reported percentage differences also agree with the data. Reproduction exits are correctly classified: candidate **0/pass**, control **1/fail**.

2. **Changed paths and coverage:** The engine patch inserts `discardBody(conn, a)` before GET routing and before DELETE response routing. POST dispatch is unchanged; other changes are documentation and credits.

   The ordinary inference suites issue POST requests and provide regression coverage, not direct coverage of this fix. However, **the reproduction did exercise both changed branches**, according to its recorded output:

   - Bodyless GET → GET: both targets return 200 twice.
   - GET with body → GET: candidate returns 200 twice; control’s second response is 501 with leftover probe bytes embedded in the parsed method.
   - DELETE with body → GET: both initially return the expected missing-response 404; candidate then returns 200, while control returns the same contaminated-method 501.

   Thus the central failure condition was triggered. Uncertain framing and body-read failure handling were not demonstrated.

3. **PR claims:**

   - **Supported:** draining GET/DELETE bodies prevents the demonstrated next-request contamination on a retained connection. Ordinary bodyless GET behavior remains functional.
   - **Not fully tested:** bodyless requests perform no reads internally; malformed or uncertain framing closes the connection safely. Successful bodyless responses do not establish those implementation details.
   - **Not tested:** nginx pooling configuration, idle timeout behavior, dropped-SYN recovery, streaming through the proxy, authentication setup, and three weeks without cross-session failures.
   - **Not tested:** clean application against the specified engine revision and patch series, upstream’s existing fix, patch-number availability, and the anticipated merge conflict. The listed documentation additions are visible in the diff.
   - **Exact symptom differs:** this reproduction produces **501 Unsupported method**, not the described historical **400 bad request syntax**. It supports the contamination mechanism without verifying that historical status code.

4. **Evidence limitations:** One candidate-first repetition leaves timing vulnerable to order, temperature, and cache effects. Fixed boundary, cut-in, and performance prompts are comparable; the time-limited soak completes different amounts of work. Its roughly ten-minute duration cannot establish long-term stability. Available memory falls by **1,277/1,211 MB**, without evidence distinguishing caching from leakage.

   Crucially, **`claim.sh` is missing**: request framing, socket reuse, and assertions cannot be audited beyond the captured output. Fault and external benchmark suites did not run. No unexpected errors or restore problem are recorded. Image identifiers agree across the bundle, but independent build provenance tying the control to the stated base is absent.

5. **EVIDENCE SUPPORTS THE CLAIM** — both body-carrying methods contaminate the control’s next request but pass on the candidate; bodyless controls pass; regression checks agree, subject to the missing reproduction source.
