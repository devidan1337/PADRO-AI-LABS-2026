# Obsidian Integration

## Purpose

This document defines the role of Obsidian within PADRO-AI-LABS-2026.

Obsidian serves as the primary knowledge authoring and exploration environment.

Git remains the authoritative storage and version control system.

Program Brain remains the architectural knowledge model.

---

# Design Principle

Obsidian is a workspace.

Git is the source of truth.

Program Brain is the knowledge architecture.

These are separate responsibilities.

---

# System Roles

## Obsidian

Purpose:

* Capture ideas
* Link concepts
* Explore knowledge
* Create notes
* Build relationships between topics

Strengths:

* Backlinks
* Graph view
* Rapid note creation
* Knowledge discovery

---

## Git Repository

Purpose:

* Version control
* Audit trail
* Backup
* Historical record

Strengths:

* Change tracking
* Recovery
* Branching
* Evidence preservation

---

## Program Brain

Purpose:

* Knowledge governance
* Retrieval architecture
* Knowledge classification
* Long-term continuity

Strengths:

* Structure
* Context
* Retrieval quality

---

# Vault Structure

Recommended structure:

```text
Program-Brain/

├── Governance
├── Architecture
├── Operations
├── Projects
├── Research
├── Lessons-Learned
├── Career
└── Reference
```

These domains should align with Program Brain architecture.

---

# Note Types

## Permanent Notes

Examples:

* Architecture concepts
* Standards
* Frameworks

Purpose:

Long-term knowledge.

---

## Project Notes

Examples:

* Lab work
* Active projects
* Future plans

Purpose:

Project execution.

---

## Research Notes

Examples:

* DFIR
* OSINT
* AI Engineering

Purpose:

Learning and synthesis.

---

## Daily Notes

Examples:

* Progress tracking
* Ideas
* Discoveries

Purpose:

Capture before classification.

---

# Linking Standards

Notes should link:

* Projects to research
* Research to standards
* Standards to architecture
* Lessons learned to projects

The goal is context preservation.

---

# Security Rules

Obsidian must never contain:

* Passwords
* API keys
* Tokens
* SSH private keys
* Secret values

Lab 03 security standards apply.

---

# Git Integration

Vault content should be capable of synchronization with Git.

Benefits:

* Backup
* Audit trail
* Version history
* Recovery

---

# Future Hermes Integration

Hermes should eventually retrieve:

* Approved Program Brain content
* Architecture documents
* Standards
* Research summaries

Hermes should not retrieve:

* Secrets
* Credentials
* Excluded information

---

# Success Criteria

A future version of Dan should be able to:

* Open Obsidian
* Navigate linked knowledge
* Recover project context
* Continue work quickly

without relying solely on memory.

---

# Design Principle

Obsidian is where knowledge is explored.

Git is where knowledge is preserved.

Program Brain is where knowledge is organized.
