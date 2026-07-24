# PAL Network Trust Model

## Principle

No system inherits trust merely because it is physically inside the home network. Trust is assigned by role, identity, zone, and required communication path.

## Zones

- WAN/untrusted
- Home/user
- AI infrastructure
- Management plane
- Guest/IoT
- Future public relay

## Control rules

- Management interfaces are denied from non-management zones.
- AI services publish only documented application ports.
- AI endpoints may use controlled outbound Internet access.
- Public relay compromise must not grant broad home-lab authority.
- Remote access uses authenticated private paths without public home port forwarding.
- Every cross-zone exception has owner, purpose, evidence, and review date.

## Assurance

Validate both permitted and denied traffic after every material network change. Preserve logs and configuration backups privately.
