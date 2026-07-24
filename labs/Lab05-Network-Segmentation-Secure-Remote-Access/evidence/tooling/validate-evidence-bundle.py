#!/usr/bin/env python3
"""Read-only validator for a future VLAN 30 DNS evidence bundle."""

from __future__ import annotations

import argparse
import hashlib
import json
import mimetypes
import os
from pathlib import Path
import stat
import sys

DIRECTORIES = {"raw", "sanitized", "metadata", "logs"}
TRUTH_STATES = {"PASS", "FAIL", "PARTIAL", "INCONCLUSIVE", "NOT_RUN", "BLOCKED"}
REQUIRED_ENTRY_FIELDS = {
    "schema_version", "run_id", "relative_path", "artifact_role", "capture_state",
    "source_device_role", "capture_timestamp_utc", "tool", "tool_version",
    "command_identifier", "byte_size", "sha256", "file_type",
    "privacy_classification", "test_identifier", "test_status",
    "sanitization_status", "human_reviewer_status", "notes",
}
REQUIRED_MANIFEST_FIELDS = {
    "schema_version", "run_id", "operator", "topology_mode",
    "management_connection_confirmation", "vlan30_connection_confirmation",
    "edge_switch_port_confirmation", "expected_address_classes",
    "observed_address_classes", "configuration_changed",
    "endpoint_vpn_state_changed", "restoration_succeeded",
    "overall_run_status", "artifacts",
}
EXPECTED_ARTIFACT_BASENAMES = {
    "00-RUN-CONTEXT.json", "01-CLIENT-BASELINE.txt",
    "02-ROUTE-AND-DNS-STATE.txt", "03-LOCAL-RESOLVER-UDP.txt",
    "04-LOCAL-RESOLVER-TCP.txt", "05-EXTERNAL-DNS-NEGATIVE-CONTROL.txt",
    "06-VPN-TAILSCALE-STATE-BEFORE.txt", "07-OPNSENSE-DNS-CAPTURE-BEFORE.pcapng",
    "08-VPN-STATE-CHANGE.txt", "09-LOCAL-RESOLVER-RETEST.txt",
    "10-OPNSENSE-DNS-CAPTURE-AFTER.pcapng", "11-VPN-TAILSCALE-STATE-AFTER.txt",
    "12-RESTORATION-VALIDATION.txt", "13-TEST-RESULTS.json",
    "OPERATOR-NOTES.md",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def is_below(child: Path, parent: Path) -> bool:
    try:
        child.resolve().relative_to(parent.resolve())
        return True
    except ValueError:
        return False


def find_repository(start: Path) -> Path | None:
    for candidate in (start, *start.parents):
        if (candidate / ".git").exists():
            return candidate
    configured = os.environ.get("PADRO_REPOSITORY_ROOT")
    return Path(configured).resolve() if configured else None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--evidence-root", required=True, type=Path)
    parser.add_argument("--report", required=True, type=Path,
                        help="New report path outside both repository and evidence root")
    parser.add_argument("--repository-root", type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    root = args.evidence_root.resolve()
    report = args.report.resolve()
    repository = (args.repository_root.resolve() if args.repository_root
                  else find_repository(Path.cwd().resolve()))
    errors: list[str] = []
    warnings: list[str] = []

    if repository and is_below(root, repository):
        raise SystemExit("Refusing an evidence root beneath the Git repository.")
    if repository and is_below(report, repository):
        raise SystemExit("Refusing a validation report beneath the Git repository.")
    if is_below(report, root):
        raise SystemExit("Validation report must be outside the evidence root.")
    if report.exists():
        raise SystemExit("Refusing to overwrite an existing validation report.")
    if not report.parent.is_dir():
        raise SystemExit("Validation report parent must already exist.")
    if not root.is_dir():
        raise SystemExit("Evidence root is not a directory.")

    actual_dirs = {p.name for p in root.iterdir() if p.is_dir() and not p.is_symlink()}
    if actual_dirs != DIRECTORIES:
        errors.append(f"directory boundary mismatch: expected {sorted(DIRECTORIES)}, got {sorted(actual_dirs)}")

    files: dict[str, dict[str, object]] = {}
    for path in root.rglob("*"):
        relative = path.relative_to(root).as_posix()
        if path.is_symlink():
            errors.append(f"symlink detected: {relative}")
            continue
        if path.is_file():
            mode = stat.S_IMODE(path.stat().st_mode)
            files[relative] = {
                "byte_size": path.stat().st_size,
                "sha256": sha256(path),
                "mode": oct(mode),
                "detected_type": mimetypes.guess_type(path.name)[0] or "application/octet-stream",
            }
            if relative.startswith("raw/") and mode & stat.S_IROTH:
                errors.append(f"world-readable raw file: {relative} ({oct(mode)})")

    manifest_path = root / "metadata" / "MANIFEST.json"
    ledger_path = root / "metadata" / "DERIVATION-LEDGER.json"
    manifest = {}
    entries: list[dict[str, object]] = []
    if not manifest_path.is_file():
        errors.append("missing metadata/MANIFEST.json")
    else:
        try:
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            top_missing = REQUIRED_MANIFEST_FIELDS - set(manifest)
            if top_missing:
                errors.append(f"manifest missing top-level fields: {sorted(top_missing)}")
            entries = manifest.get("artifacts", [])
            if not isinstance(entries, list):
                errors.append("manifest artifacts must be a list")
                entries = []
        except (UnicodeDecodeError, json.JSONDecodeError) as exc:
            errors.append(f"invalid manifest: {exc}")

    seen: set[str] = set()
    for entry in entries:
        missing = REQUIRED_ENTRY_FIELDS - set(entry)
        if missing:
            errors.append(f"manifest entry missing fields {sorted(missing)}: {entry.get('relative_path')}")
        relative = str(entry.get("relative_path", ""))
        if relative in seen:
            errors.append(f"duplicate manifest relative path: {relative}")
        seen.add(relative)
        status_value = entry.get("test_status")
        if status_value not in TRUTH_STATES:
            errors.append(f"artifact without valid test status: {relative}")
        if status_value == "PASS" and relative not in files:
            errors.append(f"PASS result without supporting artifact: {relative}")
        if relative in files:
            actual = files[relative]
            if entry.get("sha256") != actual["sha256"]:
                errors.append(f"hash mismatch: {relative}")
            if entry.get("byte_size") != actual["byte_size"]:
                errors.append(f"size mismatch: {relative}")

    represented_names = {Path(path).name for path in seen}
    absent_contract_entries = sorted(EXPECTED_ARTIFACT_BASENAMES - represented_names)
    if absent_contract_entries:
        errors.append(f"expected artifacts absent from manifest: {absent_contract_entries}")

    ignored = {"metadata/MANIFEST.json", "metadata/DERIVATION-LEDGER.json"}
    unexpected = sorted(set(files) - seen - ignored)
    missing_files = sorted(path for path in seen if path not in files)
    if unexpected:
        errors.append(f"unexpected files: {unexpected}")
    if missing_files:
        for relative in missing_files:
            matching = [e for e in entries if e.get("relative_path") == relative]
            if not matching or matching[0].get("test_status") not in {"NOT_RUN", "BLOCKED"}:
                errors.append(f"missing artifact not classified NOT_RUN/BLOCKED: {relative}")

    ledger_entries: list[dict[str, object]] = []
    if not ledger_path.is_file():
        errors.append("missing metadata/DERIVATION-LEDGER.json")
    else:
        try:
            ledger = json.loads(ledger_path.read_text(encoding="utf-8"))
            ledger_entries = ledger.get("derivatives", [])
        except (UnicodeDecodeError, json.JSONDecodeError) as exc:
            errors.append(f"invalid derivation ledger: {exc}")
    for derivative in ledger_entries:
        parent = str(derivative.get("raw_parent_artifact_path", ""))
        child = str(derivative.get("derivative_path", ""))
        if not parent or not derivative.get("raw_parent_sha256"):
            errors.append(f"derivative without raw parent/hash: {child}")
            continue
        if parent not in files:
            errors.append(f"derivative raw parent missing: {parent}")
        elif files[parent]["sha256"] != derivative.get("raw_parent_sha256"):
            errors.append(f"derivative parent hash mismatch: {child}")
        if child not in files:
            errors.append(f"derivative file missing: {child}")
        elif files[child]["sha256"] != derivative.get("derivative_sha256"):
            errors.append(f"derivative hash mismatch: {child}")

    output = {
        "validator_schema_version": "1.0",
        "operation": "read-only",
        "evidence_root": str(root),
        "enumerated_files": files,
        "errors": errors,
        "warnings": warnings,
        "result": "PASS" if not errors else "FAIL",
    }
    temporary = report.with_name(f".{report.name}.tmp")
    if temporary.exists():
        raise SystemExit(f"Refusing existing temporary report: {temporary}")
    temporary.write_text(json.dumps(output, indent=2) + "\n", encoding="utf-8")
    os.replace(temporary, report)
    return 0 if not errors else 1


if __name__ == "__main__":
    sys.exit(main())
