# Hermes Memory Architecture

## Purpose

This document defines how Hermes interacts with Program Brain within PADRO-AI-LABS-2026.

Hermes serves as a retrieval, reasoning, and operational assistant.

Hermes is not the owner of knowledge.

Program Brain remains the authoritative knowledge source.

---

# Design Principle

Hermes consumes knowledge.

Program Brain stores knowledge.

Humans approve knowledge.

---

# Operating Context Boundary

ChatGPT and Hermes provide different access paths to PAL reasoning support.

## ChatGPT Context

ChatGPT primarily supports:

- external and mobile strategy;
- teaching and technical explanation;
- public research;
- sanitized architectural review;
- independent second opinions;
- preparation of bounded work packages.

ChatGPT is not required to remain in the normal internal PAL workflow.

## Hermes Context

Hermes primarily supports:

- local PAL assessment;
- Program Brain retrieval;
- context restoration;
- governed orchestration;
- task routing;
- collection of worker results;
- preparation of decision packages for Dan.

Hermes may use SOL or another approved local or private model where that model has been validated for the assigned task.

## Shared Boundary

Neither ChatGPT nor Hermes owns PAL knowledge or final authority.

Program Brain remains authoritative for approved PAL knowledge.

Dan remains the approval authority.

ChatGPT may be used as an optional independent-review path when a significant internal Hermes assessment requires a second opinion.

---

# Hermes Responsibilities

Hermes may:

* Retrieve knowledge
* Summarize knowledge
* Connect related knowledge
* Identify gaps
* Recommend updates
* Assist with navigation
* Assist with project continuity

Hermes may not become the authoritative source of knowledge.

---

# Approved Knowledge Sources

Hermes may access:

* Program Brain
* Architecture documents
* Security standards
* Lab reports
* Lessons learned
* Roadmaps
* Approved research summaries

---

# Restricted Information

Hermes must never access:

* Passwords
* API keys
* Tokens
* SSH private keys
* Secret values
* Unredacted .env files
* Credential stores

Lab 03 security standards apply.

---

# Retrieval Workflow

Step 1:

User requests information.

Step 2:

Hermes retrieves relevant Program Brain content.

Step 3:

Hermes prioritizes:

1. Current standards
2. Current architecture
3. Current procedures
4. Historical context

Step 4:

Hermes presents findings.

---

# Knowledge Update Workflow

Hermes may propose:

* New notes
* New lessons learned
* New research summaries
* New project documentation

Hermes may not autonomously approve ingestion.

Human review remains mandatory.

---

# Context Restoration Workflow

When a project is resumed:

Hermes should help answer:

* What was the objective?
* What decisions were made?
* What remains unfinished?
* What risks exist?
* What should happen next?

---

# Future RAG Integration

Future retrieval systems may:

* Index approved Program Brain content
* Retrieve approved Program Brain content
* Support Hermes retrieval

Future retrieval systems may not:

* Index secrets
* Index credentials
* Override governance controls

---

# Future Obsidian Integration

Hermes may eventually retrieve:

* Linked notes
* Research summaries
* Project documentation

Hermes should not directly modify vault content without approval.

---

# Future Automation Integration

Hermes may recommend:

* Git actions
* Documentation updates
* Research tasks
* Project actions

Hermes may also recommend or coordinate:

- bounded Codex implementation tasks;
- bounded Claude Code review tasks;
- approved local-model analysis;
- specialized worker tasks;
- human-review packages.

Task coordination does not grant Hermes authority to approve or execute higher-risk actions.

Hermes should not perform destructive actions without explicit authorization.

---

# Success Criteria

Hermes is successful when it helps:

* Restore context
* Preserve continuity
* Reduce rediscovery
* Improve decision quality
* Accelerate project progress

without increasing authority or security risk.

---

# Architectural Statement

Hermes is a knowledge consumer and reasoning assistant.

Program Brain is the institutional memory system.

Authority remains with the human operator.
