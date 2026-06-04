# LAB-01 Evidence — WSL Baseline

## Evidence Item 001 — WSL Health Check

Date: 2026-06-02  
Host: PADRO-CORE  
Environment: Ubuntu on WSL2  
Kernel: 6.6.114.1-microsoft-standard-WSL2  

## Key Findings

- CPU threads visible to Ubuntu: 24
- Memory visible to Ubuntu: 15 GiB
- Memory used at baseline: 1.4 GiB
- Memory available: 14 GiB
- Swap configured: 4.0 GiB
- Swap used: 0 B
- Root filesystem size: 1007 GiB
- Root filesystem used: 7.5 GiB
- System load average: 0.00, 0.00, 0.00

## Observations

The WSL2 environment is healthy and lightly loaded. The largest memory consumer is the VS Code Server extension host. Hermes is running with a modest memory footprint. No swap pressure is present.

## Decision

No `.wslconfig` tuning is required at this stage. The system should remain on default dynamic WSL2 resource allocation until heavier workloads such as Docker, vector databases, local LLM inference, or multi-container lab environments are introduced.

## Evidence File

`evidence/wsl-health-check-2026-06-02.txt`
