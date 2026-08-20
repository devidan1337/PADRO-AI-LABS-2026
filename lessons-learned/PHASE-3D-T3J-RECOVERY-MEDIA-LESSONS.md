# Phase 3D T3J — Recovery Media Lessons Learned

## Context

The 2026-08-20 workflow correlated a physical USB across Windows, USBIPD, WSL, and Linux; applied a least-change package decision; created and validated a LUKS2/ext4 recovery medium; proved a synthetic lock/reopen recovery cycle; removed the synthetic artifact; returned the media to a locked, unmounted, unshared state; and promoted only secret-free technical evidence into canonical PAL.

No real recovery material was placed on the USB. These lessons inform the recovery-copy/custody gate and future Lab 14 ingestion/automation work.

## Engineering lessons

### 1. Simulate packages before installing

The initial broader `cryptsetup` simulation required 11 packages. Simulating the narrower `cryptsetup-bin` request reduced the transaction to one new package with no upgrades or removals. Package simulation was not administrative ceremony; it materially reduced change scope and the number of components that could complicate rollback or attribution.

Future privileged package work should treat a clean simulation as a mandatory decision gate and prefer the smallest package that provides the required capability.

### 2. Device nodes are observations, not identities

The recovery USB appeared as `/dev/sde` in this run, but `/dev/sdX` assignment is ephemeral. Reconnection order, WSL restart, other attached storage, and USBIPD behavior can change it.

The stronger identity was the cross-environment correlation anchored by serial `2371DC58`, then checked against model, capacity, VID:PID, current Windows disk number, current USBIPD BUSID, USB transport, and Linux block metadata. Destructive work must never be authorized by `/dev/sdX` alone.

### 3. Keep Windows Admin and canonical PAL separate

Privileged device execution occurred as `d4n@PADRO-WIN-CORE`; canonical repository custody remained `dev@PADRO-AI-CORE`. That boundary reduces the chance that administrative shell state, device access, credentials, or raw transcripts leak into the canonical documentation environment.

Future workflows should make environment role explicit: the privileged side performs the minimum approved device work, while canonical PAL receives reviewed, secret-free evidence and documentation only.

### 4. Promotion needs an explicit boundary

Raw execution evidence and canonical documentation have different trust and disclosure roles. Evidence should be finalized, screened, hashed, and verified in the execution environment before it is copied. Canonical PAL should then verify the destination bytes, classify identifiers, and generate narrative derivatives without modifying the raw artifacts.

This boundary makes it possible to preserve authoritative evidence while still producing a readable internal report, a runbook, lessons, and a sanitized portfolio candidate.

### 5. Full terminal transcription and interactive secrets do not mix

Full terminal recording can capture prompts, pasted values, recovery text, QR data, command history, screen content, and secret-derived errors. It should be disabled around interactive unlock and recovery work.

Evidence capture should use bounded, deliberately selected, secret-free commands before and after the interactive step. The record needs to prove state and outcome, not reproduce the secret-bearing interaction.

### 6. A manifest must not hash itself while it is being written

A hash manifest cannot reliably include its own final digest in the same write operation: adding the digest changes the file being hashed. The correct sequence is to finalize the evidence artifacts, generate a manifest over those artifacts only, and treat the manifest as a separate promotion object.

The T3J manifest correctly contains 11 artifact entries and does not include itself.

### 7. Verify copied bytes, not the old source path

The promoted manifest retained absolute paths from the execution environment. Running it unchanged in canonical PAL attempts to read those original paths; if the source is still reachable, such a check can accidentally prove the source twice while never reading the copies.

Destination verification must remap each entry to the expected canonical basename or relative path, execute within the destination directory, and fail on missing, extra, duplicate, or mismatched objects. Cross-environment transfer is complete only when the destination bytes match the source expectations.

### 8. Credential creation is not the completion condition

A credential is operationally useful only after custody and function are independently proven. The owner must verify that the intended credential is stored in the approved custody system and that a separate login/unlock/recovery exercise succeeds without relying on the creating session or leaking the value.

For the recovery medium, the owner-controlled reopen with the externally retained credential proved the technical half of that rule. The production recovery-copy/custody gate still must approve real material, independent copies, custody separation, and recovery usability.

### 9. Manual execution is valuable, but routine manual ingestion is too costly

The manual workflow exposed each necessary control: identity correlation, package simulation, destructive approval, interactive secret custody, state validation, hashing, teardown, secret screening, and evidence promotion. That makes it an excellent control-discovery exercise.

It also exposed substantial overhead. Routine ingestion should not require repeated hand assembly of terminal snippets, manifests, tables, reports, and captures. Future automation should absorb device identity capture, evidence collection, hashing, secret screening, report generation, and promotion while retaining explicit human approval for destructive actions, forced USB binding, credential entry, real recovery-material handling, custody decisions, and exception resolution.

## Automation design direction

The next automation layer should be fail-closed and split by privilege:

- Windows collection records disk, serial, VID:PID, BUSID, share, and attach state without selecting a device automatically.
- Linux collection records the resolved device graph, package simulation, LUKS/mount pre-state, and final locked state without formatting, unlocking, or mounting automatically.
- A manifest generator hashes a closed artifact set, excludes its own output, and uses relative paths.
- A promotion verifier checks destination bytes and rejects absolute-source revalidation.
- Secret screening runs before evidence leaves the privileged environment and again before canonical documentation is produced.
- Report and PADRO-capture generators consume an approved secret-free schema instead of raw terminal transcripts.
- Human gates remain mandatory for destructive device selection, package installation, forced USBIPD bind, interactive credentials, recovery-content writes, deletion, custody, and publication.

## Closure lesson

Technical success and operational authorization are different states. T3J proved that the offline LUKS2 medium can recover synthetic bytes and return to a locked, unmounted, unshared state. It did not authorize real recovery material. Preserving that distinction is the most important control carried into the next gate.
