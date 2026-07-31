# Phase 3D-C2 — Disposition Execution Plan

> **planning_status: COMPLETE**
> **execution_status: NOT AUTHORIZED**
> **disposition_actions_executed: 0**
> **files_moved: 0**
> **files_deleted: 0**
> **files_sanitized: 0**
> **files_staged: 0**
> **files_committed: 0**
> **files_pushed: 0**

This is a planning-only control document. Approval of a disposition category is not approval to execute it.

## 1. Purpose and authority

Phase 3D-C1 recorded Dan's human disposition decisions. Phase 3D-C2 translates those decisions into a precise, auditable plan for a possible later execution phase. Dan remains the final authority over destinations, retention, sanitization, deletion, Git promotion, and execution-wave release. This document neither performs nor authorizes execution.

## 2. Source records and precedence

Records used:

1. `reports/sync/PHASE-3D-C1-HUMAN-DECISIONS.md`
2. `reports/sync/PHASE-3D-C1-HUMAN-DISPOSITION-BRIEF.md`
3. `reports/sync/phase-3d-a1-artifact-disposition-draft.json`
4. `reports/sync/PHASE-3D-A1-REPOSITORY-HEALTH-REVIEW.md`
5. `reports/sync/PHASE-3D-A1-RESULT.md`
6. `reports/sync/phase-3d-b-integrity-baseline.json`
7. `reports/sync/PHASE-3D-B-INTEGRITY-BASELINE-REVIEW.md`
8. `reports/sync/PHASE-3D-B-RESULT.md`
9. `reports/sync/PHASE-3D-B-VALIDATION-ADDENDUM.md`

Precedence is: (1) Phase 3D-C1 human decisions; (2) Phase 3D-C1 disposition brief; (3) Phase 3D-A1 inventory and recommendations; (4) Phase 3D-B integrity and validation records; (5) current filesystem observations, used only to identify drift. Current observations do not overwrite historical evidence. Where the earlier recommendation conflicts with C1, the C1 human decision controls.

## 3. Decision summary

| Decision outcome | Count |
|---|---:|
| Approved proposed dispositions | 29 |
| Revised dispositions | 6 |
| Deferred | 0 |
| Rejected | 0 |
| Total records | 35 |

The approved categories are retain privately outside Git, archive privately, delete candidate, temporary paired retention, keep pending another phase, sanitized derivative candidate, and commit after sanitization. Six earlier commit-after-sanitization recommendations were revised to raw-private retention with only an optional separately authored sanitized derivative.

## 4. Primary disposition action matrix

### Matrix conventions and exact membership

- `B-HASH` means: immediately before a future action, compute SHA-256 and compare it with the corresponding Phase 3D-B `artifact_entries[].sha256`; any mismatch stops the action. The later evidence ledger must retain both baseline and pre-action values.
- `VERIFY` means: validate existence/absence as appropriate, hash equality at any destination, size, expected grouped membership, Git state, and ledger completion.
- `RESTORE` means: reverse only from a verified source/destination copy or approved backup; for deletion, preserve or document an approved reproducible regeneration route before acting.
- A repository derivative is distinct from its raw source. No raw artifact in this inventory is approved for direct commit.
- Group aliases below have exact, closed membership for this plan. Broad filesystem globs are labels, not authority to add new files.

| Alias | Exact paths governed by the C1 decision |
|---|---|
| G08 | `reports/sync/PHASE-3B-R-PROMOTION-RESULT-2026-07-23.md`<br>`reports/sync/phase-3b-r-promotion-ledger.json` |
| G15 | `reports/sync/PHASE-3C2B-R-RESULT-2026-07-23.md`<br>`reports/sync/phase-3c2b-r-promotion-ledger.json` |
| G20 | `logs/2026-06-06-active-session-163122.log`<br>`logs/2026-06-07-active-session-161109.log`<br>`logs/2026-06-07-active-session-163134.log`<br>`logs/2026-06-07-active-session-164358.log`<br>`logs/2026-06-07-active-session-165345.log`<br>`logs/2026-06-07-active-session-185427.log`<br>`logs/2026-06-07-active-session-190926.log`<br>`logs/2026-06-07-active-session-192248.log`<br>`logs/2026-06-07-active-session-192811.log`<br>`logs/2026-06-07-active-session-194011.log`<br>`logs/2026-06-07-active-session-194155.log`<br>`logs/2026-06-11-active-session-205250.log`<br>`logs/2026-07-16-active-session-090807.log`<br>`logs/2026-07-16-active-session-090839.log`<br>`logs/2026-07-18-active-session-165309.log`<br>`logs/2026-07-18-active-session-165317.log`<br>`logs/2026-07-23-active-session-184427.log`<br>`logs/2026-07-23-active-session-190526.log`<br>`logs/2026-07-23-active-session-204231.log`<br>`logs/2026-07-23-active-session-204451.log`<br>`logs/2026-07-23-active-session-204629.log`<br>`logs/2026-07-23-active-session-204913.log`<br>`logs/2026-07-24-active-session-000253.log`<br>`logs/2026-07-24-active-session-101602.log` |
| G21 | `logs/cloud-sync/20260724T001829Z.log`<br>`logs/cloud-sync/20260724T002250Z.log`<br>`logs/cloud-sync/20260724T002353Z.log`<br>`logs/cloud-sync/20260724T002534Z.log`<br>`logs/cloud-sync/20260724T003304Z.log`<br>`logs/cloud-sync/20260724T003619Z.log` |
| G22 | `reports/sync/20260724T001829Z-pal-drive-sync.md`<br>`reports/sync/20260724T002250Z-pal-drive-sync.md`<br>`reports/sync/20260724T002353Z-pal-drive-sync.md`<br>`reports/sync/20260724T002534Z-pal-drive-sync.md`<br>`reports/sync/20260724T003304Z-pal-drive-sync.md`<br>`reports/sync/20260724T003619Z-pal-drive-sync.md` |
| G23 | `reports/sync/PAL-INGESTION-PLACEMENT-PLAN-2026-07-23.md`<br>`reports/sync/pal-ingestion-placement-plan.json` |
| G24 | `reports/sync/PHASE-3A-DRY-RUN-2026-07-23.md`<br>`reports/sync/PHASE-3A-PLACEMENT-RESULT-2026-07-23.md`<br>`reports/sync/phase-3a-placement-ledger.json`<br>`reports/sync/phase-3a-preflight.json` |
| G25 | `reports/sync/phase-3b-conversion-ledger.json`<br>`reports/sync/phase-3b-preflight.json`<br>`reports/sync/phase-3b-r-preflight.json` |
| G26 | `reports/sync/phase-3c1-evidence-inventory.json`<br>`reports/sync/phase-3c1-preflight.json` |
| G27 | `reports/sync/phase-3c2a-candidate-inventory.json`<br>`reports/sync/phase-3c2a-preflight.json` |
| G28 | `reports/sync/phase-3c2b-artifact-contract.json`<br>`reports/sync/phase-3c2b-preflight.json`<br>`reports/sync/phase-3c2b-r-preflight.json` |
| G29 | `reports/sync/phase-3c2c1-preflight.json`<br>`reports/sync/phase-3c2c1-readiness-matrix.json` |
| G30 | `scripts/cloud-sync/__pycache__/process-pal-inbox.cpython-314.pyc` |

| Decision ID | Current artifact path or grouped paths | Artifact type | Human-approved disposition | Planned future action | Proposed destination class | Execution prerequisites | Sensitivity/privacy concern | Paired/grouped dependencies | Required pre-action hash | Required post-action validation | Rollback method | Git eligibility | Current execution authorization | Blocking condition | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| D3C1-001 | `recovery-bash-history-last-500.txt` | Command-history text | Retain privately outside Git | After destination approval, preserve raw privately; later retention review | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED` | Dan approves storage, encryption, access, copy/move, retention | Highly sensitive commands, secrets, paths, hosts | None | `B-HASH` | `VERIFY`; raw absent from index | `RESTORE` from verified private copy | Raw: never; derivative: separate decision | NOT AUTHORIZED | Destination/policy approval; drift revalidation | Never sanitize in place |
| D3C1-002 | `recovery-git-summary.txt` | Git recovery summary | Archive privately | Preserve active, later transition to legacy | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`, then `PRIVATE_LEGACY_ARCHIVE — PATH NOT YET APPROVED` | Storage and lifecycle approvals | Internal repository recovery metadata | Lifecycle must be consistent with the recovery-timeline record | `B-HASH` | `VERIFY` at each transition | `RESTORE` from prior verified tier | Raw: no; minimal derivative only by new decision | NOT AUTHORIZED | Both destinations and lifecycle policy unapproved | Deletion needs separate decision |
| D3C1-003 | `recovery-git-timeline.txt` | Git recovery timeline | Archive privately | Preserve active, later transition to legacy | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`, then `PRIVATE_LEGACY_ARCHIVE — PATH NOT YET APPROVED` | Storage and lifecycle approvals | Sensitive internal chronology/metadata | Lifecycle must be consistent with the recovery-summary record | `B-HASH` | `VERIFY` at each transition | `RESTORE` from prior verified tier | Raw: no; minimal derivative only by new decision | NOT AUTHORIZED | Both destinations and lifecycle policy unapproved | Deletion needs separate decision |
| D3C1-004 | `recovery-history-last-300.txt` | Command-history text | Retain privately outside Git | Preserve raw privately; later retention review | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED` | Storage, encryption, access, copy/move, and retention approvals | Highly sensitive commands, identifiers, secrets | None | `B-HASH` | `VERIFY`; raw absent from index | `RESTORE` from verified private copy | Raw: never | NOT AUTHORIZED | Destination/policy approval; drift revalidation | Never sanitize in place |
| D3C1-005 | `recovery/RECENT-INPUT-RECOVERY.md` | Recovery narrative | Retain privately outside Git | Preserve raw privately while sole-source value is assessed | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED` | Destination, sole-source, access, retention approvals | Highly sensitive recovered input/context | None | `B-HASH` | `VERIFY`; raw absent from index | `RESTORE` from verified private copy | Raw: never | NOT AUTHORIZED | Sole-source and storage decisions | Derivative requires separate exhaustive review |
| D3C1-006 | `labs/Lab05-Network-Segmentation-Secure-Remote-Access/evidence/2026-07-22-23-network-checkpoint/README.phase-3b-review.md` | Historical evidence-index review candidate | Keep pending another phase | Preserve unchanged pending item 41 authority/custody decision | `CURRENT LOCATION — TEMPORARY RETENTION` | Item 41 and evidence-custody review | Potential private network evidence; unsupported authority | Item 41 boundary | `B-HASH` | Unchanged hash/status; no Git promotion | `RESTORE` from approved backup if later action changes it | Not currently eligible | NOT AUTHORIZED | Item 41 unresolved | Preserve exactly `HISTORICAL_NARRATIVE_UNVERIFIED`; do not resolve/reclassify |
| D3C1-007 | `reports/sync/PHASE-3B-DOCX-ANALYSIS-2026-07-23.md` | Phase analysis report | Commit after sanitization | Author separate Git-ready governance summary | `REPOSITORY SANITIZED-DERIVATIVE LOCATION — NOT YET APPROVED` | Factual/privacy/authority/duplication review and commit approval | Identifiers, paths, unsupported claims, evidence handling | Phase 3 reconciliation | `B-HASH` before derivative comparison | Lineage/diff review; raw untracked/private; derivative checks | Remove derivative from index/worktree; raw unchanged | Derivative only after approval | NOT AUTHORIZED | Review, name, location, commit grouping unapproved | Current raw file not approved for direct commit |
| D3C1-008 | G08 (2 exact paths) | Paired promotion result and ledger | Sanitized derivative candidate | Retain raw pair privately; separately author derivative | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`; derivative location not approved | Pair, storage, factual/privacy/authority/duplication reviews | Rollback paths, identifiers, hashes, unsupported claims | Both G08 members inseparable | `B-HASH` for both | Pair/hash verification; derivative-to-both comparison | Restore pair; remove unapproved derivative | Raw: never; derivative: later consideration | NOT AUTHORIZED | Private destination and derivative approvals | No derivative creation in C2 |
| D3C1-009 | `reports/sync/PHASE-3B-RESULT-2026-07-23.md` | Phase result report | Commit after sanitization | Author sanitized boundary/result derivative | `REPOSITORY SANITIZED-DERIVATIVE LOCATION — NOT YET APPROVED` | Five-part review and commit approval | Paths, hashes, network facts, rollback; item 41 overstatement | Phase 3/item 41 records | `B-HASH` | Lineage/diff; raw remains private/untracked | Remove derivative; preserve raw | Derivative only | NOT AUTHORIZED | Reviews and location unapproved | Preserve item 41 boundary |
| D3C1-010 | `reports/sync/PHASE-3C1-EVIDENCE-DISCOVERY-2026-07-23.md` | Evidence-discovery report | Commit after sanitization | Author sanitized discovery-boundary derivative | `REPOSITORY SANITIZED-DERIVATIVE LOCATION — NOT YET APPROVED` | Five-part review and commit approval | Evidence identities, infrastructure details, implied verification | Item 41 evidence chain | `B-HASH` | Lineage/diff and wording review | Remove derivative; preserve raw | Derivative only | NOT AUTHORIZED | Item 41 and review approvals | Preserve exactly `HISTORICAL_NARRATIVE_UNVERIFIED` |
| D3C1-011 | `reports/sync/PHASE-3C1-RESULT-2026-07-23.md` | Phase result report | Commit after sanitization | Author minimal sanitized non-promotion result | `REPOSITORY SANITIZED-DERIVATIVE LOCATION — NOT YET APPROVED` | Five-part review and commit approval | Identifiers, source locations, search overinterpretation | Item 41 evidence chain | `B-HASH` | Lineage/diff and uncertainty review | Remove derivative; preserve raw | Derivative only | NOT AUTHORIZED | Item 41 and review approvals | Preserve exact item 41 boundary |
| D3C1-012 | `reports/sync/PHASE-3C2A-LOCAL-EVIDENCE-SEARCH-2026-07-23.md` | Local evidence-search report | Commit after sanitization | Author generalized custody/search-method derivative | `REPOSITORY SANITIZED-DERIVATIVE LOCATION — NOT YET APPROVED` | Five-part review and commit approval | Local paths, identifiers, network facts, candidate details | Item 41/candidate custody decisions | `B-HASH` | Lineage/diff; locations removed; claims bounded | Remove derivative; preserve raw | Derivative only | NOT AUTHORIZED | Custody and review approvals | Raw remains private |
| D3C1-013 | `reports/sync/PHASE-3C2A-RESULT-2026-07-23.md` | Phase result report | Commit after sanitization | Author sanitized limitations/result derivative | `REPOSITORY SANITIZED-DERIVATIVE LOCATION — NOT YET APPROVED` | Five-part review and commit approval | Evidence metadata; implied historical custody/PASS | Item 41/candidate custody decisions | `B-HASH` | Lineage/diff; historical limitations retained | Remove derivative; preserve raw | Derivative only | NOT AUTHORIZED | Item 41 and review approvals | Unsupported historical PASS claims remain unsupported |
| D3C1-014 | `reports/sync/PHASE-3C2B-EVIDENCE-REGENERATION-DESIGN-2026-07-23.md` | Evidence-regeneration design | Commit after sanitization | Author safe architecture/design derivative | `REPOSITORY SANITIZED-DERIVATIVE LOCATION — NOT YET APPROVED` | Five-part review; tracked-asset reconciliation; commit approval | Defensive architecture, paths, identifiers, new-run/historical confusion | Authoritative tooling | `B-HASH` | Lineage/diff; security and duplication validation | Remove derivative; preserve raw | Derivative only | NOT AUTHORIZED | Tooling authority and review approvals | New run must not validate historical item 41 |
| D3C1-015 | G15 (2 exact paths) | Paired promotion result and ledger | Sanitized derivative candidate | Retain raw pair privately; separately author derivative | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`; derivative location not approved | Pair, storage, factual/privacy/authority/duplication reviews | Hashes, rollback paths, technical disclosure, unsupported claims | Both G15 members and promoted assets | `B-HASH` for both | Pair/hash and derivative-to-both comparison | Restore pair; remove derivative | Raw: never; derivative: later consideration | NOT AUTHORIZED | Private destination and derivative approvals | Preserve item 41 non-promotion |
| D3C1-016 | `reports/sync/PHASE-3C2B-RESULT-2026-07-23.md` | Phase result report | Commit after sanitization | Author rationalized design/result derivative | `REPOSITORY SANITIZED-DERIVATIVE LOCATION — NOT YET APPROVED` | Five-part review, overlap reconciliation, commit approval | Duplicate/conflicting narratives and security details | Regeneration design, G15, and tracked assets | `B-HASH` | Lineage/diff; duplication and security review | Remove derivative; preserve raw | Derivative only | NOT AUTHORIZED | Authority/duplication reviews | Current raw not direct-commit approved |
| D3C1-017 | `reports/sync/PHASE-3C2C1-READINESS-REHEARSAL-2026-07-24.md` | Readiness rehearsal report | Keep pending another phase | Retain until new-identity evidence-run decision | `CURRENT LOCATION — TEMPORARY RETENTION` | Future evidence-run phase closes readiness gaps | Security preparation and rehearsal/execution confusion | Readiness result and G29 | `B-HASH` | Unchanged; future phase linkage verified | `RESTORE`; no action meanwhile | Potential derivative after review | NOT AUTHORIZED | Evidence run not authorized | Retention: local, grouped context |
| D3C1-018 | `reports/sync/PHASE-3C2C1-RESULT-2026-07-24.md` | Readiness result report | Keep pending another phase | Retain with rehearsal until future-run decision | `CURRENT LOCATION — TEMPORARY RETENTION` | Future evidence-run phase decision | Could imply current readiness/completed collection | Readiness rehearsal and G29 | `B-HASH` | Unchanged; no historical-verification implication | `RESTORE`; no action meanwhile | Potential derivative after review | NOT AUTHORIZED | Evidence run not authorized | Retention: local, grouped context |
| D3C1-019 | `reports/sync/pal-drive-manifest.jsonl` | External-system sync manifest | Retain privately outside Git | Preserve under private sync audit/recovery policy | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED` | Storage, access, encryption, retention, copy/move approvals | External IDs, names, hierarchy, sync metadata | Raw-log and readable-report sync groups | `B-HASH` | `VERIFY`; raw absent from index | `RESTORE` from verified private copy | Raw: never | NOT AUTHORIZED | Private architecture and policy | No cloud synchronization authorized |
| D3C1-020 | G20 (24 exact baseline paths) | Active-session log group | Keep pending another phase | Retain closed baseline set pending diagnostic-retention policy | `CURRENT LOCATION — TEMPORARY RETENTION` | Resolve drift; approve log retention and diagnostic closure | Sensitive operational logs; content not inspected | All 24 baseline members together; 12 new matches excluded pending review | `B-HASH` for all; one known mismatch stops execution | Exact 24-member reconciliation and hash validation | `RESTORE`; no action meanwhile | Raw: never | NOT AUTHORIZED | Inventory/hash drift; diagnostic policy open | Local/private temporary retention; broad glob is not membership authority |
| D3C1-021 | G21 (6 exact paths) | Raw cloud-sync log group | Temporary paired retention | Preserve each log with timestamp-matched G22 report | `CURRENT LOCATION — TEMPORARY RETENTION` | Pair audit and sync-retention decision | Sensitive external-sync operational logs | Six one-to-one G21↔G22 timestamp pairs | `B-HASH` for all | Six complete pair checks; raw logs absent from Git | Restore complete affected pair | Raw logs: never | NOT AUTHORIZED | Paired audit/retention unresolved | No cloud sync authorized |
| D3C1-022 | G22 (6 exact paths) | Human-readable sync report group | Temporary paired retention | Preserve each report with timestamp-matched G21 log | `CURRENT LOCATION — TEMPORARY RETENTION` | Pair audit and sync-retention decision | External identifiers, paths, filenames | Six one-to-one G22↔G21 timestamp pairs | `B-HASH` for all | Six complete pair checks; Git state checked | Restore complete affected pair | Raw reports not currently eligible; derivative possible later | NOT AUTHORIZED | Paired audit/retention unresolved | No partial disposition |
| D3C1-023 | G23 (2 exact paths) | PAL ingestion planning pair | **Revised:** raw-private; optional sanitized derivative | Preserve both raw controls privately; optionally author minimal summary | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`; derivative location not approved | Destination plus factual/privacy/authority/duplication and commit approvals | External hierarchy, IDs, locations, stale placement plans | Both G23 members together | `B-HASH` for both | Pair/hash; derivative lineage; raw absent from Git | Restore pair; remove derivative | Raw: never; derivative only later | NOT AUTHORIZED | Storage/review approvals | Original recommendation revised |
| D3C1-024 | G24 (4 exact paths) | Phase 3A placement control group | **Revised:** raw-private; optional sanitized derivative | Preserve raw group; optionally author minimal provenance summary | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`; derivative location not approved | Destination, group and five-part review approvals | IDs, paths, hashes, external details, claims | All four G24 members | `B-HASH` for all | Four-member/hash and lineage validation | Restore group; remove derivative | Raw: never; derivative only later | NOT AUTHORIZED | Storage/review approvals | Original recommendation revised |
| D3C1-025 | G25 (3 exact paths) | Phase 3B control JSON group | **Revised:** raw-private; optional sanitized derivative | Preserve raw controls; optionally author minimal provenance summary | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`; derivative location not approved | Destination, group and five-part review approvals | Hashes, paths, IDs, rollback, item 41 authority | All three G25 members | `B-HASH` for all | Group/hash; item 41 and lineage review | Restore group; remove derivative | Raw: never; derivative only later | NOT AUTHORIZED | Storage/review approvals | Raw JSON is not a commit candidate |
| D3C1-026 | G26 (2 exact paths) | Phase 3C1 discovery JSON pair | **Revised:** raw-private; optional sanitized derivative | Preserve raw pair; optionally author minimal boundary summary | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`; derivative location not approved | Destination, group and five-part review approvals | Private evidence identities; implied verification | Both G26 members; item 41 chain | `B-HASH` for both | Pair/hash; uncertainty and lineage review | Restore pair; remove derivative | Raw: never; derivative only later | NOT AUTHORIZED | Item 41/storage/review approvals | Preserve `HISTORICAL_NARRATIVE_UNVERIFIED` |
| D3C1-027 | G27 (2 exact paths) | Phase 3C2A search JSON pair | **Revised:** raw-private; optional sanitized derivative | Preserve raw pair; optionally author minimal custody summary | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`; derivative location not approved | Destination, custody and five-part review approvals | Private locations/evidence metadata; implied custody | Both G27 members | `B-HASH` for both | Pair/hash; uncertainty and lineage review | Restore pair; remove derivative | Raw: never; derivative only later | NOT AUTHORIZED | Custody/storage/review approvals | Original recommendation revised |
| D3C1-028 | G28 (3 exact paths) | Phase 3C2B contract/preflight group | **Revised:** raw-private; optional sanitized derivative | Preserve raw group; optionally author minimal control summary | `PRIVATE_ACTIVE_ARCHIVE — PATH NOT YET APPROVED`; derivative location not approved | Destination, tracked-asset reconciliation, five-part reviews | Paths, hashes, schemas, defensive architecture | All three G28 members and tracked assets | `B-HASH` for all | Group/hash; security, duplication, lineage review | Restore group; remove derivative | Raw: never; derivative only later | NOT AUTHORIZED | Storage/authority/review approvals | Original recommendation revised |
| D3C1-029 | G29 (2 exact paths) | Readiness JSON pair | Keep pending another phase | Retain pair through next evidence-run decision | `CURRENT LOCATION — TEMPORARY RETENTION` | Next evidence-run phase closes gaps | Security preparation; execution implication | Both G29 members with readiness rehearsal/result reports | `B-HASH` for both | Pair/hash; future phase linkage | `RESTORE`; no action meanwhile | Not currently eligible; later derivative possible | NOT AUTHORIZED | Evidence run not authorized | Local/grouped temporary retention |
| D3C1-030 | G30 (1 exact path) | Generated Python bytecode cache | Delete candidate | Delete only after all deletion gates pass | `DELETION — NO DESTINATION` | Exact path; reproducibility; no diagnostics; hash; Dan deletion approval; regeneration documented | Generated executable derivative may embed path/version metadata | One-member group must be confirmed exactly | `B-HASH` | Absence check; source remains; regeneration test/procedure recorded; ledger | Regenerate from approved source/runtime or restore approved backup | Never | NOT AUTHORIZED | Deletion authorization and diagnostic closure | Do not delete in this phase |
| D3C1-031 | `reports/sync/phase-3d-a1-preflight.json` | Phase 3D-A1 draft control | Keep pending another phase | Retain through Phase 3/supervisor disposition | `CURRENT LOCATION — TEMPORARY RETENTION` | Phase 3D governance closure and human review | Local paths and premature authority | Complete five-record Phase 3D-A1 draft set | `B-HASH` | Set completeness/hash/Git status | `RESTORE`; no action meanwhile | Repository-eligible only after later review | NOT AUTHORIZED | Phase 3D review open | Local temporary retention |
| D3C1-032 | `reports/sync/phase-3d-a1-artifact-disposition-draft.json` | Consolidated draft inventory | Keep pending another phase | Retain until all recommendations are accepted/rejected/superseded | `CURRENT LOCATION — TEMPORARY RETENTION` | Phase 3D governance closure | Sensitive categories; draft mistaken as authority | Phase 3D-A1 draft set | `B-HASH` | Completeness/hash/Git state | `RESTORE`; no action meanwhile | Repository-eligible only after later review | NOT AUTHORIZED | Recommendations not fully superseded by execution record | Local temporary retention |
| D3C1-033 | `reports/sync/PHASE-3D-A1-REPOSITORY-HEALTH-REVIEW.md` | Draft analytical report | Keep pending another phase | Retain through supervisor/Phase 3 review | `CURRENT LOCATION — TEMPORARY RETENTION` | Human factual/privacy review | Draft judgments/internal governance | Phase 3D-A1 draft set | `B-HASH` | Hash, set, authority labeling | `RESTORE`; no action meanwhile | Repository-eligible after approval | NOT AUTHORIZED | Supervisor review open | Local temporary retention |
| D3C1-034 | `reports/sync/PHASE-3D-A1-RESULT.md` | Draft result report | Keep pending another phase | Retain with complete A1 draft set | `CURRENT LOCATION — TEMPORARY RETENTION` | Phase 3/supervisor acceptance | Could imply acceptance/authority | Phase 3D-A1 draft set | `B-HASH` | Hash, set, authority labeling | `RESTORE`; no action meanwhile | Repository-eligible after approval | NOT AUTHORIZED | Supervisor review open | Local temporary retention |
| D3C1-035 | `labs/Lab05-Network-Segmentation-Secure-Remote-Access/DELIVERABLE-MAP.phase-3d-review.md` | Draft Lab 05 deliverable map | Keep pending another phase | Retain until Lab 05 authority/filename reconciliation | `CURRENT LOCATION — TEMPORARY RETENTION` | Lab 05 phase/policy closes filename and authority questions | Draft mistaken for authoritative index/roadmap | Phase 3D-A1 set; Lab 05 deliverables | `B-HASH` | Hash; mapping/authority/factual review | `RESTORE`; no action meanwhile | Repository-eligible after Lab 05 review | NOT AUTHORIZED | Lab 05 authority unresolved | Local/repository-eligible temporary retention |

## 5. Private-retention plan

The four raw artifacts governed by D3C1-001, D3C1-004, D3C1-005, and D3C1-019 must remain outside Git. A later operator may act only after Dan approves an exact private-storage destination, encryption, access controls, retention, and copy-versus-move method. The sequence would be pre-hash, verified transfer, destination hash/size validation, source-handling decision, Git absence check, and ledger entry. No destination exists by implication, and no movement is authorized here.

## 6. Private-archive plan

D3C1-002 and D3C1-003 share this lifecycle concept:

1. A private active archive while operationally relevant.
2. A restricted private legacy archive after the active recovery, audit, or governance period.
3. Deletion only through another explicit decision.

Dan must approve both exact locations and each lifecycle transition. Neither archive is created by this plan.

## 7. Delete-candidate plan

D3C1-030 governs exactly one generated cache member: `scripts/cloud-sync/__pycache__/process-pal-inbox.cpython-314.pyc`. Before deletion, a later phase must confirm the exact path, confirm it is interpreter-generated and reproducible from an approved source/runtime, confirm no diagnostic dependency remains, record a pre-deletion SHA-256, obtain explicit deletion authorization, define rollback/regeneration, and perform a post-deletion absence check. This plan does not delete it.

## 8. Paired synchronization-retention plan

| Raw log (not Git eligible) | Human-readable report |
|---|---|
| `logs/cloud-sync/20260724T001829Z.log` | `reports/sync/20260724T001829Z-pal-drive-sync.md` |
| `logs/cloud-sync/20260724T002250Z.log` | `reports/sync/20260724T002250Z-pal-drive-sync.md` |
| `logs/cloud-sync/20260724T002353Z.log` | `reports/sync/20260724T002353Z-pal-drive-sync.md` |
| `logs/cloud-sync/20260724T002534Z.log` | `reports/sync/20260724T002534Z-pal-drive-sync.md` |
| `logs/cloud-sync/20260724T003304Z.log` | `reports/sync/20260724T003304Z-pal-drive-sync.md` |
| `logs/cloud-sync/20260724T003619Z.log` | `reports/sync/20260724T003619Z-pal-drive-sync.md` |

All six timestamp joins are complete and unambiguous in the C1 inventory. Preserve each pair together; do not partially disposition either group. Current metadata observation found no unmatched member in these two closed six-member sets. Raw logs are never Git eligible.

## 9. Pending-phase dependency plan

| Record | Unresolved dependency | Closing phase/policy | Evidence needed later | Temporary-retention mode |
|---|---|---|---|---|
| D3C1-006 | Item 41 authority and custody | Explicit item 41 evidence-governance decision | Authoritative custody, factual/privacy review; keep `HISTORICAL_NARRATIVE_UNVERIFIED` | Local/private; not Git eligible now |
| D3C1-017 | Future new-identity run readiness | Authorized evidence-run phase | Closed readiness gaps and explicit run/non-run decision | Local with D3C1-018/029 |
| D3C1-018 | Rehearsal outcome vs later execution | Authorized evidence-run phase | Future-phase outcome and preserved no-historical-verification boundary | Local with D3C1-017/029 |
| D3C1-020 | Diagnostic need and log-retention limits; inventory drift | Private diagnostic-retention policy and drift review | Closed 24-member inventory, hashes, retention period, diagnostic owner sign-off | Private/local grouped; raw never Git eligible |
| D3C1-029 | Machine-readable readiness gaps | Authorized evidence-run phase | Updated readiness assessment and pair reconciliation | Local paired/grouped; later derivative possible |
| D3C1-031 | A1 control authority | Phase 3D/supervisor governance closure | Factual/privacy review and supersession mapping | Local; repository-eligible only later |
| D3C1-032 | Recommendations not fully executed/superseded | Phase 3D execution/audit closure | Decision-to-execution reconciliation | Local; repository-eligible only later |
| D3C1-033 | Draft health findings | Phase 3D/supervisor review | Factual/privacy acceptance | Local; repository-eligible only later |
| D3C1-034 | Draft result acceptance | Phase 3D/supervisor review | Authority/acceptance evidence | Local; repository-eligible only later |
| D3C1-035 | Lab 05 authority and filenames | Lab 05 reconciliation phase/policy | Approved deliverable map, duplication and gap review | Local; repository-eligible only later |

## 10. Sanitized-derivative candidate plan

D3C1-008 and D3C1-015 each govern a raw two-member promotion control set. Preserve each complete raw pair privately. Only a separately authored derivative may later be proposed. It must pass factual, privacy, authority, duplication, and lineage review; receive human content approval; and receive separate staging and commit authorization. The review must compare the derivative with both raw members and ensure unsupported claims, internal paths, identifiers, hashes, rollback details, and item 41 implications are handled correctly. No derivative is created here.

## 11. Commit-after-sanitization plan

| Record | Raw source | Sensitive/machine-specific content and sanitization | Proposed Git-ready derivative | Review/comparison/raw treatment |
|---|---|---|---|---|
| D3C1-007 | `PHASE-3B-DOCX-ANALYSIS-2026-07-23.md` | Private IDs/paths, unsupported claims, evidence handling | Bounded governance analysis | Five-part human review; line-by-line source comparison; raw remains private |
| D3C1-009 | `PHASE-3B-RESULT-2026-07-23.md` | Paths, hashes, network facts, rollback, item 41 claims | Bounded result summary | Five-part review; compare to raw; preserve item 41 boundary; raw private |
| D3C1-010 | `PHASE-3C1-EVIDENCE-DISCOVERY-2026-07-23.md` | Evidence identities/infrastructure and verification implications | Sanitized discovery boundary | Five-part review; compare to raw; preserve `HISTORICAL_NARRATIVE_UNVERIFIED`; raw private |
| D3C1-011 | `PHASE-3C1-RESULT-2026-07-23.md` | IDs, source locations, overinterpretation | Minimal non-promotion result | Five-part review; compare to raw; preserve exact item 41 boundary; raw private |
| D3C1-012 | `PHASE-3C2A-LOCAL-EVIDENCE-SEARCH-2026-07-23.md` | Local paths, network facts, candidate details | Generalized custody/search-method record | Five-part review; compare to raw; raw private |
| D3C1-013 | `PHASE-3C2A-RESULT-2026-07-23.md` | Evidence metadata and implied historical custody/PASS | Sanitized limitations/result | Five-part review; compare to raw; unsupported historical PASS stays unsupported; raw private |
| D3C1-014 | `PHASE-3C2B-EVIDENCE-REGENERATION-DESIGN-2026-07-23.md` | Defensive architecture, paths/IDs, historical/new-run confusion | Safe regeneration architecture | Five-part and security review; compare to raw/tracked assets; raw private |
| D3C1-016 | `PHASE-3C2B-RESULT-2026-07-23.md` | Security detail and duplicate/conflicting controls | Rationalized design/result summary | Five-part and duplication review; compare to raw; raw private |

All current raw files in this section are **not approved for direct commit**.

## 12. Revised raw-private control-record plan

The original recommendations for D3C1-023 through D3C1-028 were revised by Dan. Their raw machine-readable or grouped control records must remain private outside Git and must not be described or handled as commit candidates. Only a separately authored, minimal, human-reviewed summary or sanitized derivative may later be considered for Git after lineage, factual, privacy, authority, duplication, staging, and commit approvals. Group completeness must be preserved for G23 through G28; D3C1-026 must preserve `HISTORICAL_NARRATIVE_UNVERIFIED`.

## 13. Proposed execution waves

Every wave below is **NOT AUTHORIZED** and requires a discrete Dan authorization. A stop in one wave prevents dependent waves.

| Wave | Status | Entry criteria | Actions that would occur | Validations | Rollback | Required human authorization | Explicit stop condition |
|---|---|---|---|---|---|---|---|
| 0 — Revalidation and drift detection | NOT AUTHORIZED | Approved read-only scope and baseline | Re-enumerate closed inventory; hash/stat/Git checks; identify new files separately | 81-path reconciliation; grouping, hash, tracking report | No mutation; discard draft observations | Dan approves revalidation window | Any missing, changed, new matching, tracked, or anomalous path |
| 1 — Approve private storage architecture | NOT AUTHORIZED | Wave 0 clean; proposed architecture documented | Decide exact active/legacy locations, encryption, ownership, permissions, retention, copy/move | Access-control and recovery test plan reviewed | Reject design; no storage creation | Dan approves architecture | Any location/policy remains unspecified |
| 2 — Preserve paired and grouped records | NOT AUTHORIZED | Waves 0–1 passed; closed membership signed | Lock execution manifest for groups/pairs; no file action yet unless separately released | Counts, hashes, pair links, ledger schema | Revert manifest proposal | Dan approves exact manifest | Partial/ambiguous/mismatched group |
| 3 — Copy and verify private-retention artifacts | NOT AUTHORIZED | Approved destination and copy method; Waves 0–2 passed | Copy approved D3C1-001/004/005/019 sources, then verify; source disposition remains separate | Source/destination SHA-256, size, access, index absence | Remove only failed destination copy under approval; source retained | Dan approves each source/destination action | Hash/access failure or source change |
| 4 — Archive approved private artifacts | NOT AUTHORIZED | Active/legacy lifecycle approved and current hashes match | Archive approved D3C1-002/003 and raw-private sets exactly as authorized | Hash/size/access/group integrity and ledger | Restore from verified prior copy/tier | Dan approves each transfer/transition | Any incomplete group, mismatch, or policy gap |
| 5 — Delete generated cache candidate | NOT AUTHORIZED | D3C1-030 gates all passed; explicit deletion release | Delete exactly G30 | Pre-hash, absence, source availability, regeneration proof | Regenerate/restore as preapproved | Dan explicitly authorizes deletion | Path/hash differs, diagnostic dependency, or regeneration fails |
| 6 — Draft sanitized derivatives | NOT AUTHORIZED | Raw sources privately preserved; names/locations/scopes approved | Author new derivatives, never rewrite raw | Lineage, fact, privacy, authority, duplication and item 41 checks | Remove draft derivative; raw untouched | Dan authorizes each drafting scope | Unsupported claim, disclosure, or lineage gap |
| 7 — Human review of derivatives | NOT AUTHORIZED | Wave 6 candidates complete | Dan/reviewers accept, revise, or reject each derivative | Raw-to-derivative comparison and recorded approvals | Return to Wave 6 or reject | Dan approves final content | Any reviewer requirement unresolved |
| 8 — Intentional Git promotion | NOT AUTHORIZED | Wave 7 approval plus commit grouping and repository location | Stage only specifically approved derivatives; commit/push are separately gated | Diff, status, secret/privacy checks, exact staged set | Unstage/revert approved derivative commit as separately directed | Separate Dan approvals for stage, commit, and push | Raw file staged, extra file present, check fails, or approval absent |
| 9 — Post-execution audit and reconciliation | NOT AUTHORIZED | Authorized waves complete | Reconcile ledger, decisions, paths, hashes, Git/private states, exceptions | Independent count/hash/state audit | Execute documented per-action rollback only with authority | Dan approves closure | Any discrepancy, missing evidence, or open exception |

## 14. Hash and evidence requirements

A future execution ledger must contain: decision ID; source path; source SHA-256; source size; source modification time; action; destination path when applicable; destination SHA-256; validation result; operator; authority reference; execution timestamp; rollback status; and exception notes. For grouped records, use one entry per physical member plus a group reconciliation entry. The source SHA-256 must be freshly computed immediately before action and compared with the Phase 3D-B baseline. This phase does not generate the execution ledger.

## 15. Drift assessment

Observation date: 2026-07-31. The assessment used metadata and mechanical hashing only; sensitive contents were not read or reproduced.

| Check | Observation | Effect |
|---|---|---|
| Missing baseline paths | 0 of 81 | No missing-path drift |
| Unexpected tracked baseline paths | 0 | No Git-classification drift to tracked |
| Baseline hash drift | `logs/2026-07-24-active-session-101602.log`: Phase 3D-B `ffdf46eb7fd7507e3ec9342e1ee3e95ddbd698336fe27ffba260d74c81483dfc`; current `dd72a00df5075ef108df240205e272d8fe8672fd5b89b5f15636f14679d19bdd` | Blocks D3C1-020 and execution globally pending review |
| Changed broad-pattern membership | The active-session glob now finds 36 files, while C1 governs the closed G20 set of 24 | 12 files are unexpected new observations, not silently added to C1 |
| New matching paths | `logs/2026-07-28-active-session-165012.log`; `logs/2026-07-28-active-session-170515.log`; `logs/2026-07-28-active-session-172753.log`; `logs/2026-07-28-active-session-173802.log`; `logs/2026-07-28-active-session-174807.log`; `logs/2026-07-29-active-session-171221.log`; `logs/2026-07-29-active-session-213957.log`; `logs/2026-07-29-active-session-215521.log`; `logs/2026-07-29-active-session-220640.log`; `logs/2026-07-29-active-session-220919.log`; `logs/2026-07-29-active-session-220958.log`; `logs/2026-07-29-active-session-221155.log` | Require separate inventory and human classification; no disposition inferred |
| Other grouped membership | G08, G15, G21–G30 exact baseline members remain observable; cloud-sync/report/cache pattern counts remain 6/6/1 | No other observed membership drift |
| Category mismatch | The changed D3C1-020 member no longer satisfies its baseline-integrity prerequisite; new logs have no C1 category | Human review required; no repair performed |

Historical evidence is preserved: current values are recorded as observations, not replacements for Phase 3D-B baseline values.

## 16. Unresolved decisions requiring Dan

Before execution, Dan must decide:

- the approved private active archive location;
- the approved restricted legacy archive location;
- encryption requirements;
- permissions and ownership requirements;
- retention periods by category and lifecycle trigger;
- whether verified copies or moves are preferred;
- secure-deletion expectations, including whether ordinary deletion is sufficient for generated cache;
- sanitized-derivative names and repository locations;
- authorization for each execution wave and each item/group within it;
- Git commit grouping and separate stage/commit/push boundaries;
- whether the execution ledger remains private or receives a sanitized derivative;
- disposition/classification of the 12 new active-session logs and acceptance or investigation of the changed baseline log;
- whether and how the historical 81-path inventory is superseded after drift review.

No choice is made on Dan's behalf.

## 17. Final readiness verdict

**Verdict: `BLOCKED_BY_INVENTORY_DRIFT`**

The execution plan is complete and suitable for human review, but execution is blocked by D3C1-020 hash and membership drift and remains unauthorized independently of that drift.

- Total decision IDs accounted for: **35 of 35**, each exactly once in the primary matrix.
- Total physical or grouped paths accounted for: **81 physical paths across 35 decision records**; the 13 grouped records preserve exact membership. Twelve newly observed matching paths are separately recorded as drift and are not treated as decided paths.
- Approved plus revised accounting: **29 + 6 = 35**; deferred **0**; rejected **0**.
- Unresolved blockers: D3C1-020 hash drift; 12 unclassified new matching logs; private-storage architecture; retention/security policies; derivative names/locations/reviews; wave and Git authorizations; pending item 41, Phase 3, diagnostic, evidence-run, and Lab 05 dependencies.
- Execution authorization status: **NOT AUTHORIZED**.
- No disposition actions were executed. No artifact was moved, copied, deleted, sanitized, staged, committed, pushed, permission-changed, timestamp-altered intentionally, or synchronized to cloud storage. No archive or derivative was created; `.gitignore` was not modified; item 41 was not resolved; `HISTORICAL_NARRATIVE_UNVERIFIED` was not changed.
