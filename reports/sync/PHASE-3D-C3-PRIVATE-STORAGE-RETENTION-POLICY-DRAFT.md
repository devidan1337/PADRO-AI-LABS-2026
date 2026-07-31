# Phase 3D-C3 — Private Storage and Retention Policy Decision Draft

> **policy_status: DRAFT_FOR_HUMAN_REVIEW**
> **execution_status: NOT AUTHORIZED**
> **files_copied: 0**
> **files_moved: 0**
> **files_deleted: 0**
> **files_sanitized: 0**
> **permissions_changed: 0**
> **archives_created: 0**
> **files_staged: 0**
> **files_committed: 0**
> **files_pushed: 0**

## 1. Purpose, authority, and scope

This document is a provisional policy draft for Dan's review. It builds on the Phase 3D-C1 human disposition decisions, the Phase 3D-C2 execution plan, and the Phase 3D-C2A active-session log drift review. It documents proposed controls only. It neither authorizes nor performs transfer, storage, archival, deletion, sanitization, permission changes, encryption changes, synchronization, or Git promotion.

The historical Phase 3D-B baseline and the original closed 24-member G20 classification remain unchanged. Current observations supplement historical records; they do not rewrite them.

## 2. Transfer method

Initial execution waves shall use copy-first handling in this order:

1. Hash the source.
2. Copy it to the approved private destination.
3. Hash the destination.
4. Confirm an exact source-to-destination match.
5. Validate destination ownership and permissions.
6. Record the action in the raw execution register.
7. Preserve the original until a separate removal decision is authorized.

Direct moves are not authorized during initial execution waves. Whether copy-first handling must apply to every later category remains a human decision.

## 3. Active private archive

The active private archive must:

- exist outside the Git repository;
- be owned by `dev`;
- default to directory permissions `0700`;
- default to file permissions `0600`;
- be inaccessible to agents by default;
- require explicit human approval for temporary agent read access;
- prohibit agent write or delete access unless separately authorized; and
- use an exact path that remains **`NOT YET APPROVED`**.

No path is proposed, implied, or created by this draft.

## 4. Restricted legacy archive

The restricted legacy archive must:

- remain outside Git;
- be separate from active operational storage;
- contain records no longer operationally active but still retained for audit, recovery, governance, or historical value;
- use access controls equivalent to or stricter than the active private archive;
- require a separate transition decision before any record changes from active to legacy status; and
- use an exact path that remains **`NOT YET APPROVED`**.

No path is proposed, implied, or created by this draft.

## 5. Encryption and protected transfer

The provisional requirements are:

- The storage device or archive boundary must use encryption at rest.
- Transfers must use local trusted filesystem operations or encrypted transport.
- Backups must preserve confidentiality controls equivalent to those of the primary storage boundary.
- Sensitive future client or investigative material must use a separate encrypted boundary from ordinary PAL artifacts.
- The exact encryption implementation remains **`NOT YET APPROVED`**.

These requirements do not authorize creation, configuration, or use of an encrypted destination.

## 6. Provisional retention classes

All periods below are provisional until Dan approves them.

| Retention class | Provisional rule |
|---|---|
| Ordinary active-session logs | Retain for an initial 90 days, then review. |
| Milestone, incident, failure, troubleshooting, or governance-relevant logs | Retain until incorporated into authoritative documentation and all dependencies are closed. |
| Recovery histories and recovery notes | Retain for 90–180 days, or until recovery reconstruction is complete and useful information has been transferred. |
| Raw sync logs and manifests | Retain until reconciliation, exception closure, and paired review are complete. |
| Governance and human-decision records | Retain permanently unless explicitly superseded under documented governance. |
| Generated cache artifacts | Retain only until reproducibility and diagnostic irrelevance are confirmed; no retention afterward. |
| Evidence-bearing or future client records | No generic PAL retention period applies; case-specific authority and retention rules are required. |

Retention expiry is a review trigger, not automatic deletion authority. Any deletion or lifecycle transition requires its own applicable authorization and recorded validation.

## 7. Supplemental active-session log group

The twelve active-session logs created on July 28–29 are provisionally classified as **`D3C1-020-S1`**.

`D3C1-020-S1` is a supplemental classification label only. It is not a retroactive modification of the Phase 3D-C1 decision record, D3C1-020, or the original closed 24-member G20 baseline. The historical distinction between the original 24 logs and the supplemental 12 must be preserved.

Provisional policy for `D3C1-020-S1`:

- retain the files temporarily local/private;
- treat the raw files as not Git eligible;
- inventory and hash them only in a future authorized phase;
- apply the same diagnostic-retention policy used for the original 24 logs; and
- do not inspect their contents during this phase.

This draft does not inventory, hash, open, search, parse, quote, summarize, copy, move, or otherwise inspect or disposition the twelve logs.

## 8. Deletion standard for D3C1-030

D3C1-030 governs the generated Python bytecode cache candidate. Ordinary deletion is provisionally sufficient for this candidate; specialized overwrite or shredding is not required.

Before any future deletion, the authorized operator must:

1. Confirm the exact path.
2. Confirm that the artifact is generated and reproducible.
3. Confirm that no diagnostic dependency remains.
4. Record the pre-deletion hash.
5. Perform the separately authorized ordinary deletion.
6. Perform and record a post-deletion absence check.
7. Document regeneration from the approved source and runtime as the rollback method.

Deletion remains unauthorized in Phase 3D-C3.

Future sensitive plaintext, investigation evidence, backups, or encrypted containers may require stronger cryptographic-erasure rules. That stronger standard is not required for this generated cache candidate.

## 9. Sanitized derivatives

A sanitized derivative is:

> A separately authored document derived from a raw private artifact that preserves useful workflow, governance, technical, or educational value while excluding sensitive, identifying, machine-specific, externally linked, or security-relevant details.

A sanitized derivative:

- is not the raw artifact with superficial redactions;
- must preserve lineage to the raw source;
- must undergo factual, privacy, authority, duplication, and security review;
- must not replace or modify the raw source; and
- requires separate Git staging, commit, and push authorization.

Derivative drafting, review, and Git promotion are distinct authorization boundaries. This draft creates no sanitized derivative.

## 10. Future raw execution register

The future raw execution register will be the authoritative record of actions actually performed. It must include:

- decision ID;
- source path;
- source hash;
- source size;
- source modification time;
- action performed;
- destination path, where applicable;
- destination hash;
- operator;
- authority reference;
- execution time;
- validation result;
- rollback status; and
- exception notes.

The raw execution register must remain private. A separately authored sanitized execution summary may later be considered for Git. Any public summary must omit exact private paths, sensitive filenames, private identifiers, internal archive locations, and unnecessary security details.

The execution-register location and any sanitized-summary name and Git location remain unapproved.

## 11. Future execution waves

Each future wave requires separate owner authorization. No wave is authorized by this draft.

| Wave | Purpose | Status |
|---|---|---|
| Wave 0 | Revalidation and drift detection | NOT AUTHORIZED |
| Wave 1 | Private storage architecture approval | NOT AUTHORIZED |
| Wave 2 | Paired and grouped-record preservation | NOT AUTHORIZED |
| Wave 3 | Copy and verify private-retention artifacts | NOT AUTHORIZED |
| Wave 4 | Archive approved private artifacts | NOT AUTHORIZED |
| Wave 5 | Delete generated cache candidate | NOT AUTHORIZED |
| Wave 6 | Draft sanitized derivatives | NOT AUTHORIZED |
| Wave 7 | Human review of derivatives | NOT AUTHORIZED |
| Wave 8 | Intentional Git promotion | NOT AUTHORIZED |
| Wave 9 | Post-execution audit | NOT AUTHORIZED |

Authorization of one wave does not imply authorization of another wave or of every item within that wave. Stage, commit, and push remain separate approvals within any future Git-promotion activity.

## 12. Human decisions still required — Dan approval required

Dan must still approve:

- the exact active archive path;
- the exact legacy archive path;
- the encryption implementation;
- the backup location and protection;
- the final retention periods;
- whether the provisional `D3C1-020-S1` label is accepted;
- whether copy-first applies to every category or only initial waves;
- the execution-register location;
- the sanitized-summary naming and Git location; and
- which wave may be authorized first.

Until those decisions are recorded, the corresponding paths, controls, periods, labels, and actions remain unapproved. No choice is made on Dan's behalf.

## 13. Execution boundary and phase result

This phase produced one policy-documentation file only. No disposition or storage action occurred. No artifact was copied, moved, deleted, sanitized, permission-changed, archived, synchronized, encrypted, staged, committed, or pushed. No archive path was invented or created, no log content was inspected, and the Git index was not intentionally changed.

Final status:

- `policy_status: DRAFT_FOR_HUMAN_REVIEW`
- `execution_status: NOT AUTHORIZED`
- `files_copied: 0`
- `files_moved: 0`
- `files_deleted: 0`
- `files_sanitized: 0`
- `permissions_changed: 0`
- `archives_created: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`
