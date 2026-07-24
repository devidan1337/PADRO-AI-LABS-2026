#!/usr/bin/env bash
set -Eeuo pipefail

readonly EXIT_USAGE=64
readonly EXIT_CONFIG=78
readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd -P)"
readonly DEFAULT_CONFIG="${HOME}/.config/pal/cloud-sync.env"

mode=""
verbose=0

usage() {
  cat <<'EOF'
Usage: sync-pal-drive.sh MODE [--verbose]

Modes (choose exactly one):
  --inventory-only  Verify PAL and write a source inventory; download nothing.
  --dry-run         Inventory and produce a transfer plan; download nothing.
  --execute         Inventory, safely import, deduplicate, and report.
  --verbose         Show additional rclone progress.
  --help            Show this help.

Real configuration is read from ~/.config/pal/cloud-sync.env when present.
EOF
}

die() {
  printf 'cloud-sync: %s\n' "$*" >&2
  exit "${2:-1}"
}

while (($#)); do
  case "$1" in
    --inventory-only|--dry-run|--execute)
      [[ -z "$mode" ]] || die "choose exactly one mode" "$EXIT_USAGE"
      mode="${1#--}"
      ;;
    --verbose) verbose=1 ;;
    --help) usage; exit 0 ;;
    *) die "unknown option: $1" "$EXIT_USAGE" ;;
  esac
  shift
done
[[ -n "$mode" ]] || die "a mode is required (see --help)" "$EXIT_USAGE"

if [[ -f "$DEFAULT_CONFIG" ]]; then
  # This file must contain only shell assignments owned by the local user.
  # shellcheck disable=SC1090
  source "$DEFAULT_CONFIG"
fi

: "${PAL_RCLONE_REMOTE:=pal-drive:}"
: "${PAL_DRIVE_FOLDER:=PAL}"
: "${PAL_STAGING_ROOT:=${HOME}/pal-cloud-staging/google-drive}"
: "${PAL_STATE_ROOT:=${PAL_STAGING_ROOT}/.state}"

[[ "$PAL_RCLONE_REMOTE" == *: ]] || PAL_RCLONE_REMOTE="${PAL_RCLONE_REMOTE}:"
[[ "$PAL_DRIVE_FOLDER" == "PAL" ]] || die "PAL_DRIVE_FOLDER must be exactly 'PAL'" "$EXIT_CONFIG"
[[ "$PAL_STAGING_ROOT" != "$REPO_ROOT" && "$PAL_STAGING_ROOT" != "$REPO_ROOT/" ]] ||
  die "staging must not be the repository root" "$EXIT_CONFIG"
case "$PAL_STAGING_ROOT/" in
  "$REPO_ROOT"/*) die "staging must remain outside the repository" "$EXIT_CONFIG" ;;
esac

command -v rclone >/dev/null || die "rclone is required" "$EXIT_CONFIG"
command -v python3 >/dev/null || die "python3 is required" "$EXIT_CONFIG"

mkdir -p "$PAL_STATE_ROOT"
chmod 700 "$PAL_STAGING_ROOT" "$PAL_STATE_ROOT"
exec 9>"${PAL_STATE_ROOT}/sync.lock"
flock -n 9 || die "another PAL cloud-sync run is active" 75

export PAL_RCLONE_REMOTE PAL_DRIVE_FOLDER PAL_STAGING_ROOT PAL_STATE_ROOT REPO_ROOT
export PAL_SYNC_VERBOSE="$verbose"
python3 "${SCRIPT_DIR}/process-pal-inbox.py" "$mode"
