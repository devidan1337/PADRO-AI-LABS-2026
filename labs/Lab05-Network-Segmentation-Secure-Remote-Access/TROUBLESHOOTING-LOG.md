# Lab05 Troubleshooting Log

> Authoritative Lab05 troubleshooting record promoted after Phase 3B source reconciliation. Entries retain explicit uncertainty where root cause or factual authority remains unresolved.

## T-001 — UEFI shell instead of operating system

### Symptoms

The appliance completed POST and entered the UEFI shell.

### Initial hypotheses

No bootable operating system, an incorrect boot order, a missing EFI entry, or a failed drive.

### Evidence observed

The boot manager listed removable installation media and network-boot options, and the OPNsense installer booted from the removable media.

### Root cause or current assessment

The best-supported cause is that no usable installed OPNsense boot entry existed yet.

### Resolution or next action

OPNsense was installed from removable media; the media was removed; the appliance then booted from internal storage.

### Lessons learned

Retain installer media, document boot order, and capture firmware and storage inventory.

### Status

Resolved according to both sources.

## T-002 — WAN has no displayed address

### Symptoms

The console showed the WAN interface without an IPv4 address.

### Initial hypotheses

Incorrect physical-interface mapping, no link, DHCP delay or failure, an upstream-port issue, or a private-WAN policy interaction.

### Evidence observed

The WAN cable path reached an upstream switch, but physical interface mapping had not been completed.

### Resolution or next action

Observe link indicators; use interface auto-detection or controlled connect/disconnect tests; verify link state; renew DHCP; inspect WAN logs and upstream leases; then test gateway reachability, IP reachability, and DNS in that order.

### Status

Unresolved in both sources.

## T-003 — Git pathspec did not match Lab05 files

### Symptoms

Git searched for a duplicated nested lab path.

### Root cause or current assessment

Root-relative paths were used while the shell was already inside the Lab05 directory.

### Resolution or next action

Stage the current directory from the lab directory, or return to the repository root and use the lab-relative path.

### Lessons learned

Repository automation should resolve and display the repository root before staging.

### Status

Resolved according to both sources.

## T-004 — GitHub push DNS failure

### Symptoms

SSH could not resolve the public Git hosting hostname.

### Evidence observed

The local commit succeeded and the local branch was ahead of its remote-tracking branch.

### Root cause or current assessment

The sources attribute the failure to a temporary WSL DNS or connectivity problem rather than Git authorization.

> **Causal confidence:** The later successful push is confirmed, but the exact corrective action was not captured. Temporary WSL DNS or connectivity failure remains the best-supported assessment rather than a fully reproduced root cause.

### Resolution or next action

The push later succeeded. For recurrence, record route, resolver, direct-IP reachability, DNS lookup, and VPN state before changing SSH keys.

### Status

Operationally resolved; causal details remain partially unresolved.

## T-005 — SSH key-only authentication failure

### Symptoms

SSH returned `Permission denied (publickey)` over Tailscale.

### Evidence observed

The SSH daemon responded, and the reported public keys did not match.

### Root cause or current assessment

The best-supported working theory is that the authorized public key did not correspond to the client private key being offered.

### Resolution or next action

Compare public-key text or fingerprints, then verify authorization-file ownership and permissions.

### Status

Unresolved in both sources.

## T-006 — Hardware fact discrepancies

### Symptoms

Two processor model identifiers conflicted, and the storage device was described with a protocol that the installer evidence did not establish.

### Evidence observed

Official platform information supported one processor model, while installer evidence identified the disk but not its protocol.

### Resolution or next action

Treat both hardware facts as unverified until local system output is captured.

### Lessons learned

Maintain an evidence-backed asset inventory.

### Status

Unresolved fact verification; both sources prescribe the same cautious treatment.

## 2026-07-21 — AI_LAB DNS failure associated with endpoint VPN services

> **Provenance and causal confidence:** This incident was introduced from the authorized DOCX source during Phase 3B reconciliation and is approved for inclusion. Functional recovery is supported by the post-change tests. Endpoint VPN background filtering remains the strongest supported association, but the exact responsible component and any vendor defect were not proven.

### Context

An AI_LAB client on VLAN 30 could reach its local gateway but could not complete DNS queries through the expected local resolver.

### Symptoms

Local DNS port tests and queries timed out. Direct use of a public resolver also timed out, which was consistent with the intended firewall policy.

### Initial hypotheses

The investigation considered local routing, OPNsense resolver behavior, firewall policy, packet visibility, and endpoint VPN state.

### Diagnostic actions

- Verified that the client selected the directly connected Ethernet route.
- Compared local and OPNsense-side resolver tests.
- Reviewed packet-capture observations.
- Inspected endpoint VPN application, adapter, process, and service state.
- Stopped the endpoint VPN and threat-protection services for a controlled retest.

### Evidence observed

- The gateway remained reachable.
- OPNsense resolved successfully through its recursive resolver.
- The failing-state capture did not show the expected client DNS packets reaching OPNsense.
- A disconnected VPN interface did not mean all endpoint VPN services were inactive.
- After the background services stopped, local DNS port and query tests succeeded.
- Direct external DNS remained blocked as intended.

### Root cause or current assessment

The strongest supported assessment is that endpoint VPN background filtering remained in the traffic path and affected local DNS. The evidence does not establish a proven vendor defect or identify a single service with certainty.

### Resolution or next action

The controlled test removed the endpoint VPN filtering layer from the test path by stopping its active background services and client process.

### Validation

Local resolver reachability and DNS queries succeeded after the change, while direct external DNS continued to time out under the intended policy.

### Lessons learned

Record endpoint VPN process, service, adapter, DNS, and route state before changing firewall or resolver configuration. Treat endpoint VPN software as part of the path until evidence excludes it.

### Status

Confirmed functional recovery; root-cause attribution remains a best-supported engineering assessment.
