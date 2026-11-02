**Issue outcome: NEEDS THE LAB** (label `issue:needs-lab`)

- triage: Run a cold full restart of all four nodes with a plain ./start-switchless.sh on current main (it includes 0035, which opens rank 0's follower ports before its weights load). Do not docker start any rank by hand. Do it once with RANK_LOCAL=0, so rank 2 (the worker across the ring) loads over NFS through the neighbour hop, and once with RANK_LOCAL=1, which takes NFS out of the load. Keep send_redirects=0 on the head. Watch whether rank 2's engine goes past the PyTorch banner or sits in D-state with NFS rx at 0, whether any follower exits with ConnectFailed (keep TF_DS_CONNECT_S at its default of 300 s), whether port_xmit_data moves on each HCA once the TCP rendezvous is ESTABLISHED, and whether rank 0 binds the API port. Collect every rank's log. The issue was reported at 220547b, before 0035 and the MASTER_ADDR Tailscale guard in scripts/config.sh.

Facts:

- triage: lab (high confidence)
- triage, what shows it: Run a cold full restart of all four nodes with a plain ./start-switchless.sh on current main (it includes 0035, which opens rank 0's follower ports before its weights load). Do not docker start any rank by hand. Do it once with RANK_LOCAL=0, so rank 2 (the worker across the ring) loads over NFS through the neighbour hop, and once with RANK_LOCAL=1, which takes NFS out of the load. Keep send_redirects=0 on the head. Watch whether rank 2's engine goes past the PyTorch banner or sits in D-state with NFS rx at 0, whether any follower exits with ConnectFailed (keep TF_DS_CONNECT_S at its default of 300 s), whether port_xmit_data moves on each HCA once the TCP rendezvous is ESTABLISHED, and whether rank 0 binds the API port. Collect every rank's log. The issue was reported at 220547b, before 0035 and the MASTER_ADDR Tailscale guard in scripts/config.sh.
- patches named: 0035, scripts/config.sh, start-switchless.sh

_FIXED means the fix is verified on hardware, not merged. NEEDS THE LAB and REPRODUCED are for a person to pick up._
