# Environment Standard

## Purpose

This document defines how development, automation, AI tooling, and future infrastructure components are configured within PADRO-AI-LABS-2026.

The goal is to provide a repeatable, secure, and documented environment that can be rebuilt from scratch if necessary.

---

# Current Environment

Host:

* Windows 11

Primary Development Environment:

* WSL2 Ubuntu

Primary Repository:

* PADRO-AI-LABS-2026

Repository Location:

```text
~/projects/PADRO-AI-LABS-2026
```

---

# Approved Development Tools

## Current

* Git
* GitHub
* OpenAI Codex
* Claude Code
* Bash
* SSH

## Planned

* Hermes
* Tailscale
* Docker
* Qdrant
* OpenRouter
* Telegram Integration
* VPS Relay

---

# Environment Variable Policy

Secrets must be loaded through:

* Environment variables
* Local `.env` files
* Password manager retrieval

Secrets must never be hardcoded.

Example:

```bash
export OPENAI_API_KEY=...
```

Allowed:

```bash
.env
.env.local
.env.example
```

---

# .env Standards

`.env`

Purpose:

Local secrets.

Requirements:

* Git ignored
* Never committed

Example:

```text
OPENAI_API_KEY=
ANTHROPIC_API_KEY=
```

---

`.env.example`

Purpose:

Template only.

Requirements:

* Safe for Git
* No real values

Example:

```text
OPENAI_API_KEY=your-key-here
ANTHROPIC_API_KEY=your-key-here
```

---

# Git Protection

The following must exist in `.gitignore`:

```text
.env
.env.*
*.key
*.secret
```

Before every commit:

```bash
git status
git diff --cached
```

---

# SSH Standards

Approved location:

```text
~/.ssh
```

Private keys:

* Never committed
* Never copied into documentation

Public keys:

* May be documented if useful

---

# Agent Access Model

## ChatGPT

Access:

* Documentation
* Reports
* Architecture

No access:

* Secret values
* Local files

---

## Codex

Access:

* Repository content

No access without approval:

* Secret stores
* Credential files
* SSH keys

---

## Hermes

Access:

* Program Brain
* Documentation
* Reports

No access:

* Raw secrets
* `.env`
* SSH private keys

---

# Logging Standards

Logs may contain:

* Commands
* Outputs
* Errors

Logs must not contain:

* API keys
* Passwords
* Tokens
* Private keys

If a secret appears in a log:

1. Archive the log.
2. Rotate the credential.
3. Document the incident.

---

# Rebuild Standard

A future version of PADRO-AI-LABS should be rebuildable using:

* README.md
* MASTER-ROADMAP.md
* SYSTEM-ARCHITECTURE.md
* AUTHORITY-CONTRACT.md
* Environment Standard

No rebuild should require undocumented knowledge.

---

# Design Principle

A secure environment is one that can be:

* understood
* audited
* rebuilt
* recovered

without relying on memory.
