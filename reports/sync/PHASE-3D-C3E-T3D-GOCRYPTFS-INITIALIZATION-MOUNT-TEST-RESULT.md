# Phase 3D-C3E-T3D — gocryptfs Initialization, Mount, Locked-State, and Synthetic Write Test Result

> **verdict: `T3D_COMPLETE_READY_FOR_BACKUP_RESTORE_AUTHORIZATION`**
>
> **scope: DISPOSABLE INITIALIZATION, CONTROLLED MOUNT, LOCKED-STATE, AND SYNTHETIC WRITE TEST**
>
> **production, backup, restore, corruption, and cleanup remain unauthorized**

## 1. Authority and test boundary

This implementation followed the T3C authorization, with T3B and T3A retained as governing inputs. Dan retained direct control of every interactive password entry. No password, password hint, master key, emergency recovery material, or configuration content was requested, captured, relayed, transcribed, generated, retained, or recorded.

The test operated only on:

- ciphertext: `/home/dev/pal-encryption-test/gocryptfs/cipher/`; and
- plaintext mountpoint: `/home/dev/pal-encryption-test/gocryptfs/plain/`.

The restore and backup directories remained unused. Both production archive paths remained absent and untouched. This disposable result does not constitute production selection.

## 2. Pre-initialization validation

Pre-initialization validation was recorded at `2026-08-01T13:07:21Z`.

| Observation | Actual result |
|---|---|
| User | `uid=1000(dev) gid=1000(dev)` |
| Groups | `dev`, plus sandbox-mapped `nogroup` entries |
| Git branch | `main` |
| Git HEAD | `821544b4c01a4d2c7f42b8b36217c6102d79ef0c` |
| Git staged-path count | `0` |
| gocryptfs package | Installed, dpkg status `ii` |
| Installed version | `2.6.1-1` |
| Executable | `/usr/bin/gocryptfs` |
| Ciphertext directory | Exists; `dev:dev`; initial mode `0700`; empty |
| Plaintext directory | Exists; `dev:dev`; initial mode `0700`; empty |
| Exact mounts on either test path | None |
| `gocryptfs.conf` before initialization | Absent |
| Restore and backup directories | Empty and unused |
| Production archive paths | Both absent |
| Authorization conflict | None observed |

All pre-initialization gates passed before state-changing work began.

## 3. Locked-state fallback control

The plaintext mountpoint started as `dev:dev` mode `0700`. Only its mode was changed, first to `0500`, which removes ordinary owner write permission while preserving owner read and traversal. Ownership remained `dev:dev`.

Exactly one pre-initialization fallback write was attempted as `dev`. It failed with permission denied, and no probe file or directory remained. This established `0500` as the tested fail-closed locked-state mode.

FUSE required the mounting user to have write access to the mountpoint. The first owner-controlled mount command therefore failed before mounting while the path remained `0500`. No plaintext exposure or artifact resulted. Under the existing authorization, only the mountpoint mode was temporarily returned to `0700` for each controlled authentication and mount attempt. After every successful unmount, mode `0500` was restored and validated.

## 4. Initialization result

Dan manually ran the authorized initialization command and reported success. Interactive password selection, entry, and confirmation remained exclusively owner-controlled. Codex received no password value or hint.

| Observation | Actual result |
|---|---|
| Disposable initializations | `1` to the extent locally observable |
| `gocryptfs.conf` | Exists; `dev:dev`; mode `0400`; contents not read or displayed |
| Root `gocryptfs.diriv` | Exists; `dev:dev`; mode `0444` |
| Initialization artifact timestamp | `2026-08-01 09:25:49.302205060 -0400` |
| Mount immediately after initialization | None |
| Plaintext test files immediately after initialization | None |
| Recovery material displayed | Not recorded; Dan retained sole responsibility for any displayed recovery material |
| Recovery material recorded by Codex | `0` |

No second initialization was locally observed.

## 5. First controlled mount and synthetic dataset

After the mountpoint was temporarily set to `0700`, Dan ran the approved mount command and entered the disposable test password interactively. The mount succeeded and was independently verified.

| Mount observation | Actual result |
|---|---|
| Target | `/home/dev/pal-encryption-test/gocryptfs/plain` |
| Source | `/home/dev/pal-encryption-test/gocryptfs/cipher` |
| Filesystem type | `fuse.gocryptfs` |
| User/group IDs | `1000:1000` |
| Production path involved | No |
| Automatic mount configuration | None observed |

Only the two authorized synthetic files and their necessary `nested/` directory were created in the verified mounted plaintext view. File content was limited to the label `SYNTHETIC TEST DATA`, a test identifier, and a UTC timestamp.

| Plaintext file | Size | Owner:group | Mode | SHA-256 |
|---|---:|---|---|---|
| `/home/dev/pal-encryption-test/gocryptfs/plain/synthetic-note.txt` | 95 bytes | `dev:dev` | `0600` | `6bfbea5e8c76ead0a3f525c97bf2ee68bed87762999670d71d0a5dfbcaee5c72` |
| `/home/dev/pal-encryption-test/gocryptfs/plain/nested/synthetic-record.txt` | 97 bytes | `dev:dev` | `0600` | `e6fc9d7f35c5353f509cc3b87b24dd119a8a703ccb370df94c8fc287010ee329` |

No unauthorized plaintext file appeared.

## 6. Ciphertext observation

After the synthetic writes, the ciphertext tree contained one encrypted subdirectory and five regular files in total. The regular-file total consists of standard gocryptfs control/metadata files and two encrypted data objects. Standard observed control filenames included `gocryptfs.conf` and `gocryptfs.diriv`; configuration contents were not read or recorded.

| Ciphertext validation | Actual result |
|---|---|
| Ciphertext directories below root | `1` |
| Ciphertext regular files below root | `5` |
| Encrypted data objects excluding files named `gocryptfs.conf` and `gocryptfs.diriv` | `2` |
| Plaintext filenames directly visible | No |
| Synthetic plaintext label directly readable | No |
| Encrypted object SHA-256 1 | `c95518a6151893d0266cbe0d38119b6f2a9c87c446b4b9b2c360c71ea10a8dea` |
| Encrypted object SHA-256 2 | `fa79dd1079949ec9edb5dd8df51982bc081111cfbb7d8ed30d6e5dd01d47bea3` |

No ciphertext was copied to the backup or restore directory.

## 7. First unmount and locked-state validation

The first successful mount was explicitly unmounted with the local FUSE unmount helper. Validation then confirmed:

- the mount was absent;
- the plaintext mountpoint was empty;
- synthetic plaintext files were not visible through it;
- ciphertext initialization artifacts and encrypted objects remained;
- mode `0500` and ownership `dev:dev` were restored;
- a second controlled ordinary fallback write failed with permission denied;
- no fallback artifact remained;
- no process retained the mount; and
- no automatic remount occurred.

## 8. Wrong-password behavior

For authentication testing only, the empty and unmounted mountpoint was temporarily changed from `0500` to `0700`. Dan made exactly one interactive wrong-password attempt and reported that it was rejected. No wrong password or hint was recorded.

Independent validation confirmed that the plaintext path remained unmounted and empty, no plaintext was accessible, and no fallback artifact existed. Mode `0500` was restored and verified before preparing the mountpoint for the authorized correct-password remount. Wrong-password access was not granted.

## 9. Correct-password remount and hash validation

Dan performed one owner-controlled correct-password remount. The exact approved source, target, and `fuse.gocryptfs` filesystem type were verified again. Exactly the two authorized files and the expected `nested/` directory reappeared.

Both plaintext SHA-256 values matched their first-mount values:

- `synthetic-note.txt`: match;
- `nested/synthetic-record.txt`: match.

No unauthorized entry appeared. The remount was then explicitly unmounted.

## 10. Final locked-state and boundary validation

After the final unmount:

| Boundary | Actual result |
|---|---|
| Exact plaintext mount | Absent |
| Plaintext mountpoint contents | Empty |
| Plaintext mountpoint owner:group | `dev:dev` |
| Final fail-closed mode | `0500` |
| Final fallback write | Failed with permission denied |
| Final fallback artifact | Absent |
| Initialization artifacts | Intact |
| Encrypted synthetic objects | Retained; cleanup not performed |
| gocryptfs process retaining mount | None observed |
| Automatic remount | None observed |
| Automatic mount configuration | None observed in checked system/user locations |
| Restore directory | Empty and unused |
| Backup directory | Empty and unused |
| Production paths | Both absent and untouched |
| Package changes during T3D | None; gocryptfs remains `2.6.1-1` |
| LUKS or cryptsetup activity | None observed or performed |
| Git index | Empty; zero staged paths |
| Git operations | Nothing staged, committed, or pushed |

Backup, restore, corruption simulation, cleanup, production work, and LUKS work were not performed.

## 11. Mandatory status block

- `t3d_status: COMPLETE`
- `gocryptfs_initialization: EXECUTED`
- `interactive_password_entry: OWNER_CONTROLLED`
- `password_recorded: 0`
- `master_keys_recorded: 0`
- `mounts_successful: 2`
- `wrong_password_attempts: 1`
- `wrong_password_access_granted: 0`
- `synthetic_test_files_created: 2`
- `plaintext_hash_matches_after_remount: 2`
- `fallback_write_tests: 3`
- `fallback_writes_succeeded: 0`
- `backups_created: 0`
- `restore_tests_performed: 0`
- `production_paths_status: UNTOUCHED`
- `luks_status: NOT AUTHORIZED`
- `packages_installed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 12. Verdict

**`T3D_COMPLETE_READY_FOR_BACKUP_RESTORE_AUTHORIZATION`**

The disposable filesystem initialized successfully; owner-controlled correct-password mounts worked; wrong-password access was rejected; the two synthetic plaintext hashes survived an unmount/remount cycle; plaintext names and content were not directly exposed in ciphertext; all successful mounts were explicitly unmounted; and fail-closed mode `0500` rejected ordinary fallback writes before initialization, after the first unmount, and after the final unmount. Backup and restore remain unauthorized pending a later owner decision.
