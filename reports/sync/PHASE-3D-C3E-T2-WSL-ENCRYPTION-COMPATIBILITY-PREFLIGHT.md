# Phase 3D-C3E-T2 — WSL Encryption Environment Compatibility Preflight

> **verdict: `BLOCKED_PENDING_PACKAGE AND PRIVILEGE DECISIONS`**
>
> **scope: READ-ONLY COMPATIBILITY AND PRIVILEGE ASSESSMENT**
>
> **production decision: DEFERRED UNTIL BOTH CONTROLLED TESTS AND RESTORE EXERCISES ARE COMPLETE**

## 1. Authority and boundary

The owner approved sequential evaluation of gocryptfs forward mode first and a LUKS2 file-backed container second. This preflight only inspected compatibility. It does not authorize installation, either test, remediation, production use, or any state-changing encryption operation.

The governing inputs were read:

- `PHASE-3D-C3E-T1-LUKS-VS-GOCRYPTFS-COMPARISON.md`;
- `PHASE-3D-W1A-HUMAN-PRIVATE-STORAGE-ARCHITECTURE-DECISIONS.md`; and
- `PHASE-3D-W1R-PRIVATE-STORAGE-ARCHITECTURE-REVIEW.md`.

Their controls remain in force: manual unlock/mount only, test data only, restore testing before production selection, secrets outside Git and reports, and no production use.

## 2. Evidence classification

The findings use these meanings:

- **Confirmed available:** directly visible and usable for read-only inspection in this execution context.
- **Available but privilege-restricted:** present, but this Codex sandbox cannot exercise it because of privilege or sandbox controls.
- **Missing software:** command/package is not installed.
- **Not testable without state changes:** proof would require an unauthorized install, device creation, mapping, mount, or test artifact.
- **Unsupported or blocked:** a required interface is absent from the current execution context.
- **Requires Windows-side confirmation:** Linux-side evidence cannot establish the Windows WSL package version, distribution registration/version, or host policy.

No mount attempt, module load, package refresh, or device operation was made. Consequently, visible kernel support is not proof of operational mount capability.

## 3. Windows-side observations

The owner supplied the confirmed `wsl --version` observations and the Windows distribution listing below. These are owner-supplied Windows observations; they were not produced by Codex.

```text
NAME      STATE      VERSION
Ubuntu    Running    2
```

| Observation | Result |
|---|---|
| `wsl --version` | **Owner-supplied observation:** WSL version `2.7.10.0`; Kernel version `6.18.33.2-2`; WSLg version `1.0.73.2`; MSRDC version `1.2.6676`; Direct3D version `1.611.1-81528511`; DXCore version `10.0.26100.1-240331-1435.ge-release`; Windows version `10.0.26200.8973` |
| `wsl -l -v` | **Owner-supplied observation:** distribution name `Ubuntu`; state `Running`; WSL generation `2`; Ubuntu is the default distribution, as indicated by the `*` marker in the owner output |

The Windows-side WSL application, kernel, distribution name, distribution state, default-distribution status, and WSL generation are now confirmed from owner-supplied observations. No Windows-side owner output remains outstanding.

## 4. General WSL and Linux observations

| Check | Observation | Classification |
|---|---|---|
| Kernel | `Linux PADRO-AI-CORE 6.18.33.2-microsoft-standard-WSL2 ... x86_64 GNU/Linux`; `/proc/version` confirms the same Microsoft WSL2 kernel build | Confirmed available |
| Distribution | Ubuntu 26.04 LTS (Resolute Raccoon) | Confirmed available |
| WSL configuration | `/etc/wsl.conf`: `systemd=true`, default user `dev`, hostname `PADRO-AI-CORE`, hosts generation disabled | Confirmed available |
| PID 1 | `bwrap`, because commands run inside Codex's restricted sandbox rather than as the normal WSL PID namespace | Available but privilege-restricted |
| systemd | `/run/systemd/system` and `/run/systemd/private` exist and `systemctl` exists; `systemctl is-system-running` cannot connect to the system bus from this sandbox | Requires confirmation in the normal interactive WSL shell |
| Identity | `uid=1000(dev) gid=1000(dev)`; reported groups are `dev` and repeated sandbox-mapped `nogroup`; no `fuse` group is visible | Confirmed in this context |
| Sudo | `/usr/bin/sudo` exists; `sudo -n true` exits 1 because the sandbox sets `no_new_privs`. It did not prompt. Passwordless sudo and interactive sudo availability in the owner's normal shell are therefore not established | Available but privilege-restricted; normal-shell confirmation required |
| Mount table | Read-only inspection completed. Root is backed by `/dev/sdd` ext4. This sandbox overlays/rebinds paths and exposes many mounts read-only; the repository alone is writable | Confirmed in this context |
| `/home/dev` backing filesystem | `/dev/sdd`, ext4, with 4 KiB blocks as recorded by the preceding T1 assessment | Confirmed available |
| Free space | approximately 947 GiB available of 1007 GiB (`1,016,109,391,872` bytes available at inspection) | Confirmed available; no size authorized |
| User namespaces | `user.max_user_namespaces=2147483647`; `/proc/sys/kernel/unprivileged_userns_clone` is absent | Inconclusive for mount policy; FUSE still depends on `/dev/fuse` and helper policy |

The current mount table includes `fusectl` at `/sys/fs/fuse/connections`. No gocryptfs, loop-backed encrypted filesystem, or device-mapper test mount was observed.

## 5. Repository state

| Item | Observation |
|---|---|
| Branch | `main` |
| HEAD | `e69a2f5776edd0c53ec83cb07d2fa65d84edf48b` |
| Index | Clean before this report; no staged changes |
| Working tree | Already contained numerous untracked owner files, including the T1 input; no tracked modification was reported |
| Handling | Pre-existing untracked material was preserved and was not modified |

The dirty baseline means validation is based on exact before/after status comparison and the single expected new output path, not on an assumption that the repository began clean.

## 6. gocryptfs forward-mode preflight

| Check | Observation | Assessment |
|---|---|---|
| `gocryptfs` | Command absent; `dpkg-query` reports no installed package | Missing software |
| Package candidate | Local, unrefreshed APT metadata reports `2.6.1-1` from Ubuntu Resolute `universe` | Confirmed in current metadata only |
| `fuse3` | Installed, version `3.18.2-1` | Confirmed available |
| `fusermount3` | `/usr/bin/fusermount3` exists; `/usr/bin/fusermount` also exists | Confirmed available |
| `/dev/fuse` | Absent from the sandbox's `/dev` | Unsupported or blocked in this context |
| `/dev/fuse` ownership/mode | Not applicable because the node is absent | Not testable here |
| FUSE group | No `fuse` group entry and current user has no FUSE-named group. Modern FUSE access is principally controlled by the device node/helper, so group absence alone is not dispositive | Inconclusive |
| Kernel/filesystem evidence | `CONFIG_FUSE_FS=y`, `/sys/module/fuse` exists, and `/proc/filesystems` lists `fuse`, `fuseblk`, and `fusectl` | Kernel support visible |
| `fusectl` | Mounted at `/sys/fs/fuse/connections` | Confirmed available |
| User policy | User namespaces are numerous, but this sandbox uses its own user/PID namespaces, `no_new_privs`, and a restricted device view | Available but privilege-restricted |

An ordinary-user gocryptfs mount as `dev` is plausible in a normal WSL shell because FUSE3 and its set-up helper are installed and kernel support is built in. It is **not confirmed**: `gocryptfs` must first be installed under separate authorization, and `/dev/fuse` access must be checked outside this sandbox. Installing the package would normally require root; a normal forward-mode mount should ordinarily run as `dev` once the mountpoint, ciphertext directory, and `/dev/fuse` access are authorized. Root or Windows-side configuration may be needed if the normal WSL shell also lacks `/dev/fuse`.

**Preflight result: `GOCRYPTFS_PREFLIGHT_REQUIRES_PACKAGE_INSTALL`**

This result does not claim that FUSE works. The absent binary is the immediate known prerequisite; actual FUSE access remains an implementation-authorization gate.

## 7. LUKS2 file-backed-container preflight

| Check | Observation | Assessment |
|---|---|---|
| `cryptsetup` | Command absent; `dpkg-query` reports no installed package | Missing software |
| Package candidate | Local, unrefreshed APT metadata reports `2:2.8.4-1ubuntu4` from Ubuntu Resolute `main` | Confirmed in current metadata only |
| `losetup` | `/usr/sbin/losetup`; supplied by installed `util-linux 2.41.3-3ubuntu2` | Confirmed available |
| `dmsetup` | `/usr/sbin/dmsetup`; installed `2:1.02.205-2ubuntu3` | Confirmed available |
| `/dev/loop-control` | Absent | Blocked in this context |
| `/dev/loop*` | No nodes found | Blocked in this context |
| `/dev/mapper` | Absent | Blocked in this context |
| `/dev/mapper/control` | Absent | Blocked in this context |
| Loop kernel evidence | `CONFIG_BLK_DEV_LOOP=y`, `/sys/module/loop`, `/proc/misc` loop-control minor 237, and loop block major 7 | Kernel support visible |
| Device-mapper evidence | `CONFIG_BLK_DEV_DM=y`, `/sys/module/dm_mod`, `/proc/misc` device-mapper minor 236, and device-mapper block major 254 | Kernel support visible |
| dm-crypt evidence | `CONFIG_DM_CRYPT=m` and `dm-crypt.ko` is present; `/sys/module/dm_crypt` is absent, so it is not currently shown as loaded in this namespace | Software/kernel support available but activation unconfirmed |
| `modprobe` | `/usr/sbin/modprobe` exists (`kmod 34.2-2ubuntu2`) | Confirmed available; loading a module was not authorized |

LUKS image setup, loop association, `cryptsetup` format/open/close, filesystem creation, mounting, and cleanup normally require root. The restricted Codex environment cannot obtain root because `no_new_privs` blocks sudo, and it does not expose the device nodes. Although WSL's kernel advertises the required facilities, this environment does not prove that the normal interactive WSL shell exposes or can create the nodes. Creating nodes, loading dm-crypt, or allocating a loop would be state-changing and was not attempted.

If the normal WSL shell also lacks these nodes, privileged Linux remediation may be needed and could be ephemeral across WSL starts. An alternative Windows-attached VHD design would require separate design review and may require Windows administrator involvement; it is not authorized by this file-backed-container preflight.

**Preflight result: `LUKS_PREFLIGHT_BLOCKED_BY_DEVICE_NODES`**

This is the most restrictive result: `cryptsetup` also requires installation, root is unconfirmed, and dm-crypt activation may require privileged remediation, but missing loop and mapper nodes prevent even a later file-backed test in this execution context.

## 8. Privilege assessment

- The current user is `dev`; `sudo` is installed.
- `sudo -n true` failed without prompting because Codex runs with `no_new_privs`. This neither proves nor disproves passwordless or interactive sudo in the owner's normal WSL shell.
- A later gocryptfs package installation would normally require root. Once installed and once FUSE/device/path access is confirmed, a normal gocryptfs mount would likely run as `dev`.
- LUKS setup, mapping, filesystem creation, mount, and cleanup would require root.
- Codex's execution environment materially differs from the normal interactive WSL shell: it uses `bwrap`, separate user/PID/network namespaces, restricted device exposure, read-only system mounts, `no_new_privs`, and a narrowly writable repository bind.
- Therefore privilege and device failures observed here must be rechecked in the owner's normal interactive WSL shell under a separately authorized implementation preflight; they must not be bypassed here.

## 9. Plaintext-fallback design preflight

Future tests must use isolated disposable test paths. They must **not** use:

- `/home/dev/pal-private-archive/active/`
- `/home/dev/pal-private-archive/legacy/`

Suggested names for later owner review only:

| Purpose | Proposed path | Status |
|---|---|---|
| gocryptfs ciphertext backing | `/home/dev/pal-encryption-tests/gocryptfs/ciphertext/` | **PROPOSED — NOT CREATED OR APPROVED** |
| gocryptfs plaintext mount | `/home/dev/pal-encryption-tests/gocryptfs/plaintext/` | **PROPOSED — NOT CREATED OR APPROVED** |
| gocryptfs restore target | `/home/dev/pal-encryption-tests/gocryptfs/restore/` | **PROPOSED — NOT CREATED OR APPROVED** |
| gocryptfs backup | `/home/dev/pal-encryption-tests/gocryptfs/backup/` | **PROPOSED — NOT CREATED OR APPROVED** |
| LUKS backing image | `/home/dev/pal-encryption-tests/luks2/backing/pal-luks2-test.img` | **PROPOSED — NOT CREATED OR APPROVED** |
| LUKS plaintext mount | `/home/dev/pal-encryption-tests/luks2/plaintext/` | **PROPOSED — NOT CREATED OR APPROVED** |
| LUKS restore target | `/home/dev/pal-encryption-tests/luks2/restore/` | **PROPOSED — NOT CREATED OR APPROVED** |
| LUKS backup | `/home/dev/pal-encryption-tests/luks2/backup/` | **PROPOSED — NOT CREATED OR APPROVED** |

A future authorized workflow must fail closed before writing plaintext. For gocryptfs, use `findmnt --target <plaintext-path>` and confirm an expected FUSE filesystem type such as `fuse.gocryptfs` (the exact reported type must be established in the controlled test), the intended ciphertext/mount relationship, and the expected gocryptfs process. `/proc/self/mountinfo` is the independent low-level confirmation.

For LUKS2, use `findmnt --target <plaintext-path>` and confirm the authorized inner filesystem type, a source resolving to the expected `/dev/mapper/<approved-test-name>`, and the expected mapper name. Confirm the mapper independently before writes, and use `/proc/self/mountinfo` to verify the mount visible to the writing process. Process presence alone is insufficient for either technology.

## 10. Decision table

| Capability                               | gocryptfs | LUKS2 |
| ---------------------------------------- | --------- | ----- |
| Candidate software installed             | NO — missing software | NO — missing software |
| Package candidate known                  | YES — `2.6.1-1` in existing metadata | YES — `2:2.8.4-1ubuntu4` in existing metadata |
| Kernel support visible                   | YES — FUSE built in | YES — loop and DM built in; dm-crypt module present |
| Required device available                | NO in Codex sandbox (`/dev/fuse` absent) | NO in Codex sandbox (loop and mapper nodes absent) |
| Ordinary-user path plausible             | YES, but unconfirmed outside sandbox | NO |
| Root required                            | Install: YES; normal mount: likely NO | YES for setup, mapping, filesystem, mount, cleanup |
| Windows-side action possibly required    | POSSIBLY; Windows-side WSL details are confirmed, but policy and `/dev/fuse` may still require assessment | YES/POSSIBLY; Windows-side WSL details are confirmed, but an admin-only VHD alternative may need separate assessment if authorized |
| State-changing test currently authorized | NO        | NO    |
| Preflight result                         | `GOCRYPTFS_PREFLIGHT_REQUIRES_PACKAGE_INSTALL` | `LUKS_PREFLIGHT_BLOCKED_BY_DEVICE_NODES` |

## 11. Verdict

**`BLOCKED_PENDING_PACKAGE AND PRIVILEGE DECISIONS`**

The Windows-side WSL application, kernel, distribution name, distribution state, default-distribution status, and WSL generation are now confirmed by the owner; no Windows-side owner output remains outstanding. The environment is not presently ready to request both state-changing tests: both candidate applications are missing; gocryptfs still needs normal-shell `/dev/fuse` confirmation; and LUKS2 is blocked by absent loop and mapper device nodes in this execution context, with root and dm-crypt activation unconfirmed. Package installation remains unauthorized. The verdict requests no installation and authorizes no testing.

Gocryptfs remains the recommended first disposable test candidate. LUKS remains deferred pending privileged device-node remediation and validation. No implementation or production decision is authorized; the production technology decision remains deferred until both controlled tests and restore exercises are complete.

## 12. Human decisions required

- Whether package installation may be authorized.
- Which package may be installed first; the approved sequence currently points to gocryptfs first.
- The approved disposable backing, ciphertext, plaintext mount, restore, and backup paths.
- The approved test size.
- Whether interactive sudo/root use is acceptable.
- Password and recovery-material generation, entry, custody, escrow, and non-logging handling.
- The approved backup destination.
- Cleanup authorization, including exact artifacts and device/mapping teardown.
- Whether gocryptfs testing proceeds before LUKS2, consistent with the current owner direction.
- Whether any Linux device-node/module remediation is acceptable.
- Whether a Windows-administrator-assisted VHD alternative may be assessed if the file-backed LUKS approach remains blocked.

## 13. Mandatory status block

- `preflight_status: COMPLETE`
- `gocryptfs_test_status: NOT AUTHORIZED`
- `luks_test_status: NOT AUTHORIZED`
- `package_installation_status: NOT AUTHORIZED`
- `production_use_status: NOT AUTHORIZED`
- `packages_installed: 0`
- `keys_created: 0`
- `containers_created: 0`
- `ciphertext_directories_created: 0`
- `test_directories_created: 0`
- `loop_devices_created: 0`
- `mappings_created: 0`
- `filesystems_created: 0`
- `mounts_created: 0`
- `test_files_created: 0`
- `backups_created: 0`
- `permissions_changed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 14. Validation record

Exactly one Phase 3D-C3E-T2 output file was revised and no other file was modified by this revision. Package metadata was not refreshed; no package was installed. No device, mapping, mount, directory, key, container, filesystem, backup, or test file was created. The Git index remained unchanged. `git diff --check` was run against this report. Work stopped without staging or committing.
