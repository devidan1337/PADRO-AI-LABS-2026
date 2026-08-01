# Phase 3D-C3E-T3H — Production Runbook, Recovery Custody, Backup Architecture, and Canary Migration Design

> **design status: `COMPLETE`**
>
> **implementation status: `NOT AUTHORIZED`**
>
> **scope: DOCUMENTATION AND DESIGN ONLY**

## 1. Authority, evidence, and boundary

Final human decision owner: **Dan**

This design implements the decisions recorded in T3G and retains the successful T3D initialization/mount evidence, T3F backup/restore evidence, T1 technology analysis, T2 compatibility findings, and W1A private-storage architecture controls.

T3H defines future procedures and gates only. It does not create a production path or script, initialize or mount storage, select or enter a password, generate recovery material, connect or configure a backup device, copy or migrate data, enable BitLocker, install a package, perform LUKS work, or modify the retained disposable environment.

## 2. Production vault model

- `production_vault_model: SINGLE_OPERATIONAL_VAULT`
- `production_ciphertext_path: /home/dev/.pal-private-cipher/archive/`
- `production_plaintext_mountpoint: /home/dev/pal-private-archive/`
- `future_client_data_boundary: SEPARATE_ENCRYPTED_STORE_REQUIRED`
- `future_investigative_data_boundary: SEPARATE_ENCRYPTED_STORE_REQUIRED`

The single production vault is limited to private PAL operational material. When mounted, its plaintext root is designed to contain:

- `/home/dev/pal-private-archive/active/`
- `/home/dev/pal-private-archive/legacy/`

The ciphertext directory and plaintext mountpoint are separate paths. The logical `active/` and `legacy/` directories exist only inside the successfully verified mounted view; the design must not create writable fallback subdirectories beneath an unmounted plaintext path.

Client data, investigative material, legal evidence, regulated data, credentials, authentication material, and high-sensitivity secrets must not share this vault. Future client and investigative use requires separate encrypted stores, keys, custody, retention rules, execution registers, and explicit authority.

No production path is authorized for creation by T3H.

## 3. Production password custody

- `production_password_manager: BITWARDEN`
- `production_password_storage: APPROVED_PASSWORD_MANAGER`
- `production_password_owner: DAN`
- `production_password_generation: UNIQUE_HIGH_ENTROPY`
- `password_reuse: PROHIBITED`
- `password_agent_access: PROHIBITED`
- `password_in_git_or_reports: PROHIBITED`
- `password_in_arguments: PROHIBITED`
- `password_in_environment_variables: PROHIBITED`
- `password_in_scripts: PROHIBITED`
- `password_in_shell_history: PROHIBITED`
- `password_in_chat_or_prompts: PROHIBITED`

Bitwarden may hold the routine production password. Dan alone selects and controls it during a later initialization checkpoint. It must be unique, high entropy, and unrelated to personal, email, GitHub, SSH, banking, client, Bitwarden-master, recovery-USB, or other credentials.

The routine password must enter gocryptfs only through Dan's interactive terminal entry. Scripts and agents must never accept it through an argument, option, environment variable, file, pipe, standard input redirection, prompt relay, clipboard capture, or automation interface.

Bitwarden must not contain the actual gocryptfs emergency recovery material. T3H neither selects nor generates any password.

## 4. Hybrid recovery custody

- `recovery_model: TWO_PRINTED_PLUS_ENCRYPTED_USB`

The future production recovery set consists of three independently inventoried copies:

1. sealed printed recovery copy 1, intended for a home fire-resistant safe;
2. sealed printed recovery copy 2, intended for a separate trusted secure location; and
3. one encrypted offline USB stored at a third location, separate from both printed copies.

Design requirements:

- both printed envelopes must be tamper-evident;
- the two printed copies must not share a location;
- the recovery USB must normally remain disconnected;
- the recovery USB must not be the ciphertext backup drive;
- its encryption password must differ from the production gocryptfs password;
- the USB password may be stored in Bitwarden;
- actual gocryptfs recovery material must not be stored in Bitwarden or any cloud service;
- the routine password and recovery material must not be colocated;
- every copy requires an inventory entry and a non-secret vault identifier; and
- inventory records may identify custody category, seal state, review date, and recovery-copy identifier, but never material values or hints.

No physical address, actual secret, recovery value, USB device, encryption method, or custody location is selected in T3H.

## 5. Recovery inspection cadence

- `physical_seal_check: EVERY_6_MONTHS`
- `usb_readability_test: EVERY_6_MONTHS`
- `full_recovery_inventory_review: ANNUAL`
- `usb_decryption_test: ANNUAL`
- `cold_start_archive_restore_test: ANNUAL`
- `recovery_material_rotation_review: AFTER_PASSWORD_OR_CONFIGURATION_CHANGE`

| Review | Secret-free proof objective |
|---|---|
| Physical seal check | Confirms each printed package is present, has the expected non-secret identifier, and shows no unexplained tamper evidence; contents need not be exposed to the recorder |
| USB readability test | Confirms the intended offline device is physically available and readable at the device/filesystem level without copying recovery material into reports or agents |
| Full recovery inventory review | Reconciles all three expected copies, custody categories, identifiers, last-check dates, and exceptions without recording secrets |
| USB decryption test | Dan proves the offline USB can be unlocked with its separately held credential and that the expected recovery item is available; evidence records outcome only |
| Cold-start archive restore test | Proves recovery from a cold host/WSL start, compatible tooling, ciphertext backup, interactive password control, mount verification, plaintext hash validation, and explicit teardown |
| Rotation review | Determines whether password/configuration changes require recovery copies, identifiers, seals, inventories, or old-copy disposition to be updated under separate authority |

Inspections must minimize exposure. Reports record dates, identifiers, pass/fail outcomes, exceptions, and owner acknowledgment—not password values, master keys, recovery text, hints, photographs, or screenshots.

## 6. Production backup architecture

- `production_backup_model: STAGED_MULTI_COPY`
- `initial_off_device_backup: OFFLINE_EXTERNAL_DRIVE`
- `backup_content: COMPLETE_GOCRYPTFS_CIPHERTEXT_TREE`
- `plaintext_backup: PROHIBITED`
- `drive_connected_only_during_backup: REQUIRED`
- `post_backup_disconnect: REQUIRED`
- `source_and_backup_hash_validation: REQUIRED`
- `backup_manifest: REQUIRED`
- `backup_delete_mirroring: PROHIBITED`
- `single_external_drive_as_final_architecture: NOT_APPROVED`
- `future_offsite_backup: REQUIRED_BEFORE_HIGH_SENSITIVITY_USE`
- `future_luks_external_backup: PREFERRED_PENDING_TEST`

The initial future production backup stage uses a separately authorized offline external drive. The complete gocryptfs ciphertext tree—including required configuration and directory metadata—is copied while plaintext backup is prohibited. The backup workflow must inventory relative paths, object types, ownership, modes, sizes, practical timestamps, and regular-file SHA-256 values before and after copying.

The external drive is connected only for an authorized backup or restore operation and disconnected afterward. Backup logic must be copy/version oriented and must never mirror deletion automatically. Unexpected links, devices, sockets, FIFOs, mount states, or manifest mismatches cause an immediate stop.

The external ciphertext-backup drive and encrypted recovery USB are distinct physical devices with different purposes, data, custody, connection cadence, and failure domains. Neither substitutes for the other.

One external drive is an initial stage, not the final architecture. A later separate or off-site encrypted copy is required before high-sensitivity use. A LUKS-protected external backup is preferred only after the separate LUKS test and decision sequence succeeds.

T3H does not select, connect, purchase, partition, format, mount, encrypt, or approve a particular device or service.

## 7. Canary scope and candidate worksheet

- `canary_item_count: 3_TO_5`
- `canary_max_total_size: 25_MB`
- `canary_observation_period: 14_DAYS`
- `source_preservation: REQUIRED`
- `external_ciphertext_backup: REQUIRED`
- `restore_validation: REQUIRED`
- `source_deletion_during_canary: PROHIBITED`

Eligible canary items must be explicitly selected private PAL operational material, low sensitivity, replaceable or reconstructable, and free of credentials, secrets, client data, investigative material, legal evidence, regulated material, production recovery material, or irreplaceable master copies. Ambiguous classification means not selected.

The future canary worksheet must use this blank structure; T3H does not populate it from existing files:

| Candidate identifier | Source path | Classification | Reason eligible | Replaceability assessment | Size | Prohibited-data screening | Source SHA-256 | Owner approval | Final decision |
|---|---|---|---|---|---:|---|---|---|---|
| _To be assigned_ | _To be owner-approved_ | _Low-sensitivity private PAL operational_ | _Pending_ | _Pending_ | _Pending_ | _Pass/Fail with secret-free rationale_ | _Pending_ | _Dan: Approved/Rejected_ | _Selected/Not selected_ |

The approved worksheet must identify 3–5 items totaling no more than 25 MB. It belongs in an appropriately private execution record and must not expose prohibited data through descriptions or paths.

## 8. Copy-first canary procedure

No copy is authorized in T3H. A later implementation must:

1. load the exact owner-authorized candidate list and reject any unlisted item;
2. recheck source existence, regular-file/object type, classification, size total, and prohibited-data screening;
3. calculate and record each source SHA-256 before copying;
4. prove the production vault is successfully mounted at the exact approved target from the exact approved ciphertext source as `fuse.gocryptfs` in the writing process's namespace;
5. copy rather than move, with narrowly scoped destinations;
6. calculate each destination SHA-256 immediately after copying;
7. require exact source/destination hash equality;
8. record a private execution-register entry with identifiers, paths, sizes, hashes, timestamps, mount evidence, and outcome;
9. preserve every source artifact throughout the canary; and
10. stop immediately on any mismatch, unexpected mount/type/source/target, fallback-path risk, permission discrepancy, unauthorized object, classification ambiguity, or prohibited-data finding.

No mismatch may trigger automatic repair, overwrite, recopy, deletion, or retry.

## 9. Helper-script architecture

- `production_mount_workflow: REVIEWED_HELPER_SCRIPTS`
- `mount_invocation: HUMAN_INITIATED`
- `password_entry: DAN_INTERACTIVE_ONLY`
- `agent_initiated_mount: PROHIBITED`
- `automatic_startup_mount: PROHIBITED`
- `mount_script_fail_closed: REQUIRED`
- `mount_failure_mode_restore: 0500`
- `exact_mount_verification: REQUIRED`
- `unmount_script: REQUIRED`
- `post_unmount_fallback_test: REQUIRED`
- `shell_aliases: DEFERRED_NEAR_TERM`
- `aliases_as_thin_wrappers_only: REQUIRED`
- `scripts_require_disposable_test: REQUIRED_BEFORE_PRODUCTION`

The following are future script designs only; no script is created by T3H.

### 9.1 `scripts/private-archive-mount.sh`

| Design element | Requirement |
|---|---|
| Purpose | Fail-closed preparation, human-interactive gocryptfs invocation, and exact post-mount verification |
| Preconditions | User exactly `dev`; gocryptfs expected version; ciphertext path exactly `/home/dev/.pal-private-cipher/archive/`; plaintext path exactly `/home/dev/pal-private-archive/`; both real directories, not links; target empty and unmounted; `dev:dev`; mode `0500`; no prohibited automount configuration; clean fallback probe |
| Allowed state changes | Change only the plaintext mountpoint `0500`→`0700`; invoke the fixed-path gocryptfs mount interactively; restore `0500` if mount does not verify |
| Stop conditions | Wrong user/version/path/type/owner/mode; nonempty target; any existing or ambiguous mount; fallback write success/residue; unexpected object; unavailable FUSE; failed mount; source/target/type mismatch |
| Expected output | Secret-free timestamped pass/stop messages, observed version, path checks, fallback outcome, exact mount source/target/type, and final mode; no secret-bearing command output |
| Secret handling | Never accept password by argument, environment, file, pipe, agent, log, or script input; Dan interacts directly with gocryptfs |
| Mount verification | Require exact target `/home/dev/pal-private-archive/`, source relationship to `/home/dev/.pal-private-cipher/archive/`, `fuse.gocryptfs`, expected UID/GID, and independent `/proc/self/mountinfo` confirmation |
| Error recovery | If no verified mount exists, ensure target empty and return `0500`; if an unexpected mount exists, do not unmount blindly—preserve state and stop for owner review |
| Audit evidence | Record secret-free preflight, permission transitions, mount IDs/type/source/target, exit status, and stop reason in the private execution register |

### 9.2 `scripts/private-archive-status.sh`

| Design element | Requirement |
|---|---|
| Purpose | Read-only classification of locked, correctly mounted, unexpected-mounted, or inconsistent state |
| Preconditions | User can inspect exact paths and mount namespace; no state-changing authority required |
| Approved paths | Only the exact ciphertext and plaintext paths defined in Section 2 |
| Allowed state changes | None |
| Stop conditions | Symlink, missing/extra path, inaccessible metadata, ambiguous namespace, unexpected filesystem/source/target, nonempty unmounted target, or mode inconsistent with state |
| Expected output | One clear secret-free state plus observed owner/mode, gocryptfs version, and exact mount evidence |
| Secret handling | Must never request a password or read configuration contents/recovery material |
| Mount verification | Use `findmnt` and `/proc/self/mountinfo`; process presence alone is insufficient |
| Error recovery | None automatically; recommend the appropriate reviewed mount, unmount, or incident workflow |
| Audit evidence | Optional secret-free status record with timestamp and state code; never enumerate plaintext content by default |

### 9.3 `scripts/private-archive-unmount.sh`

| Design element | Requirement |
|---|---|
| Purpose | Verify expected production mount, explicitly unmount, restore fail-closed mode, and prove fallback writes fail |
| Preconditions | Exact expected target is mounted from the approved source as `fuse.gocryptfs`; user is `dev`; no unexpected nested mount or unclear busy process |
| Allowed state changes | Explicit FUSE unmount; change only plaintext mountpoint to `0500`; one controlled fallback probe that must leave no artifact |
| Stop conditions | Unexpected source/type/target, busy/unmount failure, retained mount, nonempty underlying mountpoint, ownership mismatch, fallback success/residue, automatic remount, or unknown process |
| Expected output | Secret-free verification, unmount result, final owner/mode/emptiness, probe outcome, retained-process check, and remount check |
| Secret handling | Never request, handle, or log a password or recovery material |
| Mount verification | Verify before unmount and verify absence afterward through both mount-information mechanisms |
| Error recovery | Preserve state; never force-delete, kill broadly, or unmount an unexpected filesystem; stop for owner review |
| Audit evidence | Record expected mount facts, unmount method/outcome, final `0500` state, fallback result, and exceptions |

Aliases are deferred. If later approved, they must be thin wrappers that invoke reviewed scripts without changing arguments, paths, secret flow, validation, or error handling.

## 10. Manual mount runbook design

This future procedure is not authorized for execution by T3H:

1. verify current identity is exactly the authorized owner `dev`;
2. verify exact real ciphertext `/home/dev/.pal-private-cipher/archive/` and plaintext `/home/dev/pal-private-archive/` paths, rejecting links and substitutions;
3. confirm the plaintext mountpoint is not mounted using `findmnt` and `/proc/self/mountinfo`;
4. confirm the mountpoint is empty;
5. confirm ownership is `dev:dev`;
6. confirm fail-closed numeric mode `0500`;
7. perform exactly one controlled fallback-write probe, require permission denial, and confirm no probe remains;
8. temporarily set only the plaintext mountpoint to `0700`;
9. invoke gocryptfs with fixed source and target through Dan-controlled interactive password entry;
10. verify the exact FUSE mount using `findmnt` and `/proc/self/mountinfo`;
11. verify source, target, filesystem type, UID/GID, and namespace relationship; and
12. if mount execution or verification fails, confirm no mount exists, ensure the target is empty, restore `0500`, record a secret-free stop, and do not retry automatically.

No password, mount, permission change, or execution is authorized here.

## 11. Explicit unmount runbook design

The future reviewed unmount procedure must:

1. verify the exact expected production mount;
2. reject and preserve any unexpected source, target, filesystem type, or namespace state;
3. perform an explicit locally appropriate FUSE unmount;
4. prove the exact mount is absent using `findmnt` and `/proc/self/mountinfo`;
5. prove the underlying plaintext mountpoint is empty;
6. restore only that mountpoint to `0500` while preserving `dev:dev`;
7. perform exactly one controlled fallback-write probe and require failure;
8. prove no probe remains;
9. check for retained gocryptfs or open-file processes associated with the mount;
10. wait a defined short interval and prove no automatic remount occurred; and
11. record secret-free outcome evidence.

It must not force an unexpected unmount, kill unrelated processes, clean content, or weaken the locked state.

## 12. Lost-password incident procedure

- `lost_password_response: CONTROLLED_INCIDENT_PROCEDURE`
- `repeated_password_attempts: STOP_AFTER_3_FAILURES`
- `ciphertext_modification_during_incident: PROHIBITED`
- `pre_recovery_ciphertext_backup: REQUIRED`
- `recovery_material_use: DAN_EXPLICIT_AUTHORIZATION_REQUIRED`
- `agent_access_to_recovery_material: PROHIBITED`
- `recovery_attempt_evidence: SECRET_FREE_ONLY`
- `failed_recovery_escalation: PRESERVE_AND_STOP`

Decision tree:

```text
Start incident
  |
  +-- Verify exact non-secret vault identifier and approved ciphertext path
  |     `-- mismatch/uncertainty -> preserve and stop
  |
  +-- Verify plaintext mount state; do not write or initialize
  |     `-- unexpected mount -> preserve and escalate
  |
  +-- Confirm expected configuration/ciphertext artifacts exist without reading protected content
  |     `-- missing/changed -> preserve and stop
  |
  +-- Confirm installed gocryptfs version and known-compatible environment
  |     `-- unexpected -> stop before package or format changes
  |
  +-- Dan verifies the intended Bitwarden entry, keyboard layout, and Caps Lock
  |
  +-- Attempt routine password only under owner control
  |     +-- success -> verify mount, record outcome, follow explicit unmount runbook
  |     `-- failure count reaches 3 -> stop routine attempts
  |
  +-- Verify current ciphertext backup state and create a separately authorized
  |   pre-recovery ciphertext backup before any emergency workflow
  |
  +-- Decide whether emergency recovery is actually necessary
        +-- no -> preserve and resolve custody/version/path issue
        `-- yes -> require later explicit Dan-controlled recovery authorization
                  with agents excluded from recovery material
```

This design intentionally provides no emergency recovery command. Any master-key or recovery-material use requires a later explicit owner-controlled authorization. Evidence may record identifiers, checks, attempt count, versions, mount state, backup state, decision, and outcome only—not passwords, hints, recovery values, screenshots, or secret-bearing output.

## 13. Backup and restore cadence

- `ciphertext_backup_frequency: AFTER_EACH_MATERIAL_CHANGE`
- `minimum_backup_frequency: WEEKLY`
- `canary_restore_test: ONCE_DURING_14_DAY_PERIOD`
- `post_configuration_change_restore_test: REQUIRED`
- `full_production_restore_test: QUARTERLY`
- `annual_cold_start_recovery_test: REQUIRED`
- `backup_manifest: REQUIRED`
- `backup_versioning: REQUIRED_WHEN_SUPPORTED`
- `backup_delete_mirroring: PROHIBITED`

A material change includes:

- an artifact addition or removal;
- directory restructuring;
- a gocryptfs configuration change;
- a password change;
- a backup-tool change; or
- a backup-device change.

Backup after each material change is the target cadence, with weekly as the minimum even when no material change is recognized. Every backup requires a versioned, relative ciphertext manifest with counts, structure, object types, SHA-256 values, metadata, source identifier, backup identifier, and secret-free outcome. Deletions must not propagate automatically.

Restore tests use isolated destinations, exact manifest comparison, Dan-controlled interactive mount, plaintext reference hashes, explicit unmount, and fail-closed teardown. Configuration or password changes trigger an immediate separately authorized restore validation because they affect recoverability.

## 14. Broad-migration gates

- `canary_observation_period_completed: REQUIRED`
- `canary_mount_cycles_successful: MINIMUM_5`
- `canary_unmount_cycles_successful: MINIMUM_5`
- `fallback_write_controls_passed: REQUIRED`
- `external_ciphertext_backup_completed: REQUIRED`
- `external_backup_hash_validation: REQUIRED`
- `canary_restore_test_completed: REQUIRED`
- `restored_plaintext_hash_validation: REQUIRED`
- `helper_scripts_tested_on_disposable_environment: REQUIRED`
- `helper_scripts_tested_on_canary: REQUIRED`
- `password_custody_confirmed: REQUIRED`
- `recovery_copy_inventory_confirmed: REQUIRED`
- `usb_recovery_copy_validated: REQUIRED`
- `incident_runbook_reviewed: REQUIRED`
- `unexpected_plaintext_writes: 0`
- `integrity_failures: 0`
- `unresolved_mount_failures: 0`
- `broad_pal_operational_migration: REQUIRES_POST_CANARY_HUMAN_AUTHORIZATION`
- `automatic_canary_graduation: PROHIBITED`
- `client_data_expansion: SEPARATE_AUTHORIZATION_REQUIRED`
- `investigative_data_expansion: SEPARATE_AUTHORIZATION_REQUIRED`
- `credential_storage_expansion: SEPARATE_AUTHORIZATION_REQUIRED`
- `high_sensitivity_expansion: BLOCKED_PENDING_HOST_ENCRYPTION`

The 14-day clock starts only after a valid canary implementation is complete and its evidence baseline is recorded. All gates are cumulative. A minimum count is not a target to automate; each mount/unmount cycle must be owner-initiated, authorized, verified, and recorded. Any unresolved failure prevents graduation.

Passing every gate only makes the canary eligible for human review. It does not authorize broad migration automatically.

## 15. Canary rollback design

- `canary_rollback_model: PRESERVE_AND_STOP`
- `automatic_cleanup_on_failure: PROHIBITED`
- `automatic_repair: PROHIBITED`
- `source_artifact_preservation: REQUIRED`
- `ciphertext_preservation: REQUIRED`
- `external_backup_preservation: REQUIRED`
- `retry_requires_human_authorization: REQUIRED`

Future rollback sequence:

1. stop new writes, copies, mounts, retries, and automation;
2. record the exact secret-free state, time, error, paths, mount evidence, and affected candidate identifiers;
3. if mounted and the mount is verified and stable, follow the reviewed explicit-unmount procedure; otherwise preserve the unexpected state for owner review rather than forcing teardown;
4. preserve original source artifacts and their pre-copy hashes;
5. preserve production ciphertext, configuration, manifests, and metadata without repair;
6. preserve the external ciphertext backup and keep it disconnected after safe completion of the authorized operation;
7. verify no fallback plaintext file appeared and quarantine the workflow—not the evidence—if one did;
8. compare available manifests read-only and classify the failure without modifying data;
9. document owner decisions and required new authority; and
10. retry, repair, restore, remove, or clean up only after a separate Dan authorization.

Rollback is preservation, not deletion or reversal by assumption.

## 16. BitLocker and host-encryption direction

- `host_encryption_timing: AFTER_CANARY_START_BEFORE_BROAD_MIGRATION`
- `limited_canary_without_host_encryption: AUTHORIZED_WITH_RESTRICTIONS`
- `bitlocker_enablement: BLOCKED_PENDING_READINESS_REVIEW`
- `bitlocker_recovery_key_custody: REQUIRED_BEFORE_ENABLEMENT`
- `bitlocker_recovery_key_retrieval_test: REQUIRED`
- `bitlocker_failed_device_runbook: REQUIRED`
- `verified_external_backup: REQUIRED_BEFORE_ENABLEMENT`
- `broad_migration_without_host_encryption: PROHIBITED`
- `high_sensitivity_use_without_host_encryption: PROHIBITED`
- `primary_known_failure_mode: USER_CANNOT_LOCATE_CORRECT_RECOVERY_KEY`

A later BitLocker readiness phase must, without assuming enablement:

1. verify Windows edition and BitLocker/device-encryption support;
2. verify TPM, Secure Boot, firmware, boot configuration, and disk-health state;
3. confirm no disruptive firmware, partition, drive, OS, or disk migration is pending;
4. design and create under separate authority at least two separately located recovery-key copies;
5. record the matching recovery-key identifier with each copy without putting the key in ordinary reports;
6. prove recovery-key retrieval without relying on the encrypted PC;
7. create and validate Windows recovery media;
8. confirm a current, restorable external PAL/WSL backup; and
9. approve failed-device, motherboard/TPM, firmware-change, and drive-migration runbooks.

The primary known operational failure is inability to locate the correct recovery key when the protected device cannot supply normal access. Custody and offline retrieval proof therefore precede enablement.

T3H does not inspect private Microsoft-account data, enable BitLocker, create recovery keys, alter firmware/TPM policy, or authorize high-sensitivity use.

## 17. LUKS strategic direction

- `luks_strategic_direction: RETAINED`
- `luks_disposable_test: RECOMMENDED`
- `luks_production_selection: DEFERRED`
- `luks_package_installation: NOT_AUTHORIZED`
- `luks_device_node_remediation: NOT_AUTHORIZED`
- `luks_test_execution: NOT_AUTHORIZED`
- `future_luks_external_backup: PREFERRED_PENDING_TEST`
- `gocryptfs_replacement_by_luks: NOT_DECIDED`

LUKS remains a candidate for dedicated/external drives, native Linux storage, whole PAL volumes, offline media, and future evidence devices. It remains locally unvalidated because WSL loop-device, device-mapper, device-node, dm-crypt, and privilege requirements are unresolved. Any next LUKS work requires a separate T4 authorization sequence beginning with privileged compatibility, risk, recovery, and rollback review.

## 18. Remaining deferred choices

T3H explicitly defers:

- the actual production password;
- actual gocryptfs emergency recovery material;
- exact physical custody addresses and people beyond Dan's final authority;
- the exact recovery-USB device and encryption implementation;
- the exact external backup device;
- any purchase, connection, partition, format, mount, or encryption action;
- the exact off-site provider or destination;
- actual canary artifacts and source paths;
- helper-script implementation and aliases;
- production ciphertext and plaintext path creation;
- production initialization and configuration;
- production mount and unlock;
- production data copy or migration;
- BitLocker enablement or private account review;
- LUKS installation, remediation, or testing; and
- disposable-test cold-start validation or cleanup.

## 19. Recommended separated next phases

T3H recommends separate, non-automatic phases:

1. **T3I — Helper Script Design Review and Disposable Test Authorization**: review exact script code/design and authorize only a disposable-environment test if Dan approves.
2. **T3J — Production Vault and Canary Implementation Authorization**: after T3I evidence and final custody/backup/canary selections, decide whether to authorize production path creation, initialization, recovery-copy establishment, external backup, and limited canary actions.
3. **Separate BitLocker readiness phase**: verify prerequisites, recovery custody, retrieval, recovery media, and backup before any enablement decision.
4. **Separate LUKS T4 compatibility and test sequence**: begin with privileged WSL/device compatibility and risk review before package or test authority.

T3H authorizes none of these implementation activities. Each phase requires its own governing human decision.

## 20. Mandatory T3H status block

- `t3h_status: DESIGN_COMPLETE`
- `production_vault_model: SINGLE_OPERATIONAL_VAULT`
- `production_path_creation: NOT_AUTHORIZED`
- `production_initialization: NOT_AUTHORIZED`
- `production_mount: NOT_AUTHORIZED`
- `production_migration: NOT_AUTHORIZED`
- `production_password_manager: BITWARDEN`
- `recovery_model: TWO_PRINTED_PLUS_ENCRYPTED_USB`
- `initial_off_device_backup: OFFLINE_EXTERNAL_DRIVE`
- `future_offsite_backup: REQUIRED`
- `canary_item_count: 3_TO_5`
- `canary_observation_period: 14_DAYS`
- `production_mount_workflow: REVIEWED_HELPER_SCRIPTS`
- `automatic_mount: PROHIBITED`
- `agent_controlled_unlock: PROHIBITED`
- `lost_password_response: CONTROLLED_INCIDENT_PROCEDURE`
- `canary_rollback_model: PRESERVE_AND_STOP`
- `bitlocker_enablement: BLOCKED_PENDING_READINESS_REVIEW`
- `luks_test_execution: NOT_AUTHORIZED`
- `files_copied: 0`
- `directories_created: 0`
- `mounts_created: 0`
- `passwords_created: 0`
- `recovery_material_created: 0`
- `files_deleted: 0`
- `packages_installed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 21. T3H validation record

T3H was documentation-and-design-only. Exactly one design report was created: this file. No existing repository file was modified. No production, backup, or recovery path or device was created, selected, connected, formatted, mounted, or altered. No password or recovery material was created or requested. No data was copied or migrated. No mount, permission, package, host-encryption, BitLocker, or LUKS state changed. The retained disposable source, backup, restore, and locked mountpoints remained unchanged. The Git index remained unchanged and empty. `git diff --check` was run against this report. Work stopped without staging or committing.
