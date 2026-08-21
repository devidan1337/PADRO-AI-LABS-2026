# Phase 3D Gate 2A — Empty Production Vault Execution Plan

> **design verdict: `GATE_2A_DESIGN_READY_FOR_HUMAN_EXECUTION_AUTHORIZATION`**
>
> **scope: DESIGN AND REVIEW ONLY**
>
> **execution authority: NOT GRANTED**
>
> **decision owner: Dan**

## 1. Purpose and governing boundary

This plan defines the exact future human-controlled sequence for Gate 2A. It does not execute that sequence. Gate 2A is limited to:

1. owner creation and approved password-manager custody of one unique production gocryptfs password;
2. creation of the exact approved production ciphertext directory and plaintext mountpoint;
3. initialization of an empty production gocryptfs vault; and
4. transient owner-only observation of the initialization-time gocryptfs emergency recovery material, with no Gate 2A retention or copy.

Gate 2A does not authorize a production mount, canary, `active/` or `legacy/` directory, PAL artifact, source copy or migration, recovery-USB access, printed or USB recovery copy, ciphertext backup, helper adaptation, helper execution, password test, master-key recovery test, cleanup, retry, repair, staging, commit, or push.

The governing order remains:

1. Gate 1A recovery-custody design/readiness — human-approved before Gate 2A;
2. Gate 2A empty production-vault initialization — this plan;
3. Gate 1B recovery-custody completion — separately authorized copying to printed copies A and B and encrypted USB copy C;
4. Gate 2B production-helper lifecycle validation;
5. Gate 3 dedicated external ciphertext backup; and
6. Gate 4 limited canary / first real ingestion.

No step below may be treated as self-authorizing. A separate human execution authorization must name Gate 2A, the exact paths, the installed gocryptfs version, and the allowed action class before any state-changing step begins.

## 2. Approved identities, paths, ownership, and modes

The execution identity and host must be exactly:

- user: `dev`;
- host: `PADRO-AI-CORE`; and
- canonical repository: `/home/dev/projects/PADRO-AI-LABS-2026`.

The only production vault paths are:

- ciphertext: `/home/dev/.pal-private-cipher/archive/`;
- plaintext mountpoint: `/home/dev/pal-private-archive/`.

No alternative, relative, parameter-supplied, symlinked, bind-mounted, substituted, backup, restore, test, client, or investigative path is permitted.

Required locked-state metadata is:

| Object | Required type | Required owner:group | Required numeric mode | Gate 2A content |
|---|---|---|---:|---|
| `/home/dev/.pal-private-cipher/` | real directory; necessary parent of the approved ciphertext path | `dev:dev` | `0700` | only `archive/` |
| `/home/dev/.pal-private-cipher/archive/` | real directory; not a mountpoint | `dev:dev` | `0700` | empty before initialization; only standard initialization artifacts afterward |
| `/home/dev/pal-private-archive/` | real directory; unmounted | `dev:dev` | `0500` | empty |
| `gocryptfs.conf` after initialization | real regular file; not a link | `dev:dev` | `0400` | never display or copy its contents in Gate 2A evidence |
| `gocryptfs.diriv` after initialization | real regular file; not a link | `dev:dev` | `0444` | never display or copy its contents in Gate 2A evidence |

The `0700` ciphertext and `0500` locked-mountpoint baseline, both owned by `dev:dev`, retain the T3G/T3H design and the validated T3I-B disposable baseline. The `0400` and `0444` artifact modes are the installed-version behavior already observed on the retained disposable vault. Any different owner, group, mode, type, or artifact behavior is a stop, not permission to normalize or repair it.

The logical future plaintext directories `/home/dev/pal-private-archive/active/` and `/home/dev/pal-private-archive/legacy/` must not be created in Gate 2A. They may exist only inside a later verified production mount under separate authority.

## 3. Design-review observations

Read-only review on `2026-08-21` observed:

- identity `dev@PADRO-AI-CORE`;
- canonical repository path exact;
- `/usr/bin/gocryptfs` version `2.6.1` with go-fuse `2.8.0`;
- `/usr/bin/gocryptfs-xray` version `2.6.1`;
- both production roots absent;
- no exact production mount observed;
- retained disposable ciphertext `dev:dev` mode `0700`;
- retained disposable plaintext empty, unmounted, `dev:dev` mode `0500`; and
- the three retained helpers remain executable, disposable-only, and byte-identical to the final T3I-B hashes.

The helper hashes observed were:

| Disposable-only helper | SHA-256 |
|---|---|
| `scripts/private-archive-mount.sh` | `27e7ae82b741da177f9a219a6d6916185ee5907739c9748b2cb8957df660b524` |
| `scripts/private-archive-status.sh` | `ade6e6efa7800356b1e296712b2d25b67820e011b4f6e13f035ee8dc0565850f` |
| `scripts/private-archive-unmount.sh` | `eba7648c21c10828cbefd0c868ec43fe070a27e695f80f3f2f9ab77caf368938` |

These observations are not execution authorization. All volatile facts must be rechecked immediately before a future Gate 2A run.

## 4. Installed gocryptfs recovery behavior

For installed gocryptfs `2.6.1`, forward-mode initialization with default options:

1. generates a random 256-bit gocryptfs master key;
2. encrypts that master key under the owner-entered password in `gocryptfs.conf`;
3. creates `gocryptfs.diriv` as required vault metadata; and
4. when attached to a terminal, displays the plaintext master key once after successful initialization with an explicit master-key label and recovery warning.

The displayed master key is the production emergency recovery material governed by Gates 1A and 1B. gocryptfs does not generate a separate recovery-code file, recovery certificate, QR code, or second emergency secret. `gocryptfs.conf` contains the encrypted master key but is not a substitute for the separately held emergency master-key copies.

Installed gocryptfs suppresses the master-key display when it is not running on a terminal. Therefore Gate 2A must use a direct local interactive terminal. No redirection, pipeline, `tee`, `script`, terminal recorder, remote prompt relay, screen share, screenshot, or non-terminal wrapper is permitted.

Installed-version read-only evidence confirms the deferred retrieval capability. `gocryptfs-xray 2.6.1` help and its installed man page define `-dumpmasterkey` as decrypting and showing the existing master key from a supplied `gocryptfs.conf`. The documented invocation takes the configuration path, not a password or master-key value, as its file operand. Its help exposes no password argument, password-file, external-password, or environment-secret option. The installed binary contains the terminal password-reader path and a specific failure path for inability to read a password from the terminal. Together, this supports later owner-interactive password entry and master-key display in a direct terminal without putting either secret in a command argument, environment variable, file, pipe, or agent context. No real configuration or master key was read to make this determination.

The retrieval capability does not authorize a Gate 1B command. Gate 1B must independently review and authorize its exact installed-version retrieval command, direct-terminal controls, output handling, and copy sequence before execution. It must use the routine password only through owner-controlled terminal interaction and must present the master key only to the owner in the controlled Gate 1B session. The mode must not be run during Gate 2A initialization or validation: it would expose recovery material again and adds no proof needed for empty initialization. It is also not an emergency substitute when both the routine password and external master-key custody are unavailable.

No master-key value, fragment, format sample, transcription, photograph, screenshot, hash, checksum, hint, or derived verifier may enter this plan, evidence, Git, a report, chat, an agent, a cloud service, or the password manager.

## 5. Gate 2A execution prerequisites

Before even the read-only preflight begins, Dan must confirm all of the following without revealing secrets:

- Gate 1A is human-approved and its exact opaque inventory identifiers, custody categories, printed-copy procedure, encrypted-USB procedure, verification method, and temporary-copy controls are available to the owner;
- a distinct Gate 2A execution authorization has been issued;
- the owner can create and save the routine credential in the approved password manager without agent access;
- an unrecorded local interactive terminal is available;
- the owner accepts that Gate 2A will retain zero master-key copies and that Gate 1B remains blocking until it separately retrieves the existing master key and completes all three approved copies;
- Gate 1B will independently review and authorize its exact owner-interactive retrieval command before execution;
- no recovery USB, ciphertext-backup device, or other removable device is connected for Gate 2A;
- terminal transcription, shell-session recording, screen recording, screen sharing, clipboard manager/history, and logging wrappers are disabled; and
- no automation or agent will observe the password prompt or master-key display.

Because installed-version read-only evidence confirms later owner-interactive retrieval from the existing encrypted configuration using the routine password, printer readiness, recovery-USB connection, and an immediate secret handoff are not Gate 2A initialization prerequisites. They remain Gate 1B prerequisites. No real ingestion or later production gate may proceed while Gate 1B is incomplete.

## 6. Phase A — read-only preflight

Phase A makes no filesystem, mount, credential, device, Git-index, or repository change. Run it from a normal local shell as `dev`. Evidence captures only the stated pass/fail facts, not a full terminal transcript.

### 6.1 Identity and canonical repository

Run:

```bash
/usr/bin/id -un
/usr/bin/hostname
/usr/bin/pwd
/usr/bin/readlink -f /home/dev/projects/PADRO-AI-LABS-2026
/usr/bin/git -C /home/dev/projects/PADRO-AI-LABS-2026 rev-parse --show-toplevel
/usr/bin/git -C /home/dev/projects/PADRO-AI-LABS-2026 diff --cached --name-only
```

Require exact `dev`, `PADRO-AI-CORE`, and the canonical repository path from both path checks. Require no staged path. Existing unrelated untracked files are preserved and are not Gate 2A cleanup targets.

### 6.2 Tool path and version

Run:

```bash
command -v gocryptfs
/usr/bin/readlink -f /usr/bin/gocryptfs
/usr/bin/gocryptfs -version
command -v gocryptfs-xray
/usr/bin/gocryptfs-xray -version
command -v mkdir
command -v findmnt
command -v rg
command -v crontab
```

Require `/usr/bin/gocryptfs`, gocryptfs `2.6.1`, go-fuse `2.8.0`, `/usr/bin/gocryptfs-xray` `2.6.1`, `/usr/bin/mkdir`, and locally resolved `findmnt`, `rg`, and `crontab`. Do not install, upgrade, downgrade, replace, or repair a tool in Gate 2A. Version or path drift requires plan review.

### 6.3 Safe path inspection before creation

Inspect metadata only; do not use `touch`, `mkdir`, `chmod`, `chown`, `rm`, `mv`, or an editor:

```bash
/usr/bin/stat -c '%n TYPE=%F OWNER=%U:%G MODE=%a DEVICE_INODE=%d:%i' /home /home/dev
/usr/bin/namei -l /home/dev/.pal-private-cipher/archive
/usr/bin/namei -l /home/dev/pal-private-archive
test ! -e /home/dev/.pal-private-cipher && test ! -L /home/dev/.pal-private-cipher
test ! -e /home/dev/.pal-private-cipher/archive && test ! -L /home/dev/.pal-private-cipher/archive
test ! -e /home/dev/pal-private-archive && test ! -L /home/dev/pal-private-archive
test ! -e /home/dev/pal-private-archive/active && test ! -L /home/dev/pal-private-archive/active
test ! -e /home/dev/pal-private-archive/legacy && test ! -L /home/dev/pal-private-archive/legacy
```

Require `/home/dev` to be a real directory owned by `dev:dev`, with every production path and logical child absent, including dangling links. Any existing object, even apparently empty, pauses execution for human classification. Do not inspect its contents beyond the minimum metadata needed to classify the conflict, and do not delete, reuse, rename, or overwrite it.

### 6.4 Mount, process, and automatic-start inspection

Run read-only exact-path checks:

```bash
/usr/bin/findmnt -rn -M /home/dev/.pal-private-cipher/archive -o TARGET,SOURCE,FSTYPE,OPTIONS
/usr/bin/findmnt -rn -M /home/dev/pal-private-archive -o TARGET,SOURCE,FSTYPE,OPTIONS
/usr/bin/awk 'index($0,"/home/dev/.pal-private-cipher/archive") || index($0,"/home/dev/pal-private-archive")' /proc/self/mountinfo
/usr/bin/pgrep -a -u dev gocryptfs
```

The two `findmnt` checks and the fixed-path `/proc/self/mountinfo` check must produce no production match. Review `pgrep` locally and record only whether a process is associated with either approved production path; do not capture full process command lines in evidence. Any associated or ambiguous process is a stop.

Run the following exact read-only Bash block from the canonical repository. It searches literally for both production paths. It writes nothing, uses no `sudo`, ignores absent optional locations, emits only matching filenames or Boolean classifications, and treats any scan error or unreadable owner-crontab state as a stop.

```bash
(
    set -u

    prod_cipher_literal='/home/dev/.pal-private-cipher/archive'
    prod_plain_literal='/home/dev/pal-private-archive'
    automatic_reference_stop=0

    scan_literal_filenames() {
        local label="$1"
        shift
        local candidate matches scan_rc
        local -a existing_locations=()

        for candidate in "$@"; do
            if [[ -e "$candidate" || -L "$candidate" ]]; then
                existing_locations+=("$candidate")
            fi
        done

        if (( ${#existing_locations[@]} == 0 )); then
            printf '%s=%s\n' "$label" 'PASS_NO_APPLICABLE_LOCATIONS'
            return 0
        fi

        matches="$(rg -l --hidden --follow --fixed-strings --no-messages \
            -e "$prod_cipher_literal" \
            -e "$prod_plain_literal" \
            -- "${existing_locations[@]}")"
        scan_rc=$?

        case "$scan_rc" in
            0)
                printf '%s=%s\n' "$label" 'STOP_MATCHING_LOCATIONS'
                printf '%s\n' "$matches"
                automatic_reference_stop=1
                ;;
            1)
                printf '%s=%s\n' "$label" 'PASS_NO_MATCH'
                ;;
            *)
                printf '%s=%s\n' "$label" 'STOP_SCAN_ERROR'
                automatic_reference_stop=1
                ;;
        esac
    }

    scan_literal_filenames 'FSTAB_AND_SYSTEMD_REFERENCES' \
        /etc/fstab \
        /etc/systemd/system \
        /run/systemd/system \
        /run/systemd/generator \
        /run/systemd/generator.early \
        /run/systemd/generator.late \
        /usr/local/lib/systemd/system \
        /usr/lib/systemd/system \
        /lib/systemd/system \
        /etc/systemd/user \
        /usr/lib/systemd/user \
        /home/dev/.config/systemd/user \
        /home/dev/.local/share/systemd/user \
        "/run/user/$(/usr/bin/id -u)/systemd/user" \
        "/run/user/$(/usr/bin/id -u)/systemd/generator" \
        "/run/user/$(/usr/bin/id -u)/systemd/generator.early" \
        "/run/user/$(/usr/bin/id -u)/systemd/generator.late"

    scan_literal_filenames 'SYSTEM_CRON_REFERENCES' \
        /etc/crontab \
        /etc/cron.d \
        /etc/cron.hourly \
        /etc/cron.daily \
        /etc/cron.weekly \
        /etc/cron.monthly

    scan_literal_filenames 'SHELL_STARTUP_REFERENCES' \
        /etc/profile \
        /etc/bash.bashrc \
        /etc/profile.d \
        /etc/zsh \
        /home/dev/.bashrc \
        /home/dev/.bash_profile \
        /home/dev/.bash_login \
        /home/dev/.bash_aliases \
        /home/dev/.profile \
        /home/dev/.zshrc \
        /home/dev/.zprofile \
        /home/dev/.config/bash \
        /home/dev/.config/zsh \
        /home/dev/.config/fish/config.fish

    if /usr/bin/crontab -l >/dev/null 2>&1; then
        if /usr/bin/crontab -l 2>/dev/null | rg -q --fixed-strings \
            -e "$prod_cipher_literal" \
            -e "$prod_plain_literal"; then
            printf '%s\n' 'OWNER_CRONTAB_REFERENCES=STOP_MATCH'
            automatic_reference_stop=1
        else
            printf '%s\n' 'OWNER_CRONTAB_REFERENCES=PASS_NO_MATCH'
        fi
    elif /usr/bin/crontab -l 2>&1 >/dev/null | \
        rg -q --fixed-strings 'no crontab for dev'; then
        printf '%s\n' 'OWNER_CRONTAB_REFERENCES=PASS_NO_CRONTAB'
    else
        printf '%s\n' 'OWNER_CRONTAB_REFERENCES=STOP_UNREADABLE_OR_UNEXPECTED_ERROR'
        automatic_reference_stop=1
    fi

    mapfile -t repository_automation_files < <(
        rg --files /home/dev/projects/PADRO-AI-LABS-2026 \
            -g 'scripts/**' \
            -g '.github/**' \
            -g '.gitlab/**' \
            -g '.gitlab-ci.yml' \
            -g 'Makefile' \
            -g 'makefile' \
            -g 'GNUmakefile' \
            -g 'Taskfile*.yml' \
            -g 'Taskfile*.yaml' \
            -g 'ansible/**' \
            -g 'automation/**' \
            -g '*.service' \
            -g '*.mount' \
            -g '*.automount' \
            -g '*.timer' \
            -g '*.path' \
            -g '*.socket' \
            -g '*.sh' \
            -g '*.py' \
            -g '*.ps1' \
            -g '!**/__pycache__/**' \
            -g '!*.pyc'
    )

    if (( ${#repository_automation_files[@]} == 0 )); then
        printf '%s\n' 'REPOSITORY_AUTOMATION_REFERENCES=PASS_NO_AUTOMATION_FILES'
    else
        repository_matches="$(rg -l --fixed-strings --no-messages \
            -e "$prod_cipher_literal" \
            -e "$prod_plain_literal" \
            -- "${repository_automation_files[@]}")"
        repository_scan_rc=$?

        case "$repository_scan_rc" in
            0)
                repository_unexpected=0
                while IFS= read -r repository_match; do
                    case "$repository_match" in
                        /home/dev/projects/PADRO-AI-LABS-2026/scripts/private-archive-mount.sh|\
                        /home/dev/projects/PADRO-AI-LABS-2026/scripts/private-archive-status.sh|\
                        /home/dev/projects/PADRO-AI-LABS-2026/scripts/private-archive-unmount.sh)
                            printf '%s %s\n' \
                                'REPOSITORY_REFERENCE=EXPECTED_T3I_REQUIRES_SECTION_6_5_REVIEW' \
                                "$repository_match"
                            ;;
                        *)
                            printf '%s %s\n' \
                                'REPOSITORY_REFERENCE=STOP_UNEXPECTED' \
                                "$repository_match"
                            repository_unexpected=1
                            automatic_reference_stop=1
                            ;;
                    esac
                done <<<"$repository_matches"

                if (( repository_unexpected == 0 )); then
                    printf '%s\n' \
                        'REPOSITORY_AUTOMATION_REFERENCES=PASS_PENDING_SECTION_6_5_T3I_CLASSIFICATION'
                fi
                ;;
            1)
                printf '%s\n' 'REPOSITORY_AUTOMATION_REFERENCES=PASS_NO_MATCH'
                ;;
            *)
                printf '%s\n' 'REPOSITORY_AUTOMATION_REFERENCES=STOP_SCAN_ERROR'
                automatic_reference_stop=1
                ;;
        esac
    fi

    if (( automatic_reference_stop != 0 )); then
        printf '%s\n' 'AUTOMATIC_OR_FALLBACK_REFERENCE_SCAN=STOP'
        exit 1
    fi
    printf '%s\n' 'AUTOMATIC_OR_FALLBACK_REFERENCE_SCAN=PASS_PENDING_T3I_CLASSIFICATION'
)
```

No `crontab` write option is used; `crontab -l` is inspection only. Missing optional unit or startup locations are excluded before scanning and do not create false failures. A matching systemd, fstab, system-cron, owner-crontab, or shell-startup location is fail-closed `STOP`. An unexpected repository automation match is also `STOP`. The only non-stopping matches are the three known T3I helper files, and they remain pending until Section 6.5 proves their exact hashes, disposable operational constants, and defensive-only production references.

Any actual mount, automount, startup, alias, scheduled job, write redirect, synchronization job, or fallback target using either production path is `STOP`. Record only the emitted location identifiers and final `AUTOMATIC_OR_FALLBACK_REFERENCE_SCAN=PASS|STOP` classification; do not retain unrelated configuration contents.

### 6.5 Disposable-helper noninterference

Run:

```bash
/usr/bin/sha256sum /home/dev/projects/PADRO-AI-LABS-2026/scripts/private-archive-mount.sh /home/dev/projects/PADRO-AI-LABS-2026/scripts/private-archive-status.sh /home/dev/projects/PADRO-AI-LABS-2026/scripts/private-archive-unmount.sh
rg -n '^readonly (CIPHER_DIR|PLAIN_DIR|PROD_CIPHER|PROD_PLAIN)=' /home/dev/projects/PADRO-AI-LABS-2026/scripts/private-archive-mount.sh /home/dev/projects/PADRO-AI-LABS-2026/scripts/private-archive-status.sh /home/dev/projects/PADRO-AI-LABS-2026/scripts/private-archive-unmount.sh
```

Require the hashes in Section 3. Require operational constants to remain the retained disposable paths and production literals to remain deny-only guards. If these checks pass, record `REPOSITORY_AUTOMATION_REFERENCES=PASS_EXPECTED_T3I_DEFENSIVE_ONLY`. Do not run any helper. Once production paths exist, these helpers intentionally refuse because of their production-path deny guard; that refusal is expected noninterference, not authority to edit or bypass the guard.

### 6.6 Preflight decision

Dan reviews the secret-free Phase A summary. Continue only if every item is `PASS`, the repository classification is `PASS_EXPECTED_T3I_DEFENSIVE_ONLY` or `PASS_NO_MATCH`, and Dan separately releases the credential-creation action. Any `PASS_PENDING` remains incomplete. Do not batch Phase A with state-changing commands.

## 7. Phase B — owner-controlled production credential

This phase is a human action in the approved password manager, not a terminal or agent action.

1. Dan opens Bitwarden directly in his trusted owner session. No agent accesses, views, controls, or verifies it.
2. Dan creates a new production-vault entry identified by a non-secret vault label approved for inventory use.
3. Dan uses the password manager's cryptographically secure generator to create a unique random password with at least 128 bits of entropy. It must not be human-derived or reused from personal, email, GitHub, SSH, banking, client, Bitwarden-master, recovery-USB, or any other credential.
4. Dan saves and confirms the entry inside Bitwarden. Evidence records only `PRODUCTION_CREDENTIAL_CREATED_AND_SAVED=OWNER_ATTESTED`; it records no value, length, character pattern, hint, generator screenshot, private account metadata, or password-manager export.
5. Dan does not place the password in a shell argument, environment variable, file, pipe, standard-input redirection, script, report, log, terminal transcript, chat, prompt, screenshot, or clipboard. Manual entry from the owner-controlled display into the direct gocryptfs prompts is required. Clipboard use is avoided.
6. The agent never receives, repeats, compares, checks, validates, or confirms the password. gocryptfs itself performs the only value confirmation through its two direct initialization prompts.

Credential creation does not authorize path creation or initialization. Dan must issue the next explicit release after confirming the credential is safely saved.

## 8. Phase C — exact production path creation

Immediately before creation, repeat Sections 6.1, 6.3, 6.4, and 6.5. Require the same absent and unmounted results and a completed defensive-reference classification. Then, and only under explicit path-creation authorization, run as `dev`:

```bash
(
    set -Eeuo pipefail
    trap 'printf "%s\n" "PATH_CREATION=STOP_PRESERVE_STATE" >&2' ERR

    [[ ! -e /home/dev/.pal-private-cipher && ! -L /home/dev/.pal-private-cipher ]]
    /usr/bin/mkdir -m 0700 -- /home/dev/.pal-private-cipher
    [[ -d /home/dev/.pal-private-cipher && ! -L /home/dev/.pal-private-cipher ]]
    [[ "$(/usr/bin/stat -c '%U:%G:%a' /home/dev/.pal-private-cipher)" == 'dev:dev:700' ]]

    [[ ! -e /home/dev/.pal-private-cipher/archive && ! -L /home/dev/.pal-private-cipher/archive ]]
    /usr/bin/mkdir -m 0700 -- /home/dev/.pal-private-cipher/archive
    [[ -d /home/dev/.pal-private-cipher/archive && ! -L /home/dev/.pal-private-cipher/archive ]]
    [[ "$(/usr/bin/stat -c '%U:%G:%a' /home/dev/.pal-private-cipher/archive)" == 'dev:dev:700' ]]

    [[ ! -e /home/dev/pal-private-archive && ! -L /home/dev/pal-private-archive ]]
    /usr/bin/mkdir -m 0500 -- /home/dev/pal-private-archive
    [[ -d /home/dev/pal-private-archive && ! -L /home/dev/pal-private-archive ]]
    [[ "$(/usr/bin/stat -c '%U:%G:%a' /home/dev/pal-private-archive)" == 'dev:dev:500' ]]

    printf '%s\n' 'PATH_CREATION=PASS'
)
```

The subshell confines strict-shell settings and does not alter the caller's umask. It uses no `mkdir -p`. Each exact target is proven absent, including as a dangling link, immediately before its own `mkdir`. Each component is created once, one level at a time, with its required mode and is immediately verified as a real `dev:dev` directory with that exact mode before the next target is considered. Because execution identity and primary group are already gated as `dev:dev`, no privileged `chown` or `sudo` is used.

Any failed absence check, `mkdir` error, type mismatch, ownership mismatch, or mode mismatch exits the subshell nonzero. Preserve every successfully created earlier component and stop for human review. Do not rerun the block: a second invocation would encounter a pre-existing object and must stop. Do not `chmod`, `chown`, reuse, delete, rename, normalize, or repair any target.

Before initialization, validate:

```bash
/usr/bin/stat -c '%n TYPE=%F OWNER=%U:%G MODE=%a DEVICE_INODE=%d:%i' /home/dev/.pal-private-cipher /home/dev/.pal-private-cipher/archive /home/dev/pal-private-archive
test -z "$(/usr/bin/find /home/dev/.pal-private-cipher/archive -mindepth 1 -print -quit)"
test -z "$(/usr/bin/find /home/dev/pal-private-archive -mindepth 1 -print -quit)"
/usr/bin/findmnt -rn -M /home/dev/pal-private-archive -o TARGET,SOURCE,FSTYPE,OPTIONS
```

Require real, non-symlink directories; `dev:dev`; parent/ciphertext modes `0700`; plaintext mode `0500`; both directories empty; and no plaintext mount. Do not create `active/`, `legacy/`, a probe, placeholder, README, evidence file, password file, recovery file, backup, or canary.

Any validation failure stops with the just-created empty paths preserved for human review. Do not automatically repair modes, ownership, or content and do not remove or retry the paths.

## 9. Phase D — empty vault initialization

Dan must personally confirm that the terminal is local, interactive, unrecorded, and not screen-shared. No full terminal transcription may be active. The terminal is used only for initialization-time interaction and transient owner observation; it is not a carrier into Gate 1B. The recovery USB remains disconnected during Gate 2A.

Repeat the exact ciphertext emptiness and plaintext-unmounted checks. Under a distinct initialization authorization, Dan runs exactly:

```bash
/usr/bin/gocryptfs -init /home/dev/.pal-private-cipher/archive
```

No initialization option is added. In particular, do not use `-passfile`, `-extpass`, `-masterkey`, `-zerokey`, `-quiet`, custom config, reverse mode, FIDO2, redirection, a pipe, `tee`, `script`, or a wrapper.

Dan enters the saved production password only at the two direct gocryptfs prompts. No person or agent reads it aloud, relays it, records it, or asks Dan to prove it. On successful initialization, Dan alone visually confirms that gocryptfs reports success and presents the expected master-key recovery material. This presentation is transient. No value is copied, retained, or captured by Gate 2A.

Gate 2A initialization creates only the empty ciphertext configuration. It does not invoke the two-argument mount form, change the plaintext mountpoint to `0700`, mount FUSE, create plaintext content, create `active/` or `legacy/`, copy PAL content, access a source, connect or write USB media, print a copy, or create a backup.

If initialization returns nonzero, is interrupted, produces an unexpected file, suppresses the master-key display, displays recovery material outside the direct terminal, requests the password through any other channel, or behaves differently from Section 4, preserve all resulting state and stop. Do not rerun `-init`, delete a partial configuration, overwrite a configuration, change the password, or invoke `gocryptfs-xray`.

## 10. Phase E — transient presentation closure and deferred Gate 1B retrieval

At Gate 2A, the initialization-time master-key output is a transient owner-only presentation, not a retained recovery copy or handoff carrier. Dan may visually confirm only that the expected recovery material was generated and presented. He must not transcribe, memorize for later relay, print, photograph, screenshot, copy, select, or paste the value. It must not enter a temporary file, editor buffer, clipboard, note application, password manager, cloud service, print spool, repository, evidence record, chat, agent, uncontrolled paper, or any other storage.

Dan records only these secret-free facts outside the secret-bearing terminal:

- the approved opaque vault/recovery-item identifier from Gate 1A;
- `RECOVERY_MATERIAL_TYPE=GOCRYPTFS_MASTER_KEY`;
- `RECOVERY_MATERIAL_GENERATED=YES`;
- `INITIALIZATION_PRESENTATION_OBSERVED=PASS|STOP`;
- `INITIALIZATION_PRESENTATION=TRANSIENT_OWNER_ONLY`;
- `GATE_2A_RECOVERY_COPIES_CREATED=0`;
- `GATE_2A_RECOVERY_COPIES_RETAINED=0`;
- `SECRET_BEARING_INITIALIZATION_SESSION_ENDED=YES|STOP`; and
- `GATE_1B_RETRIEVAL_AND_CUSTODY=DEFERRED_SEPARATE_AUTHORIZATION`.

Do not record a recovery-material hash or any value-derived verifier. A digest could become an unnecessary oracle for a secret and is not needed for Gate 2A proof.

After the required owner observation, Dan must end the dedicated secret-bearing terminal/session. Its output and scrollback must not become evidence and must not be saved, exported, logged, photographed, copied, or kept open as temporary recovery custody. Gate 2A completion requires that the presentation is no longer visible or retained. Metadata validation continues only in a separate clean terminal.

Copying the material to printed copy A, printed copy B, or validated encrypted USB copy C is not a Gate 2A action. Gate 1B is responsible for a later, separately authorized, owner-interactive re-display of the existing filesystem master key from the existing production configuration using the routine password. Before executing anything, Gate 1B must independently define and human-authorize the exact installed-version command, confirm that the password is accepted only at the direct terminal prompt, and establish its secret-output and copy controls. Gate 1B then owns printed copies A and B, encrypted USB copy C, independent verification, seals, custody categories, and elimination of every Gate 1B working presentation or copy.

No master-key value may enter Git, reports, chat, logs, screenshots, shell arguments, environment variables, temporary or intermediate files, pipes, agent context, password managers, ordinary cloud storage, or uncontrolled paper during either gate. Gate 1B's authorized final printed copies and final file on encrypted USB C are the only planned retained recovery copies; that USB file is a controlled final custody destination, not a retrieval input, pipe, or temporary working file.

If the Gate 2A session cannot be ended without retaining output, any copy may have been created, or the presentation appears outside the direct owner-only terminal, stop and invoke human incident review. Do not reconstruct or re-display the master key, run the retrieval mode, reinitialize, print, photograph, transcribe, or write the USB under Gate 2A authority.

## 11. Phase F — post-initialization secret-free validation

Validation is metadata-only and does not mount or unlock the vault. It begins only after Dan has ended the secret-bearing initialization terminal/session without retaining its output. Do not reopen, scroll back, capture, or transcribe that session.

Run these exact-path checks in a separate clean terminal:

```bash
/usr/bin/stat -c '%n TYPE=%F OWNER=%U:%G MODE=%a' /home/dev/.pal-private-cipher /home/dev/.pal-private-cipher/archive /home/dev/pal-private-archive /home/dev/.pal-private-cipher/archive/gocryptfs.conf /home/dev/.pal-private-cipher/archive/gocryptfs.diriv
test -f /home/dev/.pal-private-cipher/archive/gocryptfs.conf && test ! -L /home/dev/.pal-private-cipher/archive/gocryptfs.conf
test -f /home/dev/.pal-private-cipher/archive/gocryptfs.diriv && test ! -L /home/dev/.pal-private-cipher/archive/gocryptfs.diriv
test "$(/usr/bin/find /home/dev/.pal-private-cipher/archive -mindepth 1 -maxdepth 1 -printf '.' | /usr/bin/wc -c)" -eq 2
test -z "$(/usr/bin/find /home/dev/pal-private-archive -mindepth 1 -print -quit)"
/usr/bin/findmnt -rn -M /home/dev/pal-private-archive -o TARGET,SOURCE,FSTYPE,OPTIONS
/usr/bin/awk 'index($0,"/home/dev/.pal-private-cipher/archive") || index($0,"/home/dev/pal-private-archive")' /proc/self/mountinfo
```

Then run `gocryptfs -info` with its output discarded and retain only its exit result:

```bash
if /usr/bin/gocryptfs -info /home/dev/.pal-private-cipher/archive >/dev/null 2>&1; then
    printf '%s\n' 'GOCRYPTFS_INFO_PARSE=PASS'
else
    printf '%s\n' 'GOCRYPTFS_INFO_PARSE=STOP'
fi
```

Finally, inspect processes locally and record only the Boolean result:

```bash
/usr/bin/pgrep -a -u dev gocryptfs
```

Require all of the following:

- ciphertext parent and archive are real `dev:dev` mode `0700` directories;
- plaintext mountpoint is a real `dev:dev` mode `0500` directory;
- `gocryptfs.conf` is a real `dev:dev` mode `0400` regular file;
- `gocryptfs.diriv` is a real `dev:dev` mode `0444` regular file;
- the ciphertext archive root contains exactly those two standard initialization artifacts and no encrypted operational object;
- `gocryptfs -info` parses the configuration successfully without preserving its output;
- plaintext mountpoint is empty and absent from both mount views;
- no `active/`, `legacy/`, PAL artifact, canary, source migration, USB write, or backup exists;
- no command in the authorized sequence wrote to the plaintext mountpoint, and no fallback probe was attempted;
- no process is associated with either production path; and
- recovery-material status is recorded only through the secret-free fields in Section 10.

Gate 2A deliberately performs no mount test and no fallback-write probe. The plaintext directory's exact empty `0500` state plus the reviewed command scope proves no Gate 2A fallback write occurred. The active mount, explicit unmount, fallback rejection, retained-process wait, and reopen lifecycle belong to Gate 2B.

Any unexpected gocryptfs process is preserved for review. Do not kill it. Any unexpected mount is preserved for review. Do not unmount it under Gate 2A authority.

## 12. Production helpers remain Gate 2B work

Gate 2A does not create, adapt, patch, rename, copy, chmod, or execute a production helper. The current helpers are validated only for the retained disposable paths. Their deny-only production guards intentionally make them stop once the production paths exist.

Gate 2B, after Gate 1B custody completion, must separately review and validate production-specific mount, status, and unmount helpers against the exact production paths. Gate 2B owns:

- production constant adaptation and exact-code review;
- Bash, ShellCheck, hash, ownership, and mode gates;
- locked status;
- `0500` to `0700` mount-ready transition;
- owner-interactive mount;
- exact source, target, type, namespace, and mounted-mode validation;
- second-mount refusal;
- explicit unmount;
- fallback-write rejection without residue;
- bounded associated-process exit and automatic-remount checks; and
- successful reopen and final locked teardown.

Pulling any of those actions into Gate 2A is a boundary error and stop condition.

## 13. Minimal secret-free Gate 2A evidence

The execution record should contain only:

| Evidence item | Allowed record |
|---|---|
| Human authority | Gate 1A approved; Gate 2A authorization identifier; Dan acknowledgment |
| Identity | `dev@PADRO-AI-CORE` pass |
| Repository | canonical path, HEAD identifier, staged-path count `0` |
| Tooling | `/usr/bin/gocryptfs`; version `2.6.1`; go-fuse `2.8.0`; `/usr/bin/gocryptfs-xray` version `2.6.1` |
| Preflight | paths absent, exact mounts absent, associated production process absent, automatic/fallback exact-command scan pass, owner crontab read result, repository T3I defensive classification pass |
| Disposable helpers | three hashes match; disposable operational constants; not executed |
| Credential | owner attestation that a unique high-entropy value was created and saved; agent access `NO` |
| Path creation | three component-by-component non-`-p` `mkdir` actions; each target absent immediately beforehand; exact path, type, `dev:dev`, numeric mode, and emptiness pass |
| Initialization | owner-observed exit success; configuration parse pass; no mount requested |
| Empty state | exactly two standard ciphertext initialization artifacts; plaintext entry count `0`; PAL operational item count `0` |
| Mount/process state | exact production mount absent in both checks; associated process absent |
| Recovery handling | opaque identifier, material type, generated `YES`, transient owner-only presentation observed, Gate 2A copies created `0`, Gate 2A copies retained `0`, initialization session ended, Gate 1B retrieval/custody deferred |
| Scope | USB/device actions `0`; printed copies `0`; backups `0`; mounts `0`; PAL copies/migrations `0`; helpers changed/executed `0` |
| Git | existing files modified `0`; report/evidence policy followed; index unchanged; staged/committed/pushed `0` |

Never capture:

- full initialization-terminal output or terminal scrollback;
- any password or master-key value, fragment, format sample, hint, length, hash, checksum, or derived verifier;
- prompt keystrokes, password-manager screens, clipboard contents, exports, private account metadata, or autofill logs;
- `gocryptfs-xray -dumpmasterkey` output;
- `gocryptfs.conf` or `gocryptfs.diriv` contents;
- screenshots, photographs, screen recordings, shell transcripts, `tee` output, `script` logs, or chat around credential/recovery entry;
- raw process listings in the retained evidence; or
- unrelated home, repository, device, or custody-location content.

## 14. Exact authorization boundary

This design authorizes nothing. A future human approval must release the following classes separately and in order:

### 14.1 Read-only preflight

Only the metadata and Boolean inspection commands in Section 6, including identity, repository/index, binary/version, path/link/type, mount-table, fixed-path process, automatic-start reference, helper-hash, and helper-constant checks. No secret-bearing output may be retained.

### 14.2 Credential creation

Only Dan's direct creation and save of one unique high-entropy routine gocryptfs password in Bitwarden, followed by manual direct entry at gocryptfs's own two initialization prompts. No agent or automation participation.

### 14.3 Path creation

Only the three exact, non-`-p` `mkdir` commands in Section 8, in order and within the fail-closed subshell:

```bash
/usr/bin/mkdir -m 0700 -- /home/dev/.pal-private-cipher
/usr/bin/mkdir -m 0700 -- /home/dev/.pal-private-cipher/archive
/usr/bin/mkdir -m 0500 -- /home/dev/pal-private-archive
```

Each command requires its exact target to have passed the immediately preceding absence-and-no-link check. No command may reuse or normalize an existing object. Failure stops the sequence and preserves any earlier successfully created component. No other path or object is authorized.

### 14.4 gocryptfs initialization

Only this exact command, after its own human release:

```bash
/usr/bin/gocryptfs -init /home/dev/.pal-private-cipher/archive
```

It may initialize once only, with installed version `2.6.1`, on the proven-empty approved ciphertext directory, using direct owner interaction. It does not authorize mounting or retry.

### 14.5 Recovery-material handling

Gate 2A authorizes only transient owner observation of the initialization-time presentation, followed by ending the secret-bearing session with zero Gate 2A copies retained. It does not authorize keeping the master key visible, copying it, treating terminal scrollback as custody, or executing any retrieval mode.

Gate 1B is responsible for later owner-interactive retrieval/re-display of the existing filesystem master key from the existing production configuration using the routine password and for copying it to printed A, printed B, and encrypted USB C. Before any Gate 1B execution, its own design and human authorization must specify the exact installed-version retrieval command and prove that the retrieval path places neither password nor master key in arguments, environment variables, temporary or intermediate files, pipes, logs, screenshots, agent context, or ordinary cloud storage. The only allowed master-key file is the final approved copy on encrypted USB C created under Gate 1B controls. Verification, packaging, custody placement, and elimination of Gate 1B working presentations/copies also require distinct Gate 1B authorization. Emergency mounting, master-key recovery testing, and recovery rehearsal remain unauthorized.

### 14.6 Validation

Only the metadata, count, parse-result, mount-absence, and Boolean process checks in Section 11. No mount, unlock, fallback probe, helper run, password test, master-key dump, backup, USB operation, or content creation.

An approval for one class does not imply the next. Failure or ambiguity returns control to Dan; it never expands command authority.

## 15. Stop conditions and preservation response

Stop immediately on:

- user or host not exactly `dev@PADRO-AI-CORE`;
- canonical repository mismatch or a nonempty Git index;
- gocryptfs path/version or go-fuse behavior inconsistent with this plan;
- any tool substitution, missing required command, or proposal to install/change a package;
- any path mismatch, relative path, symlink, dangling link, unexpected parent, wrong object type, or command targeting anything other than the approved production paths and their necessary parent;
- existing production content or any pre-existing production-path object requiring interpretation;
- any path-creation target not proven absent, including as a dangling link, immediately before its own `mkdir`;
- any `mkdir` existing-object error or other failure, any proposal to use `mkdir -p` or `install -d`, or any attempt to rerun, reuse, normalize, `chmod`, `chown`, delete, rename, or repair a path-creation target;
- any existing or ambiguous mount involving either production path;
- unexpected ownership or mode before or after creation;
- nonempty ciphertext before initialization or nonempty plaintext at any time;
- an automatic-mount, scheduled, startup, alias, sync, redirect, or plaintext fallback reference;
- any automatic/fallback scan error, unreadable or unexpectedly failing owner-crontab inspection, or repository automation reference other than the three T3I files subsequently proven defensive by Section 6.5;
- disposable-helper drift or any proposal to run, bypass, or adapt it in Gate 2A;
- a secret appearing in command output, evidence, transcript, screen capture, clipboard history, report, chat, agent context, or repository;
- password entry requested anywhere except the direct gocryptfs prompts;
- initialization failure, interruption, retry request, partial/unexpected configuration, missing expected artifact, or unexpected extra object;
- master-key display suppression, different recovery-material behavior, or an unexpected recovery file;
- any attempt to retain the initialization-time display, keep the terminal open as custody, or create a Gate 2A recovery copy;
- inability to end the secret-bearing initialization session without retaining output;
- any uncontrolled recovery copy or risk that one persists;
- any proposal to execute master-key retrieval/re-display before Gate 1B independently defines and authorizes the exact command and secret controls;
- any request to connect, mount, unlock, or write the recovery USB;
- any request to print, back up, mount, canary, migrate, create `active/` or `legacy/`, or test a helper;
- fallback plaintext write risk or evidence that any write targeted the unmounted plaintext path;
- unexpected gocryptfs process or mount after initialization;
- any command targeting a path other than the exact approved production paths, except metadata inspection of their fixed parents and the necessary ciphertext-parent creation described in Section 8; or
- ambiguity about whether an action belongs to Gate 2A, Gate 1B, Gate 2B, Gate 3, or Gate 4.

On a stop: preserve filesystem/object state, stop transcription/capture, end any unsafe secret-bearing terminal presentation without retaining it, record only a secret-free stop category, and request human review. Do not preserve terminal output as evidence or custody. Do not automatically retry, initialize again, repair, chmod, chown, move, overwrite, delete, clean, unmount, kill, dump a master key, substitute a path, connect a device, or broaden scope.

## 16. Gate 2A completion criteria

A future Gate 2A execution may be reported complete only when all of these are true:

- every Phase A preflight check passed under separate authority;
- Dan attested that the unique high-entropy routine password was created and saved in Bitwarden without agent access;
- the three exact production path components were each proven absent immediately before their own non-`-p` `mkdir`, created once in the required order, and immediately verified with the required `dev:dev` ownership and `0700`, `0700`, and `0500` modes respectively;
- installed gocryptfs `2.6.1` initialized the ciphertext directory exactly once;
- only `gocryptfs.conf` and `gocryptfs.diriv` exist at the empty ciphertext root;
- plaintext mountpoint remains empty, unmounted, and mode `0500`;
- no PAL operational content, canary, logical plaintext child, source migration, USB write, printed copy, or backup was made;
- no unexpected mount or associated process remains;
- Dan observed only that the expected master-key material was generated and transiently presented, without copying or exposing its value;
- Gate 2A created and retained zero master-key copies;
- the secret-bearing initialization terminal/session was ended and its output/scrollback was not retained or admitted into evidence;
- Gate 1B retrieval/re-display and creation of printed A, printed B, and encrypted USB C remain deferred to a separately reviewed exact command and human authorization;
- minimal secret-free evidence is complete;
- the Git index is unchanged; and
- work stops for human review before Gate 1B, Gate 2B, Gate 3, or Gate 4 action unless that next gate has its own explicit authorization.

## 17. Design verdict

**`GATE_2A_DESIGN_READY_FOR_HUMAN_EXECUTION_AUTHORIZATION`**

This conclusion is design readiness only. It does **not** authorize credential creation, path creation, gocryptfs initialization, recovery-material handling, validation execution, mounting, recovery-copy creation, backup, canary ingestion, staging, commit, or push.
