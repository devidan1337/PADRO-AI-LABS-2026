# Phase 3D-C3E-T3E — Human Authorization for gocryptfs Ciphertext Backup and Restore Validation

> **decision: `T3F AUTHORIZED WITH RESTRICTED DISPOSABLE RECOVERY SCOPE`**
>
> **next checkpoint: `Phase 3D-C3E-T3F — gocryptfs Ciphertext Backup and Restore Validation`**
>
> **current phase: DOCUMENTATION ONLY**

## 1. Decision owner and governing evidence

Final human decision owner: **Dan**

Dan authorizes the restricted T3F disposable recovery checkpoint defined by this record. This authorization follows the T3C initialization and mount-test authorization, the successful T3D result, the T3A human test direction, and the completed T3B package and path setup.

T3E is documentation-only. It does not copy, back up, restore, mount, unlock, enter a password, change permissions, create a restore directory, delete data, alter package state, or select a production technology or backup design.

## 2. Authorized next checkpoint and test purpose

Dan authorizes:

**Phase 3D-C3E-T3F — gocryptfs Ciphertext Backup and Restore Validation**

T3F may validate one copy-first backup of the retained disposable ciphertext tree, one separate restored ciphertext copy, and one password-based mount of that restored copy. It is a synthetic-data recovery test only. It does not authorize production use, a production recovery process, or a production backup architecture.

## 3. Exact path boundary

| Role | Exact path | T3F authority |
|---|---|---|
| Authoritative source ciphertext | `/home/dev/pal-encryption-test/gocryptfs/cipher/` | Read, inventory, hash, and copy from only; modification and deletion prohibited |
| Backup destination | `/home/dev/pal-encryption-test/gocryptfs/backup/` | Receive exactly one source ciphertext copy; deletion prohibited |
| Restore container | `/home/dev/pal-encryption-test/gocryptfs/restore/` | Existing disposable container only |
| Restored ciphertext | `/home/dev/pal-encryption-test/gocryptfs/restore/cipher/` | May be created and receive exactly one backup copy |
| Restored plaintext mountpoint | `/home/dev/pal-encryption-test/gocryptfs/restore/plain/` | May be created, controlled, mounted, verified, and returned to locked state |
| Original plaintext mountpoint | `/home/dev/pal-encryption-test/gocryptfs/plain/` | Read-only state verification only; must remain unmounted, empty, `dev:dev`, mode `0500` |

T3F may create only these two directories:

- `/home/dev/pal-encryption-test/gocryptfs/restore/cipher/`
- `/home/dev/pal-encryption-test/gocryptfs/restore/plain/`

The existing top-level backup and restore directories remain inside the disposable boundary. T3F must not create, use, mount, copy into, or otherwise touch:

- `/home/dev/pal-private-archive/active/`
- `/home/dev/pal-private-archive/legacy/`

No actual PAL, client, investigative, recovery-history, credential, secret, or production material may enter any test path.

## 4. Source preservation and pre-copy stop gate

The authoritative source is the retained T3D ciphertext tree at `/home/dev/pal-encryption-test/gocryptfs/cipher/`. It must remain byte-for-byte and structurally unchanged throughout T3F.

Before any directory creation or copy, T3F must verify and record:

1. the governing authorization has no conflict;
2. gocryptfs remains installed at the expected version;
3. the source exists and contains the retained initialization and encrypted synthetic objects;
4. neither the source nor the original plaintext path is an unexpected mountpoint;
5. the original plaintext mountpoint is unmounted, empty, owned by `dev:dev`, and mode `0500`;
6. backup is empty;
7. restore is empty and the two authorized restore subdirectories are absent;
8. production paths remain absent;
9. the Git index is empty;
10. source regular-file and directory counts, relative structural inventory, ownership, modes, sizes, and timestamps are recorded;
11. a SHA-256 manifest of every source regular file is recorded using relative paths; and
12. no symbolic link, socket, device, FIFO, or other unsupported object exists in the source.

T3F must stop before copying if it finds an unexpected symbolic link, special file, unsupported object, unexpected mount, extra destination data, source discrepancy, authorization conflict, or other ambiguous state. It must use `T3F_STOPPED_SOURCE_STATE_CONFLICT` unless another required verdict is more accurate.

The pre-copy manifest must not display `gocryptfs.conf` contents or any protected material. Hashing the ciphertext regular files is authorized.

## 5. One copy-first ciphertext backup

T3F is authorized to perform exactly one carefully scoped copy of the contents of:

`/home/dev/pal-encryption-test/gocryptfs/cipher/`

into the already-existing and verified-empty:

`/home/dev/pal-encryption-test/gocryptfs/backup/`

The copy must contain only the source ciphertext tree and standard gocryptfs initialization artifacts. A metadata-preserving method such as carefully scoped `cp -a` or `rsync -a` may be used. The source must not be moved, deleted, synchronized with removal, dereferenced through an unexpected link, or modified.

The following are prohibited:

- `mv`;
- `rsync --delete` or any deletion option;
- destination cleanup;
- source cleanup;
- copying contents of an unrelated parent directory;
- source writes or metadata changes; and
- dereferencing any unexpected symbolic link without a new owner decision.

After the copy, T3F must collect a relative backup inventory, counts, ownership, modes, sizes, timestamps, and a SHA-256 manifest for all regular files. It must compare source and backup relative paths and hashes exactly, confirm standard gocryptfs control artifacts are present, reject unauthorized extras or omissions, and repeat the source inventory and manifest to prove the source remained unchanged.

Where practical, ownership, permissions, and timestamps must be preserved and compared. Any mismatch requires `T3F_STOPPED_BACKUP_INTEGRITY_FAILURE` without cleanup or deletion.

## 6. Backup confidentiality and integrity gate

The backup is valid only when:

- every expected source regular file exists at the corresponding relative backup path;
- every compared SHA-256 value matches;
- source and backup structure and counts match;
- no unauthorized extra file or directory exists;
- standard gocryptfs control artifacts are present;
- ownership and permissions validate;
- timestamps and other metadata are preserved where practical;
- plaintext filenames are not directly exposed; and
- plaintext content is not directly readable in the backup.

The T3F report may name standard control files and record secret-free hashes and metadata. It must not show configuration contents, passwords, hints, master keys, recovery material, or sensitive plaintext.

## 7. One restored ciphertext copy

Only after the backup integrity gate passes, T3F may create `/home/dev/pal-encryption-test/gocryptfs/restore/cipher/` and `/home/dev/pal-encryption-test/gocryptfs/restore/plain/`. Both must be owned by `dev:dev`. The restored ciphertext destination must be verified empty before copying.

T3F may then perform exactly one carefully scoped, metadata-preserving copy of the contents of:

`/home/dev/pal-encryption-test/gocryptfs/backup/`

into:

`/home/dev/pal-encryption-test/gocryptfs/restore/cipher/`

The backup must remain unchanged. T3F must compare backup and restored ciphertext inventories, counts, relative paths, SHA-256 manifests, ownership, permissions, sizes, and practical timestamp metadata. The restored ciphertext must be a separate tree from both source and backup. No file may be moved or deleted.

Any missing, extra, mismatched, linked, or unsupported object requires `T3F_STOPPED_RESTORE_INTEGRITY_FAILURE` without cleanup.

## 8. Restored plaintext locked-state control

The restored plaintext mountpoint must:

- be owned by `dev:dev`;
- be empty and unmounted;
- use fail-closed mode `0500` while unmounted;
- be checked with `findmnt` or `/proc/self/mountinfo`; and
- deny ordinary fallback writes while locked.

T3F may change permissions only on `/home/dev/pal-encryption-test/gocryptfs/restore/plain/`. It may temporarily change that mountpoint to `0700` only for the authorized FUSE mount attempt, because the mounting user requires write access. It must restore `0500` immediately after the explicit unmount.

ACLs, immutable flags, bind mounts, ownership changes, root-owned placeholders, and unrelated security controls are not authorized. The original plaintext mountpoint must not be altered; it may only be checked to confirm its retained locked state.

## 9. Password and recovery-material boundary

Dan must enter the existing disposable test password interactively for the restored mount. Codex must stop before the command, present only the exact command, explain the expected interactive prompt, instruct Dan not to paste secrets into chat, and wait for only a success-or-failure statement.

Passwords are prohibited in arguments, environment variables, password files, scripts, shell history, reports, Git, prompts, chat, and screenshots. Codex must not request, capture, transcribe, relay, generate, retain, or repeat a password or hint.

T3F must not request, display, read, copy separately, summarize, or record a master key, emergency recovery key, password hint, or protected configuration contents. A master-key recovery workflow is not authorized. T3F validates password-based restoration only; master-key recovery requires a separate authorization.

## 10. One owner-controlled restored mount

After all backup, restore, and locked-state gates pass, T3F may temporarily set only the restored plaintext mountpoint to `0700`. Dan may then manually run exactly:

```bash
gocryptfs /home/dev/pal-encryption-test/gocryptfs/restore/cipher /home/dev/pal-encryption-test/gocryptfs/restore/plain
```

Dan must enter the existing disposable password only at the interactive prompt and report only success or failure. No automatic mount, systemd configuration, `fstab` change, startup-script change, stored password, or background remount process is authorized.

After Dan reports success, T3F must independently verify the exact mountpoint, the observed FUSE filesystem type, and its relationship to the restored ciphertext source. A failure to mount or verify requires `T3F_STOPPED_RESTORE_MOUNT_UNAVAILABLE`.

## 11. Restored plaintext validation

Only after the restored mount is verified, T3F must read-only validate exactly:

- `synthetic-note.txt`
- `nested/synthetic-record.txt`

| Retained synthetic path | Expected size | Expected SHA-256 |
|---|---:|---|
| `synthetic-note.txt` | 95 bytes | `6bfbea5e8c76ead0a3f525c97bf2ee68bed87762999670d71d0a5dfbcaee5c72` |
| `nested/synthetic-record.txt` | 97 bytes | `e6fc9d7f35c5353f509cc3b87b24dd119a8a703ccb370df94c8fc287010ee329` |

Both files must exist, their sizes and SHA-256 values must match T3D, their content must remain clearly synthetic, and no unauthorized plaintext file or directory may appear. T3F may record paths, hashes, sizes, ownership, and permissions, but must not reproduce plaintext content or modify either file.

Any hash or size mismatch requires `T3F_STOPPED_RESTORED_PLAINTEXT_HASH_MISMATCH` without attempting repair or cleanup.

## 12. Explicit unmount and final restored locked state

After validation, T3F must explicitly unmount using the locally appropriate FUSE unmount method. If the unmount requires owner or privileged interaction, Codex must stop and provide Dan the exact command rather than weaken controls.

After unmount, T3F must:

1. verify the restored plaintext mount is absent;
2. verify the restored plaintext mountpoint is empty;
3. restore mode `0500` and confirm ownership remains `dev:dev`;
4. perform exactly one controlled ordinary fallback-write attempt and require it to fail;
5. confirm no fallback probe remains;
6. verify the restored ciphertext remains intact against its manifest;
7. verify the original source remains intact against its pre-copy manifest;
8. verify the backup remains intact against its post-copy manifest;
9. verify no process retains the restored mount; and
10. verify no automatic remount occurs.

If the fallback write succeeds, plaintext remains visible, a mount persists, or any source/backup/restore integrity check fails, T3F must use the most accurate authorized stop or failure verdict and return to Dan. No cleanup is authorized.

## 13. Final original-environment preservation gate

At completion, T3F must verify:

- the original ciphertext tree remains present and unchanged;
- the original plaintext mountpoint remains unmounted, empty, `dev:dev`, and mode `0500`;
- the backup tree remains present and unchanged after validation;
- the restored ciphertext remains present and unchanged after mount validation;
- the restored plaintext mountpoint remains empty, unmounted, `dev:dev`, and mode `0500`;
- no cleanup, deletion, or move occurred;
- no package state changed;
- no LUKS or `cryptsetup` activity occurred;
- production paths remain absent and untouched;
- no automatic mount configuration was created; and
- the Git index remains empty.

## 14. T3F prohibitions

T3F must not:

- delete or clean up any test artifact;
- modify the original ciphertext tree or encrypted synthetic objects;
- create new plaintext test data;
- repeat wrong-password testing;
- test corruption or partial-backup failure;
- use master-key recovery;
- use production paths or non-synthetic data;
- install, remove, upgrade, or refresh packages, including running `apt update`;
- use LUKS or `cryptsetup`;
- configure automatic mounting;
- modify Git-tracked files other than its required result report; or
- stage, commit, or push.

## 15. Required T3F result report and verdict

T3F must create exactly one report:

`reports/sync/PHASE-3D-C3E-T3F-GOCRYPTFS-BACKUP-RESTORE-TEST-RESULT.md`

It must not contain passwords, hints, master keys, emergency recovery material, protected configuration contents, sensitive plaintext, or unrelated untracked repository content.

The report must use exactly one verdict:

- `T3F_COMPLETE_READY_FOR_RETENTION_AND_PRODUCTION_DECISION_REVIEW`
- `T3F_STOPPED_SOURCE_STATE_CONFLICT`
- `T3F_STOPPED_BACKUP_INTEGRITY_FAILURE`
- `T3F_STOPPED_RESTORE_INTEGRITY_FAILURE`
- `T3F_STOPPED_PASSWORD_HANDLING_BOUNDARY`
- `T3F_STOPPED_RESTORE_MOUNT_UNAVAILABLE`
- `T3F_STOPPED_RESTORED_PLAINTEXT_HASH_MISMATCH`
- `T3F_FAILED_REQUIRES_OWNER_REVIEW`

## 16. Mandatory T3E authorization status block

- `ciphertext_backup_test: AUTHORIZED`
- `ciphertext_restore_test: AUTHORIZED`
- `restored_mount_test: AUTHORIZED`
- `interactive_password_entry: REQUIRED`
- `password_storage: PROHIBITED`
- `master_key_recovery_test: NOT AUTHORIZED`
- `source_modification: PROHIBITED`
- `source_deletion: PROHIBITED`
- `backup_deletion: PROHIBITED`
- `restore_deletion: PROHIBITED`
- `cleanup: NOT AUTHORIZED`
- `corruption_test: NOT AUTHORIZED`
- `automatic_mount: PROHIBITED`
- `synthetic_test_data_only: REQUIRED`
- `production_paths_status: NOT AUTHORIZED`
- `luks_status: NOT AUTHORIZED`
- `files_copied: 0`
- `directories_created: 0`
- `mounts_created: 0`
- `test_files_created: 0`
- `files_deleted: 0`
- `files_moved: 0`
- `packages_installed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

These zero values describe this documentation-only T3E phase, not the future T3F implementation.

## 17. T3E validation record

T3E was documentation-only. Exactly one authorization report was created: this file. No existing repository file was modified. No file or directory outside this report was created, copied, moved, or deleted. No backup or restore data was created. No mount occurred, no password was requested or entered, and no permission or package state changed. The source, backup, restore, original plaintext, and production states remained untouched. The Git index remained unchanged and empty. `git diff --check` was run against this report. Work stopped without staging or committing.
