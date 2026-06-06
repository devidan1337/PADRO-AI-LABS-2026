# Target Architecture

## Mission

Build a secure, local-first AI infrastructure environment that is protected from direct internet exposure, segmented on a dedicated AI lab VLAN, reachable remotely only through controlled access paths, and ready for future Linode relay, Hermes, and Telegram interface layers.

## Target Implementation Architecture

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

## Core Rules

1. Local AI infrastructure is not directly exposed to the public internet.
2. AI lab systems live in a dedicated VLAN or equivalent segmented network zone.
3. Remote administration uses controlled secure access, not home-router port forwarding.
4. Linode is a relay and public edge component, not a trusted core system.
5. Hermes operates under the Lab03 authority, secrets, and trust model.
6. Telegram is a constrained command interface, not a remote shell.
7. Secrets do not live in Telegram, Program Brain, relay logs, or public-facing services.
8. Implementation changes require documentation, validation, and rollback notes.

## Local AI Lab VLAN

Purpose:

- Isolate AI lab infrastructure from primary home devices.
- Limit blast radius if an experimental service is compromised.
- Provide a stable network zone for Hermes, Program Brain, Docker services, retrieval systems, and future automation.

Expected systems:

- PADRO-AI-CORE
- Hermes local operations service
- Program Brain files and retrieval indexes
- Docker-hosted local services
- Future vector database or RAG services

Initial Lab05 work is documentation and validation only. Router, firewall, VLAN, VPN, and DNS changes must be planned before implementation.

## Secure Remote Access

Purpose:

- Allow trusted remote access to the AI lab without exposing inbound services from the home network to the internet.

Preferred model:

- Home systems initiate outbound trust where possible.
- Remote access is limited to trusted identities and devices.
- Administrative access is logged and revocable.
- Public inbound router forwarding is avoided.

Candidate technologies may include Tailscale or equivalent private connectivity, but no software installation or network setting changes are part of this repo realignment patch.

## Linode Relay

Purpose:

- Provide a small public relay layer for future Telegram-originated requests.
- Keep public exposure outside the home AI lab.
- Forward only approved request types through a restricted channel.

Assumption:

- The relay is internet-exposed and must be treated as hostile or eventually compromisable.

Restrictions:

- No broad SSH authority into the home lab.
- No secret vault role.
- No unrestricted shell control.
- No persistent authority beyond relay duties.
- No direct exposure of private AI lab services.

## Hermes Local Operations

Purpose:

- Serve as the local operations assistant for lab navigation, Program Brain retrieval, status reporting, and approved workflows.

Allowed responsibilities:

- Retrieve approved Program Brain context.
- Summarize project and lab state.
- Propose safe next actions.
- Produce reports and operational notes.
- Support future read-only checks.

Restrictions:

- No silent authority inheritance.
- No raw secret access.
- No destructive actions without explicit approval.
- No arbitrary shell execution from Telegram.
- No bypass of Lab03 authority controls.

## Telegram Interface

Purpose:

- Provide mobile access to Hermes through the relay architecture.

Allowed actions:

- Request status summaries.
- Ask Program Brain questions.
- Retrieve lab state.
- Request reports.
- Trigger pre-approved read-only checks.

Disallowed actions:

- Arbitrary shell commands.
- Secret retrieval.
- Infrastructure mutation.
- Git push or deployment actions.
- Firewall, router, VLAN, or network changes.

Approval model:

1. Telegram submits a request.
2. Relay and Hermes classify the request.
3. Read-only approved requests may proceed.
4. Higher-risk actions require explicit user approval.
5. Results are logged.
6. Denied requests are recorded with reason.

## Trust Boundaries

### Boundary 1: Internet to Linode

Risks:

- Public scanning.
- Token abuse.
- Relay compromise.

Controls:

- Minimal exposed services.
- Firewall hardening.
- SSH hardening.
- Least privilege.
- Token rotation.
- Log review.

### Boundary 2: Linode to Home Lab

Risks:

- Relay compromise becoming home-lab compromise.

Controls:

- No inbound home port forwarding.
- Prefer outbound tunnel from home.
- Restricted tunnel permissions.
- No broad SSH authority.
- Assume relay compromise in design.

### Boundary 3: Home Network to AI Lab VLAN

Risks:

- Lab compromise affecting personal devices.
- Personal device compromise affecting lab systems.

Controls:

- VLAN or equivalent segmentation.
- Explicit firewall rules.
- Limited east-west traffic.
- Dedicated lab services.
- Documented access paths.

### Boundary 4: Hermes to Local Tools

Risks:

- Agent overreach.
- Unsafe automation.

Controls:

- Authority contract.
- Execution tiers.
- Approval gates.
- Logging.
- Revocation paths.

### Boundary 5: Program Brain to Retrieval Systems

Risks:

- Sensitive information retrieval.
- Knowledge poisoning.
- Stale operational state.

Controls:

- Knowledge ingestion standard.
- Retrieval standard.
- No secrets in knowledge stores.
- Human-reviewed operational knowledge.

## Implementation Sequence

1. Lab05 - Network Segmentation & Secure Remote Access
2. Lab06 - Linode Relay Architecture
3. Lab07 - Hermes Local Operations
4. Lab08 - Telegram Interface
5. Lab09 - Docker & Local Services
6. Lab10 - Program Brain Retrieval/RAG
7. Lab11 - Telecom Automation Use Case
8. Lab12 - Portfolio Showcase

## Current Active Phase

Lab05 - Network Segmentation & Secure Remote Access.

The immediate goal is to document and validate the secure local network and remote access design before introducing public relay, Hermes operations, or Telegram control paths.
