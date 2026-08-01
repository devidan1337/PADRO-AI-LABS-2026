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
[[ "$(stat -c '%a' "$PLAIN_DIR")" == "$MOUNT_READY_MODE" ]] ||
    die "$E_MODE" "mounted plaintext mode must be $MOUNT_READY_MODE"

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

for wait_second in {0..30}; do
    [[ -z "$(findmnt -rn -M "$PLAIN_DIR" -o TARGET 2>/dev/null || true)" ]] ||
        die "$E_RETAINED" "automatic remount detected"
    process_lines="$(pgrep -a -u "$EXPECTED_USER" gocryptfs 2>/dev/null || true)"
    if [[ -z "$process_lines" ]] || ! printf '%s\n' "$process_lines" | grep -F -- "$CIPHER_DIR" >/dev/null; then
        log "associated gocryptfs process exit observed after ${wait_second}s"
        break
    fi
    (( wait_second < 30 )) || die "$E_RETAINED" "gocryptfs process remains after bounded wait"
    sleep 1
done

[[ "$(stat -c '%d:%i' "$PLAIN_DIR")" == "$plain_identity" ]] ||
    die "$E_PATH" "plaintext path identity changed during remount check"

log "LOCKED_HEALTHY unmount complete; mode=$LOCKED_MODE fallback_write=REJECTED"
