# Phase 3D-W1R — Private Storage Architecture and Encryption Review

> **verdict: `READY_FOR_OWNER_ARCHITECTURE DECISION`**  
> **review_scope: DESIGN ONLY — NO IMPLEMENTATION AUTHORIZED**

## 1. Authority, facts, and boundary

This review is based on `PHASE-3D-C3A-HUMAN-STORAGE-RETENTION-DECISIONS.md`, `PHASE-3D-W0-PRE-EXECUTION-REVALIDATION.md`, `PHASE-3D-C3-PRIVATE-STORAGE-RETENTION-POLICY-DRAFT.md`, and `PHASE-3D-C2-DISPOSITION-EXECUTION-PLAN.md`. The C3A human decision record controls where it supersedes the earlier draft or plan.

Wave 0 completed successfully. Wave 1 implementation is not authorized. This review does not authorize or perform archive creation, encryption, transfer, mounting, permission changes, key creation, backup, installation, configuration, staging, committing, or pushing.

Approved logical archive paths are:

- active: `/home/dev/pal-private-archive/active/`
- legacy: `/home/dev/pal-private-archive/legacy/`

The approved owner and group are `dev:dev`; approved directory permissions are `0700`; approved file permissions are `0600`. Agents are denied access by default. Temporary agent read requires Dan's approval. Agent write and deletion require separate authorization.

The current underlying drive does not use BitLocker. Encryption at rest is therefore not currently satisfied. Linux modes `0700` and `0600` are access controls, not encryption: they do not protect an offline copy of the physical disk or WSL `.vhdx`, and privileged identities can bypass them. Dan wants archive or WSL encryption to serve as a PAL learning exercise; this review supports that future exercise without selecting or implementing a technology.

## 2. Security layers that must not be conflated

| Layer | What it protects | What it does not protect |
|---|---|---|
| Linux ownership and modes | Accidental or unauthorized access by ordinary Linux identities while Linux enforces the filesystem policy | Offline disk/`.vhdx` copies, WSL root, a sufficiently privileged Windows administrator, or malware acting as `dev` |
| Private-archive encryption | Archive content while its archive-specific key is unavailable and storage is locked | Plaintext while unlocked; unrelated WSL files; key compromise |
| WSL virtual-disk or distribution encryption | A broader WSL storage boundary while locked | Data exposed through a running/unlocked WSL environment; data copied outside that boundary |
| Windows host-volume encryption | The Windows volume and stored `.vhdx` against offline physical loss/copy while powered off or locked | A logged-in/unlocked host, Windows administrators, malware, or plaintext backups |
| Backup encryption | Backup media or repository if stolen or disclosed | Live source storage, keys stored beside backups, or plaintext produced during restore |

An encrypted boundary changes state. When locked, ciphertext protects against offline acquisition without the key. When mounted and unlocked, normal filesystem access returns, and `dev`, WSL root, Windows administrators with sufficient control, and malware operating through an authorized context may reach plaintext. Encryption is not a substitute for least privilege, mount discipline, audit, or backup controls.

## 3. Practical threat model

Threat ratings below mean: **Yes** = primary mitigation when correctly configured and locked; **Partial** = conditional or limited mitigation; **No** = not materially mitigated by that architecture alone.

| Threat | A: host volume | B: archive container/filesystem | C: separate encrypted WSL boundary | D: file by file |
|---|---:|---:|---:|---:|
| Lost/stolen powered-off computer or physical drive | Yes | Yes for archived content | Yes for bounded content | Yes for encrypted artifacts |
| Offline copy of WSL `.vhdx` | Yes, if `.vhdx` resides on encrypted host volume | Yes for locked archive ciphertext | Yes if the separate boundary is genuinely encrypted | Yes for encrypted artifacts |
| Ordinary Linux account compromise | No for an unlocked host; Linux modes help separately | Partial; strong while locked, modes while unlocked | Partial; separation plus locked state | Partial; only files left encrypted |
| Compromise of `dev` | No while Windows/WSL is unlocked | Partial while locked; No while mounted as `dev` | Partial while detached/locked; No when exposed to `dev` | Partial until each file is decrypted |
| WSL root access | No | Partial while key/boundary is unavailable; No while mounted | Partial if detached and unlock authority is isolated; No after mount | Partial; root can capture plaintext/keys during use |
| Windows administrator access | No while host is unlocked | Partial while locked with keys unavailable to Windows; No guaranteed protection during use | Partial while detached/locked; Windows admin retains broad host control | Partial while ciphertext and keys remain separate |
| Malware while archive is mounted/unlocked | No | No | No | Partial only for artifacts not currently decrypted |
| Accidental cloud synchronization | Partial only if host policy excludes paths | Partial if only ciphertext is synced, but inclusion remains a policy failure | Partial through separation and sync exclusions | Partial; metadata/ciphertext may still sync |
| Accidental Git inclusion | No | Partial if backing ciphertext is outside the repository and mount path is excluded | Partial through boundary and explicit access design | Partial; encrypted blobs can still be committed accidentally |
| Lost encryption keys | Not a confidentiality threat; creates total loss risk | Creates archive loss risk | Creates boundary loss risk | Creates per-file/package loss risk |
| Corrupted encrypted storage | No special mitigation | May amplify recovery difficulty; needs backup/integrity checks | Same, potentially broader blast radius | Damage may be limited to individual files/packages |
| Failed Windows, WSL, or filesystem upgrade | No special mitigation beyond whole-volume recovery | Requires documented tool compatibility and recovery path | Higher dependency/attachment and recovery complexity | Usually portable if format/tool remains available |
| Backup theft or disclosure | No unless backup is separately encrypted or remains protected by the volume | Yes only when backup contains ciphertext or is separately encrypted | Yes only for encrypted boundary copies or separately encrypted backups | Yes for encrypted artifacts; metadata may remain |

No evaluated option reliably protects plaintext from malware, WSL root, or Windows administrators while the archive is mounted and unlocked. Protection from privileged administrators is strongest only when storage is locked, keys are absent from their reach, and the trusted unlock environment is controlled; on a Windows/WSL system, a Windows administrator can observe or alter the host and may capture credentials during later use.

## 4. Architecture options

### Option A — Windows host-drive encryption

Encrypt the Windows volume that stores the WSL `.vhdx`. This is full-volume protection and is the most transparent option for routine WSL use: after Windows unlocks the volume, WSL operates normally without a separate archive mount. It is a strong base layer against loss, theft, physical removal, and offline copying of the `.vhdx` while the system is powered off or the volume remains locked.

Availability and management depend on the installed Windows 11 edition, device capabilities, organizational policy, and available feature set. BitLocker must not be assumed available or enabled; the current drive does not use it. A future checkpoint must verify whether BitLocker, Windows Device Encryption, or another supported host-volume facility is available before selection.

Recovery keys must be generated, escrowed under Dan's control, kept separate from the protected device, and tested. Host encryption does not protect the archive from a Windows administrator, `dev`, WSL root, or malware after Windows and WSL are unlocked. It also does not automatically encrypt exported distributions, copied `.vhdx` files placed on other media, file-level exports, cloud copies, or backups. Backup destinations need independent encryption and key handling.

**Assessment:** excellent base layer with low daily WSL friction and broad offline coverage, but insufficient as the only control for the private archive or as separation from the main PAL environment.

### Option B — Encrypted archive container or filesystem inside WSL

Create a separately locked encryption boundary specifically for the approved private archive. Candidate families, for later evaluation rather than selection here, include:

| Technology family | Normal use and unlock | Backup/portability | Complexity and limitations | Learning and automation implications |
|---|---|---|---|---|
| LUKS-backed virtual disk or loop device | Transparent filesystem after explicit unlock/mount | Back up locked image or files; Linux-oriented portability | Requires block-device, filesystem, mount, capacity, and recovery management; corruption can affect the container | High systems-learning value; automation must never silently broaden unlock authority |
| `fscrypt` where supported | Per-directory-style transparent access after policy unlock | File/filesystem semantics and support must be verified; recovery depends on metadata and keys | Availability and behavior depend on the WSL kernel and backing filesystem; support cannot be assumed | Useful filesystem-encryption lesson, but compatibility proof is a prerequisite |
| gocryptfs-style encrypted directory | Plaintext view mounted over a ciphertext directory | Ciphertext is naturally file-granular and often easier to copy/version | Filename/structure metadata behavior, performance, and tool maturity require review; mounted view exposes plaintext | Strong learning value and flexible backup; agents must see neither ciphertext keys nor mounted plaintext by default |
| `age` or similar file-level/package encryption | Explicit encrypt/decrypt rather than a transparent live filesystem | Highly portable for exports and packages | Poor primary-archive ergonomics; directory updates and plaintext cleanup are manual | Good for controlled exports/backups; difficult for transparent automation |

This option offers a clear archive-only security boundary and makes the approved paths good logical mount points. Unlock and mount should be explicit; unattended automatic mounting should be a Dan decision and is not recommended by default. Leaving the archive mounted collapses most encryption benefit against `dev`, root, administrators, and malware. Keys must remain outside Git, Program Brain, prompts, shell history, and execution reports.

Backups may capture locked ciphertext, which reduces plaintext exposure, but container-image backups can be large and versioning-inefficient; filesystem-style ciphertext can be more incremental but may leak structure or change patterns. Backing up from the unlocked view risks plaintext copies. Portability ranges from strong for file-oriented formats to Linux/tool-dependent for LUKS. Complexity is moderate to high, but the option directly satisfies the desired PAL learning exercise. Agent and automation workflows must be explicit, time-bounded, allowlisted, and unable to unlock storage by default.

**Assessment:** best match for archive-specific confidentiality and learning value, provided Dan later selects the technology after compatibility, recovery, metadata, portability, and operational tradeoffs are tested.

### Option C — Separate encrypted WSL distribution or virtual disk

Place the archive in a dedicated WSL distribution, a separately attached and encrypted virtual disk, or an equivalent isolated encrypted storage boundary. A dedicated distribution alone is separation, not necessarily encryption; its backing storage must itself receive verified encryption protection.

This design separates private work from the main PAL environment and can reduce accidental agent, Git, sync, and automation reach. The private boundary can use a separate execution identity, narrow mounts, and an independent lifecycle. It is attractive for future investigative or client material that should not share the ordinary PAL trust boundary.

Costs are higher administrative overhead, distribution/disk lifecycle management, mount-order dependencies, patching, tool duplication, export/import decisions, and more complex backup and disaster recovery. Full-distribution exports or `.vhdx` backups can be large, contain unrelated sensitive state, and require precise software/version and attachment documentation. Portability is reasonable only when encryption and virtual-disk formats remain supported and recovery is tested on another device. If the archive is mounted into the main distribution, root or agents with access to that mount can still reach it; separation must be enforced through identities and explicit mount exposure.

**Assessment:** strongest structural separation and a good future boundary for investigative material, but likely more operational burden than PAL's present archive needs. It may become preferable if scope or sensitivity grows.

### Option D — File-by-file encryption

Encrypt selected artifacts or grouped packages individually. This is portable, limits corruption blast radius, and is useful for exports, offline backups, transfers, or exceptionally sensitive packages that should remain encrypted even inside another protected layer.

As a primary archive, it creates substantial manual overhead: every read or update requires decrypt/re-encrypt handling; directories and grouped records are awkward; automation may produce stray plaintext; naming, sizes, timestamps, package boundaries, and access patterns may leak metadata; consistent versioning and inventory become difficult. Files can be omitted accidentally, encrypted blobs can still enter Git or sync, and keys must be mapped and recovered correctly.

**Assessment:** useful supplemental control for exports, backups, or special packages, but not the preferred primary design for a working archive.

## 5. Comparative decision view

| Criterion | A: host volume | B: archive boundary | C: separate encrypted WSL boundary | D: file by file |
|---|---|---|---|---|
| Daily transparency | High | High while mounted; explicit unlock | Medium | Low |
| Archive isolation | Low | High | Very high | Per artifact |
| Offline `.vhdx` protection | High when stored on protected volume | Archive only | Separate boundary only | Selected artifacts only |
| Backup flexibility | Medium | Medium to high by technology | Medium to low | High |
| Administrative complexity | Low to medium | Medium to high | High | High at scale |
| Portability | Host/platform dependent | Technology dependent | Format/tool dependent | Usually high |
| Learning value | Medium | High | High | Medium |
| Primary-archive fit now | Base layer, not sufficient alone | Strongest present fit | Future/high-sensitivity candidate | Weak |

## 6. Access-control design for later consideration

The approved access policy remains unchanged: directories `0700`, files `0600`, owner/group `dev:dev`, agents denied by default, temporary agent read only with Dan approval, and agent write or deletion only under separate authorization. These controls should be applied inside the unlocked filesystem and validated after every authorized transfer. They provide no encryption.

WSL root and Windows host administrators may bypass Linux permissions while the archive is mounted. A Windows administrator also controls much of the platform on which unlocking occurs. Later design should therefore consider:

- mount only when needed and unmount promptly after use;
- prohibit archive paths and backing ciphertext from automatic sync unless a separately approved encrypted-backup workflow requires a specific ciphertext location;
- use explicit allowlists for agent access rather than inherited broad workspace access;
- use a separate execution identity for archive actions;
- retain private audit logging of unlock, mount, access, transfer, backup, and exception events;
- keep all key material outside the Git repository;
- never store keys or recovery secrets in Program Brain, prompts, shell history, or execution reports;
- place recovery-key escrow under Dan's control, separate from the protected system and backup data;
- maintain and periodically test a documented restore procedure.

These are recommendations for a later approved phase; none is implemented here.

## 7. Backup and recovery design

An archive is not recoverable merely because it is encrypted. Confidentiality, integrity, availability, and key survivability require separate controls.

| Design choice | Benefit | Principal risk or requirement |
|---|---|---|
| Encrypted archive backup | Protects backup media independently | Use a documented, recoverable format and keep keys separate |
| Backup locked ciphertext | Plaintext is not exposed to backup tooling; exact encrypted boundary can be preserved | Container copies may be large/incrementally inefficient; corruption and consistent-snapshot behavior must be addressed |
| Backup unlocked plaintext into an independently encrypted repository | File-granular versioning and restore may be easier | Plaintext traverses backup tooling and temporary areas; destination encryption must be verified before transfer |
| Offline backup | Reduces malware/ransomware and automatic-sync exposure | Media custody, aging, and periodic connection/testing are required |
| Second-device backup | Protects against loss of the primary computer | The second device must have equivalent encryption and access controls |
| Recovery-key backup | Prevents single-key loss | Never colocate the only recovery copy with the encrypted data; Dan controls escrow |
| Versioning | Recovers prior states and some corruption/deletion events | Retention may preserve sensitive deleted versions and increase storage exposure |
| Integrity verification | Detects corruption and incomplete copies | Maintain authenticated or trusted hashes/inventory separately and update under controlled procedure |
| Periodic restore test | Proves keys, software, documentation, and media actually work | Use test data or an isolated authorized environment and record the outcome |

A full WSL `.vhdx` backup has a large disclosure and recovery blast radius: it may include shell history, caches, credentials, deleted-data remnants, repositories, and unrelated PAL material. It can be large, difficult to version efficiently, inconsistent if copied while WSL is active, and dependent on WSL/virtual-disk compatibility. If used, it should be quiesced consistently, encrypted independently at the destination, tightly retained, integrity-checked, and complemented by a tested archive-level restore—not treated as the only backup.

The minimum recovery package concept should contain no actual secrets in this report, but a future controlled package must account for:

- encryption recovery material;
- a documented unlock procedure;
- required software and version information;
- an archive inventory;
- the most recent integrity record;
- the latest restore-test date and result;
- emergency owner instructions.

The recovery material should be protected and stored separately from both the archive and ordinary backup. Restore testing should periodically prove recovery on an appropriate second environment, including permissions, inventory, and integrity verification.

## 8. Recommended architecture for PAL's present stage

The recommended direction is a layered model, subject entirely to Dan's decisions and later authorization:

1. Enable supported Windows host/volume encryption when available and approved, protecting the volume that stores WSL as a broad offline-loss base layer.
2. Add a separately encrypted private-archive boundary for defense in depth and for the PAL learning objective.
3. Enforce `dev:dev`, directory mode `0700`, and file mode `0600` inside the unlocked archive.
4. Require controlled, need-based unlock/mount and prompt unmount; do not assume automatic mounting is acceptable.
5. Maintain an independently encrypted, versioned, integrity-checked, tested backup with separate recovery-key escrow.
6. Keep the detailed execution register private.
7. Publish only separately reviewed, sanitized summaries.

Option B is the strongest present-stage fit because it limits encryption scope to the approved archive, supports a meaningful learning exercise, and avoids the full operational overhead of Option C. This is not a final technology selection. LUKS-style block encryption, `fscrypt` where supported, gocryptfs-style directory encryption, and file/package encryption have materially different compatibility, metadata, backup, portability, mount, and recovery characteristics. Dan must approve the chosen technology after a test-data implementation and recovery exercise. Option C should remain a future candidate for client or investigative material requiring a distinct trust and administrative boundary.

The approved paths should remain **logical mount points** even if encrypted backing storage resides elsewhere. This preserves stable policy-facing paths while allowing the backing container, ciphertext directory, or separately attached disk to have an independent location and lifecycle. The backing location must later be explicitly approved, excluded from Git and unintended synchronization, and documented without exposing secrets. When the encrypted store is not mounted, the logical paths must not silently accept plaintext; the later design must test and prevent that failure mode.

## 9. Future learning checkpoint

### Phase 3D-C3E — WSL Private Archive Encryption Implementation and Recovery Test

This future checkpoint should be separately authorized and staged as follows:

1. Dan approves the architecture and test boundary.
2. Candidate tools are compared and one is explicitly selected.
3. Recovery-key material is created under an approved, non-repository procedure.
4. A test archive is created using test data only.
5. No production PAL artifact is placed into the encrypted archive during the first test.
6. Unlock, mount, unmount, locked-state, and wrong-key behavior are validated.
7. Ownership, `0700` directory permissions, `0600` file permissions, root/agent boundaries, and plaintext-fallback prevention are validated.
8. An encrypted backup is created under the approved test design.
9. Loss, corruption, or second-environment restore is simulated and integrity is checked.
10. Software versions, commands, custody, recovery, failure behavior, and results are documented without recording secrets.
11. Dan reviews the evidence and provides human approval before any production use.

## 10. Human decisions required

Dan must decide, and this review makes none of these decisions on his behalf:

- the preferred architecture;
- whether to encrypt the Windows host volume;
- whether to encrypt only the archive or use a dedicated WSL storage boundary;
- the chosen technology after compatibility and recovery evaluation;
- the unlock method;
- whether automatic mounting is prohibited;
- the recovery-key storage and escrow location;
- the backup destination;
- the backup frequency;
- the restore-test frequency;
- whether future client or investigative material uses a separate archive;
- whether Wave 1 implementation may later be authorized.

## 11. Verdict

**`READY_FOR_OWNER_ARCHITECTURE DECISION`**

The architecture review is complete. The verdict invites Dan's decisions only; it does not authorize Wave 1 implementation, archive creation, encryption, keys, mounts, transfers, backups, permission changes, or Git actions.

## 12. Mandatory status block

- `wave_1_review_status: COMPLETE`
- `wave_1_implementation_status: NOT AUTHORIZED`
- `archive_creation_status: NOT AUTHORIZED`
- `encryption_implementation_status: NOT AUTHORIZED`
- `keys_created: 0`
- `archives_created: 0`
- `mounts_created: 0`
- `files_copied: 0`
- `files_moved: 0`
- `files_deleted: 0`
- `permissions_changed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 13. Validation record

Exactly one file was created for Phase 3D-W1R: this review. No existing file was modified. No package was installed. No key, encrypted container, disk, mount, archive directory, or backup was created. No implementation control was applied. The Git index was left unchanged. Validation stopped without staging or committing.
