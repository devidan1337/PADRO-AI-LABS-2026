# Secrets Standard

## Purpose

This document defines how secrets are classified, stored, accessed, rotated, and revoked within PADRO-AI-LABS-2026.

A secret is not merely a sensitive string.

A secret is a delegated authority token.

Examples:

* API keys
* SSH private keys
* GitHub tokens
* Telegram bot tokens
* Cloud credentials
* Database passwords
* Service account credentials

---

## Core Principle

Secrets represent authority.

Authority must be intentionally granted, reviewable, logged when used, and revocable when no longer trusted.

---

## Secret Classification

| Tier   | Classification | Examples                                               | Repository Allowed  | Program Brain Allowed |
| ------ | -------------- | ------------------------------------------------------ | ------------------- | --------------------- |
| Tier 0 | Public         | Public URLs, public docs, generic architecture         | Yes                 | Yes                   |
| Tier 1 | Internal       | Non-sensitive hostnames, service names, repo structure | Yes, with care      | Yes                   |
| Tier 2 | Sensitive      | Internal IPs, topology, operational procedures         | Only when justified | Review required       |
| Tier 3 | Secret         | API keys, SSH private keys, passwords, tokens          | Never               | Never                 |

---

## Approved Storage Locations

### Password Manager

Preferred storage for long-lived secrets.

Examples:

* Bitwarden
* 1Password
* KeePassXC

### Local `.env` Files

Allowed only when:

* The file is local-only.
* The file is included in `.gitignore`.
* The file contains no unnecessary credentials.
* A matching `.env.example` exists without real values.

### Environment Variables

Allowed for active shell sessions and tool configuration.

Examples:

```bash
OPENAI_API_KEY
ANTHROPIC_API_KEY
```

### SSH Key Directory

Allowed for SSH keys.

Location:

```bash
~/.ssh/
```

Requirements:

* Private keys must never be committed.
* Private keys must never be copied into documentation.
* Public keys may be documented when useful.

---

## Prohibited Storage Locations

Secrets must never be stored in:

* Git commits
* GitHub issues
* GitHub Actions logs
* Program Brain
* Obsidian notes
* Markdown reports
* Screenshots
* Blog drafts
* Chat transcripts intended for publication
* Terminal logs intended for publication
* Source code files

---

## Program Brain Rules

Program Brain may store:

* That a secret exists
* What system it supports
* Where the secret is stored generally
* How to rotate it
* How to revoke it

Program Brain must never store:

* Secret values
* Passwords
* Private keys
* Tokens
* Unredacted `.env` files
* Credential rotation logs

---

## Git Rules

Before committing, verify:

```bash
git status
git diff --cached
```

Never commit files matching:

```text
.env
.env.*
*.key
*.secret
id_ed25519
id_rsa
```

If a secret is committed:

1. Stop work.
2. Rotate the secret.
3. Revoke the exposed credential.
4. Remove it from Git history if necessary.
5. Document the incident in lessons learned.

---

## Rotation Policy

Rotate immediately when:

* A secret is exposed.
* A secret is accidentally committed.
* A secret is pasted into a public or semi-public system.
* A device is compromised.
* Access is no longer needed.

Suggested rotation cadence:

| Secret Type                    | Suggested Rotation                       |
| ------------------------------ | ---------------------------------------- |
| High-value API keys            | 90 days                                  |
| SSH keys                       | 6-12 months or after device change       |
| Telegram bot tokens            | After any exposure or bot redesign       |
| VPS credentials                | After admin change or suspected exposure |
| Low-risk local dev credentials | Annually or as needed                    |

---

## Revocation Requirement

Every secret must have a known revocation path.

If the revocation method is unknown, the secret is not approved for use in PADRO-AI-LABS.

---

## Agent Access Rules

Agents may reason about:

* Secret purpose
* Secret location category
* Rotation procedure
* Revocation procedure
* Authority granted by the secret

Agents may not access:

* Secret values
* Private keys
* Tokens
* `.env` files
* Credential stores
* Browser sessions
* Clipboard contents

---

## Design Principle

No secret should exist without:

* Owner
* Purpose
* Storage location
* Authority description
* Rotation method
* Revocation method
