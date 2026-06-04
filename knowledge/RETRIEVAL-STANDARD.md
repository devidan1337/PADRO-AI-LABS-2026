# Retrieval Standard

## Purpose

This document defines how information should be retrieved from Program Brain.

The objective is to maximize relevance, context, and accuracy while minimizing noise and outdated information.

---

# Retrieval Goals

Program Brain should allow retrieval of:

* Decisions
* Standards
* Architecture
* Procedures
* Lessons learned
* Research findings
* Project history

The goal is not simply finding information.

The goal is restoring context.

---

# Retrieval Priority Order

When multiple sources exist, retrieval should prioritize:

1. Current Standards
2. Current Architecture
3. Current Procedures
4. Current Project Documentation
5. Lessons Learned
6. Historical Information

Current guidance should always take precedence over historical guidance.

---

# Retrieval Categories

## Governance Retrieval

Examples:

* Authority decisions
* Security standards
* Risk decisions

Primary Sources:

* architecture/
* security/

---

## Architecture Retrieval

Examples:

* Agent designs
* System architecture
* Integration plans

Primary Sources:

* architecture/

---

## Operational Retrieval

Examples:

* Procedures
* Runbooks
* Deployment steps

Primary Sources:

* operations/
* scripts/
* reports/

---

## Project Retrieval

Examples:

* Lab work
* Project history
* Deliverables

Primary Sources:

* labs/
* reports/

---

## Research Retrieval

Examples:

* DFIR
* OSINT
* AI Engineering
* Networking

Primary Sources:

* knowledge/

---

# Context Requirements

Retrieved information should include:

* What was decided
* Why it was decided
* When it was decided
* What replaced it (if applicable)

Information without context should be treated cautiously.

---

# Historical Retrieval

Historical information remains valuable but should be clearly identified.

Examples:

* Archived designs
* Previous standards
* Retired approaches

Historical information should not override current standards.

---

# AI Retrieval Rules

Future AI systems may retrieve:

* Approved Program Brain content
* Standards
* Architecture
* Procedures
* Lessons learned

Future AI systems may not retrieve:

* Secrets
* Credentials
* Excluded information defined in Lab 03

---

# Retrieval Quality Principles

Good retrieval should be:

* Relevant
* Accurate
* Current
* Traceable
* Explainable

---

# Success Criteria

A user should be able to ask:

* Why was this decision made?
* What is the current standard?
* How does this system work?
* What did we learn last time?

and receive a reliable answer supported by documented knowledge.

---

# Design Principle

Program Brain should retrieve understanding, not merely information.
