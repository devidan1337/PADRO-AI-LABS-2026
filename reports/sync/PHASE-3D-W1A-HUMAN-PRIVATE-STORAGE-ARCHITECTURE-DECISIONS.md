# Phase 3D-W1A — Human Private Storage Architecture Decisions

> **architecture decision: `APPROVED`**  
> **implementation boundary: `NOT AUTHORIZED`**

## 1. Authority and scope

Final decision owner: **Dan**

This document is authoritative for the Wave 1 architecture decisions recorded below. It approves an architecture direction and a future test-only design checkpoint. It does not authorize encryption implementation, archive creation, production-data migration, key creation, mounts, backups, package installation, staging, committing, or pushing.

The Phase 3D-W1R architecture review is complete, and its recommendation is resolved by this human decision record. The Phase 3D-C3A deny-by-default access policy and all restrictions not expressly changed here remain in force. Phase 3D-W0 completed revalidation but did not authorize Wave 1 implementation.

## 2. Approved architecture direction

The preferred architecture is **Option B — a separately encrypted private archive inside WSL**.

The approved archive paths remain logical mount points:

- `/home/dev/pal-private-archive/active/`
- `/home/dev/pal-private-archive/legacy/`

Encrypted backing storage may reside elsewhere, but its exact location remains unapproved. The logical mount points must not silently accept plaintext when encrypted backing storage is unavailable or locked. Plaintext-fallback prevention must be tested successfully before production use.

This architecture decision does not create either logical path or any backing storage.

## 3. Host-volume encryption

Host-drive encryption remains a desired future defense-in-depth base layer. It is not currently implemented, and the current drive does not use BitLocker. The absence of host encryption does not authorize production use of the archive.

The archive-specific encryption lab may proceed independently using test data only, subject to the staged authorization gates in this record. Final host-encryption implementation remains unapproved.

## 4. Mount, unlock, and access policy

Automatic mounting is prohibited initially. Unlock and mount must be manual and Dan-controlled. The archive should remain locked when not actively needed, and mount duration should be minimized.

Agents receive no automatic access. Agent access remains governed by the previously approved deny-by-default policy: temporary agent read access requires Dan's approval, while agent write or deletion requires separate authorization. WSL root and Windows administrators may still access plaintext while the archive is unlocked; encryption does not remove that exposure.

## 5. Initial implementation boundary

The first implementation and recovery exercise must use test data only. It may not use any production PAL recovery files, logs, manifests, disposition artifacts, credentials, secrets, client data, or investigative evidence.

Production use requires successful testing of:

- unlock and lock;
- backup and restore;
- integrity;
- permissions; and
- plaintext-fallback prevention.

Production migration requires a separate owner decision by Dan.

## 6. Client and investigative material

Future client or investigative material requires a separate encrypted archive boundary from ordinary PAL artifacts. Shared keys, mixed retention, and mixed execution registers are not approved by this decision. The exact architecture for client or investigative evidence remains a future, case-specific decision.

## 7. Technology selection

The final encryption technology remains unselected. The next design checkpoint must compare, at minimum:

- a LUKS-backed virtual disk or block device; and
- a gocryptfs-style encrypted directory.

`fscrypt` and file-level encryption may remain secondary options where technically suitable. No package or technology is authorized for installation by this record.

Technology selection requires analysis of compatibility, metadata leakage, backup, restore, portability, mounting, and recovery. Dan must approve the final technology before implementation.

## 8. Approved future checkpoint

The following design and test checkpoint is approved as the next controlled learning phase:

**Phase 3D-C3E — WSL Private Archive Encryption Implementation and Recovery Test**

Only the checkpoint itself is approved. It must begin with technology comparison and must obtain explicit implementation authorization before installing or creating anything.

The required future stages are:

1. Compare candidate technologies.
2. Record owner technology selection.
3. Approve a test-only backing location.
4. Define key and recovery-key custody.
5. Authorize any required package installation.
6. Create a test archive with test data only.
7. Validate manual unlock and lock.
8. Validate mount and unmount.
9. Validate wrong-key and locked-state behavior.
10. Validate `0700` directories and `0600` files.
11. Validate agent and plaintext-fallback controls.
12. Create an encrypted test backup.
13. Simulate loss or corruption.
14. Restore in a controlled environment.
15. Compare hashes.
16. Document results without secrets.
17. Require Dan's approval before production use.

Each stage that changes system or storage state remains subject to its stated prior authorization gate. Authorization of the design comparison does not imply authorization of later implementation stages.

## 9. Authorization status

| Activity | Status |
|---|---|
| Wave 1 architecture review | Complete |
| Wave 1 architecture direction | Approved |
| Wave 1 implementation | Not authorized |
| Phase 3D-C3E design comparison | Authorized as the next review step |
| Package installation | Not authorized |
| Key creation | Not authorized |
| Container or disk creation | Not authorized |
| Mounts | Not authorized |
| Archive-directory creation | Not authorized |
| Backup creation | Not authorized |
| Production migration | Not authorized |
| Waves 2–9 | Not authorized |

## 10. Mandatory status block

- `architecture_decision_status: APPROVED`
- `preferred_architecture: OPTION_B_ENCRYPTED_ARCHIVE_INSIDE_WSL`
- `automatic_mount_status: PROHIBITED`
- `unlock_control: MANUAL_DAN_CONTROLLED`
- `test_data_only_status: REQUIRED`
- `production_use_status: NOT AUTHORIZED`
- `technology_selection_status: NOT SELECTED`
- `c3e_design_comparison_status: AUTHORIZED`
- `wave_1_implementation_status: NOT AUTHORIZED`
- `waves_2_through_9_status: NOT AUTHORIZED`
- `packages_installed: 0`
- `keys_created: 0`
- `containers_created: 0`
- `mounts_created: 0`
- `archives_created: 0`
- `backups_created: 0`
- `files_copied: 0`
- `files_moved: 0`
- `files_deleted: 0`
- `permissions_changed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 11. Validation record

Phase 3D-W1A is documentation-only. Exactly one file was created: this decision record. No existing file was modified. No package was installed. No key, encrypted container, virtual disk, mount, archive, backup, or test data was created. The Git index remained unchanged. Validation stopped without staging, committing, or pushing.
