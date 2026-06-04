# Knowledge Ingestion Standard

## Purpose

This document defines the rules governing what information may enter Program Brain.

The objective is to maximize retrieval value while minimizing misinformation, clutter, security risks, and knowledge pollution.

---

# Core Principle

Not all information deserves to be remembered.

Program Brain should preserve useful knowledge, not accumulate unlimited data.

---

# Ingestion Requirements

Information should satisfy at least one of the following:

* Supports future decision making
* Preserves lessons learned
* Documents architecture
* Documents standards
* Documents procedures
* Preserves research findings
* Preserves project context
* Supports future retrieval

If information satisfies none of these requirements, it should not be ingested.

---

# Approved Information Sources

## Lab Reports

Examples:

* LAB01-REPORT.md
* LAB02-REPORT.md
* LAB03-REPORT.md

Status:

Approved

---

## Standards

Examples:

* Security standards
* Governance standards
* Operational standards

Status:

Approved

---

## Architecture Documents

Examples:

* System architecture
* Agent architecture
* Integration architecture

Status:

Approved

---

## Lessons Learned

Examples:

* Mistakes
* Discoveries
* Design corrections

Status:

Approved

---

## Research Summaries

Examples:

* DFIR research
* OSINT research
* AI engineering research

Status:

Approved

Raw research should be summarized before ingestion.

---

## Procedures

Examples:

* Runbooks
* Deployment procedures
* Troubleshooting guidance

Status:

Approved

---

# Conditionally Approved Information

## Meeting Notes

Allowed only when:

* Actionable
* Relevant
* Summarized

Raw meeting transcripts should not be ingested.

---

## Chat Sessions

Allowed only when:

* Curated
* Summarized
* Reviewed

Entire conversations should not be ingested automatically.

---

## Technical Logs

Allowed only when:

* Significant
* Summarized
* Relevant to future troubleshooting

Raw logs should remain separate.

---

# Rejected Information

Program Brain must reject:

* Passwords
* API keys
* Tokens
* SSH private keys
* Secret values
* Unredacted .env files
* Temporary notes
* Duplicate information
* Unverified claims
* Unsummarized raw logs
* Unsummarized chat transcripts

---

# Categorization Rules

Every ingested item should be assigned:

## Knowledge Domain

Examples:

* Governance
* Architecture
* Operations
* Projects
* Research
* Lessons Learned
* Career Development
* Reference Material

---

## Information Class

One of:

* Permanent Knowledge
* Operational Knowledge
* Historical Knowledge

---

# Quality Requirements

Before ingestion, information should be:

* Accurate
* Relevant
* Understandable
* Actionable
* Safe to retrieve

---

# Human Review Requirement

Human review is required before ingesting:

* Research conclusions
* AI-generated findings
* External intelligence
* Strategic decisions

Program Brain should preserve reviewed knowledge, not assumptions.

---

# Future AI Ingestion Rules

Future agents may propose information for ingestion.

Future agents may not autonomously approve ingestion.

Human review remains mandatory.

---

# Success Criteria

Knowledge entering Program Brain should improve:

* Future retrieval
* Decision quality
* Context restoration
* Project continuity

without increasing noise, confusion, or security risk.

---

# Design Principle

Program Brain is a curated knowledge system.

It is not a data dump.
