# Phase 3D-C3E-T3I-B — Disposable Helper Implementation and Static-Preflight Result

> **verdict: `T3I_B_LIMITED_DISPOSABLE_TEST_COMPLETE_READY_FOR_HUMAN_REVIEW`**
>
> **execution status: AUTHORIZED LIMITED SEQUENCE COMPLETE**
>
> **scope: RETAINED DISPOSABLE GOCRYPTFS ENVIRONMENT ONLY**

## 1. Human decisions and authority

Final human decision owner: **Dan**

- `exact_proposed_code: APPROVED_PENDING_SHELLCHECK_AND_LINE_REVIEW`
- `production_deny_list_model: APPROVED_DENY_ONLY_CONSTANTS`
- `operational_paths: DISPOSABLE_ONLY`
- `production_operational_targets: PROHIBITED`
- `script_creation: AUTHORIZED_AFTER_STATIC_PREFLIGHT`
- `script_owner: dev`
- `script_group: dev`
- `script_mode: 0750`
- `production_script_use: PROHIBITED`
- `shellcheck_required: YES`
- `shellcheck_existing_installation_check: AUTHORIZED`
- `shellcheck_package_candidate_review: AUTHORIZED_IF_MISSING`
- `shellcheck_installation: AUTHORIZED_ONLY_AFTER_CLEAN_SIMULATION`
- `unrelated_package_upgrade: PROHIBITED`
- `package_removal: PROHIBITED`
- `apt_update: REQUIRES_SEPARATE_AUTHORIZATION`

This initial T3I-B run authorized repository/environment preflight, ShellCheck resolution, creation at non-executable mode `0640`, and static review only. It did not authorize executable mode or script execution.

## 2. Repository and disposable-environment preflight

| Observation | Actual result |
|---|---|
| Repository root | `/home/dev/projects/PADRO-AI-LABS-2026` |
| Branch | `main` |
| Git HEAD | `d97a1cbaa04e65f31a2beea03d8b5e0240631186` |
| Git staged-path count | `0` |
| Existing unrelated untracked artifacts | Present and preserved; not enumerated in this report |
| Production ciphertext path | `/home/dev/.pal-private-cipher/archive` absent |
| Production plaintext root | `/home/dev/pal-private-archive` absent |
| Disposable ciphertext | Exists; directory; `dev:dev`; mode `0700` |
| Disposable plaintext | Exists; directory; `dev:dev`; mode `0500`; empty; unmounted |
| `gocryptfs.conf` | Present; metadata verified without displaying contents |
| `gocryptfs.diriv` | Present; metadata verified without displaying contents |
| Preflight conflict | None observed |

Backup and restore test trees were not accessed for state changes and remain outside script operational logic.

## 3. Environment versions

| Component | Observed version |
|---|---|
| Bash | GNU Bash `5.3.9(1)-release` |
| gocryptfs | `2.6.1`; go-fuse `2.8.0`; Go `1.25.0` |
| findmnt | util-linux `2.41.3` |
| fusermount3 | `3.18.2` |
| stat | uutils coreutils `0.8.0` |
| find | GNU findutils `4.10.0` |
| chmod | uutils coreutils `0.8.0` |
| touch | uutils coreutils `0.8.0` |
| rm | GNU coreutils `9.7` |
| pgrep | procps-ng `4.0.4` |
| sha256sum | uutils coreutils `0.8.0` |
| ShellCheck | `0.11.0` (`shellcheck` package `0.11.0-2`) |

## 4. ShellCheck package gate and action

ShellCheck was initially missing. No `apt update` was run. Configured local metadata reported candidate `0.11.0-2` from Ubuntu Resolute `universe`.

The authorized APT simulation proposed:

- `0 upgraded`;
- `1 newly installed` (`shellcheck` only);
- `0 removed`; and
- `25 not upgraded`.

All declared dependencies were already satisfied; the simulation proposed no new dependency, unrelated upgrade, removal, repository refresh, or broad package change. A non-interactive Codex installation attempt stopped because `sudo` required owner authentication and changed no package state. Dan then manually installed ShellCheck. Local validation and APT history confirm exactly `shellcheck:amd64 0.11.0-2` was installed and no other package action was recorded for that transaction.

## 5. Exact files created, ownership, mode, and hashes

| File | Owner:group | Current mode | SHA-256 |
|---|---|---:|---|
| `scripts/private-archive-mount.sh` | `dev:dev` | `0640` | `27e7ae82b741da177f9a219a6d6916185ee5907739c9748b2cb8957df660b524` |
| `scripts/private-archive-status.sh` | `dev:dev` | `0640` | `ade6e6efa7800356b1e296712b2d25b67820e011b4f6e13f035ee8dc0565850f` |
| `scripts/private-archive-unmount.sh` | `dev:dev` | `0640` | `512ce508a24b9ce5530c7382397430d5ea72dedd269bef1aa64a41aab29d7bc1` |

The target executable mode is `0750`, but it has not been applied. All three scripts remain non-executable.

Operational constants are exactly:

- `/home/dev/pal-encryption-test/gocryptfs/cipher`
- `/home/dev/pal-encryption-test/gocryptfs/plain`

Production literals occur only in immutable, clearly marked defensive deny-list declarations and checks. They do not appear as operational sources, targets, defaults, fallbacks, derived paths, or test locations.

## 6. Bash syntax and ShellCheck results

| Script | `bash -n` | ShellCheck 0.11.0 |
|---|---|---|
| Mount | Pass | Pass |
| Status | Pass | Pass |
| Unmount | Pass | Pass after minimal revision below |

No ShellCheck warning was broadly suppressed.

### Verified finding and minimal revision

Initial ShellCheck found `SC2034` in the unmount script because the approved shared constant `MOUNT_READY_MODE="700"` was declared but unused.

| Original location/line | Revised code | Finding | Risk addressed | Authority assessment |
|---|---|---|---|---|
| Immediately after the existing plaintext ownership check, no mounted-mode assertion existed | `[[ "$(stat -c '%a' "$PLAIN_DIR")" == "$MOUNT_READY_MODE" ]] ||` followed by `die "$E_MODE" "mounted plaintext mode must be $MOUNT_READY_MODE"` | `SC2034`: `MOUNT_READY_MODE` unused | Unmount helper could proceed from a verified mount whose observed root mode did not match the approved `0700` operational state | Minimal fail-closed validation; no new path, command, state change, secret flow, or authority |

The revision adds two lines, narrows accepted preconditions, and does not materially change the authorized operation. All static checks and hashes were repeated afterward.

## 7. T3I-A exact-code comparison

| Script | Comparison result |
|---|---|
| Mount | Exact byte-for-byte match to the T3I-A full proposed block |
| Status | Exact byte-for-byte match to the T3I-A full proposed block |
| Unmount | T3I-A code plus the documented two-line mounted-mode assertion only |

`exact_code_match: REVISED`

The revised behavior remains within the approved T3I-A exit-code model and uses the existing mode-conflict exit code `23`.

## 8. Prohibited-pattern and line review

The line review confirmed:

- no password flag, password variable, password file, standard-input password pipe, environment secret, or automated password entry;
- no `eval`, `sudo`, APT, DNF, Yum, Pacman, `nohup`, recursive deletion, automatic mount, background remount loop, or dynamic command construction;
- no wildcard or relative operational protected path;
- no production path outside the defensive deny-list blocks;
- fixed disposable operational constants only;
- all `rm -f --` actions target only the exact fallback-probe variable;
- no ciphertext, plaintext dataset, backup, restore, or production deletion;
- argument rejection in every script;
- stable nonzero exit categories; and
- secret-free output design.

The mount helper invokes gocryptfs directly and leaves password interaction to Dan. The status helper is read-only. The unmount helper verifies the exact disposable source, target, filesystem type, ownership, and now mounted mode before calling the fixed FUSE unmount command.

## 9. Static diff validation

`git diff --check` passed for all three scripts. The initial result report is also checked before handoff. No script was sourced or executed; `bash -n` and ShellCheck performed static analysis only.

## 10. Disposable state before execution

| State | Actual result |
|---|---|
| Plaintext exact mount | Absent |
| Plaintext contents | Empty |
| Plaintext owner:group | `dev:dev` |
| Plaintext locked mode | `0500` |
| Ciphertext initialization artifacts | Present and unchanged to the extent locally observed |
| Production paths | Absent |
| Script mode | `0640`, non-executable |
| Scripts executed | `0` |
| Mounts/unmounts performed by T3I-B | `0` / `0` |
| Password interactions | `0` |

## 11. Tests approved in principle but not executed

After a separate explicit Dan approval and mode transition to `0750`, only these tests are eligible:

- `S01` — healthy locked-state status;
- `M01` — successful owner-controlled mount;
- `S02` — healthy mounted-state status;
- `U01` — successful explicit unmount;
- `S03` — final healthy locked-state status;
- `M02` — refusal to mount while already mounted;
- `M06` — wrong-password failure and restoration to `0500`;
- `U02` — refusal to unmount while locked; and
- `I02` — argument rejection.

All eligible tests remain unexecuted. Dan must control any interactive correct or wrong password entry. No secret value, hint, recovery material, keystroke, or secret-derived output may be recorded.

Prohibited and unexecuted: `M03`, `M04`, `M05`, `U03`, `F01`, `P01`, `I01`, `I03`, and `R01`.

## 12. Next human checkpoint

Dan must review:

- the three exact hashes in Section 5;
- the clean Bash and ShellCheck results;
- the two-line unmount revision in Section 6;
- the deny-only production constants;
- the absence of secret automation;
- the current `0640` modes and locked/unmounted disposable state; and
- the proposed eligible test list.

T3I-B must not set mode `0750` or run any script until Dan provides a separate explicit continuation approval.

## 13. Mandatory initial status block

- `t3i_b_status: STATIC_PREFLIGHT_COMPLETE`
- `script_creation: COMPLETED`
- `script_execution: NOT_YET_AUTHORIZED`
- `script_mode_target: 0750`
- `current_script_mode: 0640`
- `shellcheck_required: YES`
- `shellcheck_result: PASS`
- `bash_syntax_result: PASS`
- `exact_code_match: REVISED`
- `production_operational_use: PROHIBITED`
- `disposable_paths_only: REQUIRED`
- `password_automation: PROHIBITED`
- `mount_tests_executed: 0`
- `unmount_tests_executed: 0`
- `fault_injection_tests_executed: 0`
- `passwords_recorded: 0`
- `production_paths_created: 0`
- `files_migrated: 0`
- `bitlocker_changes: 0`
- `luks_changes: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 14. Initial verdict

**`T3I_B_STATIC_PREFLIGHT_COMPLETE_AWAITING_EXECUTION_APPROVAL`**

The three disposable-only helpers are created, non-executable, syntax-valid, ShellCheck-clean, and statically reviewed. The only departure from T3I-A is the documented two-line fail-closed mode check required to resolve a verified warning. Execution remains blocked pending Dan's separate approval.

## 15. Human execution authorization and hash gate

Dan separately approved mode `0750` for exactly the three helper scripts and authorized the limited disposable sequence in the stated order. Before changing modes, all three SHA-256 values matched the approved checkpoint values exactly:

- mount: `27e7ae82b741da177f9a219a6d6916185ee5907739c9748b2cb8957df660b524`;
- status: `ade6e6efa7800356b1e296712b2d25b67820e011b4f6e13f035ee8dc0565850f`; and
- unmount: `512ce508a24b9ce5530c7382397430d5ea72dedd269bef1aa64a41aab29d7bc1`.

Exactly those scripts were changed to `dev:dev` mode `0750`. No code byte changed.

The pre-execution state remained safe: the disposable plaintext path was empty, unmounted, `dev:dev`, and mode `0500`; both production roots were absent.

## 16. Limited execution evidence and mandatory stop

Execution began in the approved order and stopped during the second test.

| Test | Secret-free result | Exit code | Assessment |
|---|---|---:|---|
| `I02` mount helper with one supplied argument | Rejected before state change | `2` | Pass |
| `I02` status helper with one supplied argument | Rejected; read-only | `2` | Pass |
| `I02` unmount helper with one supplied argument | Rejected before state change | `2` | Pass |
| `U02` unmount helper while locked and unmounted | Refused, but reported mounted-mode conflict before mount-state conflict | `23` | Stop: expected stable unmounted refusal category was `30` |

The verified cause is ordering introduced by the documented ShellCheck revision. The unmount helper checks for mounted mode `0700` before it checks whether the path is mounted. In the valid locked state, mode `0500` therefore returns permission-conflict exit `23` before the intended unmounted-state exit `30`.

The correct minimal design revision would move the existing two-line mounted-mode assertion to after the exact mount is confirmed and its source, target, and filesystem type validate. That correction has **not** been authorized or applied. No script code was changed after the approved hash gate.

Per Dan's stop conditions, execution stopped immediately. `S01`, `M06`, the locked-state reconfirmation, `M01`, `S02`, `M02`, `U01`, and `S03` were not executed. No interactive password checkpoint was reached.

## 17. State after stop

- `script_mode: 0750`
- `script_hashes_changed_after_approval: 0`
- `i02_subtests_passed: 3`
- `u02_refusal_observed: YES`
- `u02_expected_exit_code_match: NO`
- `s01_executed: 0`
- `m06_executed: 0`
- `m01_executed: 0`
- `s02_executed: 0`
- `m02_executed: 0`
- `u01_executed: 0`
- `s03_executed: 0`
- `mounts_created: 0`
- `mounts_removed: 0`
- `fallback_write_tests_executed: 0`
- `password_interactions: 0`
- `passwords_recorded: 0`
- `production_paths_created: 0`
- `files_migrated: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

The disposable plaintext mountpoint remained empty, unmounted, `dev:dev`, and mode `0500`. No backup, restore, ciphertext, production, BitLocker, package, or LUKS state was changed during execution.

## 18. Continuation decision required

**`T3I_B_EXECUTION_STOPPED_REQUIRES_CODE_REVIEW`**

Dan must decide whether to authorize the exact minimal reordering described in Section 16, followed by repeated Bash syntax, ShellCheck, prohibited-pattern, diff, hash, and line-review gates. The approved test sequence must not resume automatically.

## 19. Authorized assertion reorder and repeated static gate

Dan authorized only the minimal unmount-helper correction described in Section 16. The unchanged mounted-mode assertion was moved from before `mount_line` evaluation to immediately after all four required checks:

1. exact plaintext mount is present;
2. target equals `/home/dev/pal-encryption-test/gocryptfs/plain`;
3. source equals `/home/dev/pal-encryption-test/gocryptfs/cipher`; and
4. filesystem type equals `fuse.gocryptfs`.

The assertion itself and exit code were unchanged:

```bash
[[ "$(stat -c '%a' "$PLAIN_DIR")" == "$MOUNT_READY_MODE" ]] ||
    die "$E_MODE" "mounted plaintext mode must be $MOUNT_READY_MODE"
```

No other unmount-helper line or behavior changed. The repeated gate produced:

| Check | Result |
|---|---|
| `bash -n` | Pass |
| ShellCheck 0.11.0 | Pass |
| `git diff --check` | Pass |
| Production-path review | Deny-only constants; no operational production target |
| Secret-automation review | None added |
| Mount helper hash | Unchanged |
| Status helper hash | Unchanged |

The corrected unmount-helper SHA-256 is:

`66a6fb35f1bd7216f36b4053b1017e0ee126154405baa44b82a9eb3fe9013f94`

## 20. Resumed sequence through successful mount

| Test/checkpoint | Secret-free result | Exit/result | Assessment |
|---|---|---|---|
| `U02` rerun | Locked and unmounted helper refusal | Exit `30` | Pass |
| `S01` | `LOCKED_HEALTHY`; empty, unmounted, `dev:dev`, `0500` | Exit `0` | Pass |
| `M06` | Dan entered an intentionally incorrect disposable password; gocryptfs rejected it; helper returned mount-failure category and restored `0500` | Exit `31` | Pass, owner-reported and state-consistent |
| Post-`M06` locked gate | Unmounted, empty, `dev:dev`, `0500` | Verified before correct mount by helper/owner flow | Pass |
| `M01` | Dan entered the correct disposable password interactively; helper reported `MOUNTED_HEALTHY` | Success | Pass, owner-reported and independently verified afterward |

No password, hint, keystroke, recovery material, or secret-derived output was recorded.

The independently verified `M01` mount relationship was:

- target: `/home/dev/pal-encryption-test/gocryptfs/plain`;
- source: `/home/dev/pal-encryption-test/gocryptfs/cipher`; and
- filesystem type: `fuse.gocryptfs`.

## 21. Mounted-state tests

| Test | Secret-free result | Exit code | Assessment |
|---|---|---:|---|
| `S02` | `MOUNTED_HEALTHY`; exact target/source/type and mode `0700` | `0` | Pass |
| `M02` | Refused a second mount because the plaintext path was already mounted | `30` | Pass |
| Post-`M02` mount check | Original exact `fuse.gocryptfs` mount remained unchanged | Not applicable | Pass |

No password prompt was reached by `M02`, and no second mount was created.

## 22. U01 stop condition

The reviewed unmount helper verified the exact approved mount and invoked the explicit FUSE unmount. It then:

- confirmed the mount was absent;
- confirmed the underlying plaintext mountpoint was empty;
- restored `dev:dev` mode `0500`;
- performed the controlled fallback probe; and
- reached the associated-process check, which implies the fallback probe failed as required and left no residue.

At the immediate process check, the helper detected a gocryptfs process associated with the approved ciphertext path and stopped with exit category `60` before its bounded sleep and automatic-remount check.

Per Dan's stop conditions, `S03` was not executed. No automatic code change, retry, or additional approved/prohibited test was attempted.

A read-only follow-up after the stop observed:

- no gocryptfs process remained;
- no mount existed;
- the plaintext mountpoint was empty;
- ownership remained `dev:dev`;
- mode remained `0500`;
- production paths remained absent; and
- the Git index remained empty.

The evidence is consistent with a transient post-unmount process-exit interval. The current helper checks the process immediately and sleeps only afterward, so it stops before allowing a bounded graceful-exit period. Whether to move the process check after the existing bounded wait, or to add a bounded polling design, requires a separate exact-code decision. No such revision was made.

## 23. Final execution status

- `t3i_b_execution_status: STOPPED_FOR_HUMAN_REVIEW`
- `i02_subtests_passed: 3`
- `u02_passed: 1`
- `s01_passed: 1`
- `m06_passed: 1`
- `m01_passed: 1`
- `s02_passed: 1`
- `m02_passed: 1`
- `u01_unmount_completed: 1`
- `u01_helper_exit_success: 0`
- `u01_exit_category: 60`
- `s03_executed: 0`
- `mounts_successful: 1`
- `mounts_removed: 1`
- `wrong_password_attempts: 1`
- `passwords_recorded: 0`
- `fallback_writes_succeeded: 0`
- `automatic_remount_observed: 0`
- `retained_process_at_immediate_check: 1`
- `retained_process_at_follow_up: 0`
- `final_mount_present: 0`
- `final_plaintext_entries: 0`
- `final_plaintext_mode: 0500`
- `production_paths_created: 0`
- `files_migrated: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 24. Updated verdict and review question

**`T3I_B_EXECUTION_STOPPED_TRANSIENT_PROCESS_REVIEW_REQUIRED`**

The authorized sequence proved argument rejection, locked refusal, healthy locked status, wrong-password cleanup, correct owner-controlled mount, healthy mounted status, second-mount refusal, explicit unmount, fail-closed restoration, and fallback rejection. It stopped before final `S03` because the immediate retained-process check detected a process that was absent on read-only follow-up.

Dan must decide whether to keep immediate process absence as a hard requirement or authorize an exact bounded graceful-exit wait/poll revision before the process failure decision. The sequence must not resume automatically.

## 25. Authorized bounded-wait correction and resumed S03

Dan authorized a minimal correction limited to retained-process and automatic-remount verification after successful unmount. No mount, status, path, ownership, emptiness, permission, fallback-write, or secret-handling behavior was changed.

The exact replacement was:

```diff
-process_lines="$(pgrep -a -u "$EXPECTED_USER" gocryptfs 2>/dev/null || true)"
-if [[ -n "$process_lines" ]] && printf '%s\n' "$process_lines" | grep -F -- "$CIPHER_DIR" >/dev/null; then
-    die "$E_RETAINED" "gocryptfs process remains associated with approved paths"
-fi
-
-sleep 2
-[[ -z "$(findmnt -rn -M "$PLAIN_DIR" -o TARGET 2>/dev/null || true)" ]] ||
-    die "$E_RETAINED" "automatic remount detected"
+for wait_second in 0 1 2 3 4 5; do
+    [[ -z "$(findmnt -rn -M "$PLAIN_DIR" -o TARGET 2>/dev/null || true)" ]] ||
+        die "$E_RETAINED" "automatic remount detected"
+    process_lines="$(pgrep -a -u "$EXPECTED_USER" gocryptfs 2>/dev/null || true)"
+    if [[ -z "$process_lines" ]] || ! printf '%s\n' "$process_lines" | grep -F -- "$CIPHER_DIR" >/dev/null; then
+        break
+    fi
+    (( wait_second < 5 )) || die "$E_RETAINED" "gocryptfs process remains after bounded wait"
+    sleep 1
+done
```

This performs an immediate mount/process check followed, only while the associated process persists, by no more than five one-second waits. Every cycle fails with exit `60` on an automatic remount. Exit `60` also applies if the associated process remains after the deadline. The revision adds no kill, forced-unmount, background, password, production, or other command authority.

| Static/review check | Result |
|---|---|
| `bash -n` | Pass |
| ShellCheck 0.11.0 | Pass |
| `git diff --check` | Pass |
| Revised unmount SHA-256 | `a30cb52a3805cf046c6c7a0be789cfce4f77e74fb423855895e9f585c389618e` |
| Mount SHA-256 | Unchanged: `27e7ae82b741da177f9a219a6d6916185ee5907739c9748b2cb8957df660b524` |
| Status SHA-256 | Unchanged: `ade6e6efa7800356b1e296712b2d25b67820e011b4f6e13f035ee8dc0565850f` |
| Production literals | Remain defensive deny-list constants only |
| Secret automation | None added |

The resumed `S03` returned exit `0` and `STATE=LOCKED_HEALTHY`. It reported the disposable plaintext path empty, unmounted, owned by `dev:dev`, and mode `0500`. A subsequent exact process inspection found no running `gocryptfs` command associated with the approved ciphertext or plaintext path. No password interaction occurred.

The sequence is paused immediately before the newly authorized `M01` owner-controlled interactive mount. No later test has run in this resumed cycle.

## 26. Five-second U01 result and delayed-process investigation

Dan completed the owner-controlled `M01`; no password or recovery material was recorded. The following `S02` returned exit `0` and `STATE=MOUNTED_HEALTHY`, with the exact approved ciphertext source, plaintext target, `fuse.gocryptfs` type, and mounted mode `0700`.

The subsequent `U01` removed the exact approved mount, confirmed the underlying plaintext path was empty, restored `dev:dev` mode `0500`, and passed the fallback-write control. The associated `gocryptfs` process remained through the then-authorized five-second deadline, so the helper correctly stopped with exit `60`. Final `S03` was not run in that cycle.

A separately authorized read-only investigation later observed:

- the exact mount absent at `2026-08-01T18:27:00Z`, `18:27:05Z`, and `18:27:10Z`;
- the plaintext path empty, `dev:dev`, and mode `0500`;
- no exact-command-name `gocryptfs` process during any of those observations; and
- no automatic remount.

Classification: **`DISPOSABLE_PROCESS_EXITED_AFTER_DELAY`**.

## 27. Authorized thirty-second bounded-wait revision

Dan authorized only these changes to the existing post-unmount loop:

```diff
-for wait_second in 0 1 2 3 4 5; do
+for wait_second in {0..30}; do
@@
     if [[ -z "$process_lines" ]] || ! printf '%s\n' "$process_lines" | grep -F -- "$CIPHER_DIR" >/dev/null; then
+        log "associated gocryptfs process exit observed after ${wait_second}s"
         break
     fi
-    (( wait_second < 5 )) || die "$E_RETAINED" "gocryptfs process remains after bounded wait"
+    (( wait_second < 30 )) || die "$E_RETAINED" "gocryptfs process remains after bounded wait"
```

The polling interval remains one second. Exact mount absence is checked during every cycle; automatic remount and a process retained after thirty seconds both return exit `60`. The loop succeeds immediately when the associated process disappears and records only elapsed polling seconds. No detection, kill, signal, forced-unmount, background, secret, path, production, fallback, ownership, emptiness, or permission authority changed.

| Static/review check | Result |
|---|---|
| `bash -n` | Pass |
| ShellCheck 0.11.0 | Pass |
| `git diff --check` | Pass |
| Revised unmount SHA-256 | `eba7648c21c10828cbefd0c868ec43fe070a27e695f80f3f2f9ab77caf368938` |
| Mount SHA-256 | Unchanged: `27e7ae82b741da177f9a219a6d6916185ee5907739c9748b2cb8957df660b524` |
| Status SHA-256 | Unchanged: `ade6e6efa7800356b1e296712b2d25b67820e011b4f6e13f035ee8dc0565850f` |
| Production literals | Defensive deny-list constants only |
| Secret automation or new command authority | None added |

The final validation cycle is authorized but must pause for Dan's interactive password entry after the initial locked-state `S03`.

The initial `S03` ran at `2026-08-01T18:43:08Z` and returned exit `0` with `STATE=LOCKED_HEALTHY`. It confirmed the plaintext mountpoint was unmounted, empty, owned by `dev:dev`, mode `0500`, and had no observed associated `gocryptfs` process. The cycle is paused before `M01`; no password interaction has occurred in this final cycle.

## 28. Final thirty-second-control validation cycle

Dan completed the owner-controlled `M01` using interactive password entry and reported success. No password, hint, keystroke, master key, recovery material, or secret-derived output was recorded.

| Test | UTC evidence | Secret-free result | Exit | Assessment |
|---|---|---|---:|---|
| `M01` | Owner-reported before `S02` | Correct-password interactive mount succeeded | Success | Pass |
| `S02` | `2026-08-01T18:58:26Z` | `MOUNTED_HEALTHY`; exact approved source, target, `fuse.gocryptfs` type, and mode `0700` | `0` | Pass |
| `U01` | `2026-08-01T19:00:03Z` | Exact mount removed; plaintext empty; `dev:dev`; mode `0500`; fallback write rejected; no automatic remount; associated process absent at immediate `0s` observation | `0` | Pass |
| Final `S03` | `2026-08-01T19:33:04Z` | `LOCKED_HEALTHY`; unmounted, empty, `dev:dev`, mode `0500`; associated process not observed | `0` | Pass |

Observed process-exit polling delay for the successful repeated `U01`: `0` seconds. The helper did not weaken retained-process detection; the process was absent on its immediate post-unmount polling observation.

Final cycle status:

- `final_validation_cycle: COMPLETE`
- `m01_passed: 1`
- `s02_passed: 1`
- `u01_passed: 1`
- `u01_exit_code: 0`
- `s03_passed: 1`
- `automatic_remount_observed: 0`
- `fallback_writes_succeeded: 0`
- `final_mount_present: 0`
- `final_plaintext_entries: 0`
- `final_plaintext_owner_group: dev:dev`
- `final_plaintext_mode: 0500`
- `associated_process_final: NOT_OBSERVED`
- `passwords_recorded: 0`
- `production_paths_created: 0`
- `files_migrated: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

**`T3I_B_LIMITED_DISPOSABLE_TEST_COMPLETE_READY_FOR_HUMAN_REVIEW`**
