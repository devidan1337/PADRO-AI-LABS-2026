# Lab06 - Linode Relay Architecture

## Status

PLANNED

## Purpose

Design a constrained public relay layer that can later support Telegram-to-Hermes workflows without exposing the home AI lab directly.

## Scope

- Linode relay responsibilities.
- Public edge hardening plan.
- Controlled relay-to-home path.
- Assume-relay-compromise model.
- Minimal authority design.

## Non-Goals

- No Linode provisioning in this scaffold.
- No firewall or SSH configuration changes.
- No secrets stored on the relay.
- No broad home-lab authority.
- No direct public exposure of private lab services.

## Planned Deliverables

- LINODE-RELAY-ARCHITECTURE.md
- RELAY-HARDENING.md
- RELAY-FIREWALL.md
- RELAY-VALIDATION.md
- LAB06-REPORT.md

## Success Criteria

- Relay duties are narrowly defined.
- Relay compromise does not equal home-lab compromise.
- The relay cannot act as an unrestricted remote shell.
