# Phase 3D-C3A — Human Storage and Retention Policy Decisions

> **policy_status: APPROVED**
> **wave_0_status: AUTHORIZED**
> **waves_1_through_9_status: NOT AUTHORIZED**

## 1. Authority and scope

Final decision owner: **Dan**

Decision date: **2026-07-31**

This document is authoritative for the Phase 3D-C3 policy decisions recorded below. It supersedes the C3 draft only where this document makes a final policy decision; it does not modify the draft or rewrite earlier historical evidence.

This document authorizes **Wave 0 planning and revalidation activity only**. It does not authorize storage creation, copying, moving, deletion, sanitization, permission changes, encryption changes, staging, committing, or pushing. Approval of a policy, path, standard, or future objective is not authorization to execute the associated action.

## 2. Approved archive architecture

| Archive class | Approved path |
|---|---|
| Active private archive | `/home/dev/pal-private-archive/active/` |
| Restricted legacy archive | `/home/dev/pal-private-archive/legacy/` |

Both archive classes are governed by these controls:

- owner: `dev`
- group: `dev`
- directory permissions: `0700`
- file permissions: `0600`
- agent access: denied by default
- temporary agent read access requires Dan's approval
- agent write and delete access remain prohibited unless separately authorized

Approval of these paths and controls does **not** authorize creating the directories or archives yet.

## 3. Approved transfer policy

Initial execution waves must use copy-first handling in this order:

1. Calculate the source SHA-256.
2. Copy to the approved destination.
3. Calculate the destination SHA-256.
4. Confirm an exact hash match.
5. Validate ownership and permissions.
6. Record the action in the private execution register.
7. Preserve the original until a separate removal decision is authorized.

Direct moves are not authorized during initial execution waves. This policy defines the required method but does not authorize any transfer.

## 4. Encryption decision

- Encryption at rest is not currently satisfied.
- The current drive does not use BitLocker.
- Linux permissions provide access control but not host-level encryption.
- Encrypting the WSL private-archive environment is approved as a future PAL learning and implementation objective.
- The exact encryption method remains unapproved.
- Highly sensitive client or investigative evidence is not approved for this archive until encryption is implemented and tested.
- Archive creation remains unauthorized until a later wave.

No encryption technology is selected by this decision record.

## 5. Approved retention policy

| Record class | Approved retention rule |
|---|---|
| Ordinary active-session logs | Retain for an initial 90 days, then review. |
| Milestone, incident, failure, troubleshooting, or governance-relevant logs | Retain until useful facts are transferred into authoritative documentation and dependencies are closed. |
| Recovery histories and notes | Retain for 90–180 days or until recovery reconstruction is complete. |
| Raw sync logs and manifests | Retain until reconciliation, exception closure, and paired review are complete. |
| Governance and human-decision records | Retain permanently unless explicitly superseded under documented governance. |
| Generated cache artifacts | No retention after reproducibility and diagnostic irrelevance are confirmed. |
| Evidence-bearing or future client records | Require case-specific retention authority. |

A retention period ending triggers review; it does not independently authorize deletion or another disposition action.

## 6. Supplemental active-session logs — D3C1-020-S1

`D3C1-020-S1` is approved as the supplemental inventory group for the 12 July 28–29 active-session logs identified by Phase 3D-C2A.

- It does not modify the original closed G20 baseline.
- The 12 files remain local/private.
- The raw logs are not Git eligible.
- They follow the 90-day review policy.
- Milestone, failure, incident, or meaningful troubleshooting logs may be retained longer under the applicable retention rule.
- They must be inventoried and hashed in a later authorized phase.
- No log contents were reviewed during C3.

This classification does not authorize inventorying, hashing, opening, copying, moving, deleting, or otherwise dispositioning the files during C3A.

## 7. Approved deletion standard for D3C1-030

Before any separately authorized deletion of `D3C1-030`, the operator must:

1. Confirm the exact `.pyc` path.
2. Confirm the corresponding `.py` source exists.
3. Confirm the file is generated and reproducible.
4. Confirm no diagnostic dependency remains.
5. Record the pre-deletion SHA-256.
6. Delete only the exact file.
7. Perform a post-deletion absence check.
8. Record regeneration as the rollback method.

No secure overwrite is required. This decision approves the deletion standard only; it does **not** authorize deletion.

## 8. Approved sanitized-derivative policy

A sanitized derivative is a separately authored public-safe document based on a private raw artifact.

It may preserve:

- workflow;
- governance value;
- technical lessons;
- validated results; and
- educational value.

It must exclude unnecessary:

- private paths;
- usernames;
- identifiers;
- internal filenames;
- externally linked identifiers;
- sensitive security details; and
- unsupported authority or completion claims.

Every sanitized derivative requires:

- factual review;
- privacy review;
- authority review;
- duplication review;
- security review;
- traceability to the raw source; and
- separate staging, commit, and push authorization.

The raw source remains unchanged and private. This policy does not authorize derivative creation or Git promotion.

## 9. Approved execution-register policy

- The raw execution register is private and authoritative.
- A sanitized execution summary is potentially Git eligible after separate human review.
- The raw register must contain exact paths, hashes, timestamps, actions, operator, authority reference, validation results, rollback status, and exceptions.
- The public summary must omit exact private locations and unnecessary sensitive details.
- Final register and summary paths remain unapproved.

Approval of this policy does not authorize creating either record.

## 10. Wave authorization

### Wave 0 — Revalidation and drift detection

Status: **`AUTHORIZED_FOR_EXECUTION`**

Authorized scope:

- confirm all planned source paths still exist;
- recalculate current hashes;
- verify grouped membership;
- inspect Git classification and index state;
- identify new or changed drift; and
- produce one pre-execution revalidation record.

Wave 0 must not:

- create archive directories;
- copy files;
- move files;
- delete files;
- sanitize files;
- inspect sensitive file contents unless separately approved;
- change ownership or permissions;
- implement encryption;
- modify `.gitignore`;
- stage;
- commit;
- push; or
- synchronize to cloud storage.

Wave 0 is authorized by this record but was not executed during C3A.

### Waves 1–9

| Wave | Status |
|---|---|
| Wave 1 | `NOT AUTHORIZED` |
| Wave 2 | `NOT AUTHORIZED` |
| Wave 3 | `NOT AUTHORIZED` |
| Wave 4 | `NOT AUTHORIZED` |
| Wave 5 | `NOT AUTHORIZED` |
| Wave 6 | `NOT AUTHORIZED` |
| Wave 7 | `NOT AUTHORIZED` |
| Wave 8 | `NOT AUTHORIZED` |
| Wave 9 | `NOT AUTHORIZED` |

Authorization of Wave 0 does not imply authorization of any later wave.

## 11. Status summary and C3A execution boundary

- `policy_status: APPROVED`
- `wave_0_status: AUTHORIZED`
- `waves_1_through_9_status: NOT AUTHORIZED`
- `archive_creation_status: NOT AUTHORIZED`
- `encryption_implementation_status: NOT AUTHORIZED`
- `files_copied: 0`
- `files_moved: 0`
- `files_deleted: 0`
- `files_sanitized: 0`
- `permissions_changed: 0`
- `archives_created: 0`
- `files_staged: 0`
- `files_committed: 0`
- `files_pushed: 0`

C3A created this decision record only. No Wave 0 command was executed. No storage or disposition action occurred. Work stops without staging or committing.
