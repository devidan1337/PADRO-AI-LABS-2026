# PAL Google Drive cloud-to-local import

This workflow inventories and imports `pal-drive:PAL/` with one-way copy
semantics. It never invokes `sync`, `bisync`, `move`, or delete operations.
Payload files remain in external staging. Repository placement requires review
under the Program Brain ingestion standard.

## Configuration

Copy `sync-config.example.env` to `~/.config/pal/cloud-sync.env`, keep it outside
the repository, and run `chmod 600 ~/.config/pal/cloud-sync.env`. The defaults
already target `pal-drive:PAL/` and `~/pal-cloud-staging/google-drive/`.

Never place an rclone configuration, OAuth token, key, or real `.env` file in
this repository.

## Commands

```bash
scripts/cloud-sync/sync-pal-drive.sh --inventory-only
scripts/cloud-sync/sync-pal-drive.sh --dry-run
scripts/cloud-sync/sync-pal-drive.sh --execute
```

The processor compares Drive IDs, paths, metadata, and downloaded SHA-256
content. Exact duplicates are not retained twice. Ambiguous same-name content
is quarantined. A changed revision with the same Drive ID is backed up before
its managed staging copy is replaced.

Generated sanitized logs are written to `logs/cloud-sync/`; cumulative
machine-readable records and run reports are written to `reports/sync/`.
Raw payload, revision history, conflicts, review sidecars, locks, and state stay
in external staging.

Google-native Docs, Sheets, Slides, and Drawings are exported by rclone to one
preservation-oriented format: DOCX, XLSX, PPTX, or SVG respectively. The
selected format and source Drive ID are recorded in the manifest.
