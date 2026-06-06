# PADRO-AI-LABS-2026 Master Roadmap

## Program Mission

Build a secure, local-first AI infrastructure lab that remains protected from direct internet exposure, is segmented on an AI lab VLAN, and is reachable remotely only through controlled secure access. Future phases add a Linode relay, Hermes local operations, and a Telegram interface without turning the home lab into public infrastructure.

## Target Architecture

```text
Telegram / Mobile User
        |
        v
Linode Relay Server
        |
        v
Secure Tunnel / Controlled Relay Path
        |
        v
Home Network Edge
        |
        v
Dedicated AI Lab VLAN
        |
        v
Local AI Infrastructure
        |
        v
Hermes / Program Brain / Local Tools
```

Primary architecture reference:

- architecture/TARGET-ARCHITECTURE.md

## Program Principles

1. Local-first AI infrastructure.
2. No direct public inbound access to the home lab.
3. Dedicated AI lab VLAN or equivalent segmented network zone.
4. Controlled secure remote access before public relay work.
5. Linode acts as a constrained relay, not a trusted core.
6. Hermes follows Lab03 authority, secrets, and trust boundaries.
7. Telegram is a constrained command interface, not unrestricted shell access.
8. Documentation must lead implementation and preserve rollback paths.

## Current Program Status

Current Active Lab:

Lab05 - Network Segmentation & Secure Remote Access

Last Completed Official Lab:

Lab04 - Program Brain / Knowledge

Repository:

PADRO-AI-LABS-2026

## Official Labs

### Lab01 - Foundation

Status: COMPLETE

Purpose:

- Establish the baseline local development environment and repository workflow.

Focus:

- WSL2 baseline.
- Git/GitHub workflow.
- SSH authentication.
- System inventory.
- Lab logging.

Representative deliverables:

- reports/LAB01-REPORT.md
- reports/SYSTEM-BASELINE.md
- scripts/system_inventory.sh
- scripts/lab-log.sh

### Lab02 - Agent Engineering

Status: COMPLETE

Purpose:

- Define how ChatGPT, Codex, Claude Code, Hermes, and human operators divide responsibilities.

Focus:

- Agent roles.
- Workflow boundaries.
- Human approval points.
- Agent responsibility mapping.

Representative deliverables:

- architecture/AGENT-RESPONSIBILITY-MATRIX.md
- architecture/AGENT-WORKFLOW.md
- architecture/SYSTEM-ARCHITECTURE.md
- reports/LAB02-REPORT.md

### Lab03 - Authority/Secrets/Trust

Status: COMPLETE

Purpose:

- Define authority boundaries, secrets handling, trust assumptions, and incident response expectations.

Focus:

- Authority contract.
- Secrets governance.
- Threat model.
- Environment standard.
- Incident response.

Representative deliverables:

- architecture/AUTHORITY-CONTRACT.md
- architecture/AUTHORITY-MATRIX.md
- security/SECRETS-STANDARD.md
- security/ENVIRONMENT-STANDARD.md
- security/THREAT-MODEL.md
- security/INCIDENT-RESPONSE.md
- reports/LAB03-REPORT.md

### Lab04 - Program Brain/Knowledge

Status: COMPLETE

Purpose:

- Establish the knowledge architecture that supports Hermes, retrieval, documentation, and future RAG work.

Focus:

- Program Brain structure.
- Knowledge ingestion.
- Retrieval standards.
- Obsidian integration.
- Hermes memory architecture.

Representative deliverables:

- knowledge/PROGRAM-BRAIN-ARCHITECTURE.md
- knowledge/KNOWLEDGE-INGESTION-STANDARD.md
- knowledge/RETRIEVAL-STANDARD.md
- knowledge/OBSIDIAN-INTEGRATION.md
- knowledge/HERMES-MEMORY-ARCHITECTURE.md
- reports/LAB04-REPORT.md

### Lab05 - Network Segmentation & Secure Remote Access

Status: ACTIVE

Purpose:

- Design and validate the network foundation for local AI infrastructure before adding relay or chat interfaces.

Focus:

- AI lab VLAN design.
- Home network trust boundaries.
- Secure remote access model.
- Trusted device model.
- No public inbound home-lab exposure.
- Validation and rollback documentation.

Official folder:

- labs/Lab05-Network-Segmentation-Secure-Remote-Access

Planned deliverables:

- VLAN-DESIGN.md
- SECURE-REMOTE-ACCESS.md
- DEVICE-TRUST-MODEL.md
- FIREWALL-RULES-PLAN.md
- VALIDATION.md
- LAB05-REPORT.md

Success criteria:

- The AI lab network zone is documented.
- Remote access path is defined and validated.
- The design avoids home-router public inbound exposure.
- Trust boundaries are clear before Linode relay work begins.

### Lab06 - Linode Relay Architecture

Status: PLANNED

Purpose:

- Design a small public relay layer that can support Telegram and Hermes workflows without exposing the home AI lab directly.

Focus:

- Linode relay responsibilities.
- Public edge hardening.
- Relay-to-home controlled path.
- Assume-relay-compromise model.
- Minimal authority and no secret vault role.

Official folder:

- labs/Lab06-Linode-Relay-Architecture

Planned deliverables:

- LINODE-RELAY-ARCHITECTURE.md
- RELAY-HARDENING.md
- RELAY-FIREWALL.md
- RELAY-VALIDATION.md
- LAB06-REPORT.md

Success criteria:

- Relay responsibilities are constrained.
- Relay compromise does not equal home-lab compromise.
- Relay does not hold broad home-lab authority.

### Lab07 - Hermes Local Operations

Status: PLANNED

Purpose:

- Deploy Hermes as a local operations assistant before exposing any remote control path.

Focus:

- Local Hermes service model.
- Program Brain access.
- Retrieval validation.
- Tool permission tiers.
- Approval boundaries.
- Local-only operations first.

Official folder:

- labs/Lab07-Hermes-Local-Operations

Planned deliverables:

- HERMES-DEPLOYMENT.md
- HERMES-PERMISSIONS.md
- HERMES-OPERATIONS.md
- HERMES-VALIDATION.md
- LAB07-REPORT.md

Success criteria:

- Hermes can retrieve approved Program Brain context.
- Hermes does not access secrets.
- Hermes does not perform destructive actions without approval.
- Hermes runs locally before Telegram integration.

### Lab08 - Telegram Interface

Status: PLANNED

Purpose:

- Connect Telegram to Hermes through the relay architecture while enforcing read-only-first behavior and approval workflows.

Focus:

- Telegram bot interface.
- Request classification.
- Read-only commands.
- Approval prompts.
- Audit logging.
- Deny-by-default command model.

Official folder:

- labs/Lab08-Telegram-Interface

Planned deliverables:

- TELEGRAM-INTERFACE.md
- COMMAND-POLICY.md
- APPROVAL-FLOW.md
- TELEGRAM-VALIDATION.md
- LAB08-REPORT.md

Success criteria:

- Telegram cannot execute arbitrary shell commands.
- Telegram cannot retrieve secrets.
- Higher-risk actions require explicit approval.
- Logs capture requests, decisions, and results.

### Lab09 - Docker & Local Services

Status: PLANNED

Purpose:

- Containerize local AI lab services in a controlled, documented environment.

Focus:

- Docker service boundaries.
- Local service inventory.
- Network attachment rules.
- Persistence and backup planning.
- Service health checks.

Planned deliverables:

- DOCKER-SERVICE-STANDARD.md
- LOCAL-SERVICES-INVENTORY.md
- SERVICE-NETWORKING.md
- LAB09-REPORT.md

### Lab10 - Program Brain Retrieval/RAG

Status: PLANNED

Purpose:

- Implement retrieval and RAG capabilities for Program Brain while preserving knowledge quality and secrets boundaries.

Focus:

- Retrieval index design.
- Vector database evaluation.
- Ingestion pipeline.
- Source attribution.
- Retrieval validation.

Planned deliverables:

- RAG-ARCHITECTURE.md
- RETRIEVAL-PIPELINE.md
- INDEX-VALIDATION.md
- LAB10-REPORT.md

### Lab11 - Telecom Automation Use Case

Status: PLANNED

Purpose:

- Apply the lab architecture to a realistic telecom automation workflow with human approval and operational safeguards.

Focus:

- NOC-style alarm review.
- Ticket summarization.
- Health-check analysis.
- Incident documentation.
- Safe AI-assisted triage.

Planned deliverables:

- USE-CASE.md
- AUTOMATION-BOUNDARIES.md
- TRIAGE-WORKFLOW.md
- LAB11-REPORT.md

### Lab12 - Portfolio Showcase

Status: PLANNED

Purpose:

- Package the program into a portfolio-ready showcase without exposing secrets, private infrastructure details, or unsafe operational access.

Focus:

- Public narrative.
- Architecture diagrams.
- Sanitized evidence.
- Lessons learned.
- Demo boundaries.

Planned deliverables:

- PORTFOLIO-SHOWCASE.md
- PUBLIC-ARCHITECTURE-SUMMARY.md
- SANITIZED-EVIDENCE.md
- LAB12-REPORT.md

## Support Modules

The existing folders below are retained as support modules and historical work products. They are not the official implementation lab sequence for local AI infrastructure:

- labs/Lab05-AI-Documentation-Workflow
- labs/Lab06-Retrieval-System
- labs/Lab07-Telecom-Automation-Foundation

These folders must not be moved or deleted until a separate migration plan is approved.
