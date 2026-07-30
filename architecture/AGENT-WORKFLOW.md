# PADRO-AI-LABS Agent Operating Model

## Purpose

This document defines how Dan, ChatGPT, Hermes, Codex, Claude Code, approved local models, and future specialized workers coordinate inside PADRO-AI-LABS.

The operating model is context-dependent.

ChatGPT and Hermes are alternate assessment interfaces. They are not mandatory sequential layers in every workflow.

Authority remains with Dan.

## Core Principles

1. Dan is the system owner and final decision-maker.
2. Program Brain is PAL's authoritative institutional-memory layer.
3. ChatGPT supports external, mobile, strategic, educational, and independent-review work.
4. Hermes supports internal, local, Program-Brain-aware assessment and orchestration.
5. Codex, Claude Code, and specialized workers perform bounded implementation or review tasks.
6. No agent approves its own higher-risk work.
7. Agent reasoning authority does not imply execution authority.
8. Higher-risk changes return to Dan for explicit approval.
9. Secrets and restricted information remain outside unauthorized model and agent context.
10. All operating modes remain subject to the authority contract, authority matrix, and applicable security standards.

## Roles

### Dan

Dan is:

- system owner;
- authority source;
- risk acceptor;
- final reviewer;
- approval authority;
- operator of last resort.

Dan may approve, reject, revise, defer, or terminate proposed work.

### ChatGPT

ChatGPT serves primarily as PAL's external and mobile strategic interface.

Approved uses include:

- architectural reasoning;
- tutoring and technical explanation;
- public or external research;
- career and portfolio strategy;
- sanitized workflow design;
- independent second-opinion review;
- creation of work packages for later use inside the lab.

ChatGPT is not required to participate in routine internal PAL operations once Hermes can perform the necessary local assessment safely.

ChatGPT must not be treated as PAL's authoritative memory source.

### Hermes

Hermes serves as PAL's local, Program-Brain-aware assessment and orchestration interface.

Approved responsibilities may include:

- restoring current project context;
- retrieving approved Program Brain content;
- assessing PAL state;
- identifying gaps, dependencies, risks, and next actions;
- preparing bounded implementation work packages;
- routing approved tasks to Codex, Claude Code, local models, or specialized workers;
- collecting worker results;
- presenting decision packages to Dan;
- supporting approved operational workflows.

Hermes does not own Program Brain knowledge and may not approve its own higher-risk actions.

### Codex

Codex serves primarily as an implementation worker.

Approved responsibilities may include:

- scripts;
- configurations;
- repository changes;
- structured documentation;
- tests;
- validation procedures;
- bounded refactoring.

Codex operates only within the authority and file scope granted for the task.

### Claude Code

Claude Code serves primarily as an implementation or independent-review worker, depending on the task.

Approved responsibilities may include:

- code and configuration review;
- risk identification;
- alternative implementation analysis;
- validation;
- documentation review;
- bounded implementation when explicitly authorized.

Claude Code is not automatically required after every Codex task.

### Local Models and Specialized Workers

Approved local or private models, including SOL where validated, may support:

- private reasoning;
- classification;
- summarization;
- retrieval;
- evidence organization;
- bounded domain analysis;
- specialized PAL workflows.

Their authority is determined by the assigned worker role, not by where the model runs.

## Operating Mode 1 — External or Mobile Assessment

Use this mode when Dan is outside the lab or needs external strategic support.

```text
Dan
  ↓
ChatGPT
  ↓
Research, teaching, architecture, or sanitized assessment
  ↓
Portable recommendation or bounded work package
  ↓
Dan reviews before transfer into PAL
```

Typical uses:

* studying;
* architectural planning;
* public research;
* reviewing sanitized project information;
* designing future workflows;
* preparing instructions for later execution;
* requesting an external second opinion.

Sensitive PAL data must be minimized or sanitized before it is supplied externally.

## Operating Mode 2 — Internal PAL Assessment

Use this as the normal future operating mode inside the lab.

```text
Dan
  ↓
Hermes
  ↓
Program Brain retrieval and local PAL assessment
  ↓
Codex, Claude Code, approved local model, or specialized worker
  ↓
Hermes collects and evaluates results
  ↓
Dan approval when required
  ↓
Controlled execution or documentation
```

Hermes may coordinate work but may not silently expand its own authority.

## Operating Mode 3 — Independent External Review

Use this mode for significant architecture, governance, security, incident, or risk decisions.

```text
Hermes produces an internal assessment
  ↓
A sanitized package is reviewed through ChatGPT
  ↓
Dan compares the internal and external assessments
  ↓
Dan approves, rejects, revises, or defers
```

This is an escalation and assurance path, not a mandatory step for routine work.

## Worker Routing

Hermes or ChatGPT may recommend a worker, but the assigned task must specify:

* objective;
* authorized inputs;
* authorized files or systems;
* prohibited actions;
* required output;
* success criteria;
* validation requirements;
* approval requirements.

Worker selection should be based on task requirements rather than a permanent sequence.

Examples:

* Codex for bounded repository implementation;
* Claude Code for independent technical review;
* SOL or another approved local model for private assessment;
* a specialized worker for retrieval, OSINT, telecom, incident response, or documentation.

## Human Approval Boundary

Dan's explicit approval is required before:

* destructive actions;
* production-impacting actions;
* credential or secret changes;
* firewall or access-control changes;
* external publication;
* Git push or merge where approval is required by policy;
* evidence disposition;
* incident containment;
* autonomous communication with outside parties;
* expansion of an agent's authority;
* modification of governing agent instructions.

Agents may prepare recommendations and work products without receiving authority to execute the resulting action.

## Knowledge Boundary

Program Brain remains the authoritative institutional-memory source.

Hermes may consume and recommend updates to approved knowledge.

ChatGPT may assist with sanitized material and external analysis.

Neither ChatGPT nor Hermes may silently declare generated content authoritative.

Knowledge promotion remains subject to human review and the Lab 04 ingestion standards.

## Transition State

PAL is transitioning from a ChatGPT-centered planning workflow to a Hermes-centered internal operating workflow.

During the transition:

* ChatGPT remains available for PAL planning and instruction;
* Hermes capabilities must be validated incrementally;
* local retrieval must be proven before Hermes becomes the normal internal interface;
* tool permissions must remain narrow;
* local-model performance must be evaluated;
* fallback to direct human operation must remain available.

The transition is complete only when Hermes can reliably restore context, retrieve approved knowledge, route bounded work, preserve auditability, and return consequential decisions to Dan.

## Success Criteria

The operating model is successful when:

* Dan can use ChatGPT outside the lab without making it a mandatory internal dependency;
* Hermes can assess PAL locally using approved knowledge;
* implementation and review workers receive bounded tasks;
* unnecessary agent handoffs are avoided;
* authority remains clear;
* secrets remain protected;
* important decisions return to Dan;
* workflows remain explainable and auditable.
