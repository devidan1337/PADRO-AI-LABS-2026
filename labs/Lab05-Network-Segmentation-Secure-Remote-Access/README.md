# Lab05 - Network Segmentation & Secure Remote Access

## Status

ACTIVE

## Purpose

Design and validate the private network foundation for PADRO-AI-LABS before introducing public relay, Hermes operations, or Telegram interfaces.

## Scope

- AI lab VLAN or equivalent segmented network zone.
- Home network trust boundaries.
- Secure remote access model.
- Trusted device model.
- No public inbound exposure to local AI infrastructure.
- Validation and rollback documentation.

## Non-Goals

- No router, firewall, VLAN, VPN, or DNS changes in this scaffold.
- No software installation.
- No Linode relay deployment.
- No Hermes or Telegram remote execution.
- No secrets, credentials, SSH keys, or `.env` files.

## Planned Deliverables

- VLAN-DESIGN.md
- SECURE-REMOTE-ACCESS.md
- DEVICE-TRUST-MODEL.md
- FIREWALL-RULES-PLAN.md
- VALIDATION.md
- LAB05-REPORT.md

## Success Criteria

- AI lab segmentation is documented.
- Secure remote access path is defined.
- Public inbound exposure to the home lab is avoided.
- Evidence requirements are clear before implementation.
