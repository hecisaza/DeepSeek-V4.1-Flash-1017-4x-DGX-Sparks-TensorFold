### Evidence: pr vs base

| target | role | image / artifact | model | settings that differ from the control |
|---|---|---|---|---|
| `pr` | candidate | `tensorfold-dsv41:pr-bea850f4` (17f50370b8ea) | `DeepSeek-V4.1-Flash-1017` | - |
| `base` | control | `tensorfold-dsv41:base-476bbc77` (3014a9d4e74f) | `DeepSeek-V4.1-Flash-1017` | baseline |

Conditions: fabric ring; order: A then B, one repetition (no reverse order: pass --opt reps=2 for a counterbalanced run); repetitions: 1; kit 38339fb.
Restore: live restored (verified: API answers, running artifact is live's).

#### smoke

| target | rep | arithmetic | greedy repeat equal | stream matches | JSON mode | first token (stream) | errors |
|---|---|---|---|---|---|---|---|
| `pr` | 0 | ✓ | ✓ | ✓ | ✓ | 0.089 s | - |
| `base` | 0 | ✓ | ✓ | ✓ | ✓ | 0.091 s | - |

<details><summary>machine state after the suite</summary>

- `pr` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2184 MHz, 51, [N/A], [N/A], 30 %"], "load": "load average: 4.60, 2.84, 1.34", "mem_available_mb": "27678"}}`
- `base` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2177 MHz, 56, [N/A], [N/A], 85 %"], "load": "load average: 4.15, 5.28, 4.23", "mem_available_mb": "26780"}}`

</details>

#### boundary

**19 of 19** greedy reply hashes identical, `pr` against `base`, over 1 repetition(s).

| rep | prompt | tokens (pr / base) | `pr` | `base` | same |
|---|---|---|---|---|---|
| 0 | len5 | 5 / 5 | `38127fef0fbb` | `38127fef0fbb` | ✓ |
| 0 | len2047 | 2047 / 2047 | `8488ccfbcf35` | `8488ccfbcf35` | ✓ |
| 0 | len2048 | 2048 / 2048 | `c5ac2fb76516` | `c5ac2fb76516` | ✓ |
| 0 | len2049 | 2049 / 2049 | `6766401c9caa` | `6766401c9caa` | ✓ |
| 0 | len4095 | 4095 / 4095 | `ed9e5086f520` | `ed9e5086f520` | ✓ |
| 0 | len4096 | 4096 / 4096 | `52584e31f990` | `52584e31f990` | ✓ |
| 0 | len4097 | 4097 / 4097 | `1a71db317ee7` | `1a71db317ee7` | ✓ |
| 0 | len6143 | 6143 / 6143 | `2f9626e9baf5` | `2f9626e9baf5` | ✓ |
| 0 | len6144 | 6144 / 6144 | `11933f2d4bd7` | `11933f2d4bd7` | ✓ |
| 0 | len6145 | 6145 / 6145 | `7aa2f63b2547` | `7aa2f63b2547` | ✓ |
| 0 | len8193 | 8193 / 8193 | `2ef3dc011922` | `2ef3dc011922` | ✓ |
| 0 | len12289 | 12289 / 12289 | `4fcfbd64881f` | `4fcfbd64881f` | ✓ |
| 0 | pfx_base | 5124 / 5124 | `52afe4842e5d` | `52afe4842e5d` | ✓ |
| 0 | pfx_div3072 | 3376 / 3376 | `64d23fe171dc` | `64d23fe171dc` | ✓ |
| 0 | pfx_div2044 | 2348 / 2348 | `16db99ba02f2` | `16db99ba02f2` | ✓ |
| 0 | pfx_div4092 | 4396 / 4396 | `63798c5ba36c` | `63798c5ba36c` | ✓ |
| 0 | pfx_div4093 | 4397 / 4397 | `6b1cfc31884d` | `6b1cfc31884d` | ✓ |
| 0 | pfx_base_again | 5124 / 5124 | `52afe4842e5d` | `52afe4842e5d` | ✓ |
| 0 | pfx_extend | 6660 / 6660 | `357a869fef18` | `357a869fef18` | ✓ |

<details><summary>machine state after the suite</summary>

- `pr` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2177 MHz, 59, [N/A], [N/A], 14 %"], "load": "load average: 5.46, 3.27, 1.54", "mem_available_mb": "27394"}}`
- `base` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2171 MHz, 61, [N/A], [N/A], 0 %"], "load": "load average: 4.86, 5.34, 4.30", "mem_available_mb": "27421"}}`

</details>

#### cutin

`pr` rep 0: short question first token **17.02 s** (rounds 16.953–17.057), long prompt first token 19.72 s (rounds 19.709–19.771); 3 rounds
`base` rep 0: short question first token **17.0 s** (rounds 16.927–17.092), long prompt first token 19.76 s (rounds 19.662–19.801); 3 rounds

![cut-in](cutin.svg)

<details><summary>machine state after the suite</summary>

- `pr` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2171 MHz, 66, [N/A], [N/A], 85 %"], "load": "load average: 6.79, 4.07, 1.92", "mem_available_mb": "27312"}}`
- `base` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2177 MHz, 66, [N/A], [N/A], 0 %"], "load": "load average: 6.70, 5.77, 4.51", "mem_available_mb": "27341"}}`

</details>

#### perf

| target | rep | decode tok/s, one stream | prefill tok/s, cold long prompt | aggregate tok/s, concurrent streams | errors |
|---|---|---|---|---|---|
| `pr` | 0 | **56.9** (54.8–60.7) | **3201.1** (3197.7–3201.9; 12004 tokens) | **149.1** (140.9–157.3; 4 streams) | - |
| `base` | 0 | **56.7** (55.3–59.9) | **3186.6** (3186.6–3215.6; 12004 tokens) | **154.2** (140.0–157.9; 4 streams) | - |

`pr` against `base`: decode +0.4%, prefill +0.5%, aggregate -3.3% (medians over repetitions; the verdict counts a difference only beyond the rounds' spread, at least ±3 %).

![decode](perf-decode.svg)

![prefill](perf-prefill.svg)

![aggregate](perf-aggregate.svg)

<details><summary>machine state after the suite</summary>

- `pr` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2171 MHz, 62, [N/A], [N/A], 96 %"], "load": "load average: 6.25, 4.23, 2.06", "mem_available_mb": "27021"}}`
- `base` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2171 MHz, 66, [N/A], [N/A], 96 %"], "load": "load average: 5.93, 5.68, 4.53", "mem_available_mb": "27010"}}`

</details>

#### soak

`pr` rep 0: 178 completions, 132 client aborts, **0 errors**, 63 canary checks with **0 mismatches**
  machine samples, first and last: `{"head": {"gpus": ["0, NVIDIA GB10, 2184 MHz, 63, [N/A], [N/A], 0 %"], "load": "load average: 6.23, 4.26, 2.08", "mem_available_mb": "26989"}}` → `{"head": {"gpus": ["0, NVIDIA GB10, 2171 MHz, 64, [N/A], [N/A], 94 %"], "load": "load average: 6.56, 6.28, 4.15", "mem_available_mb": "25712"}}`
`base` rep 0: 174 completions, 130 client aborts, **0 errors**, 58 canary checks with **0 mismatches**
  machine samples, first and last: `{"head": {"gpus": ["0, NVIDIA GB10, 2177 MHz, 64, [N/A], [N/A], 7 %"], "load": "load average: 5.93, 5.68, 4.53", "mem_available_mb": "27022"}}` → `{"head": {"gpus": ["0, NVIDIA GB10, 2177 MHz, 72, [N/A], [N/A], 96 %"], "load": "load average: 7.05, 6.80, 5.64", "mem_available_mb": "25811"}}`

![soak](soak.svg)

<details><summary>machine state after the suite</summary>

- `pr` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2184 MHz, 59, [N/A], [N/A], 0 %"], "load": "load average: 6.24, 6.32, 4.30", "mem_available_mb": "25734"}}`
- `base` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2184 MHz, 62, [N/A], [N/A], 0 %"], "load": "load average: 5.83, 6.56, 5.64", "mem_available_mb": "25795"}}`

</details>

#### repro

| target | role | rep | exit | outcome | expected | as expected |
|---|---|---|---|---|---|---|
| `pr` | candidate | 0 | 0 | passes | passes | ✓ |
| `base` | control | 0 | 1 | fails | fails | ✓ |

**Reproduced on the control and gone on the candidate** (every repetition).

Command: `bash claim.sh {api} {model}`

<details><summary>output of the script (tail)</summary>

- `pr` rep 0: `fold"}]}' GET with body, then GET: the next request on the kept connection parsed from its own request line DELETE with body, then GET: first  -> 404 '{"error": {"message": "no stored response has id \'resp_claim0044_does_not_exist\'", "type": "invalid_request_error", "param": "response_id", "code": null}}' DELETE with body, then GET: second -> 200 '{"object": "list", "data": [{"id": "DeepSeek-V4.1-Flash-1017", "object": "model", "created": 1793479210, "owned_by": "tensorfold"}]}' DELETE with body, then GET: the next request on the kept connection parsed from its own request line CLAIM: holds `
- `base` rep 0: `ssage": "no stored response has id \'resp_claim0044_does_not_exist\'", "type": "invalid_request_error", "param": "response_id", "code": null}}' DELETE with body, then GET: second -> 501 '<!DOCTYPE HTML>\n<html lang="en">\n    <head>\n        <meta charset="utf-8">\n        <style type="text/css">\n            :root {\n                color-scheme: lig' DELETE with body, then GET: error page says: <p>Message: Unsupported method ('probe=0044&amp;scanner=1GET').</p> DELETE with body, then GET: the next request on the kept connection failed with the probe's bytes in the reply CLAIM: does not hold `

</details>

<details><summary>machine state after the suite</summary>

- `pr` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2184 MHz, 58, [N/A], [N/A], 0 %"], "load": "load average: 5.82, 6.23, 4.29", "mem_available_mb": "25733"}}`
- `base` rep 0: `{"head": {"gpus": ["0, NVIDIA GB10, 2184 MHz, 61, [N/A], [N/A], 0 %"], "load": "load average: 5.83, 6.56, 5.64", "mem_available_mb": "25792"}}`

</details>

#### What this run does not show

- a clean pair exit and recovery after an injected read fault (`fault` did not run)
- an external benchmark against a control (The Grill or similar) (`bench` did not run)
- <!-- add: paths only checked by reading, faults not injected, configurations not run -->

_Generated by inference-agent-kit `report.py` from `20261031T202447/results.json`._
