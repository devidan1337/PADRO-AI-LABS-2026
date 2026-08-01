# Phase 3D-C3E-T3I-A — Helper Script Exact-Code Design Review for Retained Disposable gocryptfs

> **verdict: `T3I_A_DESIGN_COMPLETE_READY_FOR_HUMAN_CODE_REVIEW`**
>
> **scope: EXACT CODE PROPOSAL ONLY — SCRIPTS NOT CREATED OR EXECUTED**
>
> **decision owner: Dan**

## 1. Authority and design boundary

Final human decision owner: **Dan**

This review follows T3H, T3G, T3F, and T3D. It proposes exact Bash code for three future scripts named for their eventual purpose:

- `scripts/private-archive-mount.sh`
- `scripts/private-archive-status.sh`
- `scripts/private-archive-unmount.sh`

The proposed T3I disposable versions operate only on:

- ciphertext: `/home/dev/pal-encryption-test/gocryptfs/cipher`
- plaintext: `/home/dev/pal-encryption-test/gocryptfs/plain`

They must never operate on production, backup, restore, client, investigative, or other storage. Production literals appear in proposed executable code only as defensive deny-list checks. They are never accepted as an argument, source, target, configuration input, or state-change path. The later static gate must confirm this distinction.

T3I-A creates no script, changes no mode, performs no probe, and authorizes no execution.

## 2. Shared design rules and constants

Every proposed script begins with:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'
```

Every script embeds this immutable disposable constant block:

```bash
readonly CIPHER_DIR="/home/dev/pal-encryption-test/gocryptfs/cipher"
readonly PLAIN_DIR="/home/dev/pal-encryption-test/gocryptfs/plain"
readonly EXPECTED_USER="dev"
readonly LOCKED_MODE="500"
readonly MOUNT_READY_MODE="700"
readonly EXPECTED_FSTYPE="fuse.gocryptfs"
```

No writable external configuration file is used. There is no current-working-directory dependency, wildcard expansion for protected paths, `eval`, dynamic command construction, `sudo`, package operation, secret automation, automatic mount, or remount loop.

T3D observed the filesystem type exactly as `fuse.gocryptfs`; therefore this proposal accepts only that value. A generic `fuse` value is not accepted speculatively. If a later disposable test reliably observes `fuse` in the same verification namespace, T3I-B may approve an explicit narrow allow-list such as `fuse.gocryptfs|fuse`. Until then, every alternate or blank type fails closed.

## 3. Stable exit-code design

| Exit code | Stable meaning |
|---:|---|
| `0` | Success: healthy locked/mounted state or completed requested operation |
| `2` | Arguments supplied or invocation contract violated |
| `10` | Wrong user |
| `11` | Missing required dependency |
| `20` | Unauthorized/production path detected or disposable constant invariant failed |
| `21` | Path state conflict: missing, wrong type, symlink, nonempty, or changed identity |
| `22` | Ownership conflict |
| `23` | Permission/mode conflict |
| `30` | Unexpected, ambiguous, or pre-existing mount |
| `31` | gocryptfs mount command failed |
| `32` | Mount returned success but exact verification failed |
| `40` | FUSE unmount failed or mount remained |
| `50` | Fallback-write control failed or probe residue exists |
| `60` | Retained associated process or automatic remount detected |
| `70` | Internal cleanup or invariant failure not represented above |

Codes are not reused for different meanings. Messages include UTC timestamps and a stable category without secrets.

## 4. Exact proposed mount script

Proposed future disposable version of `scripts/private-archive-mount.sh`:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

readonly CIPHER_DIR="/home/dev/pal-encryption-test/gocryptfs/cipher"
readonly PLAIN_DIR="/home/dev/pal-encryption-test/gocryptfs/plain"
readonly EXPECTED_USER="dev"
readonly LOCKED_MODE="500"
readonly MOUNT_READY_MODE="700"
readonly EXPECTED_FSTYPE="fuse.gocryptfs"
readonly PROBE_PATH="${PLAIN_DIR}/.pal-private-archive-fallback-probe"

# Defensive deny-list only; never operational targets.
readonly PROD_CIPHER="/home/dev/.pal-private-cipher/archive"
readonly PROD_PLAIN="/home/dev/pal-private-archive"
readonly PROD_ACTIVE="/home/dev/pal-private-archive/active"
readonly PROD_LEGACY="/home/dev/pal-private-archive/legacy"

readonly E_ARGS=2
readonly E_USER=10
readonly E_DEP=11
readonly E_UNAUTHORIZED=20
readonly E_PATH=21
readonly E_OWNER=22
readonly E_MODE=23
readonly E_MOUNT_STATE=30
readonly E_MOUNT_FAILED=31
readonly E_MOUNT_VERIFY=32
readonly E_FALLBACK=50
readonly E_INTERNAL=70

mode_changed=0
mount_verified=0
plain_identity=""

utc_now() { date -u +'%Y-%m-%dT%H:%M:%SZ'; }
log() { printf '%s %s\n' "$(utc_now)" "$*"; }
die() { local code=$1; shift; log "ERROR[$code] $*" >&2; exit "$code"; }

require_commands() {
    local cmd
    for cmd in date id gocryptfs findmnt stat find chmod touch rm grep; do
        command -v "$cmd" >/dev/null 2>&1 || die "$E_DEP" "missing command: $cmd"
    done
}

reject_symlink_paths() {
    local component
    for component in \
        /home /home/dev /home/dev/pal-encryption-test \
        /home/dev/pal-encryption-test/gocryptfs "$CIPHER_DIR" "$PLAIN_DIR"; do
        [[ ! -L "$component" ]] || die "$E_PATH" "symlink path component rejected: $component"
    done
}

exact_mount_line() {
    findmnt -rn -M "$PLAIN_DIR" -o TARGET,SOURCE,FSTYPE 2>/dev/null || true
}

is_mounted() {
    [[ -n "$(exact_mount_line)" ]]
}

is_empty_unmounted_plain() {
    ! is_mounted && [[ -z "$(find "$PLAIN_DIR" -mindepth 1 -print -quit)" ]]
}

check_identity_unchanged() {
    [[ "$(stat -c '%d:%i' "$PLAIN_DIR")" == "$plain_identity" ]] ||
        die "$E_PATH" "plaintext path identity changed"
}

cleanup_on_exit() {
    local rc=$?
    trap - EXIT
    if (( mount_verified == 0 && mode_changed == 1 )); then
        if ! is_mounted; then
            if [[ -d "$PLAIN_DIR" && ! -L "$PLAIN_DIR" ]] &&
               [[ -z "$(find "$PLAIN_DIR" -mindepth 1 -print -quit)" ]]; then
                chmod "$LOCKED_MODE" "$PLAIN_DIR" || rc=$E_INTERNAL
                log "failure cleanup: plaintext mode restored to $LOCKED_MODE"
            else
                log "ERROR[$E_INTERNAL] failure cleanup could not prove empty safe mountpoint" >&2
                rc=$E_INTERNAL
            fi
        else
            log "ERROR[$E_MOUNT_VERIFY] mount exists but was not verified; state preserved" >&2
            rc=$E_MOUNT_VERIFY
        fi
    fi
    exit "$rc"
}

on_err() {
    local rc=$?
    log "ERROR[$rc] unexpected command failure" >&2
    return "$rc"
}

on_signal() {
    log "ERROR[70] interrupted; entering failure cleanup" >&2
    exit "$E_INTERNAL"
}

trap cleanup_on_exit EXIT
trap on_err ERR
trap on_signal HUP INT TERM

(( $# == 0 )) || die "$E_ARGS" "arguments are not accepted"
require_commands
[[ "$(id -un)" == "$EXPECTED_USER" ]] || die "$E_USER" "must run as $EXPECTED_USER"

[[ "$CIPHER_DIR" == "/home/dev/pal-encryption-test/gocryptfs/cipher" ]] ||
    die "$E_UNAUTHORIZED" "cipher constant invariant failed"
[[ "$PLAIN_DIR" == "/home/dev/pal-encryption-test/gocryptfs/plain" ]] ||
    die "$E_UNAUTHORIZED" "plain constant invariant failed"

for denied in "$PROD_CIPHER" "$PROD_PLAIN" "$PROD_ACTIVE" "$PROD_LEGACY"; do
    [[ "$CIPHER_DIR" != "$denied" && "$PLAIN_DIR" != "$denied" ]] ||
        die "$E_UNAUTHORIZED" "operational path matches deny-list"
    [[ ! -e "$denied" ]] || die "$E_UNAUTHORIZED" "production path unexpectedly exists: $denied"
done

reject_symlink_paths
[[ -d "$CIPHER_DIR" ]] || die "$E_PATH" "ciphertext directory missing or not a directory"
[[ -d "$PLAIN_DIR" ]] || die "$E_PATH" "plaintext directory missing or not a directory"
[[ "$(stat -c '%U:%G' "$CIPHER_DIR")" == "dev:dev" ]] ||
    die "$E_OWNER" "ciphertext ownership mismatch"
[[ "$(stat -c '%U:%G' "$PLAIN_DIR")" == "dev:dev" ]] ||
    die "$E_OWNER" "plaintext ownership mismatch"
[[ -f "$CIPHER_DIR/gocryptfs.conf" && ! -L "$CIPHER_DIR/gocryptfs.conf" ]] ||
    die "$E_PATH" "gocryptfs.conf missing or unsafe"
[[ -f "$CIPHER_DIR/gocryptfs.diriv" && ! -L "$CIPHER_DIR/gocryptfs.diriv" ]] ||
    die "$E_PATH" "gocryptfs.diriv missing or unsafe"
[[ -z "$(findmnt -rn -M "$CIPHER_DIR" -o TARGET 2>/dev/null || true)" ]] ||
    die "$E_MOUNT_STATE" "ciphertext directory is an unexpected mountpoint"
! is_mounted || die "$E_MOUNT_STATE" "plaintext path is already mounted"
[[ -z "$(find "$PLAIN_DIR" -mindepth 1 -print -quit)" ]] ||
    die "$E_PATH" "unmounted plaintext path is not empty"
[[ "$(stat -c '%a' "$PLAIN_DIR")" == "$LOCKED_MODE" ]] ||
    die "$E_MODE" "plaintext mode must initially be $LOCKED_MODE"

plain_identity="$(stat -c '%d:%i' "$PLAIN_DIR")"
check_identity_unchanged

if touch "$PROBE_PATH" 2>/dev/null; then
    rm -f -- "$PROBE_PATH"
    die "$E_FALLBACK" "critical: fallback write succeeded while locked"
fi
[[ ! -e "$PROBE_PATH" && ! -L "$PROBE_PATH" ]] || {
    rm -f -- "$PROBE_PATH"
    die "$E_FALLBACK" "fallback probe residue detected"
}

check_identity_unchanged
! is_mounted || die "$E_MOUNT_STATE" "mount appeared before mode transition"
chmod "$MOUNT_READY_MODE" "$PLAIN_DIR"
mode_changed=1
check_identity_unchanged
[[ "$(stat -c '%U:%G' "$PLAIN_DIR")" == "dev:dev" ]] ||
    die "$E_OWNER" "ownership changed during preparation"
[[ "$(stat -c '%a' "$PLAIN_DIR")" == "$MOUNT_READY_MODE" ]] ||
    die "$E_MODE" "failed to establish mount-ready mode"
! is_mounted || die "$E_MOUNT_STATE" "mount appeared before gocryptfs invocation"

log "owner-interactive gocryptfs mount starting; no password is captured"
if ! gocryptfs "$CIPHER_DIR" "$PLAIN_DIR"; then
    die "$E_MOUNT_FAILED" "gocryptfs mount command failed"
fi

mount_line="$(exact_mount_line)"
[[ -n "$mount_line" ]] || die "$E_MOUNT_VERIFY" "mount command succeeded but target is unmounted"
IFS=' ' read -r observed_target observed_source observed_fstype <<<"$mount_line"
[[ "$observed_target" == "$PLAIN_DIR" ]] || die "$E_MOUNT_VERIFY" "unexpected mount target"
[[ "$observed_source" == "$CIPHER_DIR" ]] || die "$E_MOUNT_VERIFY" "unexpected mount source"
[[ "$observed_fstype" == "$EXPECTED_FSTYPE" ]] || die "$E_MOUNT_VERIFY" "unexpected filesystem type"

mount_verified=1
log "MOUNTED_HEALTHY target=$PLAIN_DIR source=$CIPHER_DIR fstype=$EXPECTED_FSTYPE"
```

### 4.1 Interactive behavior and failure trap review

T3D showed that the direct foreground invocation returns after successful setup while the FUSE mount remains available; no separately visible retained process was guaranteed in the restricted inspection namespace. gocryptfs may daemonize/background itself as part of normal successful behavior. The script therefore invokes it directly and synchronously, then treats the mount table—not process presence—as authoritative. It uses no `nohup`, shell `&`, password automation, or background monitor. Exact return/daemon behavior remains a T3I-B disposable-test assumption to validate.

The EXIT trap is armed before state changes. It does nothing after a verified successful mount. If mounting fails and the target remains unmounted, it restores `0500` only after proving the exact directory remains non-symlinked and empty. If any unverified mount exists, it preserves state and refuses to unmount automatically. It deletes only the exact probe if the critical forbidden write unexpectedly succeeds; it never removes other plaintext or ciphertext content.

## 5. Exact proposed read-only status script

Proposed future disposable version of `scripts/private-archive-status.sh`:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

readonly CIPHER_DIR="/home/dev/pal-encryption-test/gocryptfs/cipher"
readonly PLAIN_DIR="/home/dev/pal-encryption-test/gocryptfs/plain"
readonly EXPECTED_USER="dev"
readonly LOCKED_MODE="500"
readonly MOUNT_READY_MODE="700"
readonly EXPECTED_FSTYPE="fuse.gocryptfs"

# Defensive deny-list only; never operational targets.
readonly PROD_CIPHER="/home/dev/.pal-private-cipher/archive"
readonly PROD_PLAIN="/home/dev/pal-private-archive"
readonly PROD_ACTIVE="/home/dev/pal-private-archive/active"
readonly PROD_LEGACY="/home/dev/pal-private-archive/legacy"

readonly E_ARGS=2
readonly E_USER=10
readonly E_DEP=11
readonly E_UNAUTHORIZED=20
readonly E_PATH=21
readonly E_OWNER=22
readonly E_MODE=23
readonly E_MOUNT_STATE=30

utc_now() { date -u +'%Y-%m-%dT%H:%M:%SZ'; }
out() { printf '%s %s\n' "$(utc_now)" "$*"; }
die() { local code=$1; shift; out "ERROR[$code] $*" >&2; exit "$code"; }

(( $# == 0 )) || die "$E_ARGS" "arguments are not accepted"
for cmd in date id findmnt stat find pgrep grep; do
    command -v "$cmd" >/dev/null 2>&1 || die "$E_DEP" "missing command: $cmd"
done
[[ "$(id -un)" == "$EXPECTED_USER" ]] || die "$E_USER" "must run as $EXPECTED_USER"

[[ "$CIPHER_DIR" == "/home/dev/pal-encryption-test/gocryptfs/cipher" ]] ||
    die "$E_UNAUTHORIZED" "cipher constant invariant failed"
[[ "$PLAIN_DIR" == "/home/dev/pal-encryption-test/gocryptfs/plain" ]] ||
    die "$E_UNAUTHORIZED" "plain constant invariant failed"

production_present=0
for denied in "$PROD_CIPHER" "$PROD_PLAIN" "$PROD_ACTIVE" "$PROD_LEGACY"; do
    if [[ -e "$denied" || -L "$denied" ]]; then
        out "PRODUCTION_PATH_UNEXPECTED path=$denied"
        production_present=1
    fi
done
(( production_present == 0 )) || die "$E_UNAUTHORIZED" "production path exists"

out "CIPHER_EXISTS=$([[ -d "$CIPHER_DIR" ]] && printf YES || printf NO)"
out "PLAIN_EXISTS=$([[ -d "$PLAIN_DIR" ]] && printf YES || printf NO)"
[[ -d "$CIPHER_DIR" && ! -L "$CIPHER_DIR" ]] || die "$E_PATH" "cipher path incomplete or unsafe"
[[ -d "$PLAIN_DIR" && ! -L "$PLAIN_DIR" ]] || die "$E_PATH" "plain path incomplete or unsafe"

cipher_owner="$(stat -c '%U:%G' "$CIPHER_DIR")"
plain_owner="$(stat -c '%U:%G' "$PLAIN_DIR")"
cipher_mode="$(stat -c '%a' "$CIPHER_DIR")"
plain_mode="$(stat -c '%a' "$PLAIN_DIR")"
out "CIPHER_OWNER=$cipher_owner CIPHER_MODE=$cipher_mode"
out "PLAIN_OWNER=$plain_owner PLAIN_MODE=$plain_mode"
[[ "$cipher_owner" == "dev:dev" && "$plain_owner" == "dev:dev" ]] ||
    die "$E_OWNER" "ownership conflict"

out "GOCRYPTFS_CONF_PRESENT=$([[ -f "$CIPHER_DIR/gocryptfs.conf" && ! -L "$CIPHER_DIR/gocryptfs.conf" ]] && printf YES || printf NO)"
out "GOCRYPTFS_DIRIV_PRESENT=$([[ -f "$CIPHER_DIR/gocryptfs.diriv" && ! -L "$CIPHER_DIR/gocryptfs.diriv" ]] && printf YES || printf NO)"
[[ -f "$CIPHER_DIR/gocryptfs.conf" && ! -L "$CIPHER_DIR/gocryptfs.conf" ]] ||
    die "$E_PATH" "initialization configuration missing or unsafe"
[[ -f "$CIPHER_DIR/gocryptfs.diriv" && ! -L "$CIPHER_DIR/gocryptfs.diriv" ]] ||
    die "$E_PATH" "initialization diriv missing or unsafe"

mount_line="$(findmnt -rn -M "$PLAIN_DIR" -o TARGET,SOURCE,FSTYPE 2>/dev/null || true)"
process_lines="$(pgrep -a -u "$EXPECTED_USER" gocryptfs 2>/dev/null || true)"
if [[ -n "$process_lines" ]] && printf '%s\n' "$process_lines" | grep -F -- "$CIPHER_DIR" >/dev/null; then
    out "ASSOCIATED_GOCRYPTFS_PROCESS=YES"
else
    out "ASSOCIATED_GOCRYPTFS_PROCESS=NOT_OBSERVED"
fi

if [[ -n "$mount_line" ]]; then
    IFS=' ' read -r target source fstype <<<"$mount_line"
    out "MOUNT_TARGET=$target MOUNT_SOURCE=$source MOUNT_FSTYPE=$fstype"
    [[ "$target" == "$PLAIN_DIR" && "$source" == "$CIPHER_DIR" && "$fstype" == "$EXPECTED_FSTYPE" ]] ||
        die "$E_MOUNT_STATE" "UNSAFE_STATE unexpected mount relationship"
    [[ "$plain_mode" == "$MOUNT_READY_MODE" ]] ||
        die "$E_MODE" "UNSAFE_STATE mounted root mode differs from expected operational mode"
    out "STATE=MOUNTED_HEALTHY"
    exit 0
fi

if [[ -z "$(find "$PLAIN_DIR" -mindepth 1 -print -quit)" ]] && [[ "$plain_mode" == "$LOCKED_MODE" ]]; then
    out "UNMOUNTED_EMPTY=YES LOCKED_MODE=YES"
    out "STATE=LOCKED_HEALTHY"
    exit 0
fi

out "UNMOUNTED_EMPTY=$([[ -z "$(find "$PLAIN_DIR" -mindepth 1 -print -quit)" ]] && printf YES || printf NO)"
if [[ "$plain_mode" != "$LOCKED_MODE" ]]; then
    die "$E_MODE" "UNSAFE_STATE unmounted mode is not $LOCKED_MODE"
fi
die "$E_PATH" "INCOMPLETE_STATE unmounted plaintext path is not empty"
```

The status script performs no write probe, chmod, mount, unmount, cleanup, or content display. `ASSOCIATED_GOCRYPTFS_PROCESS=NOT_OBSERVED` is informational because namespace/daemon behavior may hide a process even when an exact mount is authoritative.

## 6. Exact proposed unmount script

Proposed future disposable version of `scripts/private-archive-unmount.sh`:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

readonly CIPHER_DIR="/home/dev/pal-encryption-test/gocryptfs/cipher"
readonly PLAIN_DIR="/home/dev/pal-encryption-test/gocryptfs/plain"
readonly EXPECTED_USER="dev"
readonly LOCKED_MODE="500"
readonly MOUNT_READY_MODE="700"
readonly EXPECTED_FSTYPE="fuse.gocryptfs"
readonly PROBE_PATH="${PLAIN_DIR}/.pal-private-archive-fallback-probe"

# Defensive deny-list only; never operational targets.
readonly PROD_CIPHER="/home/dev/.pal-private-cipher/archive"
readonly PROD_PLAIN="/home/dev/pal-private-archive"
readonly PROD_ACTIVE="/home/dev/pal-private-archive/active"
readonly PROD_LEGACY="/home/dev/pal-private-archive/legacy"

readonly E_ARGS=2
readonly E_USER=10
readonly E_DEP=11
readonly E_UNAUTHORIZED=20
readonly E_PATH=21
readonly E_OWNER=22
readonly E_MODE=23
readonly E_MOUNT_STATE=30
readonly E_UNMOUNT=40
readonly E_FALLBACK=50
readonly E_RETAINED=60

utc_now() { date -u +'%Y-%m-%dT%H:%M:%SZ'; }
log() { printf '%s %s\n' "$(utc_now)" "$*"; }
die() { local code=$1; shift; log "ERROR[$code] $*" >&2; exit "$code"; }

(( $# == 0 )) || die "$E_ARGS" "arguments are not accepted"
for cmd in date id findmnt fusermount3 stat find chmod touch rm pgrep grep sleep; do
    command -v "$cmd" >/dev/null 2>&1 || die "$E_DEP" "missing command: $cmd"
done
[[ "$(id -un)" == "$EXPECTED_USER" ]] || die "$E_USER" "must run as $EXPECTED_USER"

[[ "$CIPHER_DIR" == "/home/dev/pal-encryption-test/gocryptfs/cipher" ]] ||
    die "$E_UNAUTHORIZED" "cipher constant invariant failed"
[[ "$PLAIN_DIR" == "/home/dev/pal-encryption-test/gocryptfs/plain" ]] ||
    die "$E_UNAUTHORIZED" "plain constant invariant failed"
for denied in "$PROD_CIPHER" "$PROD_PLAIN" "$PROD_ACTIVE" "$PROD_LEGACY"; do
    [[ "$CIPHER_DIR" != "$denied" && "$PLAIN_DIR" != "$denied" ]] ||
        die "$E_UNAUTHORIZED" "operational path matches deny-list"
    [[ ! -e "$denied" ]] || die "$E_UNAUTHORIZED" "production path unexpectedly exists: $denied"
done

[[ -d "$CIPHER_DIR" && ! -L "$CIPHER_DIR" ]] || die "$E_PATH" "cipher path missing or unsafe"
[[ -d "$PLAIN_DIR" && ! -L "$PLAIN_DIR" ]] || die "$E_PATH" "plain path missing or unsafe"
[[ "$(stat -c '%U:%G' "$PLAIN_DIR")" == "dev:dev" ]] ||
    die "$E_OWNER" "plaintext ownership mismatch"

mount_line="$(findmnt -rn -M "$PLAIN_DIR" -o TARGET,SOURCE,FSTYPE 2>/dev/null || true)"
[[ -n "$mount_line" ]] || die "$E_MOUNT_STATE" "plaintext path is not mounted"
IFS=' ' read -r target source fstype <<<"$mount_line"
[[ "$target" == "$PLAIN_DIR" ]] || die "$E_MOUNT_STATE" "unexpected mount target"
[[ "$source" == "$CIPHER_DIR" ]] || die "$E_MOUNT_STATE" "unexpected mount source"
[[ "$fstype" == "$EXPECTED_FSTYPE" ]] || die "$E_MOUNT_STATE" "unexpected filesystem type"

plain_identity="$(stat -c '%d:%i' "$PLAIN_DIR")"
log "verified expected disposable mount; explicit unmount starting"
if ! fusermount3 -u "$PLAIN_DIR"; then
    die "$E_UNMOUNT" "fusermount3 failed; active mount state preserved"
fi

[[ -z "$(findmnt -rn -M "$PLAIN_DIR" -o TARGET 2>/dev/null || true)" ]] ||
    die "$E_UNMOUNT" "mount remains after unmount command"
[[ -d "$PLAIN_DIR" && ! -L "$PLAIN_DIR" ]] || die "$E_PATH" "plain path changed after unmount"
[[ -z "$(find "$PLAIN_DIR" -mindepth 1 -print -quit)" ]] ||
    die "$E_PATH" "underlying plaintext mountpoint is not empty"

# Device/inode differs while mounted versus underlying directory on many FUSE mounts;
# establish the underlying identity only after verified unmount.
plain_identity="$(stat -c '%d:%i' "$PLAIN_DIR")"
chmod "$LOCKED_MODE" "$PLAIN_DIR"
[[ "$(stat -c '%d:%i' "$PLAIN_DIR")" == "$plain_identity" ]] ||
    die "$E_PATH" "plaintext path identity changed during lock transition"
[[ "$(stat -c '%U:%G' "$PLAIN_DIR")" == "dev:dev" ]] ||
    die "$E_OWNER" "ownership changed after unmount"
[[ "$(stat -c '%a' "$PLAIN_DIR")" == "$LOCKED_MODE" ]] ||
    die "$E_MODE" "failed to restore locked mode"
[[ -z "$(findmnt -rn -M "$PLAIN_DIR" -o TARGET 2>/dev/null || true)" ]] ||
    die "$E_RETAINED" "mount reappeared before fallback probe"

if touch "$PROBE_PATH" 2>/dev/null; then
    rm -f -- "$PROBE_PATH"
    die "$E_FALLBACK" "critical: fallback write succeeded after unmount"
fi
[[ ! -e "$PROBE_PATH" && ! -L "$PROBE_PATH" ]] || {
    rm -f -- "$PROBE_PATH"
    die "$E_FALLBACK" "fallback probe residue detected"
}

process_lines="$(pgrep -a -u "$EXPECTED_USER" gocryptfs 2>/dev/null || true)"
if [[ -n "$process_lines" ]] && printf '%s\n' "$process_lines" | grep -F -- "$CIPHER_DIR" >/dev/null; then
    die "$E_RETAINED" "gocryptfs process remains associated with approved paths"
fi

sleep 2
[[ -z "$(findmnt -rn -M "$PLAIN_DIR" -o TARGET 2>/dev/null || true)" ]] ||
    die "$E_RETAINED" "automatic remount detected"
[[ "$(stat -c '%d:%i' "$PLAIN_DIR")" == "$plain_identity" ]] ||
    die "$E_PATH" "plaintext path identity changed during remount check"

log "LOCKED_HEALTHY unmount complete; mode=$LOCKED_MODE fallback_write=REJECTED"
```

If `fusermount3` fails, the script stops before chmod or probing, avoiding interference with a still-active mount. It never deletes ciphertext or encrypted synthetic objects. The only `rm` target is the exact probe after an unexpected critical write success/residue.

## 7. Probe-file design

The exact probe is:

`/home/dev/pal-encryption-test/gocryptfs/plain/.pal-private-archive-fallback-probe`

It is predictable for audit and cleanup, unique to this control, and confined to the approved disposable plaintext mountpoint. The scripts first prove the path is unmounted, empty, `dev:dev`, and `0500`. They immediately repeat the mount check before probing. Any successful `touch` proves the fail-closed invariant is broken, so the script removes only that probe, returns exit `50` even if removal succeeds, and forbids mount/work continuation. The probe is never attempted while mounted.

## 8. Race-condition and TOCTOU review

| Race | Consequence | Proposed mitigation |
|---|---|---|
| Path or component replaced after validation | State change could target an unauthorized object | Reject symlinks on known components; capture device/inode; repeat it before/after sensitive changes; stop on mismatch |
| Mount appears between check and chmod | chmod might apply through a new mount | Repeat exact mount check immediately before chmod and after transition; fail closed on any mount |
| Mount disappears after successful verification | Caller may assume plaintext is protected while fallback directory is exposed | Scripts only report the instant state; callers must reverify immediately before every write; future write workflows must not rely on stale status output |
| Mount appears between fallback check and probe | Probe might write into encrypted view rather than test fallback | Repeat mount check immediately before probe; keep the interval minimal; treat ambiguity as failure |
| Process exits or appears during unmount | Stale process evidence or remount can be missed | Mount table is authoritative; check associated process after unmount, wait a bounded two seconds, then repeat mount and inode checks |
| Symlink substitution | Redirects protected operations | Reject exact-path and known-parent symlinks; use quoted absolute paths; no glob, `eval`, or user path input |
| Underlying inode hidden by FUSE | Comparing mounted inode to underlying inode is invalid | Establish underlying device/inode only after verified unmount; do not treat mounted-root inode as the underlying directory identity |

Residual TOCTOU risk remains because an unprivileged shell script cannot make multi-command filesystem/mount checks atomic. For a personal lab, fixed paths, exclusive owner control, no concurrent automation, repeated immediate checks, inode consistency, and fail-closed stops are proportionate. Privileged namespaces, ACLs, immutable flags, bind mounts, and kernel-policy changes are explicitly outside this design.

## 9. Static-review gate

Before any future script execution, T3I-B must require:

1. `bash -n` on each exact script;
2. ShellCheck on each script with findings resolved or explicitly reviewed;
3. line-by-line manual code review;
4. confirmation that production paths appear only in defensive deny-list logic and never as operational source/target values;
5. confirmation that executable operational paths are exactly the disposable pair;
6. searches proving no password argument, environment, file, pipe, prompt automation, `eval`, `sudo`, package command, `nohup`, shell backgrounding, automount, or remount loop exists;
7. stable exit-code and error-path review;
8. `git diff --check` for the future script changes;
9. explicit executable-permission review before any `chmod`; and
10. hashes of the reviewed script bytes before testing.

ShellCheck is required but its installation is not authorized. If unavailable, implementation stops and asks for separate package authority; it must not silently skip the gate.

## 10. Future disposable test matrix

| ID | Test | Expected outcome | Classification |
|---|---|---|---|
| `S01` | Healthy locked-state status | `LOCKED_HEALTHY`, exit 0 | Safe read-only |
| `M01` | Successful owner-controlled mount | Verified mount, exit 0 | State-changing; separate authorization and Dan interaction |
| `S02` | Healthy mounted-state status | `MOUNTED_HEALTHY`, exit 0 | Safe read-only after authorized mount |
| `U01` | Successful explicit unmount | `LOCKED_HEALTHY`, exit 0 | State-changing; separate authorization |
| `S03` | Final locked-state status | `LOCKED_HEALTHY`, exit 0 | Safe read-only |
| `M02` | Mount while already mounted | Refusal, exit 30, no state change | Requires authorized mounted precondition |
| `M03` | Mountpoint mode wrong | Refusal, exit 23 | Fault setup mutates mode; separately authorize and restore |
| `M04` | Unmounted plaintext nonempty | Refusal, exit 21 | Creating placeholder is fault injection; not authorized by T3I-A |
| `M05` | Initialization artifact missing | Refusal, exit 21 | Deletion/rename prohibited; use a separately authorized disposable copy only |
| `M06` | Wrong-password mount failure | Exit 31 and automatic restoration to `0500` | Dan-controlled secret test; separately authorize; no value recorded |
| `U02` | Unmount while not mounted | Refusal, exit 30 | Safe when locked; script itself is invoked but makes no state change |
| `U03` | Unexpected mount source/type | Refusal, exit 30 | Creating unexpected mount is privileged/stateful fault injection; prohibited absent new authority |
| `F01` | Fallback probe unexpectedly succeeds | Exit 50, probe removed, no mount | Requires deliberately weakening control; prohibited absent new authority |
| `P01` | Production path unexpectedly exists | Exit 20 | Creating path prohibited; static/mock review only unless later authorized |
| `I01` | Wrong user | Exit 10 | Requires alternate identity/context; separately reviewed execution |
| `I02` | Any argument supplied | Exit 2 | Safe invocation-contract test |
| `I03` | Required command missing | Exit 11 | Use a controlled test harness/PATH simulation only if authorized; do not uninstall tools |
| `U04` | Retained process or automatic remount | Exit 60 | Requires controlled process/remount fault injection; prohibited absent new authority |

No test authorizes corruption, initialization-artifact deletion, production paths, secret automation, destructive simulation, or cleanup. Tests labeled state-changing or fault injection require explicit T3I-B selection and exact rollback authority.

## 11. Audit evidence design

A future T3I execution report must record:

- SHA-256 of each tested script;
- exact Git commit containing the reviewed code;
- interpreter path and Bash version;
- gocryptfs and `fusermount3` versions;
- test case identifier and authority;
- exact precondition and expected state;
- exact command invoked without secrets;
- exit code and mapped meaning;
- secret-free output summary;
- exact mount source/target/type before and after;
- owner and numeric mode before and after;
- fallback-probe outcome and residue check;
- pass/fail result;
- deviations, residual state, and stop reason; and
- explicit confirmation that no password, hint, master key, recovery material, or protected configuration content was recorded.

## 12. Structured review findings

### Controls safe to automate after authorization

- exact-user and argument rejection;
- dependency, fixed-path, symlink, type, owner, mode, emptiness, and artifact-presence checks;
- secret-free UTC logging;
- exact mount-table inspection and classification;
- disposable mountpoint mode transitions;
- controlled fallback probe and exact-probe cleanup on critical success;
- direct gocryptfs invocation that leaves password interaction to Dan;
- exact successful-mount verification;
- verified FUSE unmount;
- post-unmount `0500`, emptiness, process, and remount checks.

### Decisions remaining human-controlled

- whether scripts may be created, made executable, or run;
- interactive password entry and retry decisions;
- approval of every state-changing test and fault setup;
- response to unexpected mounts, content, processes, production paths, or cleanup failure;
- any future conversion from disposable to production constants;
- package/ShellCheck installation; and
- repair, retry, cleanup, or production adoption.

### Assumptions requiring disposable validation

- direct gocryptfs return/daemon behavior after successful interactive mount;
- exact `findmnt` source rendering and `fuse.gocryptfs` type in the script's namespace;
- mounted-root mode observation of `0700`;
- `pgrep -a` visibility and command-line association after mount/unmount;
- bounded two-second automatic-remount observation adequacy;
- Bash ERR/EXIT/signal trap behavior across wrong-password and interrupted prompts; and
- ShellCheck findings for process substitution, command substitution, and trap flow.

### Likely failure modes

- wrong password or interrupted prompt;
- FUSE unavailable;
- path owner/mode drift;
- unmounted plaintext residue;
- stale or unexpected mount;
- source/type formatting differs from the validated expectation;
- cleanup cannot prove emptiness;
- mount succeeds but verification fails;
- busy unmount;
- hidden/retained process or remount;
- symlink/path replacement race; and
- production-path deny guard trips because later work created those paths.

### Convenience versus fail-closed behavior

The deliberate friction—starting at `0500`, probing before mount, requiring Dan interaction, verifying exact mount facts, refusing arguments, and restoring `0500`—is a security control. Automatic retries, aliases that bypass output, generic path parameters, stored credentials, broad FUSE acceptance, forced unmounts, and silent repair would be more convenient but conflict with the tested fail-closed design.

Shell aliases should remain deferred. If later approved, they must be thin, argument-free wrappers around reviewed scripts and must not suppress output, add password handling, change paths, or alter exit codes.

## 13. Conflict resolution note

Two requirements need precise interpretation: executable logic must contain no production operational path, while scripts must detect unexpected production paths. This proposal resolves them with immutable deny-only constants. Static review must fail if a production literal appears anywhere except the clearly marked deny-list declaration/check block. If Dan instead requires production strings to be entirely absent byte-for-byte, the runtime production-path detection requirement must move to an external authorized test harness; T3I-B must decide that alternative before script creation.

## 14. Next checkpoint recommendation

Recommend, but do not automatically authorize:

**Phase 3D-C3E-T3I-B — Human Exact-Code Decisions and Disposable Script-Test Authorization**

T3I-B should decide:

- whether this exact proposed code or a reviewed revision is approved;
- the deny-list interpretation in Section 13;
- whether the three disposable script files may be created;
- whether executable permissions may be set;
- whether ShellCheck is already available or installation is separately needed and authorized;
- which safe and state-changing test cases may execute;
- which fault-injection cases remain prohibited; and
- exact stop, rollback, evidence, and cleanup authority for approved tests.

## 15. Mandatory status block

- `t3i_a_status: DESIGN_COMPLETE`
- `exact_mount_script_code: PROPOSED_NOT_CREATED`
- `exact_status_script_code: PROPOSED_NOT_CREATED`
- `exact_unmount_script_code: PROPOSED_NOT_CREATED`
- `disposable_paths_only: REQUIRED`
- `production_paths_status: NOT_AUTHORIZED`
- `password_automation: PROHIBITED`
- `automatic_mount: PROHIBITED`
- `agent_controlled_unlock: PROHIBITED`
- `shellcheck_required: YES`
- `shellcheck_installation: NOT_AUTHORIZED`
- `script_creation: NOT_AUTHORIZED`
- `script_execution: NOT_AUTHORIZED`
- `fault_injection: NOT_AUTHORIZED`
- `files_created_outside_report: 0`
- `permissions_changed: 0`
- `mounts_created: 0`
- `mounts_removed: 0`
- `files_deleted: 0`
- `packages_installed: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

## 16. Verdict

**`T3I_A_DESIGN_COMPLETE_READY_FOR_HUMAN_CODE_REVIEW`**

The exact code proposal, stable exit codes, trap behavior, read-only status model, unmount protections, probe semantics, race review, static gate, test matrix, and audit evidence design are complete for human review. No script implementation or execution is authorized.

## 17. T3I-A validation record

T3I-A was documentation-and-code-design-only. Exactly one review report was created: this file. No existing repository file or script was modified, and none of the three proposed scripts was created. No executable permission, mount, unmount, probe, password interaction, disposable artifact, production path, package, BitLocker state, or LUKS state changed. The Git index remained unchanged and empty. `git diff --check` was run against this report. Work stopped without staging or committing.
