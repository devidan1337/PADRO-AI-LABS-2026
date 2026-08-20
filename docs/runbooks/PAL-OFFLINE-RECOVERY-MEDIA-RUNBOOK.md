# PAL Offline Recovery Media Runbook

> **purpose: REPEATABLE OWNER-CONTROLLED ACCESS TO THE PAL OFFLINE LUKS2 RECOVERY USB**
>
> **default state: PHYSICALLY OFFLINE, USBIPD NOT SHARED, LUKS CLOSED, PLAINTEXT UNMOUNTED**
>
> **production-content status at publication: NOT YET POPULATED OR AUTHORIZED**

## 1. Scope and authority

Use this runbook only for a separately authorized recovery-copy population, inspection, readability test, recovery test, or actual recovery operation. It does not authorize creating or changing credentials, repartitioning, formatting, initializing LUKS, changing keyslots, repairing a filesystem, or copying real recovery material before the recovery-copy/custody gate is approved.

The human owner controls every unlock and every destructive or security-sensitive decision. Automation may collect secret-free state and enforce gates, but it must never supply a credential or choose to continue after a mismatch.

## 2. Known identity record

The 2026-08-20 validated medium had this correlated identity:

| Layer | Validated value |
|---|---|
| Windows disk | `Disk 2` |
| Device description | `Generic Flash Disk` / `Alcor Micro` |
| Serial | `2371DC58` |
| VID:PID | `058f:6387` |
| USBIPD BUSID during validation | `2-1` |
| Linux device path during validation | `/dev/sde` |
| LUKS partition during validation | `/dev/sde1` |
| Mapper name | `pal_recovery` |
| Filesystem | `ext4`, label `PAL-RECOVERY` |

Windows disk numbers, USBIPD BUSIDs, and Linux `/dev/sdX` names can change after reconnection or restart. The serial is the primary durable identity. Never reuse `Disk 2`, `2-1`, `/dev/sde`, or `/dev/sde1` without re-deriving and correlating them in the current session.

## 3. Absolute prohibitions

- Never put a passphrase in a command argument, environment variable, script, key file, pipe, redirected standard input, clipboard-driven automation, shell history, transcript, log, screenshot, evidence file, report, Git object, or chat.
- Never put passwords, recovery codes, TOTP seeds, QR codes, Proton recovery data, Bitwarden credentials, LUKS secret fields, or secret-bearing terminal output in evidence.
- Never enable automatic unlock, a stored key, persistent automount, startup attachment, or unattended remount.
- Never operate on an unverified `/dev/sdX` or partition.
- Never write recovery material to ordinary Google Drive, Git, issue trackers, chat, prompts, or another unapproved cloud/sync destination.
- Never run partitioning, formatting, LUKS initialization, keyslot, repair, or other destructive commands without a separate authorization and complete serial/device correlation.
- Never use the recovery USB as the routine ciphertext-backup drive.

## 4. Stop conditions

Stop, preserve state, and request human review if any of these occurs:

- serial, model, capacity, VID:PID, Windows disk number, USBIPD BUSID, Linux transport, or resolved block device does not correlate;
- more than one candidate device matches, or the serial is missing;
- the expected USB is already mounted, mapped, shared, or attached in an unexplained state;
- an unexpected partition, filesystem, mapper, mount, nested mount, process, or open handle appears;
- `cryptsetup isLuks` does not return success for the verified partition;
- unlock fails, behaves unexpectedly, or requests the credential outside the direct interactive prompt;
- the mapper does not resolve to the verified partition;
- the mounted filesystem is not the expected ext4 filesystem from `/dev/mapper/pal_recovery`;
- authorized source content, classification, custody destination, or approval is ambiguous;
- a hash/integrity comparison fails;
- secret scanning finds a secret in proposed evidence or ordinary repository/cloud output;
- unmount or LUKS close fails;
- mapper or plaintext mount remains after closeout;
- USBIPD cannot detach/unbind or cannot confirm `Not shared`; or
- any command would target the device based only on a remembered `/dev/sdX` name.

Do not automatically retry, repair, clean up unexpected objects, force-unmount an unknown filesystem, or select another device.

## 5. Windows privileged side — identify, share, and attach

Run this section from the approved Windows administrative environment. Keep full terminal transcription disabled before any interactive credential step.

1. Connect only the intended recovery USB.
2. Inspect Windows disks and record secret-free current-session metadata:

   ```powershell
   Get-Disk | Format-Table Number,FriendlyName,SerialNumber,BusType,Size,OperationalStatus
   Get-CimInstance Win32_DiskDrive | Format-Table Index,Model,SerialNumber,PNPDeviceID,Size
   ```

3. Require the intended serial `2371DC58`, expected description/capacity, and USB bus. Identify the current Windows disk number; do not assume it remains `Disk 2`.
4. Inspect USBIPD state:

   ```powershell
   usbipd list
   ```

5. Correlate the current BUSID and VID:PID `058f:6387` with the same physical serial/device. Do not assume the BUSID remains `2-1`.
6. Bind/share only the correlated BUSID when required:

   ```powershell
   usbipd bind --busid <CURRENT-BUSID>
   ```

7. If USBIPD reports the known USBPcap compatibility warning, stop and review it. Use `--force` only with explicit human approval and only after repeating the full identity correlation:

   ```powershell
   usbipd bind --busid <CURRENT-BUSID> --force
   ```

8. Attach the exact shared device to the intended WSL distribution:

   ```powershell
   usbipd attach --wsl --busid <CURRENT-BUSID>
   ```

9. Leave the Windows session available for closeout. Do not leave sharing configured after the operation.

## 6. Linux side — verify before access

Run this section only after Windows correlation and attach succeed.

1. Confirm the execution identity and intended host. Keep the privileged Windows execution context separate from canonical PAL documentation work.
2. Inspect USB descriptors and block devices without changing them:

   ```bash
   lsusb
   lsblk -o NAME,PATH,SIZE,MODEL,SERIAL,TRAN,TYPE,FSTYPE,LABEL,MOUNTPOINTS
   ```

3. Require all of the following before continuing:

   - serial `2371DC58`;
   - USB transport;
   - expected model/capacity;
   - VID:PID `058f:6387` in USB descriptor output;
   - one intended LUKS partition; and
   - no plaintext mount and no unexpected mapper.

4. Resolve the current device and partition from this session. If a `/dev/disk/by-id/` link containing the verified serial exists, prefer it for correlation. Confirm its resolved block device with `readlink -f`, `lsblk`, and `udevadm info`. Do not continue from a remembered `/dev/sde` value.
5. Verify LUKS on the resolved partition:

   ```bash
   sudo cryptsetup isLuks <VERIFIED-PARTITION>
   ```

6. Continue only on exit `0`.

## 7. Linux side — interactive unlock and controlled mount

1. Confirm `/dev/mapper/pal_recovery` is absent and the approved mountpoint is empty and unmounted.
2. Open LUKS interactively:

   ```bash
   sudo cryptsetup open <VERIFIED-PARTITION> pal_recovery
   ```

   Enter the passphrase only at the direct `cryptsetup` prompt. The owner must retain control; no agent, script, pipe, argument, password manager automation, or transcript may receive it.

3. Verify the mapper resolves to the exact verified partition and reports an active crypt mapping:

   ```bash
   sudo cryptsetup status pal_recovery
   lsblk -o NAME,PATH,SIZE,MODEL,SERIAL,TRAN,TYPE,FSTYPE,LABEL,MOUNTPOINTS
   ```

4. Mount only at the pre-approved controlled mountpoint:

   ```bash
   sudo mount -t ext4 /dev/mapper/pal_recovery <APPROVED-MOUNTPOINT>
   ```

5. Verify the exact source, target, type, and read/write state:

   ```bash
   findmnt --mountpoint <APPROVED-MOUNTPOINT> -o TARGET,SOURCE,FSTYPE,OPTIONS
   ```

6. Continue only if the source is `/dev/mapper/pal_recovery`, the target is exact, and the type is `ext4`.

## 8. Perform the authorized recovery operation

1. Reconfirm the specific human approval, purpose, source, destination, classification, and custody record.
2. If the recovery-material custody gate has not been approved, perform no real-material copy.
3. Access or copy only the explicitly authorized recovery item. Do not browse unrelated content or create extra copies.
4. Keep the material entirely inside the controlled plaintext view and its approved offline source/destination. Do not route it through the canonical repository, ordinary Google Drive, Git, chat, prompts, screenshots, or evidence capture.
5. Verify copied bytes locally. For real recovery material, record only an opaque item identifier and `MATCH`/`PASS` outcome in secret-free evidence; do not publish a digest that could validate guesses against low-entropy recovery data.
6. Confirm the intended login or recovery function independently where the governing custody procedure requires it. Credential creation or copying is incomplete until custody and actual recovery usability have both been verified.

## 9. Linux side — synchronize, unmount, close, and prove absence

1. Finish all authorized writes and close applications using the mount.
2. Synchronize pending writes:

   ```bash
   sync
   ```

3. Verify the mount relationship one last time, then unmount the exact approved target:

   ```bash
   findmnt --mountpoint <APPROVED-MOUNTPOINT> -o TARGET,SOURCE,FSTYPE,OPTIONS
   sudo umount -- <APPROVED-MOUNTPOINT>
   ```

4. Prove the plaintext mount is absent. If it remains, stop; do not force unmount automatically.
5. Close the exact mapper:

   ```bash
   sudo cryptsetup close pal_recovery
   ```

6. Prove both controls:

   ```bash
   test ! -e /dev/mapper/pal_recovery
   findmnt --mountpoint <APPROVED-MOUNTPOINT>
   ```

   The mapper check must succeed as absent, and `findmnt` must return no mount for the target. Recheck with `lsblk` and confirm the verified partition remains `crypto_LUKS` with no mountpoint.

## 10. Windows closeout and physical custody

1. After Linux proves the mapper and plaintext mount absent, detach the current BUSID if it remains attached:

   ```powershell
   usbipd detach --busid <CURRENT-BUSID>
   ```

2. Remove sharing:

   ```powershell
   usbipd unbind --busid <CURRENT-BUSID>
   ```

3. Inspect status:

   ```powershell
   usbipd list
   ```

4. Require the exact device to report `Not shared`.
5. Safely disconnect the physical USB and return it to its approved offline custody location. It must remain separate from the routine ciphertext-backup drive and from the two printed recovery copies.

## 11. Secret-free evidence record

An operational record may include:

- date/time and human approver;
- purpose and authorization identifier;
- secret-free device correlation outcome;
- software version;
- pre/post shared, attached, mapper, and mount states;
- authorized recovery-item inventory identifier;
- integrity comparison `MATCH`/`MISMATCH` without secret-bearing content;
- unmount and close result;
- final `crypto_LUKS`/mapper-absent/mount-absent result; and
- final USBIPD `Not shared` result.

Treat hostnames, usernames, device serials, disk numbers, BUSIDs, device paths, mapper names, and custody inventory identifiers as internal identifiers. Exclude passwords, recovery material, secret-derived hints, LUKS secret fields, UUIDs, QR codes, TOTP seeds, recovery codes, private locations, and secret-bearing screenshots or transcripts.

## 12. Completion condition

The operation is complete only when authorized content work and integrity validation have finished, Linux reports no plaintext mount and no mapper, Windows reports the device `Not shared`, the USB is physically offline in approved custody, and the secret-free execution record has passed review.
