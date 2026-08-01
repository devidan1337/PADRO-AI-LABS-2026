# Phase 3D-C3E-T3G — Human Retention, gocryptfs Production-Pilot, and LUKS Strategic Direction Decisions

> **decision: `GOCRYPTFS INITIAL LIMITED PRODUCTION DIRECTION APPROVED WITH CONDITIONS`**
>
> **next checkpoint: `Phase 3D-C3E-T3H — Production Runbook, Recovery Custody, and Canary Migration Design`**
>
> **current phase: DOCUMENTATION-ONLY HUMAN DECISION**

## 1. Decision owner, authority, and evidence

Final human decision owner: **Dan**

Dan records the retention and strategic direction decisions in this document after reviewing the T3A through T3F gocryptfs authorization and result chain, the T1 technology comparison, the T2 WSL compatibility preflight, and the W1A private-storage architecture decisions.

The disposable test successfully validated:

- gocryptfs initialization;
- manual owner-controlled password entry and mounting;
- explicit unmounting;
- fail-closed plaintext mountpoint behavior;
- wrong-password rejection;
- ciphertext backup;
- separate ciphertext restoration;
- password-based mounting of restored ciphertext;
- restored plaintext size and SHA-256 integrity; and
- preservation of production, cleanup, package, automatic-mount, and LUKS boundaries.

This successful test evidence supports the conditional direction below. It does not create a production environment, authorize unrestricted migration, or remove any later implementation gate.

T3G is documentation-only. It creates no path, mount, archive, backup, key, password, package, host-encryption control, or LUKS object and does not modify or delete any retained test artifact.

## 2. Decision 1 — gocryptfs production direction

`gocryptfs_production_direction: APPROVED_WITH_CONDITIONS`

gocryptfs is approved as PAL's initial limited private-operational-archive technology, subject to every control and implementation gate in this record. The approval is for a future restricted canary after the required production runbook, recovery-custody design, backup architecture, canary selection process, and separate implementation authorization are complete.

The approval is not authorization to create production paths, initialize production gocryptfs, unlock or mount production storage, migrate data, or perform a broad deployment. Successful disposable testing establishes technical and operational evidence only; it does not itself create a production environment or authorize unrestricted migration.

## 3. Decision 2 — initially eligible PAL material

A later limited production canary may include only individually reviewed, selected, private PAL operational material, such as:

- raw PAL operational logs;
- terminal or command histories approved for private retention;
- private execution registers;
- unsanitized internal reports;
- private validation evidence; and
- internal working notes that contain no prohibited category.

Every canary item must:

1. be explicitly selected and approved;
2. be replaceable or reconstructable;
3. contain no prohibited category listed in Section 4;
4. receive a source SHA-256 before copying;
5. receive a destination SHA-256 after copying;
6. match exactly by SHA-256;
7. remain preserved at its source until separate removal authority exists; and
8. be recorded in a private execution register with secret-free handling evidence.

Eligibility is not blanket authority over a file type or directory. Each actual artifact remains subject to the future canary selection and implementation gate.

## 4. Decision 3 — prohibited production-pilot data

The initial pilot must not contain:

- passwords or password-manager exports;
- API keys or tokens;
- SSH private keys;
- credentials or authentication material;
- client data;
- investigative evidence;
- legal case material;
- regulated data;
- production recovery material;
- irreplaceable master copies;
- actual production secrets; or
- sensitive personal information whose loss or exposure would create significant harm.

- `high_sensitivity_data: NOT AUTHORIZED`
- `client_or_investigative_data: NOT AUTHORIZED`
- `credentials_and_secrets: NOT AUTHORIZED`

These categories require a separate architecture, authority, custody, and evidence-handling review. They cannot enter the initial pilot through implication, convenience, or classification uncertainty.

## 5. Decision 4 — production path design

The approved logical production paths remain:

- `/home/dev/pal-private-archive/active/`
- `/home/dev/pal-private-archive/legacy/`

- `production_path_design: APPROVED`
- `production_path_creation: NOT_YET_AUTHORIZED`
- `production_initialization: NOT_YET_AUTHORIZED`
- `production_mount: NOT_YET_AUTHORIZED`
- `production_data_migration: NOT_YET_AUTHORIZED`

Both paths must remain absent until the production runbook, password and recovery-custody design, backup target and failure-domain design, and canary implementation authorization have been reviewed and committed through the applicable repository workflow. Approval of their logical role is not authority to create them or any encrypted backing path.

## 6. Decision 5 — limited canary deployment

`initial_migration: LIMITED_CANARY_ONLY`

A later canary must:

- use a small number of explicitly approved PAL operational artifacts;
- contain no prohibited category;
- follow copy-first handling;
- preserve every source artifact;
- compare source and destination SHA-256 values exactly;
- exercise and record locked, mounted, unmounted, backup, and restore behavior; and
- stop on any unexpected mount, permission, path, object, classification, or integrity condition.

T3G does not authorize a broad migration. Expansion beyond the canary requires evidence review and a separate human decision.

## 7. Decision 6 — production mount and unlock controls

- `automatic_mount: PROHIBITED`
- `agent_controlled_unlock: PROHIBITED`
- `manual_owner_unlock: REQUIRED`
- `explicit_unmount: REQUIRED`
- `locked_mountpoint_mode: 0500`
- `temporary_mount_ready_mode: 0700`
- `mount_verification: REQUIRED`
- `fallback_write_validation: REQUIRED`

The future production workflow must retain this tested control sequence:

1. confirm the plaintext mountpoint is unmounted using `findmnt` or `/proc/self/mountinfo`;
2. confirm the mountpoint is fail-closed at mode `0500` with expected ownership;
3. prove that an ordinary fallback write fails and leaves no artifact;
4. temporarily change only the mountpoint to mode `0700`;
5. have Dan perform the owner-controlled interactive mount without exposing a password;
6. verify the exact expected `fuse.gocryptfs` mount, source, target, and namespace through `findmnt` or `/proc/self/mountinfo`;
7. perform only separately authorized work;
8. explicitly unmount with the locally appropriate FUSE method;
9. restore mode `0500`; and
10. verify the mount is absent, the mountpoint is empty, no process or automatic remount remains, and ordinary fallback writes fail without residue.

Systemd unlock units, `fstab` entries, shell-startup mounts, stored or scripted passwords, environment-variable passwords, agent-controlled unlock, and background remount processes are prohibited.

## 8. Decision 7 — password and recovery custody

Production password and recovery custody must be designed, documented, and approved before production initialization.

Required direction:

- Dan retains final unlock authority;
- the production password must be unique and not reused from any other credential;
- the password may be stored in a reputable password manager selected later by Dan;
- emergency recovery material must be stored separately from the password;
- at least one offline recovery copy is recommended;
- passwords and recovery material must not enter Git, reports, chat, prompts, screenshots, scripts, command arguments, environment variables, shell history, logs, or agent memory;
- Codex, Hermes, and other PAL agents must not possess, retain, relay, or control the unlock secret; and
- recovery exercises may record outcomes but never secret values or hints.

`production_recovery_custody_plan: REQUIRED_BEFORE_INITIALIZATION`

T3G does not choose the password manager, physical recovery medium, offline method, custodian location, or exact recovery procedure. Those choices belong in the T3H design and a subsequent human authorization.

## 9. Decision 8 — production backup requirements

`off_device_backup: REQUIRED_BEFORE_BROAD_MIGRATION`

The same-WSL ciphertext backup and separate restore validated recovery mechanics, file-level integrity, and password-based recoverability. It does not satisfy production disaster-recovery requirements because it remains within the same host and failure domain.

Before broad migration, the architecture must include:

- the primary encrypted ciphertext tree;
- at least one encrypted copy on a separate physical device or failure domain;
- a documented restore procedure;
- periodic restore validation; and
- eventual consideration of an offline or off-site encrypted copy.

Production backup must target the complete ciphertext tree and its required standard control artifacts, not the mounted plaintext view. The exact device, service, medium, schedule, retention, versioning, off-site method, access control, and consistency process remain deferred to the T3H production runbook and recovery design.

## 10. Decision 9 — host encryption condition

- `host_encryption: REQUIRED_BEFORE_HIGH_SENSITIVITY_USE`
- `limited_canary_before_host_encryption: CONDITIONALLY_PERMITTED`

A later, separately authorized, replaceable PAL operational canary may proceed before host encryption only if it meets every eligibility and control in this record.

High-sensitivity, client, investigative, credential, regulated, irreplaceable, or materially harmful data remains prohibited until Windows host encryption or an equivalent approved control is enabled, verified, and incorporated into an approved architecture. gocryptfs protects the selected archive tree; it does not replace full host and WSL virtual-disk defense in depth or eliminate exposure while mounted.

## 11. Decision 10 — disposable test retention

`disposable_test_retention: 30_DAYS`

The complete successful disposable environment must be retained for 30 days from this T3G decision date, `2026-08-01`. The retention period therefore runs until no earlier than `2026-08-31`, subject to a later explicit cleanup decision.

Retain unchanged:

- original disposable ciphertext at `/home/dev/pal-encryption-test/gocryptfs/cipher/`;
- original locked plaintext mountpoint at `/home/dev/pal-encryption-test/gocryptfs/plain/`;
- verified backup tree at `/home/dev/pal-encryption-test/gocryptfs/backup/`;
- restored ciphertext tree at `/home/dev/pal-encryption-test/gocryptfs/restore/cipher/`; and
- restored locked plaintext mountpoint at `/home/dev/pal-encryption-test/gocryptfs/restore/plain/`.

- `cold_start_recovery_test: RECOMMENDED_BEFORE_CLEANUP`
- `disposable_cleanup: SEPARATE_AUTHORIZATION_REQUIRED`

One later cold-start recovery validation after restarting WSL or Windows is recommended during retention and before cleanup. T3G does not authorize that state-changing validation, deletion, cleanup, modification, or retention-period shortening.

## 12. Decision 11 — LUKS strategic direction

- `luks_strategic_direction: RETAINED`
- `luks_disposable_test: RECOMMENDED`
- `luks_production_selection: DEFERRED`
- `luks_package_installation: NOT_AUTHORIZED`
- `luks_device_node_remediation: NOT_AUTHORIZED`
- `luks_test_execution: NOT_AUTHORIZED`

LUKS remains the preferred future candidate for:

- dedicated external drives;
- native Linux storage;
- full encrypted PAL volumes;
- offline encrypted backup media;
- future evidence-storage devices; and
- environments requiring a whole-filesystem encryption boundary.

LUKS has not been locally validated. Its WSL loop-device, device-mapper, device-node, dm-crypt activation, and privilege requirements remain unresolved. The T2 evidence observed missing loop and mapper device nodes in the restricted execution context and did not establish safe root-capable operation in the normal WSL environment.

A later T4 sequence should begin with a separate privileged compatibility, device-node, operational-risk, and rollback review. No package installation, device remediation, module action, mapping, formatting, mounting, or LUKS test is authorized by T3G.

## 13. Decision 12 — complementary architecture direction

The intended strategic layering is:

- Windows device encryption protects the host and WSL virtual disk at rest;
- gocryptfs protects selected PAL operational files and supports convenient ciphertext-tree backup and granular restoration; and
- LUKS may later protect dedicated, external, native-Linux, or whole-volume storage.

Unnecessary gocryptfs-inside-LUKS nesting is not approved. Any layered nesting requires a documented threat-model reason, a clear operational benefit, recovery analysis, and separate authorization.

`gocryptfs_replacement_by_luks: NOT_DECIDED`

The technologies may ultimately serve complementary roles. T3G neither selects LUKS for production nor decides that LUKS must replace gocryptfs.

## 14. Authorized next documentation checkpoint

Dan authorizes only:

**Phase 3D-C3E-T3H — Production Runbook, Recovery Custody, and Canary Migration Design**

T3H is documentation and design only. It may define:

- the production path and encrypted-backing layout;
- the manual owner-controlled mount and explicit-unmount runbook;
- fail-closed ownership, mode, mount-verification, and fallback-write controls;
- password and recovery-custody requirements;
- off-device backup architecture requirements;
- canary eligibility, classification, selection, and execution-register procedures;
- copy-first migration and source-preservation procedures;
- preflight, hash validation, rollback, and stop conditions;
- incident, lost-password, and unavailable-recovery handling;
- periodic backup and restore-validation cadence; and
- evidence gates and conditions for broad migration.

T3H must not create a production directory or backing store, initialize production gocryptfs, enter a production password, mount production storage, migrate data, create a production backup, delete or modify test artifacts, enable host encryption, install packages, remediate devices, or perform LUKS work.

No production-pilot implementation checkpoint is authorized until the T3H design is reviewed and a later explicit human authorization is recorded.

## 15. Mandatory status block

- `gocryptfs_production_direction: APPROVED_WITH_CONDITIONS`
- `gocryptfs_production_pilot: AUTHORIZED_AFTER_RUNBOOK`
- `production_path_design: APPROVED`
- `production_path_creation: NOT_YET_AUTHORIZED`
- `production_initialization: NOT_YET_AUTHORIZED`
- `production_mount: NOT_YET_AUTHORIZED`
- `production_data_migration: NOT_YET_AUTHORIZED`
- `initial_migration: LIMITED_CANARY_ONLY`
- `high_sensitivity_data: NOT AUTHORIZED`
- `client_or_investigative_data: NOT AUTHORIZED`
- `credentials_and_secrets: NOT AUTHORIZED`
- `automatic_mount: PROHIBITED`
- `agent_controlled_unlock: PROHIBITED`
- `manual_owner_unlock: REQUIRED`
- `production_recovery_custody_plan: REQUIRED_BEFORE_INITIALIZATION`
- `host_encryption: REQUIRED_BEFORE_HIGH_SENSITIVITY_USE`
- `off_device_backup: REQUIRED_BEFORE_BROAD_MIGRATION`
- `disposable_test_retention: 30_DAYS`
- `cold_start_recovery_test: RECOMMENDED_BEFORE_CLEANUP`
- `disposable_cleanup: SEPARATE_AUTHORIZATION_REQUIRED`
- `luks_strategic_direction: RETAINED`
- `luks_disposable_test: RECOMMENDED`
- `luks_production_selection: DEFERRED`
- `luks_package_installation: NOT_AUTHORIZED`
- `luks_test_execution: NOT_AUTHORIZED`
- `files_copied: 0`
- `directories_created: 0`
- `mounts_created: 0`
- `files_deleted: 0`
- `files_moved: 0`
- `packages_installed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

The zero values describe this documentation-only T3G phase.

## 16. T3G validation record

T3G was documentation-only. Exactly one decision report was created: this file. No existing repository file was modified. No production path, backing store, mount, file copy, initialization, backup, directory, or test artifact was created, modified, moved, or deleted. No permission, package, host-encryption, automatic-mount, or LUKS state changed. The complete disposable environment remained retained and unmounted. Both production paths remained absent. The Git index remained unchanged and empty. `git diff --check` was run against this report. Work stopped without staging or committing.
