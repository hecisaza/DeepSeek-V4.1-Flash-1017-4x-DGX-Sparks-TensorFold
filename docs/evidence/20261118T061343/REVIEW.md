1. **Recomputed results**

| Measurement | Candidate | Base |
|---|---:|---:|
| Boundary hashes identical | **19/19**, matching labels and token counts | |
| Cut-in median, short request | 41.444 s | 41.638 s |
| Cut-in median, long request | 44.135 s | 44.322 s |
| Soak completions / aborts | 148 / 111 | 143 / 108 |
| Soak errors / canary mismatches | 0 / 0 | 0 / 0 |
| Canary checks | 49 | 48 |
| Smoke arithmetic / greedy repeat / stream match / JSON object | All true | All true |
| Smoke streaming first token | 0.099 s | 0.102 s |

These match `report.md`, including its rounded medians. Smoke replies themselves are absent, so their recorded check results cannot be independently re-evaluated.

**One discrepancy in interpretation:** “admitted during the long prefill in 3 of 3 rounds” is unsupported for both targets. `cutin` delays the short request three seconds but compares request-relative durations using only a one-second adjustment. Adding the intended delay places the short first token **0.281–0.316 seconds after** the long first token in every round. Exact arrival ordering would require shared-clock timestamps.

2. **Changed paths and coverage**

`config.sh` adds `checks=2` to prepared-state identity. `prepare.sh` changes step 7: packed preparation builds relative links to indexed Engram files and passes that directory to the packer; unpacked preparation checks unexpected filenames and directory accessibility before copying. Tests and changelog also change.

No inference request triggers these preparation branches. The hardware suites demonstrate runtime regression coverage, not successful rejection of stray files or marker migration.

The author tests execute the actual extracted step 7 with simulated workers and packer, plus marker/start tests. They trigger visible/hidden stray files, joined filenames, missing tables/directories, a non-directory path, packed input selection, and old markers. The inaccessible-directory case was skipped.

3. **Claims**

- **Supported by author tests:** reject and name unexpected files without deleting them; reject before copying into the affected directory; compare whole filenames; preserve clean-copy capability and ignore unrelated extensions.
- **Supported:** indexed-only packer input, relative links, stock-table selection with `ABLIT=1`, and retaining existing packed shards/copies.
- **Supported in simulation:** versioned markers trigger preparation; current markers, `PREPARE=0`, dry runs and running services preserve their expected behavior. A complete real migration followed by a second start was not demonstrated.
- **Supported by inspection, only weakly tested:** the added check reads filenames rather than table contents. Its test merely excludes several hashing/comparison commands.
- **Not independently tested here:** historical platform totals, real-packer byte-identical output, real mount resolution, inaccessible-directory rejection, and the acknowledged snapshot-folder limitation.

No core implementation claim is contradicted.

4. **Limitations**

One candidate-first repetition leaves timing susceptible to order effects. Public settings and performance prompt keys match; boundary cases match. The control identifier agrees with the stated base. Restore succeeded, and recorded runtime errors are zero. Soak uses the same seeded workload generator but completes different amounts of work. Fault, endurance, benchmark and repro suites did not run. Author output contains only tails; the simulated reader does not validate actual safetensors headers.

5. **Oracles**

CLAIM TEST: NONE  
No `executed-script.sh` is present.

AUTHOR TESTS: SOUND  
The inspected assertions require both intended rejection and successful clean preparation/packing; visible base failures concern those behaviors rather than setup, while the candidate passes.

6. **EVIDENCE SUPPORTS THE CLAIM** — sound author tests verify the core preparation changes; recorded inference checks show no regression; real deployment and inaccessible-directory coverage remain incomplete.
