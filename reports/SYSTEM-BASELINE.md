# System Baseline

Generated for: PADRO-AI-LABS-2026  
Snapshot time: 2026-06-04T01:30:33Z  
Repository: `/home/dev/projects/PADRO-AI-LABS-2026`

## Summary

This report captures the initial workstation baseline for Lab 01. It is intended to be safe for GitHub reporting and should avoid secrets, tokens, private keys, and detailed credential material.

To refresh this report:

```bash
./scripts/system_inventory.sh > reports/SYSTEM-BASELINE.md
```

## Host

| Item | Value |
| --- | --- |
| Hostname | PADRO-AI-CORE |
| Kernel | Linux 6.6.114.1-microsoft-standard-WSL2 |
| Architecture | x86_64 |
| Platform | WSL2 |
| Distribution | Ubuntu 26.04 LTS |

## Compute

| Item | Value |
| --- | --- |
| CPU cores available | 24 |
| Memory total | 15Gi |
| Swap total | 4.0Gi |

## Storage

| Mount | Size | Used | Available | Use |
| --- | ---: | ---: | ---: | ---: |
| `/home/dev/projects/PADRO-AI-LABS-2026` | 1007G | 7.7G | 949G | 1% |

## Toolchain

| Tool | Version |
| --- | --- |
| Bash | GNU bash 5.3.9 |
| Git | git version 2.53.0 |

## Repository Baseline

| Item | Value |
| --- | --- |
| Git branch | main |
| Git commit | 624a633 |
| Tracked files | 11 |
| Primary documentation | `README.md`, `LAB-INDEX.md`, `PROGRAM-HASH.md`, `memory/PROGRAM-BRAIN.md` |
| Logging script | `scripts/lab-log.sh` |

## Directory Baseline

```text
.
|-- architecture/
|-- blog-drafts/
|-- diagrams/
|-- labs/
|-- lessons-learned/
|-- logs/
|-- memory/
|-- prompts/
|-- reports/
|-- roadmap/
|-- screenshots/
`-- scripts/
```

## Security Notes

- Baseline reports should not include API keys, tokens, private keys, credential files, or full environment dumps.
- Network sections in generated reports should prefer interface state and listener summaries over public exposure claims.
- Raw session logs should remain separate from curated GitHub reports.
- Any future cloud relay or remote access work should be documented in a separate lab with explicit threat modeling.

## Refresh Command

Run this command from the repository root:

```bash
./scripts/system_inventory.sh > reports/SYSTEM-BASELINE.md
```
