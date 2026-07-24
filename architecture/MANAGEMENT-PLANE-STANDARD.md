# PAL Management-Plane Standard

## Scope

Applies to OPNsense WebGUI/SSH/console, EdgeSwitch administration, IPMI/BMC, hypervisor administration, and future orchestration control interfaces.

## Requirements

1. Management services must not be directly exposed to the public Internet.
2. Access must originate from approved admin identities/devices.
3. Management traffic must use a dedicated VLAN or equally strong isolated path.
4. Default credentials must be replaced before normal operation.
5. Firmware/software versions and update decisions must be recorded.
6. Configuration backups must precede material changes.
7. Failed and successful administrative access should be logged where supported.
8. API access must use dedicated service identities and least privilege.
9. Temporary recovery access must have an expiry/removal step.
10. Public screenshots must redact identifiers and management details.
