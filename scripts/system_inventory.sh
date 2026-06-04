#!/usr/bin/env bash

set -euo pipefail

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

value_or_unknown() {
  local value="${1:-}"
  if [ -n "$value" ]; then
    printf '%s\n' "$value"
  else
    printf 'unknown\n'
  fi
}

markdown_escape() {
  sed 's/\\/\\\\/g; s/|/\\|/g'
}

print_section_command() {
  local title="$1"
  shift

  printf '\n## %s\n\n' "$title"
  printf '```text\n'
  if "$@" 2>&1; then
    true
  else
    printf 'Command failed: %s\n' "$*"
  fi
  printf '```\n'
}

os_name="unknown"
os_version="unknown"
if [ -r /etc/os-release ]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  os_name="$(value_or_unknown "${NAME:-}")"
  os_version="$(value_or_unknown "${VERSION_ID:-}")"
fi

kernel_name="$(uname -s 2>/dev/null || printf 'unknown')"
kernel_release="$(uname -r 2>/dev/null || printf 'unknown')"
architecture="$(uname -m 2>/dev/null || printf 'unknown')"
hostname_value="$(hostname 2>/dev/null || printf 'unknown')"
snapshot_utc="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

platform="Linux"
if grep -qi microsoft /proc/version 2>/dev/null; then
  platform="WSL2"
fi

repo_root=""
git_branch=""
git_commit=""
git_status=""
tracked_files=""
if command_exists git && git rev-parse --show-toplevel >/dev/null 2>&1; then
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  git_branch="$(git branch --show-current 2>/dev/null || true)"
  git_commit="$(git rev-parse --short HEAD 2>/dev/null || true)"
  git_status="$(git status --short 2>/dev/null || true)"
  tracked_files="$(git ls-files 2>/dev/null | wc -l | awk '{print $1}')"
fi

cpu_count="unknown"
if command_exists nproc; then
  cpu_count="$(nproc 2>/dev/null || printf 'unknown')"
fi

memory_total="unknown"
swap_total="unknown"
if command_exists free; then
  memory_total="$(free -h | awk '/^Mem:/ {print $2}')"
  swap_total="$(free -h | awk '/^Swap:/ {print $2}')"
fi

printf '# System Baseline\n\n'
printf 'Generated at: `%s`\n\n' "$snapshot_utc"

printf '## Host\n\n'
printf '| Item | Value |\n'
printf '| --- | --- |\n'
printf '| Hostname | `%s` |\n' "$(printf '%s' "$hostname_value" | markdown_escape)"
printf '| Platform | `%s` |\n' "$(printf '%s' "$platform" | markdown_escape)"
printf '| OS | `%s %s` |\n' "$(printf '%s' "$os_name" | markdown_escape)" "$(printf '%s' "$os_version" | markdown_escape)"
printf '| Kernel | `%s %s` |\n' "$(printf '%s' "$kernel_name" | markdown_escape)" "$(printf '%s' "$kernel_release" | markdown_escape)"
printf '| Architecture | `%s` |\n' "$(printf '%s' "$architecture" | markdown_escape)"

printf '\n## Compute\n\n'
printf '| Item | Value |\n'
printf '| --- | --- |\n'
printf '| CPU cores available | `%s` |\n' "$(printf '%s' "$cpu_count" | markdown_escape)"
printf '| Memory total | `%s` |\n' "$(printf '%s' "$memory_total" | markdown_escape)"
printf '| Swap total | `%s` |\n' "$(printf '%s' "$swap_total" | markdown_escape)"

printf '\n## Storage\n\n'
if command_exists df; then
  printf '```text\n'
  df -h . 2>&1
  printf '```\n'
else
  printf 'df command not available.\n'
fi

printf '\n## Repository\n\n'
printf '| Item | Value |\n'
printf '| --- | --- |\n'
printf '| Root | `%s` |\n' "$(printf '%s' "${repo_root:-unknown}" | markdown_escape)"
printf '| Branch | `%s` |\n' "$(printf '%s' "${git_branch:-unknown}" | markdown_escape)"
printf '| Commit | `%s` |\n' "$(printf '%s' "${git_commit:-unknown}" | markdown_escape)"
printf '| Tracked files | `%s` |\n' "$(printf '%s' "${tracked_files:-unknown}" | markdown_escape)"

printf '\n### Git Working Tree\n\n'
if [ -n "${git_status:-}" ]; then
  printf '```text\n%s\n```\n' "$git_status"
else
  printf 'No uncommitted changes detected, or Git status unavailable.\n'
fi

printf '\n## Toolchain\n\n'
printf '| Tool | Version |\n'
printf '| --- | --- |\n'
for tool in bash git ssh curl wget python3 node npm docker code codex; do
  if command_exists "$tool"; then
    version="$("$tool" --version 2>/dev/null | head -n 1 || printf 'installed')"
    printf '| `%s` | `%s` |\n' "$tool" "$(printf '%s' "$version" | markdown_escape)"
  else
    printf '| `%s` | not found |\n' "$tool"
  fi
done

printf '\n## Network Summary\n\n'
printf 'This section avoids external exposure claims and does not collect credentials.\n\n'
if command_exists ip; then
  printf '### Interfaces\n\n'
  printf '```text\n'
  ip -brief link 2>&1 || printf 'Interface inventory unavailable or not permitted.\n'
  printf '```\n'
fi

if command_exists ss; then
  printf '\n### Listening Sockets\n\n'
  printf '```text\n'
  ss -tuln 2>&1 || printf 'Listening socket inventory unavailable or not permitted.\n'
  printf '```\n'
else
  printf '\nListening socket inventory unavailable because `ss` was not found.\n'
fi

printf '\n## Package Inventory Summary\n\n'
if command_exists dpkg; then
  package_count="$(dpkg-query -f '${binary:Package}\n' -W 2>/dev/null | wc -l | awk '{print $1}')"
  printf '| Item | Value |\n'
  printf '| --- | --- |\n'
  printf '| Debian packages installed | `%s` |\n' "$package_count"
elif command_exists rpm; then
  package_count="$(rpm -qa 2>/dev/null | wc -l | awk '{print $1}')"
  printf '| Item | Value |\n'
  printf '| --- | --- |\n'
  printf '| RPM packages installed | `%s` |\n' "$package_count"
else
  printf 'No supported package inventory command found.\n'
fi

printf '\n## Security Handling Notes\n\n'
printf -- '- This script does not print environment variables.\n'
printf -- '- This script does not read SSH keys, API keys, shell history, browser profiles, or credential stores.\n'
printf -- '- Review listener output before publishing if the workstation is running sensitive local services.\n'
printf -- '- Regenerate this report after major workstation, toolchain, or network changes.\n'
