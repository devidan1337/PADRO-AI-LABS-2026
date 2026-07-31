# Phase 3D-C3E-T1 — LUKS versus gocryptfs Technology Comparison

> **verdict: `READY_FOR_OWNER_TECHNOLOGY DECISION`**
> **recommendation: `RECOMMEND_BOTH_SEQUENTIALLY`**
> **scope: RESEARCH, LOCAL COMPATIBILITY ASSESSMENT, AND DESIGN ONLY**

## 1. Authority and fixed boundary

This comparison is governed by:

- `PHASE-3D-W1R-PRIVATE-STORAGE-ARCHITECTURE-REVIEW.md`;
- `PHASE-3D-W1A-HUMAN-PRIVATE-STORAGE-ARCHITECTURE-DECISIONS.md`; and
- `PHASE-3D-C3A-HUMAN-STORAGE-RETENTION-DECISIONS.md`.

Option B—a separately encrypted private archive inside WSL—is the approved architecture direction. The final encryption technology is **not selected**. Automatic mounting is prohibited; unlock and mount must be manual and Dan-controlled. The first exercise must use test data only. Production use remains unauthorized. This checkpoint is authorized only to compare technologies.

The approved paths remain logical, uncreated policy locations:

- `/home/dev/pal-private-archive/active/`
- `/home/dev/pal-private-archive/legacy/`

No package installation, key generation, encrypted-storage creation, directory creation, configuration change, filesystem creation, mapping, mount, backup, or production-data operation was authorized or performed.

## 2. Evidence method and local compatibility

### 2.1 Confirmed local observations

All checks were read-only. No module was loaded and no device, mapping, mount, file, or directory was created.

| Item | Confirmed observation | Meaning |
|---|---|---|
| WSL generation | `/proc/version`, `uname`, and the Microsoft kernel name report `microsoft-standard-WSL2`; `WSL_INTEROP` is present | This distribution is running under WSL 2. The Windows-side WSL application/package version could not be obtained: `wsl.exe --version` failed from this restricted command environment before returning version data. It must be recorded later from Windows PowerShell. |
| Kernel | `6.18.33.2-microsoft-standard-WSL2`, x86_64 | A real Microsoft WSL2 Linux kernel is in use. |
| Distribution | Ubuntu 26.04 LTS (Resolute Raccoon) | Candidate package availability/version must later be confirmed against the authorized Ubuntu repositories. |
| systemd | `/etc/wsl.conf` contains `[boot] systemd=true`; `/run/systemd/system` exists | Systemd is configured and its runtime directory exists. In this restricted execution context PID 1 is `bwrap`, and `systemctl is-system-running` cannot reach the system bus, so active host-level systemd state is not proven here. Automatic mount is prohibited regardless. |
| Device mapper | Kernel interfaces show device-mapper major 254, `/sys/module/dm_mod`, and `/proc/misc` device-mapper entry | Kernel support appears present. `/dev/mapper` is absent here; `dmsetup version` could not create/access `/dev/mapper/control` due to permission restrictions. Usability is not confirmed. |
| Loop devices | `/sys/module/loop` and the loop-control misc-device entry are present; `losetup` exists | Kernel and userspace support appear present, but no `/dev/loop-control` or `/dev/loopN` nodes are exposed here. No loop was allocated. Usability is not confirmed. |
| FUSE | `/sys/module/fuse`, `fuse`, `fuseblk`, and `fusectl` filesystem entries are present; `fusectl` is mounted | Kernel FUSE support is present. `/dev/fuse` is not exposed to this restricted context, so an actual user mount is not confirmed. |
| Candidate software | `cryptsetup` and `gocryptfs` commands are absent; package database reports neither installed | Both candidates would require separately authorized package installation unless later inspection finds an approved alternate binary. |
| FUSE userspace | `fuse3` 3.18.2 is installed; `/usr/bin/fusermount3` and `/usr/bin/fusermount` exist | The normal FUSE mount helper is available, but gocryptfs itself is not. |
| Backing filesystem | `/home/dev` and the repository resolve to `/dev/sdd`, ext4, 4 KiB blocks | A Linux-native backing filesystem is suitable in principle for ordinary container files and ciphertext directories. The exact test backing location remains a human decision. |
| Free space | `df -hT` reported approximately 947 GiB available on the 1007 GiB ext4 filesystem | Space is ample for a small test, but no size is approved and this observation is not authorization to allocate it. |
| Existing relevant mounts | No PAL-private, gocryptfs, crypt, mapper, or data FUSE mount was found; only `fusectl` matched | No candidate test mount was observed or created. |

Microsoft documents that WSL 2 uses a Linux kernel and provides full system-call compatibility, and that `wsl --list --verbose` and `wsl --version` are the Windows-side checks for distribution generation and WSL application version ([WSL version comparison](https://learn.microsoft.com/en-us/windows/wsl/compare-versions), [basic WSL commands](https://learn.microsoft.com/en-us/windows/wsl/basic-commands)). Microsoft also documents `/etc/wsl.conf` systemd enablement and notes that systemd services do not keep a WSL instance alive ([systemd on WSL](https://learn.microsoft.com/en-us/windows/wsl/systemd)).

### 2.2 Compatibility conclusion

- **File-backed LUKS test:** documentation-supported and **plausible but not locally confirmed**. The kernel advertises loop and device-mapper facilities and `losetup`/`dmsetup` exist, but `cryptsetup` is absent and this sandbox exposes neither loop nodes nor `/dev/mapper`. A later authorized preflight must prove device creation and cleanup privileges without using production paths.
- **Forward-mode gocryptfs test:** documentation-supported and **plausible but not locally confirmed**. Kernel FUSE and FUSE3 helpers exist, but gocryptfs is absent and `/dev/fuse` is not exposed here. A later authorized ordinary-user preflight must prove FUSE mounting.
- **Overall:** sufficient evidence exists for a technology decision and staged test recommendation, but not for declaring either implementation operational.

Assumptions requiring later testing include Windows-side WSL version, repository package versions, actual `/dev/fuse` access, creation of loop and mapper device nodes, root/sudo policy, clean unmount during normal and abnormal WSL termination, filesystem performance, and restore compatibility on a second environment.

## 3. Candidate 1 — LUKS2 file-backed container

### 3.1 Proposed design

A fixed-size ordinary backing file would be treated as a block device, formatted as LUKS2, unlocked through `cryptsetup`, exposed as a device-mapper device, formatted with a Linux filesystem, and mounted. The approved active and legacy paths would be policy-facing mount locations only after successful unlock. This is a design description, not an executed procedure.

Linux documents dm-crypt as transparent block-device encryption using device mapper and the kernel crypto API ([kernel dm-crypt documentation](https://docs.kernel.org/admin-guide/device-mapper/dm-crypt.html)). Cryptsetup documents LUKS key management, header backup, image backup, and recovery hazards ([cryptsetup FAQ](https://gitlab.com/cryptsetup/cryptsetup/-/blob/main/FAQ.md)).

### 3.2 Security and operational assessment

| Property | Assessment |
|---|---|
| Encryption scope | Encrypts filesystem blocks inside the container, including file contents, filenames, directory layout, inode metadata, and free-space history, subject to filesystem/discard behavior. It does not encrypt the backing file's host metadata or anything outside it. |
| Locked metadata confidentiality | Stronger than file-granular encryption: individual filenames, counts, directory structure, timestamps, and file sizes are not directly visible. The backing file's existence, total fixed container size, modification time, and broad activity/change pattern remain visible. Discard/TRIM can leak allocation information and should be a deliberate later decision. |
| Size leakage | Exact individual file sizes are concealed while locked; total container size is public. Used-space patterns may leak through sparse allocation, snapshots, or discard choices. |
| Integrity | Ordinary LUKS2/dm-crypt provides confidentiality but not comprehensive authenticated integrity or anti-rollback. Malicious block changes may cause corruption without reliable attribution. dm-integrity/authenticated modes exist but materially change complexity and are outside this first comparison design ([kernel dm-integrity documentation](https://docs.kernel.org/admin-guide/device-mapper/dm-integrity.html)). |
| Keys and keyslots | LUKS2 supports multiple keyslots wrapping one volume key, enabling separate passphrases/recovery credentials and controlled rotation. A keyslot is not a backup of the encrypted data. |
| Header recovery | LUKS metadata/header damage can make all content unrecoverable even if the password is known. A tested `luksHeaderBackup` is critical. LUKS2 has redundant metadata, but not immunity from overwrite or corruption. |
| Resizing | Requires coordinating backing-file growth, loop/mapping refresh, LUKS mapping size, and inner filesystem growth. Shrinking is riskier and ordering-sensitive. Fixed allocation must be planned. |
| Portability | Strong across Linux systems with compatible cryptsetup, dm-crypt, loop support, and the inner filesystem; poor on systems lacking those facilities and more cumbersome than file-granular ciphertext. |
| Backup | A locked whole-container copy preserves ciphertext, header, keyslots, filesystem, and unused space. It is simple conceptually but large, poorly compressible, and often inefficient for file-level incremental backup. Block-aware/deduplicating tools may help but expose change patterns and need validation. |
| Snapshot behavior | Host/VHD/container snapshots capture opaque block states. A live snapshot must be crash-consistent or quiesced; an unlocked/mounted filesystem copied without coordination may restore inconsistently. Old snapshots enable rollback and retain old header/keyslot states. |
| Corruption blast radius | Container/header/filesystem corruption can affect many or all files. Partial block corruption may damage local filesystem structures or files; header loss can make the whole container inaccessible. |
| Performance | Usually efficient sequential and general filesystem I/O after unlock, with block-crypto and virtual-disk layers adding overhead. WSL-specific loop/VHD behavior must be benchmarked with test data. |
| Privilege and dependencies | Normally requires root for loop association, LUKS open/close, filesystem creation, and mount; depends on loop, device mapper/dm-crypt, device nodes, cryptsetup, and filesystem tools. |
| WSL lifecycle | Manual close/unmount is required before `wsl --shutdown`, Windows restart, or termination. Abrupt WSL termination resembles power loss: the inner filesystem may need recovery and the mapper may vanish when the VM stops. Startup must remain locked; no systemd automount. |
| Plaintext fallback | High consequence if archive commands write into an ordinary directory when the encrypted filesystem is absent. Mountpoint guards and command validation are mandatory. |
| Manual-only fit | Good: an explicit root-controlled unlock/mount and explicit reverse close sequence is auditable. It must never be silently automated. |
| Learning value | Excellent for block encryption, keyslots, headers, device mapper, filesystems, sizing, clean shutdown, backup consistency, and disaster recovery. It has the larger operational blast radius for a first exercise. |

While mounted, plaintext is accessible according to normal Linux permissions. WSL root and other sufficiently privileged processes can bypass those permissions, read memory or mounted data, and interfere with the mapping. Windows administrators or malware controlling the host can observe or manipulate WSL and may capture credentials or plaintext during use.

## 4. Candidate 2 — gocryptfs forward mode

### 4.1 Proposed design

A ciphertext directory would hold encrypted per-file objects and `gocryptfs.conf`; a separate FUSE mount would expose the plaintext view. Contents and filenames would be encrypted. The approved paths could be plaintext mountpoints or policy-facing locations exposed only after successful manual mount. This report neither initializes nor mounts such a filesystem.

The upstream threat model states that a ciphertext snapshot does not reveal file contents or filenames with a sound password, but exact plaintext file sizes can be calculated; a live ciphertext observer sees counts, structure, change timing, and written-block locations, and can delete or roll back data ([gocryptfs threat model](https://nuetzlich.net/gocryptfs/threat_model/)).

### 4.2 Security and operational assessment

| Property | Assessment |
|---|---|
| Encryption scope | Encrypts regular-file contents and names in the ciphertext tree and presents plaintext through FUSE. The backing filesystem still exposes ciphertext object count, hierarchy, sizes, timestamps, and change patterns. |
| Filename and metadata privacy | Filenames are encrypted using per-directory context, but directory/object existence, nesting, counts, ciphertext sizes, modification timing, and access/change patterns remain observable. Exact plaintext file sizes are derivable from ciphertext sizes. Some ownership, mode, timestamp, link, and special-file semantics depend on gocryptfs/FUSE/backing-filesystem behavior and require testing. |
| Per-file backup/sync | Natural fit: changed ciphertext files can be copied/versioned individually, making incrementals and single-object transfer practical. Renames and directory-IV/name files must be kept consistent; a backup tool must include all gocryptfs metadata. |
| Integrity | Authenticated content blocks detect many modifications on read, but gocryptfs does not prevent deletion, truncation at supported boundaries, replay of earlier blocks, file swaps/renames, whole-tree rollback, or denial of service by a writable ciphertext adversary. Versioned trusted inventories are still needed. |
| Configuration and keys | `gocryptfs.conf` contains the master key encrypted under a password-derived key plus format parameters. The password unlocks that configuration; it is not itself the file-content key. An independently protected master-key recovery record can bypass password/config loss if valid for the filesystem. No recovery material may appear in Git, logs, prompts, or commands. |
| Corruption blast radius | Usually file- or metadata-object granular: one damaged ciphertext file commonly affects its plaintext counterpart. Loss/corruption of `gocryptfs.conf`, directory IVs, or name metadata can affect the whole filesystem or directory subtree. |
| Portability | Good across supported systems with compatible gocryptfs and FUSE; ciphertext is composed of ordinary files. Name-length and filesystem semantic differences must be tested. |
| Performance | Adds FUSE context-switching, filename translation, and per-file crypto overhead. Small-file and metadata-heavy archive work may be slower; file-granular backup avoids rescanning/copying a full container. Test locally. |
| Privilege and dependencies | Commonly mountable by an ordinary authorized user with `/dev/fuse`, `fusermount3`, and suitable mountpoint permissions; initialization/installation or environment policy may still require root. It depends on FUSE and gocryptfs, not loop or device mapper. |
| Manual workflow | A direct, Dan-initiated password prompt can mount ciphertext to plaintext; explicit `fusermount3 -u`/equivalent unmount then confirms the view is gone. No passfile, key agent, startup service, or automount is allowed. |
| Plaintext fallback | The most important operational risk is an application writing into the unmounted plaintext directory. An apparently normal directory can silently accumulate plaintext unless made inaccessible and commands verify the expected `fuse.gocryptfs` mount. |
| Grouped records/archive use | File and directory semantics suit grouped records, hash inventories, targeted restore, and archive retention better than manually encrypted packages. FUSE behavior for links, permissions, timestamps, xattrs, and atomic archive operations must be verified. |
| Encrypted backup future | Strong candidate for versioned ciphertext backup because each encrypted file remains an independent backup object. The destination sees metadata and change patterns; configuration and recovery custody cannot rely on the routine ciphertext copy alone. |
| Practical PAL fit | Lower-risk first operational validation: ordinary-file storage, file-granular backup/restore, and likely ordinary-user mounts. It offers weaker metadata confidentiality than LUKS but better day-to-day archive and backup granularity. |

Mounted plaintext remains available to `dev`, WSL root, sufficiently privileged processes, host administrators, and malware acting with suitable access. FUSE is not a security boundary against root or the Windows host.

## 5. Security comparison by threat

Ratings: **Protects while locked** means meaningful confidentiality when keys are unavailable; **Partial** means conditional/metadata-limited protection; **Does not protect** means the technology alone is not a material defense.

| Threat | LUKS2 file container | gocryptfs forward mode |
|---|---|---|
| Stolen/copied Windows drive | Protects archive content while locked and password/key unavailable; backing-file size is visible. Does not protect other WSL/Windows data. | Protects contents and filenames while locked; leaks per-file sizes, counts, hierarchy, and metadata/change patterns. Does not protect other data. |
| Copied WSL `.vhdx` | Same: locked container remains encrypted, provided no key or unlocked snapshot is captured. | Same confidentiality limitation; ciphertext and config are copied together, enabling offline password guessing. |
| Ciphertext-directory theft | Not the natural unit; theft of the container gives opaque blocks plus total size/header. | Designed for this case: content/name confidentiality with a strong password, but extensive metadata leakage. |
| Ordinary Linux-user compromise | Protects while locked if that user cannot unlock or read recovery material; normal modes govern when mounted. | Same; an unprivileged user may still copy ciphertext/config for offline guessing if backing permissions allow. |
| Compromise of `dev` | Partial while locked and secrets absent; does not protect mounted plaintext. `dev` may be unable to unlock LUKS without root but can damage an accessible backing file. | Partial while locked and secrets absent; does not protect mounted plaintext. If `dev` owns ciphertext, compromise can delete/rollback it. |
| WSL root access | No reliable protection during unlock or while mounted; root can inspect processes/memory, alter tooling, or capture plaintext. Locked data may resist immediate reading only while secrets remain unavailable. | Same. Root can access the FUSE view/ciphertext and interfere with the next unlock. |
| Windows administrator access | No strong guarantee: an administrator controls the host, can copy/modify storage, instrument WSL, or capture a later unlock. Locked ciphertext still raises the offline barrier if secrets are elsewhere. | Same; per-file ciphertext offers no special protection against an administrator observing an unlocked session. |
| Malware while unlocked | Does not protect; malware with access can read, alter, encrypt, or exfiltrate plaintext. | Does not protect; malware can read the mount and corrupt both views. |
| Accidental Git inclusion | A container outside Git plus guardrails reduces risk; committing it still discloses ciphertext/header and repository bloat. Mounted plaintext under/near Git is severe. | Per-file ciphertext is easier to accidentally commit/sync in pieces; filenames are encrypted but metadata and config leak. Plaintext mount inclusion is severe. Both locations need explicit exclusion and validation. |
| Accidental cloud synchronization | Ciphertext-only copy retains confidentiality but leaks total size/change timing and may preserve old headers. Plaintext sync defeats it. | Ciphertext is cloud-friendly but exposes per-file metadata/change patterns and allows rollback/deletion by the provider. Plaintext sync defeats it. |
| Rollback/stale-backup attack | No inherent freshness guarantee; old whole-container/header snapshots can restore deleted data, old keyslots, or old filesystem state. | No inherent freshness guarantee; attackers can replay older blocks/files/config/tree states. Trusted external inventory/version policy is required. |
| Deletion/corruption | Whole-container availability and filesystem structures are at risk; encryption is not backup. | Individual files/subtrees may fail; config loss can affect all; deletion is undetectable without external inventory/versioning. |
| Password loss | Another valid LUKS keyslot can recover; otherwise data is lost even if header survives. | Independently protected master-key recovery can recover; without password/master key, data is lost. |
| Config or LUKS-header loss | Header damage can make the entire LUKS volume unrecoverable; tested header backup is essential. | `gocryptfs.conf` loss can make the entire tree inaccessible without the separately recorded master key/config backup. Directory metadata loss can affect subtrees. |
| Partial-file corruption | Sector corruption may damage a file or filesystem metadata and may not be authenticated/detected as malicious. | Authenticated blocks generally signal corruption on read; damage is commonly localized, but truncation/rollback classes remain. |
| Whole-container/tree corruption | Potential total loss or complex filesystem recovery. | Broad deletion/corruption can still cause total loss, but versioned per-file restore may recover unaffected objects more selectively. |

Neither technology supplies availability, trusted freshness, malware defense, administrator isolation, or backups by itself.

## 6. Operational decision matrix

Ratings are qualitative and include rationale; they are not numeric scores.

| Criterion | LUKS2 file container | gocryptfs forward mode |
|---|---|---|
| Installation complexity | **Higher:** cryptsetup plus kernel/device-node/root workflow and inner filesystem tools. | **Lower:** gocryptfs plus already-present FUSE3 helpers, subject to `/dev/fuse` access. |
| Daily unlock | **Moderate:** privileged loop/open/mount sequence and reverse teardown. | **Simple-to-moderate:** ordinary-user password-driven FUSE mount and explicit unmount. |
| Need for root | **Required in normal design.** | **Usually not required for daily mount;** installation/mount policy may require administration. |
| Mount/unmount reliability | **Mature but layered:** application quiescence, filesystem unmount, crypt close, and loop cleanup. | **Good but FUSE-dependent:** busy handles and abrupt WSL exit still need testing. |
| Plaintext-fallback prevention | **Strong only with separate inaccessible exposure design;** ordinary empty mountpoint is unsafe. | **Same critical requirement;** particularly easy to mistake an empty FUSE mountpoint for a writable directory. |
| WSL startup/shutdown | **More complex:** device mapper, loop, filesystem recovery, and explicit closure. | **Simpler:** explicit FUSE unmount; abrupt shutdown behavior still needs proof. |
| Backup simplicity | **Simple whole image, costly execution.** | **Strong:** ordinary ciphertext-tree backup. |
| Backup granularity | **Coarse:** container/block level. | **Fine:** file/directory level. |
| Restore testing | **Higher effort:** restore full image/header, open, check filesystem, then hashes. | **Lower effort:** restore selected/full ciphertext plus config, mount, compare hashes. |
| Portability | **Linux-oriented, tool/filesystem dependent.** | **Broader file-level portability,** still requires gocryptfs/FUSE and compatible semantics. |
| Resizing | **Operationally complex and order-sensitive.** | **Natural growth:** limited by backing filesystem/free space, no fixed container resize. |
| Recovery options | **Strong keyslot model plus header backup,** but header/container failure has high stakes. | **Password plus master-key/config recovery,** with granular version restore. |
| Metadata confidentiality | **High:** conceals individual names, sizes, counts, and tree while locked; exposes container facts. | **Moderate:** names/content hidden, but exact sizes, counts, tree shape, timestamps/change patterns observable. |
| Corruption scope | **Broad:** header/filesystem/container structures create large blast radius. | **Usually narrower:** per-file objects, with config/directory metadata exceptions. |
| Agent-control integration | **Good if paths exist only through guarded privileged exposure;** agents cannot unlock by default. | **Good if mount and backing tree are outside agent scope;** ordinary-user mounts demand strict identity/allowlist control. |
| Auditability | **High:** distinct privileged unlock/open/mount/close events. | **High:** distinct process and mount events; per-file ciphertext churn may be noisier. |
| Test-only fit | **Good second test:** excellent recovery exercise but higher state/privilege complexity. | **Best first test:** lower allocation and recovery blast radius; validates mount guards and archive workflow. |
| Future PAL production fit | **Potentially strong** where maximum locked metadata confidentiality dominates and fixed sizing/root workflow is acceptable. | **Potentially strong** where granular archive/backup operations dominate and metadata leakage is acceptable. Production choice remains open. |
| Educational value | **Excellent systems lesson:** block crypto, headers, keyslots, filesystem and recovery. | **Excellent practical lesson:** FUSE, file-granular crypto, backup metadata, guards, and recovery. |

## 7. Plaintext-fallback control design

The required invariant is: while encrypted storage is locked, neither approved logical path can accept ordinary plaintext.

### 7.1 Recommended design pattern (not implemented)

1. Put actual LUKS or gocryptfs mount targets at separate, Dan-approved underlying paths outside the repository and agent-visible workspace.
2. Keep `/home/dev/pal-private-archive/active/` and `/home/dev/pal-private-archive/legacy/` absent or represented by root-owned, non-writable, non-traversable placeholders while locked. A sentinel may explain the locked state, but a sentinel alone is not enforcement.
3. After manual unlock, expose the verified encrypted filesystem to the approved paths using a design that cannot reveal a writable underlying directory. Prefer mount/bind topology where the approved paths become usable only after the encrypted mount succeeds.
4. Require every archive command to fail closed unless `findmnt`/mount inspection proves the exact expected source, filesystem type (`fuse.gocryptfs` for gocryptfs or the expected `/dev/mapper/...` plus inner filesystem for LUKS), mount ID, and read/write state. Merely testing that a directory exists or contains a sentinel is insufficient.
5. Recheck immediately before writes to reduce time-of-check/time-of-use risk, reject symlinks and unexpected bind mounts, and log a secret-free decision record.
6. On unmount, restore the inaccessible placeholder state and verify that writes fail. If teardown verification fails, report and stop.

### 7.2 Pattern evaluation

| Pattern | Assessment |
|---|---|
| Mountpoint ownership/modes | Necessary defense in depth. Root-owned `0000` or otherwise inaccessible locked placeholders prevent `dev` writes, but root can bypass and mounting may require privileged transitions. |
| Locked-state sentinel | Useful human warning and state marker; insufficient because it does not prevent writes and can be stale/forged. |
| Pre-command validation | Essential. Must verify the expected mount source/type, not only path existence. Centralizing all approved archive writes behind a fail-closed command gate improves auditability. |
| Separate underlying mountpoints | **Preferred.** Keeps the approved namespace unusable until successful exposure and makes ciphertext/mount plumbing distinct from policy-facing paths. |
| Read-only/inaccessible placeholder | **Preferred locked state.** Inaccessible is stronger than read-only for avoiding reads and accidental traversal. It must not contain sensitive content. |

Both candidates require this control. For gocryptfs, verify `fuse.gocryptfs` and the intended ciphertext source/process. For LUKS, verify the intended mapper device and filesystem UUID/source; do not accept any ext4 mount merely because its type matches. Production paths must not be created or used until this design has passed a separately authorized fallback test.

## 8. Key and recovery comparison

### 8.1 LUKS2

- A strong Dan-controlled passphrase unlocks a keyslot that protects the volume key. Multiple keyslots allow an operational passphrase and separately controlled recovery credential without re-encrypting all data.
- Keyslot rotation/removal must be deliberate. Old full-container/header backups may preserve old keyslots and therefore old credential access.
- A `luksHeaderBackup` made after relevant keyslot changes is essential. Header damage can make the entire container unrecoverable even with the right passphrase.
- The header backup contains security-critical metadata and material sufficient, together with a valid credential and container data, to restore access. It must be encrypted/protected and kept separately from the only container copy and separately from routine key material.
- Neither a header backup alone nor a passphrase alone is a data backup. Recovery requires compatible software, intact ciphertext, the correct header state, and a valid credential.

### 8.2 gocryptfs

- Initialization creates a random master key; the password-derived key encrypts that master key in `gocryptfs.conf`. Password quality therefore governs resistance to offline guessing when config and ciphertext are stolen together.
- `gocryptfs.conf` also carries format parameters required to interpret the tree. Losing or corrupting it can make the filesystem inaccessible unless an independently protected master-key recovery path and sufficient configuration knowledge exist.
- A separately recorded master key can provide last-resort recovery and bypass the password. It is therefore key-grade secret material, must never be printed here or placed in commands/logs/Git, and must be held under Dan's separate recovery procedure.
- Routine ciphertext backup should include a consistent config copy, but the only recovery material must not reside solely beside or inside that backup. Independently protected config/recovery copies defend against synchronized deletion, corruption, and ransomware.

For either candidate, recovery material needs separate physical/logical custody, access logging, an inventory without secrets, and periodic test-data recovery. Separation does not mean an unprotected plaintext key file.

## 9. Backup comparison

### 9.1 LUKS

- Backing up the entire **locked** container preserves ciphertext and avoids handing plaintext to backup tooling.
- The backup is whole-file/block-level, includes unused encrypted space and the header, compresses poorly, and can force large transfers for small logical changes unless a validated block/deduplication system is used.
- Copy only after clean unmount/close or through a separately designed consistent snapshot. Copying a live backing file can capture an inconsistent inner filesystem.
- Capacity is fixed by the container; every full backup pays that size, and later resizing complicates retention and restore expectations.
- Recovery should test both a restored whole container and the independently protected header backup. Restoring an old image/header can restore old data and keyslots.
- Never aim backup software at the mounted plaintext view unless a separate encrypted-backup design explicitly authorizes and validates that exposure.

### 9.2 gocryptfs

- Back up the ciphertext directory, including `gocryptfs.conf`, directory IV/name metadata, and all encrypted objects—not the mounted plaintext view.
- Per-file ciphertext makes incremental, versioned, selective restore efficient. A single plaintext change may update its ciphertext and metadata objects rather than a monolithic image.
- A restorable set requires compatible configuration plus ciphertext; separately protected recovery material remains necessary.
- The backup destination learns ciphertext object counts, hierarchy, exact plaintext sizes derivable from ciphertext sizes, timestamps, and change patterns. Cloud/version retention also preserves deleted historical ciphertext.
- Active multi-file operations can produce a logically inconsistent point-in-time backup. Quiesce writes or use a validated snapshot/version transaction and verify with hash-known test data.
- Versioned backups are a strong fit for recovery from file deletion/corruption, but trusted freshness/inventory outside the writable ciphertext domain is needed to detect rollback.

## 10. Recommendation

**`RECOMMEND_BOTH_SEQUENTIALLY`**

For the first test-data implementation, test **gocryptfs first**, if Dan selects it and separately authorizes package installation, location, size/boundary, and recovery custody. It has the lower operational and corruption blast radius, likely avoids daily root, naturally exercises granular backup/restore, and directly tests the most important PAL control: no plaintext writes through approved logical paths while locked.

Then test **LUKS2 second**, only after the local device-node/root preflight is authorized and succeeds. It provides deeper block-encryption, keyslot, header, sizing, filesystem, WSL shutdown, and disaster-recovery practice, and supplies the stronger comparison point for locked metadata confidentiality.

This sequence is a learning and evidence recommendation only. It does not select gocryptfs or LUKS for production, authorize either test, authorize installation, or imply that the second test may proceed automatically. If gocryptfs FUSE access fails but loop/device-mapper access is proven, Dan may choose LUKS first; that is an owner decision, not an automatic fallback.

## 11. Proposed later test boundary (not executed)

A separately authorized test should:

1. record Windows-side WSL version, local versions/capabilities, mount table, free space, Git/index state, and absence of candidate test artifacts before any change;
2. use synthetic test data only and a small, explicitly approved backing location and allocation;
3. avoid the two production archive paths until locked-state fallback controls pass at isolated test paths;
4. use manual Dan-controlled unlock only, with no service, automount, stored passfile, shell-history secret, or agent unlock;
5. create hash-known files covering small/large files, nested/grouped records, names, permissions, and supported metadata without any real secret;
6. test correct unlock, explicit lock/unlock cycles, clean unmount, busy-unmount handling, WSL stop/restart behavior, and proof that plaintext is unavailable when locked;
7. test wrong-password behavior and confirm no partial mount, fallback write, secret echo, or sensitive log output;
8. create a separately authorized encrypted/ciphertext backup, restore to an isolated path, and compare hashes and required metadata;
9. simulate loss/corruption only on disposable copies—for example one ciphertext object/config copy for gocryptfs or a copied test image/header scenario for LUKS—and document blast radius and recovery;
10. validate stale-backup/rollback detection using trusted test inventories;
11. cleanly unmount/close, remove only explicitly approved disposable artifacts under a recorded rollback plan, and confirm the pre-test state; and
12. keep passwords, master keys, key files, and recovery material out of commands, environment captures, logs, prompts supplied to agents, reports, Git, clipboard history where avoidable, and cloud sync.

No part of this proposed test was executed here.

## 12. Human decisions required

Dan must decide, and this report does not decide for him:

- which candidate to test first;
- whether both candidates should be tested sequentially;
- the approved test backing location;
- the approved test allocation/size;
- the passphrase and recovery-material handling and separate custody method;
- the backup destination and its encryption/access/retention controls;
- whether installing the required candidate package may be authorized;
- whether LUKS's root-required daily workflow is acceptable;
- whether the final production choice must wait until both tests and restores finish; and
- whether later compatibility proof must occur outside this restricted execution context.

## 13. Verdict

**`READY_FOR_OWNER_TECHNOLOGY DECISION`**

The comparison is complete and presents a test sequence for Dan's consideration. The verdict requests a human technology/test decision only. It authorizes no implementation or production selection.

## 14. Mandatory status

- `comparison_status: COMPLETE`
- `technology_selection_status: NOT SELECTED`
- `implementation_status: NOT AUTHORIZED`
- `package_installation_status: NOT AUTHORIZED`
- `test_storage_status: NOT AUTHORIZED`
- `production_use_status: NOT AUTHORIZED`
- `packages_installed: 0`
- `keys_created: 0`
- `containers_created: 0`
- `ciphertext_directories_created: 0`
- `mounts_created: 0`
- `test_files_created: 0`
- `backups_created: 0`
- `permissions_changed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 15. Validation record

This phase created exactly one output file: `reports/sync/PHASE-3D-C3E-T1-LUKS-VS-GOCRYPTFS-COMPARISON.md`. No existing file was modified. No packages were installed. No keys, containers, ciphertext directories, archive/test directories, mappings, mounts, filesystems, test files, or backups were created. No permissions were changed. The Git index was unchanged. `git diff --check` was run against this report. Work stopped without staging, committing, or pushing.
