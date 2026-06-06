# Lab08 - Telegram Interface

## Status

PLANNED

## Purpose

Connect Telegram to Hermes through the controlled relay architecture while enforcing read-only-first behavior, approvals, and audit logging.

## Scope

- Telegram bot interface design.
- Command allowlist.
- Request classification.
- Approval workflow.
- Audit logging.
- Deny-by-default command policy.

## Non-Goals

- No arbitrary shell command execution.
- No secret retrieval.
- No infrastructure mutation from Telegram.
- No Git push or deployment actions.
- No firewall, router, VLAN, or network changes from Telegram.

## Planned Deliverables

- TELEGRAM-INTERFACE.md
- COMMAND-POLICY.md
- APPROVAL-FLOW.md
- TELEGRAM-VALIDATION.md
- LAB08-REPORT.md

## Success Criteria

- Telegram requests are constrained and classified.
- Read-only actions are separated from approval-required actions.
- Secrets and infrastructure mutation are blocked.
- Requests, decisions, and results are auditable.
