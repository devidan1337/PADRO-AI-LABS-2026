# Physical Port Mapping

## Current

| Physical | Interface | Purpose | Status |
|----------|-----------|----------|---------|
| IPMI | Dedicated | Out-of-band management | Pending |
| Intel I210 | igb0 | LAN | Operational |
| Intel I210 | TBD | Management | Planned |
| Intel X553 | ix0 | WAN | DHCP Pending |
| Intel X553 | TBD | 10Gb Trunk | Planned |
| Intel X553 | TBD | Future AI | Reserved |
| Intel X553 | TBD | Expansion | Reserved |

---

Future Design

Internet

↓

WAN

↓

OPNsense

↓

10Gb Trunk

↓

EdgeSwitch ES-24-250W

↓

VLANs
