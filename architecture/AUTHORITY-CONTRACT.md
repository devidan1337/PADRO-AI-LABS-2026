# Authority Contract

## Purpose

This document defines how authority is delegated, limited, approved, logged, and revoked inside PADRO-AI-LABS-2026.

The central principle is:

> Agents may reason over intent, architecture, documentation, and metadata; agents may not silently inherit authority.

## Core Concepts

### Capability

What a component can technically do.

### Authority

What a component is permitted to do.

### Accountability

How the system proves what happened afterward.

### Direct Authority

Access or control a component has directly.

### Indirect Authority

Real-world effects a component can cause by triggering another system that holds authority.

## Authority Contract Matrix

| Component | Mode | Can Read | Can Write | Can Execute | Indirect Authority | Approval Trigger | Log Required | Revocation Method | Blast Radius |
|---|---|---|---|---|---|---|---|---|---|
| Dan | Normal | Repo, docs, reports | Repo docs, notes | Local user commands | High | Admin/security actions | Yes for lab actions | Stop session, revert commits | High |
| Dan | Admin | System configs, secrets by intent | System files, configs | Privileged commands | Very high | Any infrastructure/security change | Yes | Exit admin context, rotate credentials | Critical |
| Dan | Break-glass | Everything required for recovery | Emergency changes | Emergency commands | Total | Emergencies only | Mandatory | Rotate all affected credentials | Total |
| ChatGPT | Advisory | Shared docs, pasted context | Drafts only | None | Persuasive influence through Dan | Any command, security-sensitive design, credential workflow, public exposure | Decision notes recommended | Stop providing sensitive context | Moderate |
| Codex | Implementation | Repo content within scope | Repo files within scope | Local dev commands within scope | Can alter scripts/configs that later execute | Critical scripts, shell profile changes, PATH, SSH, systemd, cron, Docker, firewall, cloud CLI, git push | Yes for generated files/commands | Close session, inspect git diff, revert commits | High |
| Claude Code | Review | Repo content within scope | Recommendations by default | None by policy | Can influence architecture and code review | Any write/execute elevation | Review notes recommended | Close session, deny elevated mode | Low-Moderate |
| Hermes | Retrieval | Docs, reports, Program Brain | Notes, indexes, approved docs | None in read-only mode | Can become operational if tools enabled | Tool use, script execution, API calls, Telegram workflows | Required for Tier 3+ | Disable tools, pause jobs, revoke API keys | High |
| Program Brain / RAG | Knowledge | Curated docs and safe metadata | Indexes, embeddings | None | Can retrieve sensitive context if ingested improperly | New ingestion sources, sensitive datasets | Ingestion log required | Delete/redact docs, rebuild index | Moderate |
| Telegram Interface | Remote command surface | Status summaries, approved outputs | Responses only | Trigger approved workflows | Remote path into local operations | Any system-changing action | Mandatory | Revoke bot token, disable webhook, restrict allowlist | Very High |
| VPS Relay | Relay boundary | Relay configs, limited logs | Relay service configs | Approved relay services | Bridge between internet and private lab | Infra changes, tunnel changes, auth changes | Mandatory | Revoke SSH keys, destroy instance, rotate relay secrets | Critical |
| GitHub Actions | CI/CD | Repo content, workflow secrets at runtime | CI artifacts | Workflow commands | Can leak secrets or deploy code | Secrets, deploys, protected branches | Mandatory | Disable workflow, revoke secrets, restrict token permissions | Critical |

## Hermes Execution Tiers

| Tier | Mode | Description | Approval |
|---|---|---|---|
| Tier 0 | Read-only retrieval | Read curated documentation and summarize | No approval needed |
| Tier 1 | Documentation drafting | Draft local markdown changes | Review before commit |
| Tier 2 | Local non-destructive automation | Run safe local checks and reports | Approval recommended |
| Tier 3 | Repo modification / script execution | Modify repo files or run scripts | Human approval required |
| Tier 4 | External API calls | Use provider APIs, Telegram, GitHub, or cloud APIs | Human approval required |
| Tier 5 | Infrastructure mutation | Change VPS, tunnels, firewall, DNS, deployments | Break-glass approval required |

## Program Brain Ingestion Rule

Nothing enters Program Brain unless it is safe to retrieve later out of context.

Program Brain must never ingest:

- raw secrets
- private keys
- tokens
- unredacted `.env` files
- credential rotation logs
- private client/customer data
- live incident evidence unless explicitly approved
- anything whose retrieval would create legal, compliance, or operational risk

## Codex Approved Scope

Codex may execute:

- tests
- linters
- repo inspection
- local scripts
- package installs
- non-destructive file generation

Codex may not execute without approval:

- `rm -rf`
- `chmod` or `chown` outside the project
- network listeners
- credential commands
- cloud CLIs
- `git push`
- deployment commands
- commands under `/mnt/c/Users` unless explicitly scoped
- edits to shell profiles, SSH config, cron, systemd, Docker daemon, firewall, or PATH

Codex must never access:

- `~/.ssh`
- `~/.config/gh`
- `~/.aws`
- `~/.docker/config.json`
- `~/.hermes/.env`
- browser cookies
- Windows credential stores
- clipboard contents

## Telegram Approval Pattern

For system-changing actions:

1. Telegram requests action.
2. Hermes returns planned action and risk class.
3. Dan confirms with a unique nonce or approval phrase.
4. Hermes executes.
5. Hermes logs the result.

## Design Principle

No component should possess more authority than its role requires, and no authority should exist without an approval path, audit trail, and revocation path.
