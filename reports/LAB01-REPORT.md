# Lab 01 - Secure WSL2 AI Engineering Workstation

## Executive Summary

Lab 01 establishes the local foundation for PADRO-AI-LABS-2026: a WSL2-based engineering workstation, a documented repository structure, and repeatable evidence collection for future AI, security, automation, GRC, OSINT, and DFIR labs.

The repository is organized as a portfolio-grade lab system rather than a single application. Its current contents emphasize documentation, operational logging, memory files, reporting folders, and helper scripts. This makes the workstation suitable for reproducible lab work and public-facing proof of progress.

## Technical Objective

Create a secure local workstation baseline that can support:

- WSL2-first Linux engineering workflows
- local-first AI tooling and agent workflows
- documented lab execution
- repeatable command logging
- GitHub-ready reporting
- security-aware workstation inventory

## Business / Career Relevance

This lab demonstrates the ability to turn a personal engineering workstation into a controlled, documented, auditable environment. That maps directly to enterprise work in security engineering, platform operations, automation, GRC evidence collection, and incident response readiness.

## Architecture

Current repository structure:

```text
PADRO-AI-LABS-2026/
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
|-- scripts/
|-- README.md
|-- LAB-INDEX.md
|-- PROGRAM-HASH.md
|-- DAILY-LOG.md
|-- LESSONS-LEARNED.md
`-- templates-LAB.md
```

Key design points:

- `README.md` defines the program purpose and operating principle.
- `PROGRAM-HASH.md` defines the B1 mastery profile and A1 portfolio output layer.
- `memory/PROGRAM-BRAIN.md` acts as the local knowledge anchor for agent workflows.
- `scripts/lab-log.sh` provides repeatable session, command, note, and lesson logging.
- `reports/` stores GitHub-ready lab evidence and workstation baseline output.

## Threat Model

Primary risks for this workstation foundation:

- accidental exposure of home infrastructure
- secrets committed into the repository
- undocumented setup drift
- untracked command history and lab evidence
- unclear system baseline during troubleshooting
- over-reliance on remote services for local engineering workflows

Controls established or supported by this lab:

- local-first repository structure
- explicit operating rule to expose nothing unnecessarily
- repeatable logging through `scripts/lab-log.sh`
- baseline inventory script that prints markdown to stdout
- report files separated from raw logs
- documented lessons learned for Git and SSH authentication

## Tools Used

- WSL2
- Ubuntu
- Bash
- Git
- Markdown
- `script` terminal session logging
- standard Linux inventory commands such as `uname`, `free`, `df`, `ip`, `ss`, and package manager queries when available

## Build Steps

1. Created the PADRO-AI-LABS-2026 repository structure.
2. Added program-level documentation files.
3. Added lab index and lab template files.
4. Added memory anchor for future agent/RAG workflows.
5. Added `scripts/lab-log.sh` for repeatable session and command logging.
6. Added `scripts/system_inventory.sh` to generate markdown workstation baseline output.
7. Added `reports/SYSTEM-BASELINE.md` as the initial baseline report.

## Codex Prompts Used

```text
Analyze this repository.

Create:

1. reports/LAB01-REPORT.md
2. reports/SYSTEM-BASELINE.md
3. scripts/system_inventory.sh

The script should collect workstation baseline information and output markdown suitable for a GitHub report.

Do not modify existing files without asking.
```

## Validation Checklist

- [x] Repository structure reviewed.
- [x] Existing files were not modified.
- [x] Requested report files were created under `reports/`.
- [x] Requested inventory script was created under `scripts/`.
- [x] Inventory script outputs markdown to stdout.
- [x] Inventory script avoids collecting secrets.
- [x] Inventory script can be redirected into a GitHub-ready report.

## Evidence Collected

- Repository root: `/home/dev/projects/PADRO-AI-LABS-2026`
- Active branch: `main`
- Current tracked file count at analysis time: 11
- Existing modified file observed but not touched: `logs/2026-06-03-lab01-session-203943.log`
- Existing script reviewed: `scripts/lab-log.sh`

## Issues Encountered

- The worktree already contained one modified log file unrelated to this report creation.
- The existing repository is primarily documentation-oriented, so the analysis focused on structure, operating model, and evidence workflows rather than application runtime behavior.

## Lessons Learned

- A secure engineering workstation is not only a machine configuration; it is also a documentation and evidence system.
- Local-first AI/security labs need repeatable inventory and logging before more complex agent or cloud relay work begins.
- GitHub-ready reporting should separate raw logs from curated evidence.

## GRC / Security Interpretation

This lab creates baseline evidence for workstation control maturity:

- asset identification through system inventory
- configuration evidence through markdown reporting
- activity evidence through terminal and command logging
- knowledge retention through lessons learned
- reduced exposure through local-first architecture

These artifacts can support future control narratives around secure development environments, change documentation, access hygiene, and operational readiness.

## Resume Bullet

Built a secure WSL2-based AI/security engineering lab with repeatable workstation inventory, terminal logging, GitHub-ready reporting, and local-first documentation workflows for automation, GRC, OSINT, and DFIR practice.

## Interview Talking Points

- Explain why WSL2 is a practical foundation for local-first AI/security engineering.
- Describe how baseline inventory supports troubleshooting and audit evidence.
- Walk through the repository structure as an operating system for labs.
- Discuss why raw logs and curated reports should be separated.
- Explain the security reasoning behind avoiding unnecessary home infrastructure exposure.

## B1 Mastery Expansion

Future expansion areas:

- add package manifest snapshots
- add SSH and Git configuration hygiene checks
- add secret scanning before commits
- add local model/toolchain inventory
- add Docker and container baseline collection
- add signed release or report artifacts

## A1 Portfolio Summary

Lab 01 establishes a secure, documented workstation foundation for PADRO-AI-LABS-2026. It provides the structure, scripts, and reporting patterns needed to turn future AI/security lab work into public GitHub evidence and interview-ready artifacts.
