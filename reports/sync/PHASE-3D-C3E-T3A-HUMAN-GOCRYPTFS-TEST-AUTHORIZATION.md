# Phase 3D-C3E-T3A — Human gocryptfs Disposable Test Authorization Record

> **decision: `GOCRYPTFS DISPOSABLE TEST DIRECTION APPROVED`**
>
> **next checkpoint: `PHASE 3D-C3E-T3B AUTHORIZED WITH RESTRICTED SCOPE`**
>
> **current phase: DOCUMENTATION ONLY**

## 1. Authority and decision owner

Final decision owner: **Dan**

Dan authorizes the controlled gocryptfs direction recorded here: installation of the `gocryptfs` package from the configured Ubuntu repositories; a disposable gocryptfs test using synthetic data only; manual, Dan-controlled unlock and mount; isolated test paths only; read-only compatibility checks before installation; and evidence recording of the package version, paths, hashes, mount state, and cleanup status.

This record resolves the package and disposable-path decisions needed for the next checkpoint. It does not itself install, initialize, unlock, mount, test, back up, restore, clean up, or configure anything. Production use and production technology selection remain unauthorized.

## 2. Governing evidence and retained controls

This decision follows the Phase 3D-C3E-T1 technology comparison, the Phase 3D-C3E-T2 WSL compatibility preflight, and the Phase 3D-W1A private-storage architecture decisions. The evidence supports gocryptfs as the first disposable test direction, but it does not establish that FUSE mounting works in the normal WSL shell. That capability remains subject to the staged test gates in this record.

The following governing controls remain in force:

- automatic mounting is prohibited;
- unlock and mount must be manual and Dan-controlled;
- testing must use synthetic data only;
- production archive paths must not be used;
- plaintext-fallback prevention must pass before any production authorization;
- passwords, keys, and recovery material must remain outside Git, reports, agent prompts, command arguments, and shell history; and
- every state-changing activity must stay within its separately authorized implementation step.

## 3. Approved disposable paths

Dan approves the following isolated, test-only paths for later authorized implementation:

| Purpose | Approved disposable path |
|---|---|
| Ciphertext | `/home/dev/pal-encryption-test/gocryptfs/cipher/` |
| Plaintext mount | `/home/dev/pal-encryption-test/gocryptfs/plain/` |
| Restore test | `/home/dev/pal-encryption-test/gocryptfs/restore/` |
| Ciphertext backup | `/home/dev/pal-encryption-test/gocryptfs/backup/` |

These are disposable test locations, not production archive locations. Their approval does not create them and does not authorize every possible operation within them. Creation in T3B is limited to the approved disposable test directories; initialization, mounting, test-data creation, backup, restore, corruption simulation, and cleanup remain controlled by their stated authorization gates.

The production logical paths remain unauthorized for use:

- `/home/dev/pal-private-archive/active/`
- `/home/dev/pal-private-archive/legacy/`

They must not be created, used, mounted, tested, or written by T3B or by the disposable test unless a later, explicit production authorization from Dan permits it.

## 4. Authorized package scope

The authorization is limited to:

- package metadata inspection using currently configured Ubuntu repository information;
- package installation of `gocryptfs`; and
- dependencies automatically required by the Ubuntu package manager for that package.

The authorization does not include:

- unrelated package upgrades;
- adding external repositories;
- installing packages through `curl`, `wget`, source tarballs, GitHub releases, snaps, or PPAs;
- installing `cryptsetup`;
- installing any LUKS-related tooling;
- running a broad `apt upgrade`; or
- production configuration.

If package metadata must be refreshed, a separate explicit human confirmation is required before running `apt update`. This record does not authorize a metadata refresh.

## 5. Synthetic-data test boundary

Any later disposable test may use only purpose-created synthetic test data. The following material is prohibited from the test, its paths, its backup, its restore exercise, its hashes, and its evidence record:

- recovery histories;
- PAL logs;
- sync manifests;
- disposition artifacts;
- credentials;
- secrets;
- client data;
- investigative evidence; and
- production archive contents.

Existing repository or owner files must not be repurposed as test fixtures merely because they appear non-sensitive. Test content must be newly defined synthetic content under the appropriate later authorization.

## 6. Mount, unlock, and secret-handling policy

- Automatic mounting is prohibited.
- Unlock must be manual and Dan-controlled.
- No passphrase file may be stored.
- No password may appear in command arguments.
- No password may enter shell history.
- No password may be placed in prompts to agents.
- No key material may be placed in Git.
- No key material may be placed in reports.
- Agents may not control or perform the unlock.
- Explicit unmount is required after each test.

An authorization to install or create directories is not authorization to initialize, unlock, or mount. Dan must retain direct control of any future interactive secret entry, and evidence must record only secret-free outcomes.

## 7. Plaintext-fallback requirement

The disposable test must prove that the plaintext path cannot accept ordinary writes while gocryptfs is not mounted. A directory-existence check, sentinel file, process check, or successful prior mount is not sufficient.

Before any authorized plaintext write, the implementation must:

1. verify the mount using `findmnt` or `/proc/self/mountinfo` from the writing process's mount namespace;
2. confirm the expected gocryptfs filesystem type, with the exact observed type recorded during the controlled test;
3. confirm the expected source and its relationship to `/home/dev/pal-encryption-test/gocryptfs/cipher/`;
4. perform and record fail-closed write checks, including proof that an ordinary write is rejected while the gocryptfs mount is absent; and
5. stop on any missing, ambiguous, or unexpected mount evidence.

The test must not use either production archive path. No production authorization may be issued until the plaintext-fallback controls pass and their evidence has been reviewed.

## 8. Recovery, backup, and cleanup boundary

A later, properly authorized test may include:

- ciphertext backup;
- restore to `/home/dev/pal-encryption-test/gocryptfs/restore/`;
- hash comparison;
- wrong-password behavior;
- locked-state validation;
- mount and unmount validation; and
- cleanup review.

This list defines permissible future test subjects, not authorization to perform them now or in T3B. Actual backup, restore, corruption simulation, and cleanup each require their stated implementation step and recorded evidence. Evidence must identify relevant approved paths and record hashes, mount state, and cleanup status without exposing passwords or key material.

## 9. LUKS boundary

- LUKS package installation is not authorized.
- LUKS device-node remediation is not authorized.
- A LUKS test is not authorized.
- LUKS production selection is not authorized.

The authorization for gocryptfs does not act as implied authority for `cryptsetup`, loop-device work, device-mapper changes, module loading, device-node creation, LUKS initialization, or any other LUKS-related action.

## 10. Authorized next checkpoint

Dan authorizes the next implementation checkpoint:

**Phase 3D-C3E-T3B — gocryptfs Package Installation and Disposable Test Setup**

T3B is limited to the following scope, in order:

1. confirm the current package candidate and configured repository source using read-only checks;
2. install `gocryptfs` only, together with dependencies automatically required by the Ubuntu package manager;
3. confirm the installed version;
4. create only the four approved disposable test directories listed in Section 3;
5. record the pre-test Git and filesystem state; and
6. stop before initializing gocryptfs unless initialization is explicitly included in a later owner authorization record.

T3B must not initialize an encrypted filesystem. It must not create a key, configuration, ciphertext object, mount, test file, or backup. Initialization requires a separate, explicit owner authorization. If the current package candidate or repository source is unexpected, required dependencies exceed the permitted package scope, `apt update` appears necessary, or the approved paths cannot be used as stated, T3B must stop and return to Dan for a decision.

## 11. Mandatory status block

- `gocryptfs_test_direction: APPROVED`
- `gocryptfs_package_installation: AUTHORIZED`
- `gocryptfs_initialization: NOT AUTHORIZED`
- `gocryptfs_mount: NOT AUTHORIZED`
- `synthetic_test_data_only: REQUIRED`
- `automatic_mount_status: PROHIBITED`
- `production_paths_status: NOT AUTHORIZED`
- `luks_package_installation: NOT AUTHORIZED`
- `luks_test_status: NOT AUTHORIZED`
- `packages_installed: 0`
- `directories_created: 0`
- `keys_created: 0`
- `ciphertext_filesystems_created: 0`
- `mounts_created: 0`
- `test_files_created: 0`
- `backups_created: 0`
- `files_copied: 0`
- `files_moved: 0`
- `files_deleted: 0`
- `permissions_changed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 12. Validation record

Phase 3D-C3E-T3A was documentation-only. Exactly one file was created: this authorization record. No existing file was modified. Package metadata was not refreshed, and no package was installed. No directory, key, encrypted filesystem, mount, test file, or backup was created. No file was copied, moved, or deleted, and no permission was changed. The Git index remained unchanged. `git diff --check` was run against this report. Work stopped without staging or committing.
