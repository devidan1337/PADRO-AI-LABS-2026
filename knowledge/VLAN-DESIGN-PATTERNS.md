# VLAN Design Patterns for PAL

## Access port

Carries one endpoint VLAN, normally untagged to the connected device.

## Trunk port

Carries multiple 802.1Q-tagged VLANs between infrastructure devices such as OPNsense and a managed switch.

## Management VLAN

Contains privileged management interfaces. Membership and routing should be narrower than ordinary user networks.

## AI/security analysis VLAN

Contains services and tools that ingest untrusted data or execute experimental workloads. It should have controlled outbound access and default-deny access to management and home clients.

## Native VLAN caution

An untagged/native VLAN on a trunk can become an accidental management or lateral-movement path. Configure it intentionally, document it, and avoid using a privileged VLAN as the native VLAN where possible.

## Validation pattern

For every VLAN prove:

- correct DHCP/subnet/gateway
- correct tagged/untagged switch behavior
- intended allowed communication
- intended denied communication
- firewall log evidence
- persistence after reboot
