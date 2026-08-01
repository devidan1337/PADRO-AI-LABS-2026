# Phase 3D-C3E-T3F — gocryptfs Ciphertext Backup and Restore Validation Result

> **verdict: `T3F_COMPLETE_READY_FOR_RETENTION_AND_PRODUCTION_DECISION_REVIEW`**
>
> **scope: DISPOSABLE CIPHERTEXT BACKUP, RESTORE, AND PASSWORD-BASED RESTORED-MOUNT VALIDATION**
>
> **production use, cleanup, corruption testing, and master-key recovery remain unauthorized**

## 1. Authority and boundaries

T3F followed the T3E authorization, with T3D and T3C retained as governing evidence. The test used only the authorized disposable source, backup, restore, and mountpoint paths. Dan retained exclusive control of interactive password entry for the restored mount.

No password, password hint, master key, emergency recovery material, or protected configuration content was requested, captured, relayed, transcribed, generated, retained, displayed, or recorded. Configuration files were included in the authorized ciphertext manifests and copies, but their contents were not displayed or interpreted.

The test used no actual PAL, client, investigative, recovery-history, credential, secret, or production data. It does not establish a production backup design or production selection.

## 2. Pre-copy source gate

The pre-copy gate was recorded at `2026-08-01T14:18:20Z`.

| Observation | Actual result |
|---|---|
| User | `uid=1000(dev) gid=1000(dev)` |
| Groups | `dev`, plus sandbox-mapped `nogroup` entries |
| Git branch | `main` |
| Git HEAD | `52c402ff705d5edbed22c54af8571e710da48dcd` |
| Git staged-path count | `0` |
| gocryptfs package | Installed, dpkg status `ii`, version `2.6.1-1` |
| Executable | `/usr/bin/gocryptfs` |
| Source ciphertext | Exists; `dev:dev`; mode `0700` |
| Source exact mountpoint | Absent |
| Original plaintext | Unmounted, empty, `dev:dev`, mode `0500` |
| Backup destination | Existing, `dev:dev`, mode `0700`, empty |
| Restore container | Existing, `dev:dev`, mode `0700`, empty |
| Restore subdirectories | Both absent before T3F |
| Production paths | Both absent |
| Automatic mount reference | None observed |
| Authorization conflict | None observed |

The source contained the retained T3D initialization artifacts and encrypted synthetic objects. It contained five regular files and one directory. No symbolic link, socket, device, FIFO, or other unsupported object was found.

## 3. Authoritative source inventory and manifest

The relative source structure was:

| Relative object | Type | Owner:group | Mode | Size |
|---|---|---|---:|---:|
| `gocryptfs.conf` | Regular file | `dev:dev` | `0400` | 385 bytes |
| `gocryptfs.diriv` | Regular file | `dev:dev` | `0444` | 16 bytes |
| `KPr0WVu8jGRe16rTwQxwKBlfLHVR43MWdxUHyLEkMQE` | Regular file | `dev:dev` | `0600` | 145 bytes |
| `1TPXTjNtFeeWupPs-MuUbw/` | Directory | `dev:dev` | `0700` | 4096 bytes observed |
| `1TPXTjNtFeeWupPs-MuUbw/gocryptfs.diriv` | Regular file | `dev:dev` | `0444` | 16 bytes |
| `1TPXTjNtFeeWupPs-MuUbw/bXbUVq4xgPgxUnU_cTTk8p_GalfpIdKeQ9iCo5n32uY` | Regular file | `dev:dev` | `0600` | 147 bytes |

Practical timestamp comparison was included in the inventory gate and later matched exactly across source, backup, and restore.

| Relative regular file | SHA-256 |
|---|---|
| `gocryptfs.conf` | `30ee22c9c230ef510f1ce055e449d863a2197f4a922a79d06c29cbde96188dfc` |
| `gocryptfs.diriv` | `d346c52caa385d64a4bb870634bfddf7abafecb64e3f7985a1a53ec2db1c3251` |
| `KPr0WVu8jGRe16rTwQxwKBlfLHVR43MWdxUHyLEkMQE` | `fa79dd1079949ec9edb5dd8df51982bc081111cfbb7d8ed30d6e5dd01d47bea3` |
| `1TPXTjNtFeeWupPs-MuUbw/gocryptfs.diriv` | `fc114fa4aab942579174ffc7ee6a230925c79881b173cab6005e2eb198f2b06c` |
| `1TPXTjNtFeeWupPs-MuUbw/bXbUVq4xgPgxUnU_cTTk8p_GalfpIdKeQ9iCo5n32uY` | `c95518a6151893d0266cbe0d38119b6f2a9c87c446b4b9b2c360c71ea10a8dea` |

## 4. Copy-first backup and integrity result

After one-time approval, T3F performed exactly one metadata-preserving copy of the source contents into the verified-empty backup destination. It used a narrowly scoped `cp -a SOURCE/. DESTINATION/`; no move, deletion, cleanup, parent-directory copy, or synchronization-with-removal option was used.

| Backup validation | Actual result |
|---|---|
| Backup regular files | `5` |
| Backup directories below root | `1` |
| Relative structural inventory | Exact source match |
| Ownership and numeric modes | Exact source match |
| Sizes and practical timestamps | Exact source match |
| Source-to-backup hash matches | `5` of `5` |
| Extra or missing objects | `0` |
| Unsupported objects | `0` |
| Standard gocryptfs artifacts | Present |
| Plaintext filenames directly exposed | No |
| Synthetic plaintext label directly readable | No |
| Source manifest after backup | Unchanged from pre-copy manifest |

The backup integrity gate passed without repair, recopy, or cleanup.

## 5. Restored ciphertext copy and integrity result

Only after backup validation, T3F created exactly:

- `/home/dev/pal-encryption-test/gocryptfs/restore/cipher/`
- `/home/dev/pal-encryption-test/gocryptfs/restore/plain/`

Both were initially `dev:dev` mode `0700`. The restored ciphertext directory was verified empty. After separate one-time approval, T3F performed one narrowly scoped, metadata-preserving copy from the backup contents into the restored ciphertext directory.

| Restore validation | Actual result |
|---|---|
| Restored ciphertext regular files | `5` |
| Restored ciphertext directories below root | `1` |
| Relative structural inventory | Exact backup match |
| Ownership and numeric modes | Exact backup match |
| Sizes and practical timestamps | Exact backup match |
| Backup-to-restore hash matches | `5` of `5` |
| Extra or missing objects | `0` |
| Unsupported objects | `0` |
| Separate tree validation | Passed; representative source, backup, and restore files had distinct inode numbers |
| Source manifest after restore | Unchanged |
| Backup manifest after restore | Unchanged |

No source, backup, or restore object was moved or deleted.

## 6. Restored plaintext fail-closed control

Only the restored plaintext mountpoint was changed from initial mode `0700` to fail-closed mode `0500`; ownership remained `dev:dev`. It was verified empty and unmounted. One controlled pre-mount fallback write as `dev` failed with permission denied, and no probe remained.

After that gate passed, only the restored plaintext mountpoint was temporarily changed to `0700` for the FUSE mount attempt. It remained empty, unmounted, and owned by `dev:dev` immediately before owner handoff. The original plaintext mountpoint was not altered.

## 7. Owner-controlled restored mount

Dan manually ran the exact authorized restore-mount command and reported success. The existing disposable password was entered interactively and remained exclusively owner-controlled. No secret value or hint entered Codex or this report.

| Mount observation | Actual result |
|---|---|
| Target | `/home/dev/pal-encryption-test/gocryptfs/restore/plain` |
| Source | `/home/dev/pal-encryption-test/gocryptfs/restore/cipher` |
| Filesystem type | `fuse.gocryptfs` |
| User/group IDs | `1000:1000` |
| Production path involved | No |
| Automatic mount configuration | None observed |

## 8. Restored plaintext validation

Exactly the two retained synthetic files and their necessary `nested/` directory appeared. No unauthorized plaintext object was present. Validation did not modify either file and did not reproduce their contents.

| Restored plaintext file | Size | Owner:group | Mode | SHA-256 | T3D match |
|---|---:|---|---|---|---|
| `/home/dev/pal-encryption-test/gocryptfs/restore/plain/synthetic-note.txt` | 95 bytes | `dev:dev` | `0600` | `6bfbea5e8c76ead0a3f525c97bf2ee68bed87762999670d71d0a5dfbcaee5c72` | Yes |
| `/home/dev/pal-encryption-test/gocryptfs/restore/plain/nested/synthetic-record.txt` | 97 bytes | `dev:dev` | `0600` | `e6fc9d7f35c5353f509cc3b87b24dd119a8a703ccb370df94c8fc287010ee329` | Yes |

Both files retained the expected synthetic-data label. No sensitive plaintext was displayed or recorded.

## 9. Explicit unmount and final restored locked state

After one-time approval, the restored plaintext view was explicitly unmounted using `fusermount3 -u` on the exact restored mountpoint. Only that mountpoint was returned to mode `0500`; ownership remained `dev:dev`.

Final locked-state validation confirmed:

- the restored mount was absent;
- the restored plaintext mountpoint was empty;
- a second and final controlled fallback write failed with permission denied;
- no fallback probe remained;
- no process retained the restored mount; and
- no automatic remount occurred.

## 10. Final retained state and boundary validation

| Boundary | Actual result |
|---|---|
| Original source ciphertext | Present; 5 regular files and 1 directory; pre-copy hashes and metadata unchanged |
| Original plaintext mountpoint | Unmounted, empty, `dev:dev`, mode `0500` |
| Backup ciphertext | Present; 5 regular files and 1 directory; source-exact hashes and metadata retained |
| Restored ciphertext | Present; 5 regular files and 1 directory; backup-exact hashes and metadata retained |
| Restored plaintext mountpoint | Unmounted, empty, `dev:dev`, mode `0500` |
| Source-to-backup final comparison | `5` of `5` hashes match |
| Backup-to-restore final comparison | `5` of `5` hashes match |
| Files or directories deleted | `0` |
| Files moved | `0` |
| Cleanup | Not performed |
| Production paths | Both absent and untouched |
| Package state | Unchanged; gocryptfs remains `2.6.1-1` |
| LUKS or cryptsetup activity | None observed or performed |
| Automatic mount configuration | None observed |
| Git index | Empty; zero staged paths |
| Git operations | Nothing staged, committed, or pushed |

Corruption testing, partial-failure testing, wrong-password retesting, master-key recovery, new plaintext creation, cleanup, and production work were not performed.

## 11. Mandatory status block

- `t3f_status: COMPLETE`
- `source_regular_files: 5`
- `source_directories: 1`
- `backup_regular_files: 5`
- `backup_directories: 1`
- `restore_regular_files: 5`
- `restore_directories: 1`
- `source_backup_hash_matches: 5`
- `backup_restore_hash_matches: 5`
- `restored_mounts_successful: 1`
- `restored_plaintext_files_verified: 2`
- `restored_plaintext_hash_matches: 2`
- `fallback_write_tests: 2`
- `fallback_writes_succeeded: 0`
- `password_recorded: 0`
- `master_keys_recorded: 0`
- `files_copied: 10`
- `directories_created: 2`
- `files_deleted: 0`
- `files_moved: 0`
- `packages_installed: 0`
- `production_paths_status: UNTOUCHED`
- `luks_status: NOT AUTHORIZED`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

`files_copied` counts five regular files in the source-to-backup copy and five regular files in the backup-to-restore copy. `restore_directories` counts the encrypted directory below the restored ciphertext root; `directories_created` counts the two explicitly authorized restore subdirectories.

## 12. Verdict

**`T3F_COMPLETE_READY_FOR_RETENTION_AND_PRODUCTION_DECISION_REVIEW`**

The source-to-backup and backup-to-restore copies are structurally and cryptographically exact; the source remained unchanged; the separate restored ciphertext mounted successfully under owner-controlled password entry; both retained synthetic files matched T3D by size and SHA-256; and both plaintext mountpoints finished empty, unmounted, and fail-closed at mode `0500`. All retained disposable ciphertext trees remain in place because cleanup is unauthorized.
