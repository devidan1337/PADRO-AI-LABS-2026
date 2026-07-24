# VLAN 30 DNS Evidence-Regeneration Runbook

## 1. Purpose

This preparation-only runbook defines a repeatable, independently reviewable future DNS validation run. It is not authorization to execute the run.

## 2. Scope

The future run evaluates client addressing, routes, gateway and resolver reachability, UDP/TCP DNS, DHCP DNS, direct-external-DNS policy, OPNsense packet observations, Tailscale, endpoint VPN state, restoration, and final validation. It authorizes no OPNsense, firewall, resolver, DHCP, VLAN, route, adapter, DNS, or switch change.

## 3. Historical-item disclaimer

The original item 41 package is `HISTORICAL_NARRATIVE_UNVERIFIED`. Never combine unrelated historical files to reconstruct its custody. A new run has a new identity, date, and run ID and neither retroactively verifies nor disproves the old PASS narrative.

## 4. Required equipment

- Preferred: Device A for management/capture control and Device B as the Windows test endpoint.
- Constrained: one Ethernet-capable device, only after confirming capture persistence and safe recovery of management.
- EdgeSwitch access to ports 1 and 3; authorized OPNsense GUI credentials; UTC-capable clocks; sufficient private storage.
- Human operator, capture reviewer, and separate approver for State C.

## 5. Preferred two-device topology

Device A remains on Management LAN/VLAN 1, EdgeSwitch port 1, expected address `192.168.10.x`, gateway `192.168.10.1`; it controls OPNsense capture. Device B remains on AI_LAB VLAN 30, port 3, expected address `10.10.30.x`; it runs endpoint tests. Confirm both roles before collection.

## 6. One-device constrained topology

Prepare capture from management, manually reconnect to VLAN 30, test, reconnect to management, then stop/export. Expect loss of management and session loss. Capture continuity is not assumed: first confirm OPNsense continues capture after management-client disconnect. Stop if capture cannot remain bounded and safely controllable, the GUI session is required to sustain capture, management cannot be regained, or capture state is uncertain.

## 7. Management requirements

> Connection gate — Network: Management LAN/VLAN 1. EdgeSwitch: port 1. Expected client: `192.168.10.x`; gateway: `192.168.10.1`. Read-only/configuration-free: yes. Separate approval: required for live execution, but not for an OPNsense configuration change (none is authorized).

Use this connection for GUI inspection, capture setup/control/export, and configuration verification. Never instruct an OPNsense firewall, DNS, routing, or interface change from VLAN 30.

## 8. AI_LAB requirements

> Connection gate — Network: AI_LAB VLAN 30. EdgeSwitch: port 3. Expected client: `10.10.30.x`; local resolver/gateway role: OPNsense VLAN 30 interface. Read-only/configuration-free: yes. Separate approval: required for live execution.

Use this connection for client DNS, route, VPN, and Tailscale tests. Stop before tests if the expected address class cannot be verified.

## 9. Stop conditions

> Connection gate — Verify the gate for the action about to run: management actions use VLAN 1/port 1/`192.168.10.x`; client tests use VLAN 30/port 3/`10.10.30.x`. Read-only: yes. Separate approval: live-run approval required.

Stop on wrong network/port/address class; inability to maintain bounded capture control; output beneath Git; existing run directory; unexpected configuration drift; credential exposure; clock failure; unapproved State C; loss of Tailscale contrary to the test plan; failed restoration; or uncertain artifact identity. Record `BLOCKED` or `NOT_RUN`; do not fabricate an artifact.

## 10. Evidence-directory creation

> Connection gate — Network activity: none. EdgeSwitch port: not applicable. Expected address class: not applicable. Read-only: no (private filesystem creation only). Separate approval: future evidence-run approval required.

Create `/home/dev/pal-evidence-private/network-dns-validation/<RUN_ID>/` with run ID `YYYYMMDDTHHMMSSZ-<short-random-suffix>`. Require mode `700` on the run directory and `raw/`, `sanitized/`, `metadata/`, `logs/`; require `600` on evidence, manifests, and metadata. Refuse an existing destination and any path under the repository. Raw originals remain private and outside Git.

## 11. State A — initial baseline

> Connection gate — Network: AI_LAB VLAN 30. EdgeSwitch: port 3. Expected client: `10.10.30.x`. Read-only: yes. Separate approval: live-run approval required; State C approval is not applicable.

Record UTC time, network/port confirmation, address/subnet, DHCP DNS, directly connected and default routes, interfaces, VPN adapters/services/processes, Tailscale, gateway reachability, TCP/53 reachability, local DNS, and external-DNS negative control. Change nothing. TCP/53 alone is not DNS success; intermittent answers are `PARTIAL` or `INCONCLUSIVE`.

## 12. State B — packet-observed baseline

> Connection gate — Device A: Management LAN/VLAN 1, port 1, `192.168.10.x`. Device B: AI_LAB VLAN 30, port 3, `10.10.30.x`. Read-only: yes except bounded evidence-file creation. Separate approval: live-run and capture approval required.

Start the bounded “before” capture from Device A. From Device B run exactly one controlled UDP local-resolver query, one TCP local-resolver query, and one direct-external-resolver negative control. Record request arrival and response return separately. Missing packets in one capture do not locate the drop.

## 13. Approval boundary before State C

> Connection gate — Review/approval may occur off-network; if inspecting OPNsense use Management VLAN 1/port 1/`192.168.10.x`; if inspecting the endpoint use VLAN 30/port 3/`10.10.30.x`. Read-only: yes until approval. Separate approval: mandatory.

Pause. Obtain explicit human approval naming each endpoint VPN component that may be stopped and the restoration plan. No approval may include OPNsense, firewall, resolver, route, DNS, adapter, VLAN, DHCP, switch, or Tailscale changes.

## 14. State C — controlled endpoint VPN-layer retest

> Connection gate — Network: AI_LAB VLAN 30. EdgeSwitch: port 3. Expected client: `10.10.30.x`. Read-only: no for explicitly approved endpoint VPN component stop; all tests are observational. Separate approval: mandatory and component-specific.

Record all relevant process, adapter, and service states. Stop only named, approved endpoint VPN components; do not disable adapters or change routes/DNS. Repeat the exact State B queries under a separate bounded “after” capture controlled from VLAN 1. Record changes. Improvement is `FUNCTIONAL_RECOVERY`, not proof of a defective product or vendor.

## 15. State D — restoration

> Connection gate — Network: AI_LAB VLAN 30. EdgeSwitch: port 3. Expected client: `10.10.30.x`. Read-only: no (restore only components changed in State C). Separate approval: covered only by the component-specific State C approval.

Restore every changed endpoint VPN component to its recorded before state. Verify services, processes, adapters, routes, DNS, and Tailscale. Record success/failure. If any restoration fails, stop, mark the run `FAIL`/`BLOCKED`, and escalate; do not proceed as successful.

## 16. State E — final validation

> Connection gate — Device A: Management VLAN 1/port 1/`192.168.10.x`; Device B: AI_LAB VLAN 30/port 3/`10.10.30.x`. Read-only: yes except bounded evidence creation. Separate approval: live-run/capture approval required.

Repeat local UDP DNS, local TCP DNS, direct external DNS negative control, Tailscale state, route selection, and packet verification after restoration. Preserve observed packets and responses separately from interpretation.

## 17. OPNsense packet-capture procedure

> Connection gate — Configure/control/export only from Management LAN/VLAN 1, EdgeSwitch port 1, expected `192.168.10.x`, gateway `192.168.10.1`. Read-only/configuration-free: yes; evidence capture writes files. Separate approval: live capture approval required.

Select the OPNsense VLAN 30 interface by role and verify it without changing configuration. Filter to the test client and `(udp port 53 or tcp port 53)`; avoid unrelated full-interface traffic. Use an approved short time limit (recommended 120 seconds) or packet ceiling (recommended 500), whichever occurs first. Create distinct before/after `.pcapng` files. Privately record interface role, exact filter, UTC start/stop, tool/version, size, and SHA-256. Do not publish exact client addresses. Never use promiscuous, unlimited, or unrelated capture.

For one-device mode, prepare/start the bounded capture on VLAN 1; confirm server-side continuation after disconnect; reconnect to VLAN 30 and test; reconnect to VLAN 1; stop/export. If persistence or safe stop is uncertain, do not begin.

## 18. Windows collection-script procedure

> Connection gate — Network: AI_LAB VLAN 30. EdgeSwitch: port 3. Expected client: `10.10.30.x`. Read-only: yes, apart from private artifact creation. Separate approval: live collection approval required.

Review the script first. Supply the explicit absolute repository root used only as a deny boundary, an absolute outside-repository output path, run ID, runtime local resolver, explicit expected three-octet VLAN prefix, benign domain, external resolver, and optional product-neutral VPN service patterns. Do not place credentials in arguments. The collector refuses a wrong address class and performs no service, adapter, route, DNS, firewall, OPNsense, upload, derivative, or Git change.

## 19. Manifest generation

> Connection gate — Network activity: none. EdgeSwitch port/address: not applicable. Read-only: reads evidence and writes private metadata. Separate approval: evidence-run approval required.

Generate `metadata/MANIFEST.json` only after artifact closure. Each entry carries schema/run IDs, relative path, role/state/device, UTC capture time, tool/version, command ID, size/hash/type, privacy/test/status, parent hash if derivative, sanitization/reviewer states, and nonsensitive notes. Run metadata includes operator, topology, both connection/port confirmations, expected/observed address classes, changes, restoration, and overall status. Publication derivatives omit raw addresses, usernames, MACs, VPN endpoints, and credentials.

## 20. Hash verification

> Connection gate — Network activity: none. EdgeSwitch port/address: not applicable. Read-only: yes, except writing a report outside Git. Separate approval: no additional approval after run authorization.

Independently recompute SHA-256 and sizes from closed files; compare to manifest and ledger. Never hash a mutable capture as final. A mismatch is `FAIL` and stops publication.

## 21. Sanitized derivative procedure

> Connection gate — Network activity: none. EdgeSwitch port/address: not applicable. Read-only: no (new derivative only; raw parent remains immutable). Separate approval: explicit sanitization/publication preparation approval required.

Copy from raw into `sanitized/`; never overwrite raw. Classify each file `PRIVATE_RAW`, `PRIVATE_CONFIGURATION`, `REQUIRES_REDACTION`, `PUBLIC_READY`, or `DO_NOT_PUBLISH`. Redact internal address/subnet, public endpoint, hostname, username, email, MAC, device/interface identifier, certificate fingerprint, VPN endpoint/transport, physical-location clue, credential-like material, and sensitive firewall/routing detail.

Preserve test purpose, command category, expected-route use, local-resolver reachability, query/response observation, truth status, sequence-capable timestamps, and parent hash. Do not create a derivative when safe redaction would destroy evidentiary meaning.

## 22. Chain-of-custody verification

> Connection gate — Network activity: none. EdgeSwitch port/address: not applicable. Read-only: yes, except an outside-repository validation report. Separate approval: no additional approval after review authorization.

Verify permissions, hashes, sizes, timestamps, tools, test steps, reviewer fields, and all raw-parent relationships. A derivative without its raw-parent hash is incomplete. Distinguish raw observation, configuration state, transformation, human interpretation, and publication decision.

## 23. Result classification

> Connection gate — Network activity: none. EdgeSwitch port/address: not applicable. Read-only: yes. Separate approval: human reviewer sign-off required.

Every test uses `PASS`, `FAIL`, `PARTIAL`, `INCONCLUSIVE`, `NOT_RUN`, or `BLOCKED`. Every substantive conclusion uses `VERIFIED_OBSERVATION`, `VERIFIED_CONFIGURATION_STATE`, `FUNCTIONAL_RECOVERY`, `WORKING_THEORY`, `INFERENCE`, or `UNRESOLVED_CLAIM`.

Do not convert port reachability to DNS success, a late answer to unqualified PASS, recovery after a stop to root-cause proof, VPN correlation to vendor defect, or absent captured packets to a proven drop location. No vendor defect is claimed without independent demonstration.

## 24. Rollback and restoration

> Connection gate — Network: AI_LAB VLAN 30, port 3, expected `10.10.30.x`; use Management VLAN 1/port 1/`192.168.10.x` only for capture control. Read-only: no for restoration of approved State C changes. Separate approval: component-specific State C approval required.

Use the before-state record as the restoration target. Restore only what State C changed. Validate services, processes, adapter presence/state, routes, DNS, Tailscale, and the final DNS set. Record failures and stop.

## 25. Human-review checklist

> Connection gate — Network activity: none unless reopening private OPNsense context from Management VLAN 1/port 1/`192.168.10.x`. Read-only: yes. Separate approval: reviewer sign-off required.

- New run ID/date and outside-Git private root; permissions correct.
- Topology and port/address confirmations recorded for every state.
- No unauthorized configuration change; State C approval attached; restoration verified.
- Captures bounded/filtered and before/after distinct.
- Every manifest entry has status; blocked/not-run tests need no fabricated file.
- Hashes, sizes, timestamps, tools, commands, and ledger links verify.
- Observation and inference are separated; no historical or vendor claim is upgraded.
- Sanitized files contain no listed sensitive categories and retain evidentiary meaning.

## 26. Publication decision boundary

> Connection gate — Network activity: none. EdgeSwitch port/address: not applicable. Read-only: decision/review only. Separate approval: explicit human publication approval required.

Only reviewed `PUBLIC_READY` derivatives may be considered for Git or publication in a later authorized phase. Raw/private/configuration/do-not-publish material remains outside Git. Publication never promotes the historical candidate and never claims the new run verifies the old run.

Future item 41 options are: retain it as an explicitly unverified historical narrative, or supersede it with the new package while explicitly denying cross-run verification. Phase 3C-2B makes neither disposition.
