# Phase 3 — Remaining Gates to First Real Ingestion

> **checkpoint: `T3J_RECOVERY_MEDIA_VALIDATED_READY_FOR_RECOVERY_MATERIAL_CUSTODY_GATE`**
>
> **exact next gate: `GATE_1A_RECOVERY_CUSTODY_DESIGN_READINESS`**
>
> **first-ingestion authority: NOT YET GRANTED**

## Current completed checkpoint

T3H design is complete, the disposable-only helpers completed their bounded T3I-B validation cycle, and T3J technically validated the encrypted LUKS2 recovery USB with synthetic material. The synthetic artifact was deleted and the device returned to its locked, unmounted, offline state.

This checkpoint does **not** mean that a production vault exists. T3J-B production vault initialization is not complete; the production paths, credential, vault, mount, and backup remain pending. The recovery USB contains no real recovery material, the two printed copies do not yet exist, and the repository does not prove that a dedicated external ciphertext-backup drive exists.

## Remaining-gate classification

Every remaining Phase 3 item on the route is assigned once below. Only `BLOCKING_FIRST_REAL_INGESTION` belongs on the critical path to the first canary copy.

| Remaining item | Classification |
|---|---|
| Gate 1A: approve the exact recovery-copy set, secret-free inventory identifiers, custody categories, printed-copy procedure, encrypted-USB procedure, verification method, and temporary-copy controls; no real recovery material exists yet | `BLOCKING_FIRST_REAL_INGESTION` |
| Gate 2A: create and retain the unique production gocryptfs credential under approved owner custody; create the approved paths; initialize the empty vault and generate its production recovery material; add no operational PAL content | `BLOCKING_FIRST_REAL_INGESTION` |
| Gate 1B: place the approved recovery material on the validated encrypted USB and in two printed copies; verify required outcomes without recording secrets; establish three separate custody categories; eliminate temporary uncontrolled copies | `BLOCKING_FIRST_REAL_INGESTION` |
| Gate 2B: review production-specific helpers and validate the locked, mount, status, unmount, and reopen lifecycle, including fail-closed behavior, fallback-write rejection, and absence of a retained process or automatic remount | `BLOCKING_FIRST_REAL_INGESTION` |
| Gate 3: provide a dedicated, separately authorized external backup medium; back up the complete ciphertext tree; verify its manifest/hashes; disconnect it for offline custody | `BLOCKING_FIRST_REAL_INGESTION` |
| Gate 4: select and copy the limited 3–5-item canary, validate mounted bytes and the lock/reopen lifecycle, preserve originals, take the post-ingestion ciphertext backup, and start observation | `BLOCKING_FIRST_REAL_INGESTION` |
| Complete the 14-day canary observation, at least five successful owner-controlled mount/unmount cycles, the canary restore test, required hash checks, and failure-free review | `BLOCKING_BROAD_MIGRATION_ONLY` |
| Obtain a separate post-canary human authorization for broad PAL operational migration | `BLOCKING_BROAD_MIGRATION_ONLY` |
| Complete BitLocker/host-encryption readiness, recovery-key custody/retrieval, recovery media, and verified backup before broad migration or high-sensitivity use | `BLOCKING_BROAD_MIGRATION_ONLY` |
| Admit high-sensitivity, irreplaceable, regulated, legal, or materially harmful data | `BLOCKING_BROAD_MIGRATION_ONLY` |
| Design and authorize separate encrypted stores, keys, custody, retention, and registers for client, investigative, or credential/authentication material | `BLOCKING_BROAD_MIGRATION_ONLY` |
| Add the later separate/off-site encrypted copy required before high-sensitivity use | `BLOCKING_BROAD_MIGRATION_ONLY` |
| Select any future LUKS production architecture or decide whether LUKS replaces or complements gocryptfs | `DEFERRED_NONBLOCKING` |
| Add aliases or other convenience tooling | `DEFERRED_NONBLOCKING` |
| Perform retained-disposable-environment cold-start work or separately authorized cleanup | `DEFERRED_NONBLOCKING` |
| Publish a sanitized portfolio derivative | `DEFERRED_NONBLOCKING` |
| Automate periodic recovery inspections, backup/restore cadence, or evidence/report generation after the manual controls are proven | `POST_INGESTION_AUTOMATION` |
| Implement full Lab 14 automation, including device correlation, state capture, package review, secret screening, evidence promotion, and capture generation | `POST_INGESTION_AUTOMATION` |

## Gate 1A — Recovery custody design/readiness

**Classification:** `BLOCKING_FIRST_REAL_INGESTION`

**State:** OPEN — exact next gate.

Before production initialization, Dan must approve the exact three-copy model and its secret-free evidence boundary: two sealed printed copies in separate custody locations/categories and one recovery-material copy on the validated encrypted recovery USB at a third location. Approve the exact recovery-copy set, opaque inventory identifiers, custody categories, printed-copy procedure, encrypted-USB procedure, verification method, and controls for every temporary copy. Inventory records may contain identifiers, custody categories, seal state, dates, and pass/fail outcomes, but no secret, hint, private address, or recovery value.

No real production recovery material exists at Gate 1A. This gate approves readiness to handle material that Gate 2A will generate; it does not populate the USB or create printed recovery copies.

**Human approval required:** exact material/copy scope, inventory identifiers, two printed-copy procedure, encrypted-USB procedure, three separate custody categories, verification method, and temporary-copy controls.

## Gate 2A — Empty production vault initialization

**Classification:** `BLOCKING_FIRST_REAL_INGESTION`

**State:** NOT STARTED / NOT PROVEN COMPLETE.

Under a separate Dan-controlled implementation authorization:

1. Create a unique high-entropy production gocryptfs credential and retain it in the approved password manager. Dan enters it only at the direct interactive prompt; no agent, script, argument, environment variable, pipe, log, report, Git object, or chat receives it.
2. Create the approved ciphertext path `/home/dev/.pal-private-cipher/archive/` and plaintext mountpoint `/home/dev/pal-private-archive/` with the approved ownership and fail-closed baseline.
3. Initialize an empty production gocryptfs vault and generate its production recovery material under owner control.
4. Add no operational PAL content. Proceed directly to Gate 1B custody closure.

**Dependencies:** Gate 1A approved.

**Human approval required:** credential creation/custody, exact path creation, empty-vault initialization, interactive secret handling, and controlled handoff of the generated recovery material to Gate 1B.

## Gate 1B — Recovery custody completion

**Classification:** `BLOCKING_FIRST_REAL_INGESTION`

**State:** BLOCKED on Gate 2A.

Place the approved production recovery material on the validated encrypted recovery USB and create the two approved printed copies. Independently verify the required recovery/login and copy outcomes where applicable without recording secrets. Establish the three separate custody locations/categories and their secret-free inventory records. Eliminate every temporary uncontrolled recovery copy. Keep the routine gocryptfs credential and emergency recovery material separate.

**Dependencies:** Gates 1A and 2A complete; the generated material remains under the approved temporary-copy controls.

**Human approval required:** USB population, two printed copies, independent verification outcomes, three custody placements/categories, inventory completion, and disposition of every temporary working copy.

## Gate 2B — Production lifecycle validation

**Classification:** `BLOCKING_FIRST_REAL_INGESTION`

**State:** BLOCKED on Gate 1B.

Review, adapt, and validate production-specific mount/status/unmount helpers against the T3H design. The existing T3I-B helpers are disposable-only and are not authority for production use. Validate the full owner-controlled lifecycle: healthy locked status; exact mount source, target, type, and namespace; healthy mounted status; explicit unmount; empty `0500` locked mountpoint; fallback-write rejection without residue; no retained associated process or automatic remount; and successful reopen followed by safe teardown.

**Dependencies:** Gates 1A, 2A, and 1B complete.

**Human approval required:** exact production-helper code and execution, every interactive unlock, acceptance of lifecycle evidence, and any retry or exception.

## Gate 3 — Initial external ciphertext backup

**Classification:** `BLOCKING_FIRST_REAL_INGESTION`

**State:** BLOCKED on a physical medium not proven to exist in the repository.

Use a dedicated, separately authorized external backup medium—not the recovery USB. Copy the complete production gocryptfs ciphertext tree, including configuration and required directory metadata; create a relative manifest and verify source/backup structure and regular-file hashes. Store the verified medium offline and disconnected. Do not back up plaintext and do not mirror deletions automatically.

**Dependencies:** Gates 1A, 2A, 1B, and 2B complete; the vault locked; a reviewed backup/restore procedure; and the exact backup medium approved and correlated.

**Human approval required:** medium selection/custody, connection and any preparation, backup execution, integrity result, disconnect, and offline placement.

## Gate 4 — Limited canary / first real ingestion

**Classification:** `BLOCKING_FIRST_REAL_INGESTION`

**State:** BLOCKED on Gates 1A, 2A, 1B, 2B, and 3.

Dan approves exactly 3–5 low-sensitivity, replaceable or reconstructable private PAL operational items totaling no more than 25 MB. Preserve every original. Exclude client or investigative data, credentials, secrets, recovery material, regulated/legal material, high-sensitivity data, and irreplaceable master copies; classification ambiguity is a stop.

Mount through the validated owner-controlled workflow, prove the exact `fuse.gocryptfs` source/target/type, copy rather than move, and require exact source/destination hash equality. Verify the mounted contents, explicitly lock, reopen, and verify them again. Then lock the vault, make and integrity-check a new complete external ciphertext backup, disconnect the backup medium, record the secret-free baseline, and begin the approved 14-day observation period. Source deletion is not authorized.

**Human approval required:** candidate worksheet and classifications, exact copy action, interactive unlocks, acceptance of integrity/lifecycle evidence, post-ingestion backup, and start of observation.

## Shortest critical path

1. **Gate 1A:** Approve the recovery copy/custody design, inventory identifiers, procedures, verification method, and temporary-copy controls; create no real recovery copies yet.
2. **Gate 2A:** Approve production implementation; create the owner-held credential and approved paths; initialize the empty vault and generate its recovery material; add no operational PAL content.
3. **Gate 1B:** Immediately place the approved recovery material on the validated encrypted USB and in two printed copies; verify required outcomes without exposing secrets; place all three in separate custody categories; eliminate temporary uncontrolled copies.
4. **Gate 2B:** Review and validate production-specific helpers and the complete fail-closed mount/status/unmount/reopen lifecycle.
5. **Gate 3:** Approve a dedicated external backup medium; back up and verify the empty ciphertext tree; disconnect it.
6. **Gate 4:** Approve the 3–5 canary items; copy and hash-verify them; lock/reopen and verify; back up the changed ciphertext tree; begin observation.

Canary screening and the secret-free custody inventory template may be prepared in parallel with physical-media work, but neither preparation authorizes a copy or shortens a human gate.

## Stop conditions

Stop, preserve state, and obtain human review on any identity, path, source, target, filesystem type, mount namespace, ownership, mode, emptiness, device, custody, inventory, classification, authorization, object type, process, or expected-state mismatch. Also stop on any unexpected mount or mapper, fallback plaintext write, automatic remount, retained process, unlock anomaly, hash/manifest mismatch, secret-bearing evidence, uncontrolled recovery copy, missing printed/USB custody outcome, plaintext backup attempt, use of the recovery USB as backup media, unmount/close failure, or ambiguous canary item. Do not automatically retry, repair, overwrite, delete, force-unmount, substitute a device, or broaden scope.

## Physical-world dependencies

- Dan's direct approvals, interactive credential entry, and secret-free acceptance records.
- Two printed copies, tamper-evident packaging, and two separate approved custody locations/categories.
- The validated encrypted recovery USB, its separate third custody location, and owner-controlled unlock.
- A distinct dedicated external ciphertext-backup medium and its offline custody location. Its existence is currently unproven by the reviewed repository.

## Automation later, not now

Lab 14 full automation, aliases, scheduling, automated evidence promotion, report/capture generation, and convenience wrappers do not block the first real ingestion. The immediate path uses reviewed, human-initiated, fail-closed controls. Later automation may collect secret-free state and enforce already approved gates, but it must never choose devices, approve classifications, supply credentials, handle recovery values, initiate mounts autonomously, or continue after a mismatch.

## Governing boundary

This map narrows sequencing only; it introduces no new architecture or implementation authority. T3G/T3H controls, T3I-B's disposable-only boundary, the T3J result, and the offline recovery-media runbook remain governing. Work must stop for human review before any state-changing gate execution.
