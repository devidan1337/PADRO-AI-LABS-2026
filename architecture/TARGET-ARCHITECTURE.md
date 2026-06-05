# Target Architecture

## Mission

Build a secure local AI infrastructure environment that remains protected from direct internet exposure while allowing controlled remote interaction through a Linode relay and Telegram interface.

---

## Target System

```text
Telegram / Mobile User
        ↓
Linode Relay Server
        ↓
Secure Tunnel / Controlled Relay Path
        ↓
Home Network
        ↓
Dedicated AI Lab VLAN
        ↓
Local AI Infrastructure
        ↓
Hermes / Program Brain / Local Tools

Core Design Principles
No direct public inbound access to the home lab.
Local AI infrastructure remains inside a dedicated VLAN.
Remote access flows through a controlled relay path.
Linode is treated as exposed infrastructure.
Home systems initiate outbound trust where possible.
Telegram is a command interface, not unrestricted shell access.
Hermes must obey Lab03 authority and approval rules.
Secrets never live in Telegram, Program Brain, or public-facing relay logs.
Major Components
Home AI Lab VLAN

Purpose:

Isolate AI infrastructure from primary home devices.
Limit blast radius if lab services are compromised.
Provide a controlled network zone for Hermes, Docker, RAG, and local tools.

Expected systems:

PADRO-AI-CORE
Hermes
Program Brain
Future Docker services
Future vector database / RAG services
Local AI Infrastructure

Purpose:

Run local-first AI tooling and automation.

Components:

WSL2 Ubuntu
Git/GitHub repository
Codex
Claude Code workflow
Hermes
Program Brain
Future Docker services
Future RAG/vector search
Hermes

Purpose:

Local AI operations assistant.

Responsibilities:

Retrieve Program Brain knowledge
Summarize project state
Assist with lab navigation
Propose safe actions
Support future automation

Restrictions:

No silent authority inheritance
No raw secret access
No destructive actions without approval
No arbitrary shell execution from Telegram
Linode Relay Server

Purpose:

Provide a small controlled public relay layer between Telegram and the private AI lab.

Assumption:

The relay is internet-exposed and must be treated as hostile or eventually compromisable.

Responsibilities:

Receive Telegram-originated requests
Validate allowed request types
Forward approved requests through secure channel
Avoid storing secrets
Avoid holding broad access to the home lab

Restrictions:

No SSH private keys granting broad home access
No secret vault
No direct unrestricted shell control
No persistent authority beyond relay function
Telegram Interface

Purpose:

Provide mobile access to Hermes.

Allowed actions:

Request status summaries
Ask Program Brain questions
Retrieve lab state
Request reports
Trigger pre-approved read-only checks

Disallowed actions:

Arbitrary shell commands
Secret retrieval
Infrastructure mutation
Git push
Deployment actions
Firewall or network changes

Approval model:

Telegram requests action.
Hermes/relay classifies risk.
User confirms if action exceeds read-only scope.
Action executes only if approved.
Result is logged.
Trust Boundaries
Boundary 1: Internet to Linode

Risk:

Public exposure
Bot scans
Telegram token abuse
Relay compromise

Controls:

Minimal services
Firewall
SSH hardening
Logs
Least privilege
Token rotation
Boundary 2: Linode to Home Lab

Risk:

Relay compromise becoming home compromise

Controls:

No inbound home port forwarding
Prefer outbound tunnel from home
Restricted tunnel permissions
No broad SSH authority
Assume relay compromise
Boundary 3: Home Network to AI VLAN

Risk:

Lab compromise affecting personal devices

Controls:

VLAN segmentation
Firewall rules
Limited east-west traffic
Dedicated lab services
Boundary 4: Hermes to Local Tools

Risk:

Agent overreach

Controls:

Authority contract
Execution tiers
Approval gates
Logging
Revocation paths
Boundary 5: Program Brain to Retrieval Systems

Risk:

Sensitive information retrieval
Knowledge poisoning

Controls:

Ingestion standard
Retrieval standard
No secrets
Human-reviewed knowledge
Implementation Phases
Phase 1 - Network Foundation
Define VLAN plan
Choose router/firewall approach
Segment AI lab systems
Document firewall rules
Phase 2 - Secure Remote Access
Deploy Tailscale or equivalent private connectivity
Validate remote SSH/admin access
Avoid public inbound exposure
Phase 3 - Linode Relay
Deploy minimal relay server
Harden SSH
Configure firewall
Define relay responsibilities
Phase 4 - Hermes Local Operations
Install/configure Hermes locally
Connect Hermes to Program Brain
Validate read-only retrieval
Phase 5 - Telegram Interface
Connect Telegram to relay
Enforce read-only first mode
Add approval workflow
Phase 6 - Local Services
Add Docker services
Add RAG/vector search
Add monitoring/logging
Success Criteria

The target architecture is successful when:

Home AI lab is not directly exposed to the internet.
AI infrastructure runs inside a segmented network zone.
Remote interaction is possible through Telegram.
Linode acts only as a controlled relay.
Hermes can retrieve Program Brain context.
Risky actions require approval.
Secrets remain protected.
All major access paths are documented, logged, and revocable.
Strategic Statement

PADRO-AI-LABS is not just a documentation repository.

It is intended to become a secure, local-first AI infrastructure lab with controlled remote access, governed agent authority, persistent knowledge, and portfolio-ready implementation evidence.
