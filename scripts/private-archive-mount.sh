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
