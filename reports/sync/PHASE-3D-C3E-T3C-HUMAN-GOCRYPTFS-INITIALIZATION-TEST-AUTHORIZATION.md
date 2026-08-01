# Phase 3D-C3E-T3C — Human Authorization for gocryptfs Initialization and Controlled Mount Test

> **decision: `T3D AUTHORIZED WITH RESTRICTED DISPOSABLE TEST SCOPE`**
>
> **next checkpoint: `Phase 3D-C3E-T3D — gocryptfs Initialization, Mount, Locked-State, and Synthetic Write Test`**
>
> **current phase: DOCUMENTATION ONLY**

## 1. Decision owner and governing evidence

Final human decision owner: **Dan**

Dan authorizes the restricted T3D implementation checkpoint defined by this record. This authorization follows the T3A human test direction, the successfully completed T3B package and directory setup, the T2 WSL compatibility preflight, and the T1 LUKS-versus-gocryptfs comparison.

T3C creates authorization only. It performs no initialization, password entry, key creation, configuration creation, mount, test-data creation, backup, restore, package change, or permission change. The disposable test does not select gocryptfs for production.

## 2. Authorized paths and path exclusions

T3D may operate only on:

| Purpose | Exact authorized path |
|---|---|
| Ciphertext and initialization artifacts | `/home/dev/pal-encryption-test/gocryptfs/cipher/` |
| Plaintext mount and mounted synthetic test view | `/home/dev/pal-encryption-test/gocryptfs/plain/` |

T3D must not use:

- restore: `/home/dev/pal-encryption-test/gocryptfs/restore/`;
- backup: `/home/dev/pal-encryption-test/gocryptfs/backup/`;
- production active: `/home/dev/pal-private-archive/active/`; or
- production legacy: `/home/dev/pal-private-archive/legacy/`.

Backup and restore require a later, explicit authorization. The production paths must remain absent, unused, unmounted, and untouched.

## 3. Initialization authorization

T3D is authorized to perform exactly one disposable gocryptfs initialization in `/home/dev/pal-encryption-test/gocryptfs/cipher/`. It may create only the initialization artifacts automatically produced there by gocryptfs. It must not manually create, alter, copy, delete, relocate, or place initialization artifacts elsewhere.

Initialization is test-only. Successful initialization or testing does not constitute production selection, production configuration, or authorization to place actual PAL data in gocryptfs.

## 4. Password handling boundary

Dan must select, retain, and enter a unique disposable test password directly through gocryptfs's interactive prompt. Mount and remount password entry must also remain interactive and Dan-controlled.

The test password must not be reused from any production, personal, email, GitHub, SSH, banking, password-manager, client, or other credential. Passwords are prohibited in command arguments, environment variables, files, scripts, shell history, agent prompts, reports, Git, and any agent-accessible record. Codex must not request, capture, transcribe, relay, generate, retain, or repeat any password or password hint.

The T3D report may record only:

- that interactive password entry occurred;
- whether password confirmation succeeded; and
- whether wrong-password behavior was tested.

It must contain no password value or hint.

## 5. Master-key and recovery-material boundary

If gocryptfs displays a master key or emergency recovery material, Dan must handle it directly. Codex must not repeat, transcribe, store, summarize, capture, or place it in any report. It must not enter Git, shell history, screenshots, chat, prompts, logs, or repository files.

This disposable test must not use production recovery storage. This phase does not authorize a production recovery process. The T3D report may state only whether recovery material was displayed and whether Dan acknowledged responsibility for it; it must contain no recovery material or identifying hint.

## 6. Pre-initialization stop gate

Before initialization, T3D must verify and record that:

1. the gocryptfs package and executable remain installed, including the exact installed version;
2. the ciphertext and plaintext directories exist;
3. both directories are owned by `dev:dev`;
4. both directories are mode `0700`;
5. both directories are empty;
6. neither path is mounted, as verified with `findmnt` or `/proc/self/mountinfo`;
7. no `gocryptfs.conf` exists in the ciphertext directory;
8. neither production archive path exists or is implicated;
9. the Git index is empty; and
10. no governing authorization conflicts with T3D.

T3D must stop without initialization on any unexpected, ambiguous, or conflicting state and use `T3D_STOPPED_PREINITIALIZATION_STATE_CONFLICT` unless another required verdict more accurately describes the condition.

## 7. Locked-state plaintext fallback test

Before mounting or creating synthetic data, T3D must prove that the unmounted plaintext path cannot silently accept ordinary fallback writes.

The authorized test sequence is:

1. verify through `findmnt` or `/proc/self/mountinfo` that the plaintext path is not mounted;
2. apply the minimum temporary fail-closed mode change needed to deny ordinary owner writes while unmounted;
3. record the exact mode before and after the change and confirm ownership remains `dev:dev`;
4. attempt one controlled pre-mount write in a manner that leaves no plaintext file behind;
5. require the write to fail and confirm no file remains; and
6. stop immediately if the write succeeds, any file remains, ownership changes, or mount state is uncertain.

Because an ordinary empty owner-writable directory accepts fallback writes, T3D may temporarily change only the plaintext mountpoint mode. It may restore or adjust that mode only as required for the controlled gocryptfs mount. After every unmount, it must return the plaintext path to the tested fail-closed locked-state mode.

Immutable flags, ACLs, bind mounts, root-owned placeholders, and unrelated security mechanisms are not authorized. Failure of this control requires `T3D_STOPPED_PLAINTEXT_FALLBACK_CONTROL_FAILED`.

## 8. Controlled mount authorization

After the initialization and fallback gates pass, T3D may perform one manual, Dan-controlled mount from `/home/dev/pal-encryption-test/gocryptfs/cipher/` to `/home/dev/pal-encryption-test/gocryptfs/plain/` using interactive password entry by Dan.

The following are prohibited:

- automatic mounting;
- systemd units;
- shell startup entries;
- `fstab` entries;
- stored passwords;
- agent-controlled persistent unlock; and
- background remount processes.

T3D must verify the actual mount through `findmnt` or `/proc/self/mountinfo`, including the observed FUSE filesystem type and the relationship to the approved ciphertext source. If mount capability is unavailable, it must cleanly stop under `T3D_STOPPED_MOUNT_CAPABILITY_UNAVAILABLE` without weakening controls.

## 9. Synthetic test data and hashing

Only after a successful, verified mount, T3D may create this minimal dataset inside the mounted plaintext view:

- `synthetic-note.txt`
- `nested/synthetic-record.txt`

Content must be purpose-created, clearly labeled `SYNTHETIC TEST DATA`, and may include a test identifier and current UTC timestamp. It must contain no personal, PAL, recovery, credential, client, investigative, production, or secret information. T3D may calculate and record SHA-256 hashes of both plaintext test files.

No other test file is authorized.

## 10. Ciphertext observation

After creating the mounted synthetic files, T3D may observe the approved ciphertext directory and record:

- file counts;
- names of standard gocryptfs control files;
- ciphertext object counts;
- hashes of ciphertext objects where practical; and
- whether plaintext filenames and plaintext content are directly visible in the ciphertext tree.

T3D must not copy any ciphertext into the backup or restore directory.

## 11. Wrong-password test and correct-password validation

After the first successful mount is explicitly and cleanly unmounted, T3D may conduct exactly one wrong-password mount attempt. Dan must enter the wrong password interactively; neither its value nor a hint may be recorded.

The wrong-password attempt must fail. The plaintext path must remain unmounted, no plaintext files may be accessible, no fallback write may occur, and the report may record only the outcome. A wrong-password attempt that exposes or mounts plaintext requires `T3D_FAILED_REQUIRES_OWNER_REVIEW`.

After the successful wrong-password rejection, T3D may perform one correct-password remount for validation using interactive entry by Dan. This remount must also be explicitly unmounted.

## 12. Explicit unmount and final locked-state validation

T3D must explicitly unmount after every successful mount using the locally appropriate FUSE unmount method. After each unmount, and conclusively at the end, T3D must verify that:

- the mount is absent;
- plaintext files are inaccessible through the mountpoint;
- the plaintext mountpoint is empty;
- the tested fail-closed permissions are restored;
- ordinary writes fail while unmounted and leave no file;
- ciphertext initialization artifacts remain intact;
- no process retains the mount; and
- no automatic remount occurs.

The ciphertext and synthetic encrypted objects must remain in place. Cleanup and deletion of initialization artifacts are not authorized.

## 13. T3D prohibitions

T3D must not:

- use production paths or actual PAL data;
- use recovery logs, sync manifests, credentials, or secrets;
- create backups or perform restore testing;
- simulate corruption;
- delete initialization artifacts or clean up the test environment;
- modify Git-tracked files other than its required result report;
- install, remove, upgrade, or refresh packages, including running `apt update`;
- install or use LUKS or `cryptsetup`;
- configure automatic mounting; or
- stage, commit, or push.

## 14. Required T3D result report

T3D must create exactly one result report:

`reports/sync/PHASE-3D-C3E-T3D-GOCRYPTFS-INITIALIZATION-MOUNT-TEST-RESULT.md`

No password, password hint, master key, recovery material, or sensitive plaintext may appear in it. Except for that report, T3D must not modify Git-tracked files.

The report must use exactly one verdict:

- `T3D_COMPLETE_READY_FOR_BACKUP_RESTORE_AUTHORIZATION`
- `T3D_STOPPED_PREINITIALIZATION_STATE_CONFLICT`
- `T3D_STOPPED_PASSWORD_HANDLING_BOUNDARY`
- `T3D_STOPPED_PLAINTEXT_FALLBACK_CONTROL_FAILED`
- `T3D_STOPPED_MOUNT_CAPABILITY_UNAVAILABLE`
- `T3D_FAILED_REQUIRES_OWNER_REVIEW`

## 15. Mandatory authorization status block

- `gocryptfs_initialization: AUTHORIZED_FOR_DISPOSABLE_TEST`
- `gocryptfs_mount: AUTHORIZED_FOR_CONTROLLED_TEST`
- `interactive_password_entry: REQUIRED`
- `password_storage: PROHIBITED`
- `master_key_recording: PROHIBITED`
- `synthetic_test_data_only: REQUIRED`
- `plaintext_fallback_test: REQUIRED`
- `wrong_password_test: AUTHORIZED`
- `explicit_unmount: REQUIRED`
- `automatic_mount: PROHIBITED`
- `backup_test: NOT AUTHORIZED`
- `restore_test: NOT AUTHORIZED`
- `corruption_test: NOT AUTHORIZED`
- `cleanup: NOT AUTHORIZED`
- `production_paths_status: NOT AUTHORIZED`
- `luks_status: NOT AUTHORIZED`
- `packages_installed: 0`
- `directories_created: 0`
- `initializations_performed: 0`
- `keys_recorded: 0`
- `mounts_created: 0`
- `test_files_created: 0`
- `backups_created: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

The zero values describe this documentation-only T3C phase, not the future T3D implementation.

## 16. T3C validation record

T3C was documentation-only. Exactly one report was created: this authorization record. No existing file was modified. No password was requested or entered. No initialization artifact, key, configuration, mount, test file, or backup was created. No package state, directory, ownership, or permission was changed. Production paths remained untouched. The Git index remained unchanged and empty. `git diff --check` was run against this report. Work stopped without staging or committing.
