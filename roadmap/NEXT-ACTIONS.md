# NEXT ACTIONS

## Current Program State

Current Active Lab:

Lab05 - Network Segmentation & Secure Remote Access

Last Completed Official Lab:

Lab04 - Program Brain / Knowledge

Current Repository Status:

Roadmap realignment in progress.

## Immediate Objectives

### Objective 1 - Establish Lab05 Scope

Deliverables:

- labs/Lab05-Network-Segmentation-Secure-Remote-Access/README.md
- architecture/TARGET-ARCHITECTURE.md
- roadmap/MASTER-ROADMAP.md

Status:

IN PROGRESS

### Objective 2 - Document Network Segmentation Plan

Focus:

- AI lab VLAN purpose.
- Home network trust boundaries.
- Allowed and denied traffic classes.
- Required validation evidence.
- Rollback notes before implementation.

Status:

PENDING

### Objective 3 - Define Secure Remote Access Model

Focus:

- Trusted remote devices.
- Identity and access expectations.
- No public inbound home-lab exposure.
- Candidate private access approach.
- Audit and revocation requirements.

Status:

PENDING

### Objective 4 - Prepare Lab06 Handoff

Focus:

- Conditions required before Linode relay work begins.
- Relay trust assumptions.
- Controlled path from public edge to home lab.
- Non-goals for the relay.

Status:

PENDING

## Current Questions

1. What VLAN or segmented network approach will host the AI lab?
2. Which devices are trusted to administer PADRO-AI-CORE remotely?
3. What remote access method will be evaluated first?
4. What evidence proves the home lab has no public inbound exposure?
5. What must be complete before Linode relay architecture begins?

## Current Working Principle

Build the private local AI lab security boundary first. Do not expose relay, Hermes, Telegram, or automation workflows until network segmentation and controlled remote access are documented and validated.

## Next Commit Target

Realign the roadmap around Lab05 as the active infrastructure lab and create official Lab05-Lab08 implementation folders.
