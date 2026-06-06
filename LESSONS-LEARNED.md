# Lessons Learned

## Format

### Lesson Title
- Context:
- Mistake or discovery:
- Technical cause:
- Fix:
- Security relevance:
- Career relevance:

Lesson:
GitHub authentication failed because WSL was a fresh Linux environment and did not yet possess an SSH keypair.

Resolution:
Generated ed25519 SSH keypair, registered public key with GitHub, validated via ssh -T.

Concept Learned:
Trust relationships in Git are based on keypairs rather than account passwords.

Lab: 01

Lesson:
Codex can be used as an implementation engineer while maintaining architectural control.

Observation:
Providing explicit constraints such as "Do not modify existing files without asking" resulted in disciplined behavior and predictable outputs.

Takeaway:
Agent supervision and instruction quality directly impact implementation outcomes.


# Repository Governance Lesson

## Problem

During Lab03 and Lab04 development, an abandoned project directory (`PADRO-AI-LABS-2026-A1`) remained alongside the active repository.

This created uncertainty regarding:

* authoritative documentation
* future commits
* roadmap ownership
* repository state

## Lesson

A project should have a single authoritative repository.

Historical artifacts may be archived, but active development should occur in only one location.

Multiple active repositories create governance confusion, duplicate work, and increase the risk of divergence.

## Action Taken

* Archived A1 artifacts.
* Designated PADRO-AI-LABS-2026 as the sole authoritative repository.
* Updated governance documentation.

---

# Architecture Drift Lesson

## Problem

Support modules created during documentation work began to influence the official roadmap.

The project temporarily drifted toward:

* documentation workflows
* retrieval standards
* supporting knowledge artifacts

while the intended objective remained the construction of a secure local AI infrastructure.

## Lesson

Supporting documentation must never redefine the mission of the program.

Architecture should drive documentation.

Documentation should not drive architecture.

## Action Taken

* Defined TARGET-ARCHITECTURE.md.
* Rebuilt the roadmap around implementation.
* Separated infrastructure labs from support modules.

---

# Implementation Before Expansion Lesson

## Problem

Several labs were documented before the corresponding infrastructure existed.

This created the appearance of progress while delaying implementation decisions.

## Lesson

Documentation is valuable only when it supports implementation.

The project should maintain a balance between:

* planning
* documentation
* implementation
* validation

No future phase should spend excessive time expanding documentation without moving the underlying system forward.

## Action Taken

* Re-centered the roadmap around implementation labs.
* Defined Lab05 as the beginning of infrastructure deployment work.

---

# Target Architecture Lesson

## Problem

The project contained multiple implied future architectures.

This created uncertainty regarding:

* Tailscale
* Hermes
* Telegram
* Linode
* VLAN segmentation

and their intended relationships.

## Lesson

Every major project requires a clearly defined target architecture.

Without a target architecture, individual design decisions become disconnected and difficult to evaluate.

## Action Taken

* Created TARGET-ARCHITECTURE.md.
* Established the desired end-state architecture.
* Realigned future labs to support that architecture.

---

# Review Before Commit Lesson

## Problem

Large repository changes were generated before a complete review of file contents.

## Lesson

Every architecture or roadmap change must be reviewed before commit.

Generated documentation should be inspected for:

* roadmap drift
* stale assumptions
* duplicated responsibilities
* implementation impact

before being merged into the authoritative repository.

## Action Taken

* Added review checkpoints before major commits.
* Audited roadmap, architecture, and lab files before acceptance.

---

# Infrastructure First Lesson

## Problem

The project temporarily emphasized governance and knowledge systems more than infrastructure implementation.

## Lesson

Governance, security, and documentation are prerequisites, not final products.

The objective of PADRO-AI-LABS is the construction of a working AI infrastructure platform.

Success requires:

* functioning systems
* validated architectures
* operational tooling
* documented evidence

## Action Taken

* Transitioned from planning-focused work to implementation-focused labs.
* Established Lab05 as the first infrastructure deployment phase.
