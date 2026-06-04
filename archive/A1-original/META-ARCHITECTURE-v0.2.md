# Meta-Architecture v0.2 — File Roles and Update Rules

## Purpose
This document defines how PADRO-AI-LABS-2026-A1 stores knowledge, captures evidence, and turns hands-on work into portfolio-ready deliverables.

## Core Rule
Work should be captured lightly during execution and polished later.

The operator should stay in flow.
The assistant/Hermes system should transform raw notes into structured reports.

---

## File Role Map

### PROGRAM-BRAIN.md
The master program memory.

Stores:
- prime directive
- strategic goals
- active deliverable
- operating principles
- current next action
- long-term roadmap anchors

Update when:
- program direction changes
- a deliverable is completed
- major strategic decision is made

---

### ROADMAP.md
The ordered path of deliverables.

Stores:
- deliverable sequence
- lab progression
- skill progression
- certification/career alignment
- future expansion ideas

Update when:
- new labs are added
- priorities shift
- deliverables are completed

---

### LAB-INDEX.md
The table of contents for all labs.

Stores:
- lab number
- lab title
- status
- key tools
- linked reports

Update when:
- a lab is created
- a lab changes status
- a lab is completed

---

### DAILY-LOG.md
A chronological execution log.

Stores:
- date
- work completed
- commands run
- issues encountered
- decisions made
- next action

Update:
- after each work session

---

### FIELD-NOTES.md
Fast scratchpad notes during execution.

Stores:
- rough thoughts
- errors
- questions
- observations
- command outputs worth saving
- preferences

Rules:
- messy is acceptable
- short is preferred
- no polishing required

Update:
- during work
- whenever something important happens

---

### labs/LAB-XX-*/LAB-XX-REPORT.md
The polished technical report.

Stores:
- objective
- environment
- methodology
- implementation
- validation
- findings
- issues
- remediation
- lessons learned
- next steps

Update:
- after checkpoints
- at lab completion

---

### labs/LAB-XX-*/LAB-XX-EVIDENCE.md
The evidence record.

Stores:
- command outputs
- screenshots
- hashes if applicable
- config snippets
- timestamps
- verification results

Update:
- whenever proof is captured

---

### labs/LAB-XX-*/LAB-XX-LESSONS-LEARNED.md
The learning reflection.

Stores:
- concepts learned
- mistakes
- troubleshooting insights
- career relevance
- how this maps to GRC/OSINT/DFIR/AI engineering

Update:
- after lab completion
- after major failure/recovery

---

### scripts/
Stores reusable automation.

Examples:
- health checks
- setup scripts
- logging scripts
- validation scripts
- report helpers

Rule:
Every repeated manual action is a script candidate.

---

### evidence/
Global evidence folder.

Stores:
- screenshots
- terminal logs
- exported configs
- proof files
- before/after outputs

Rule:
Evidence should support claims made in reports.

---

### prompts/
Stores reusable prompts.

Examples:
- Hermes memory refresh prompts
- lab report generation prompts
- evidence summarization prompts
- troubleshooting prompts

Rule:
Useful prompts become assets.

---

### blog-drafts/
Stores public-facing writeups.

Purpose:
Translate technical labs into readable portfolio/blog posts.

Rule:
Blog drafts should be less operationally sensitive than internal reports.

---

### memory/
Stores Hermes-localized context files.

Examples:
- PROGRAM-CONTEXT.md
- ACTIVE-DELIVERABLE.md
- DECISION-LOG.md
- HERMES-INSTRUCTIONS.md

Purpose:
Give Hermes durable local context without relying only on chat memory.

---

## Update Flow

### During Work
Write minimal notes in:

```txt
FIELD-NOTES.md
