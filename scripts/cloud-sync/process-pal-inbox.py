#!/usr/bin/env python3
"""Safe, one-way Google Drive PAL importer.

The program never invokes an rclone delete, sync, move, or bisync operation.
"""

from __future__ import annotations

import datetime as dt
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import shutil
import subprocess
import sys
import tempfile
from typing import Any

REMOTE = os.environ["PAL_RCLONE_REMOTE"]
FOLDER = os.environ["PAL_DRIVE_FOLDER"]
STAGING = Path(os.environ["PAL_STAGING_ROOT"]).resolve()
STATE = Path(os.environ["PAL_STATE_ROOT"]).resolve()
REPO = Path(os.environ["REPO_ROOT"]).resolve()
VERBOSE = os.environ.get("PAL_SYNC_VERBOSE") == "1"
LOG_DIR = REPO / "logs/cloud-sync"
REPORT_DIR = REPO / "reports/sync"
MANIFEST = REPORT_DIR / "pal-drive-manifest.jsonl"
NOW = dt.datetime.now(dt.timezone.utc)
STAMP = NOW.strftime("%Y%m%dT%H%M%SZ")

SENSITIVE_NAMES = {
    ".env", "id_rsa", "id_ed25519", "credentials.json", "rclone.conf",
}
SENSITIVE_SUFFIXES = {".key", ".pem", ".p12", ".pfx"}
GOOGLE_EXPORTS = {
    ".docx": "docx", ".xlsx": "xlsx", ".pptx": "pptx", ".svg": "svg",
}


def safe_rel(value: str) -> Path:
    posix = PurePosixPath(value)
    if posix.is_absolute() or ".." in posix.parts or not posix.parts:
        raise ValueError(f"unsafe source path: {value!r}")
    return Path(*posix.parts)


def run(args: list[str]) -> subprocess.CompletedProcess[str]:
    if VERBOSE:
        print("+", " ".join(args[:2]), "...", file=sys.stderr)
    return subprocess.run(args, check=True, text=True, capture_output=True)


def inventory() -> list[dict[str, Any]]:
    remote_path = f"{REMOTE}{FOLDER}"
    proc = run([
        "rclone", "lsjson", remote_path, "--recursive", "--files-only",
        "--metadata", "--hash",
    ])
    items = json.loads(proc.stdout)
    for item in items:
        safe_rel(item["Path"])
    items.sort(key=lambda x: (x["Path"], x.get("ID", "")))
    return items


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def md5(path: Path) -> str:
    digest = hashlib.md5(usedforsecurity=False)
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def is_sensitive(path: Path) -> bool:
    lowered = {part.lower() for part in path.parts}
    return (
        path.name.lower() in SENSITIVE_NAMES
        or path.suffix.lower() in SENSITIVE_SUFFIXES
        or ".ssh" in lowered
        or "internal-only" in path.name.lower()
        or "secret" in path.name.lower()
        or "credential" in path.name.lower()
    )


def classify(path: Path, item: dict[str, Any]) -> tuple[str, str]:
    if is_sensitive(path):
        return "sensitive/private", "human-review"
    if item.get("Size", 0) == -1 or path.suffix.lower() in {".docx", ".xlsx", ".pptx"}:
        return "material needing conversion", "human-review"
    if path.suffix.lower() in {".jpg", ".jpeg", ".png", ".gif", ".pdf"}:
        return "raw source/reference", "human-review"
    # Repository ingestion policy requires human approval of imported knowledge.
    return "unclear and requiring review", "human-review"


def previous_records() -> list[dict[str, Any]]:
    if not MANIFEST.exists():
        return []
    records = []
    with MANIFEST.open(encoding="utf-8") as stream:
        for line in stream:
            if line.strip():
                records.append(json.loads(line))
    return records


def repo_hashes() -> dict[str, str]:
    """Hash safe tracked files only; never touch untracked credential artifacts."""
    proc = run(["git", "-C", str(REPO), "ls-files", "-z"])
    result: dict[str, str] = {}
    for raw in proc.stdout.split("\0"):
        if not raw:
            continue
        rel = safe_rel(raw)
        if is_sensitive(rel) or rel.parts[0] in {"logs", "reports"}:
            continue
        path = REPO / rel
        if path.is_file():
            result.setdefault(sha256(path), str(rel))
    return result


def selected_export(item: dict[str, Any]) -> str | None:
    if item.get("Size", 0) != -1:
        return None
    return GOOGLE_EXPORTS.get(Path(item["Path"]).suffix.lower(), "docx")


def base_record(item: dict[str, Any]) -> dict[str, Any]:
    rel = safe_rel(item["Path"])
    category, processing = classify(rel, item)
    return {
        "source_path": item["Path"],
        "source_file_id": item.get("ID"),
        "source_modification_time": item.get("ModTime"),
        "source_size": item.get("Size"),
        "source_mime_type": item.get("MimeType"),
        "source_hashes": item.get("Hashes", {}),
        "export_format": selected_export(item),
        "local_staging_path": None,
        "sha256": None,
        "final_destination_path": None,
        "transfer_status": "planned",
        "processing_status": processing,
        "classification": category,
        "synchronization_timestamp": NOW.isoformat(),
        "conflict_status": "none",
    }


def plan(items: list[dict[str, Any]], prior: list[dict[str, Any]]) -> list[dict[str, Any]]:
    by_id = {r.get("source_file_id"): r for r in prior if r.get("source_file_id")}
    output = []
    seen_paths: set[str] = set()
    for item in items:
        rec = base_record(item)
        old = by_id.get(rec["source_file_id"])
        if rec["source_path"] in seen_paths:
            rec["transfer_status"] = "source-path-collision-review"
            rec["conflict_status"] = "same-path-multiple-drive-items"
        elif old and old.get("source_path") != rec["source_path"]:
            rec["transfer_status"] = "moved-or-renamed-review"
        elif old and (
            old.get("source_modification_time") == rec["source_modification_time"]
            and old.get("source_size") == rec["source_size"]
            and old.get("transfer_status") in {"downloaded", "unchanged", "revision-updated"}
        ):
            rec["transfer_status"] = "unchanged"
            rec["sha256"] = old.get("sha256")
            rec["local_staging_path"] = old.get("local_staging_path")
        elif old and old.get("transfer_status") in {
            "downloaded", "unchanged", "revision-updated",
            "moved-or-renamed", "exact-duplicate",
            "exact-duplicate-repository", "conflict-quarantined",
        }:
            rec["transfer_status"] = "changed-revision"
        else:
            rec["transfer_status"] = "new"
        seen_paths.add(rec["source_path"])
        output.append(rec)
    return output


def download(item: dict[str, Any], target: Path) -> None:
    source = f"{REMOTE}{FOLDER}/{item['Path']}"
    args = ["rclone", "copyto", source, str(target), "--metadata", "--no-traverse"]
    export = selected_export(item)
    if export:
        args += ["--drive-export-formats", export]
    run(args)


def set_mtime(path: Path, value: str | None) -> None:
    if not value:
        return
    try:
        timestamp = dt.datetime.fromisoformat(value.replace("Z", "+00:00")).timestamp()
        os.utime(path, (timestamp, timestamp))
    except (ValueError, OSError):
        pass


def execute(items: list[dict[str, Any]], records: list[dict[str, Any]],
            prior: list[dict[str, Any]]) -> list[dict[str, Any]]:
    managed = STAGING / "managed"
    conflicts = STAGING / "conflict-review"
    revisions = STAGING / "revisions"
    review = STAGING / "review-queue"
    for directory in (managed, conflicts, revisions, review, STATE):
        directory.mkdir(parents=True, exist_ok=True)

    prior_by_id = {r.get("source_file_id"): r for r in prior if r.get("source_file_id")}
    known_hashes = {
        r["sha256"]: r for r in prior
        if r.get("sha256") and r.get("local_staging_path")
    }
    tracked_hashes = repo_hashes()
    seen_paths: dict[str, str] = {}
    path_counts: dict[str, int] = {}
    for item in items:
        path_counts[item["Path"]] = path_counts.get(item["Path"], 0) + 1

    for item, rec in zip(items, records, strict=True):
        rel = safe_rel(item["Path"])
        old = prior_by_id.get(rec["source_file_id"])
        if path_counts[rec["source_path"]] > 1:
            expected_md5 = item.get("Hashes", {}).get("md5")
            candidates = [
                managed / rel,
                conflicts / str(rec["source_file_id"] or "no-id") / rel,
            ]
            matched = next(
                (candidate for candidate in candidates
                 if candidate.is_file() and expected_md5 and md5(candidate) == expected_md5),
                None,
            )
            if matched:
                rec["sha256"] = sha256(matched)
                rec["local_staging_path"] = str(matched)
                if conflicts in matched.parents:
                    rec["transfer_status"] = "conflict-quarantined"
                    rec["conflict_status"] = "same-path-different-content"
                    rec["processing_status"] = "conflict"
                else:
                    rec["transfer_status"] = "unchanged"
                known_hashes[rec["sha256"]] = rec
                sidecar = review / (
                    rel.as_posix().replace("/", "__")
                    + f".{rec['source_file_id'] or 'no-id'}.json"
                )
                sidecar.write_text(json.dumps({
                    "source_path": rec["source_path"],
                    "source_file_id": rec["source_file_id"],
                    "sha256": rec["sha256"],
                    "staging_path": rec["local_staging_path"],
                    "classification": rec["classification"],
                    "conflict_status": rec["conflict_status"],
                    "recommended_action": "human review before repository placement",
                }, indent=2) + "\n", encoding="utf-8")
            else:
                rec["transfer_status"] = "conflict-pending-id-specific-download"
                rec["conflict_status"] = "same-path-multiple-drive-items"
                rec["processing_status"] = "conflict"
            continue
        if rec["transfer_status"] == "unchanged":
            continue
        with tempfile.TemporaryDirectory(prefix="pal-import-", dir=STATE) as tempdir:
            incoming = Path(tempdir) / rel.name
            download(item, incoming)
            digest = sha256(incoming)
            rec["sha256"] = digest

            if digest in tracked_hashes:
                rec["transfer_status"] = "exact-duplicate-repository"
                rec["final_destination_path"] = tracked_hashes[digest]
                rec["processing_status"] = "duplicate"
                continue
            if digest in known_hashes:
                duplicate = known_hashes[digest]
                rec["transfer_status"] = (
                    "moved-or-renamed" if old and old.get("source_path") != rec["source_path"]
                    else "exact-duplicate"
                )
                rec["local_staging_path"] = duplicate.get("local_staging_path")
                rec["processing_status"] = "duplicate"
                continue

            target = managed / rel
            path_owner = seen_paths.get(rec["source_path"])
            if path_owner and path_owner != rec["source_file_id"]:
                target = conflicts / str(rec["source_file_id"] or "no-id") / rel
                rec["conflict_status"] = "same-path-different-content"
                rec["transfer_status"] = "conflict-quarantined"
                rec["processing_status"] = "conflict"
            elif target.exists():
                existing_hash = sha256(target)
                if old and old.get("source_file_id") == rec["source_file_id"]:
                    backup = revisions / str(rec["source_file_id"]) / existing_hash / rel.name
                    backup.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(target, backup)
                    rec["transfer_status"] = "revision-updated"
                elif existing_hash == digest:
                    rec["transfer_status"] = "exact-duplicate"
                    rec["local_staging_path"] = str(target)
                    rec["processing_status"] = "duplicate"
                    continue
                else:
                    target = conflicts / str(rec["source_file_id"] or "no-id") / rel
                    rec["conflict_status"] = "same-name-different-content"
                    rec["transfer_status"] = "conflict-quarantined"
                    rec["processing_status"] = "conflict"
            else:
                rec["transfer_status"] = "downloaded"

            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(incoming, target)
            set_mtime(target, rec["source_modification_time"])
            rec["local_staging_path"] = str(target)
            known_hashes[digest] = rec
            seen_paths[rec["source_path"]] = str(rec["source_file_id"])

            # Make review status explicit without duplicating payload bytes.
            sidecar = review / (rel.as_posix().replace("/", "__") + ".json")
            sidecar.parent.mkdir(parents=True, exist_ok=True)
            sidecar.write_text(json.dumps({
                "source_path": rec["source_path"],
                "source_file_id": rec["source_file_id"],
                "sha256": digest,
                "staging_path": rec["local_staging_path"],
                "classification": rec["classification"],
                "recommended_action": "human review before repository placement",
            }, indent=2) + "\n", encoding="utf-8")
    return records


def write_outputs(items: list[dict[str, Any]], records: list[dict[str, Any]],
                  mode: str) -> None:
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    STATE.mkdir(parents=True, exist_ok=True)
    (STATE / "latest-inventory.json").write_text(
        json.dumps(items, indent=2) + "\n", encoding="utf-8")
    (STATE / "latest-plan.json").write_text(
        json.dumps(records, indent=2) + "\n", encoding="utf-8")

    counts: dict[str, int] = {}
    for record in records:
        key = record["transfer_status"]
        counts[key] = counts.get(key, 0) + 1
    report = REPORT_DIR / f"{STAMP}-pal-drive-sync.md"
    lines = [
        "# PAL Google Drive synchronization report", "",
        f"- Mode: `{mode}`",
        f"- Source: `{REMOTE}{FOLDER}/`",
        f"- Timestamp: `{NOW.isoformat()}`",
        f"- Files discovered: {len(items)}",
        f"- Files downloaded: {counts.get('downloaded', 0) + counts.get('revision-updated', 0)}",
        f"- Unchanged files skipped: {counts.get('unchanged', 0)}",
        f"- Exact duplicates skipped: {sum(v for k, v in counts.items() if k.startswith('exact-duplicate'))}",
        f"- Conflicts quarantined: {counts.get('conflict-quarantined', 0)}",
        "- Files automatically placed in repository: 0",
        f"- Files requiring human review: {sum(1 for r in records if r['processing_status'] in {'human-review', 'conflict'})}",
        "", "## Transfer status", "",
    ]
    for key in sorted(counts):
        lines.append(f"- {key}: {counts[key]}")
    lines += [
        "", "## Filesystem changes", "",
        "- External staging and state are under the configured PAL staging root.",
        "- Sanitized manifest/report/log files are under repository logs and reports.",
        "- No cloud files were modified or deleted.",
        "- No repository content was automatically replaced.",
        "", "## Recommended next steps", "",
        "- Review sidecars in the external `review-queue` before placing content in Program Brain.",
        "- Review conflict quarantine items manually; do not choose by filename alone.",
        "- Review sensitive/private classifications outside Program Brain.",
    ]
    report.write_text("\n".join(lines) + "\n", encoding="utf-8")

    with MANIFEST.open("a", encoding="utf-8") as stream:
        for record in records:
            stream.write(json.dumps(record, sort_keys=True) + "\n")
    log = LOG_DIR / f"{STAMP}.log"
    log.write_text(
        f"timestamp={NOW.isoformat()} mode={mode} source={REMOTE}{FOLDER}/ "
        f"discovered={len(items)} errors=0\n", encoding="utf-8")
    print(f"report={report}")
    print(f"manifest={MANIFEST}")
    print("counts=" + json.dumps(counts, sort_keys=True))


def main() -> int:
    mode = sys.argv[1] if len(sys.argv) == 2 else ""
    if mode not in {"inventory-only", "dry-run", "execute"}:
        print("invalid mode", file=sys.stderr)
        return 64
    if STAGING == REPO or REPO in STAGING.parents:
        print("staging must be outside repository", file=sys.stderr)
        return 78
    items = inventory()
    prior = previous_records()
    records = plan(items, prior)
    if mode == "execute":
        records = execute(items, records, prior)
    write_outputs(items, records, mode)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
