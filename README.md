# FastNetScan
FastNetScan is a Bash-based network scanning utility designed to quickly identify active hosts within an IP range. It uses fping for efficient reachability checks and leverages parallel execution through xargs to dramatically speed up scans over large address spaces.

Key Features:

Supports wildcard-based IP ranges (e.g., 10.0.0.*, 192.168.*.*, 10.0.*.1).

Parallel scanning controlled via the PARALLEL_JOBS variable to optimize CPU usage.

Real‑time progress indicator showing scanned hosts and the number of active hosts found.

Outputs all responsive hosts to online_hosts.txt.

Graceful interruption handling (Ctrl+C) with cleanup of temporary files.

Works on any system with bash and fping installed.

Typical Usage:
./fastnetscan.sh 192.168.1.*

Remember to use this script/software in a controlled environment. We are not responsible for any incidents. You are solely responsible.
