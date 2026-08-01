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
