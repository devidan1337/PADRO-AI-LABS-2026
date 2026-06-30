# Lab05 – Initial OPNsense Deployment

## Objective

Deploy the foundational firewall platform for PADRO-AI-LABS using enterprise hardware and establish the security boundary for all future infrastructure.

---

## Hardware

Platform:
Supermicro SYS-5019A-FN5T

CPU:
Intel Atom C3959

Memory:
64 GB ECC RDIMM

Primary Storage:
SanDisk 256 GB NVMe SSD

Secondary Storage:
3 TB SATA HDD (preserved)

Networking

2 × Intel I210 1Gb

4 × Intel X553/X557 10Gb

Dedicated IPMI

---

## Installation Decisions

Filesystem

Selected:

ZFS

Reasoning

• Enterprise-grade filesystem
• Snapshot capability
• Upgrade rollback
• Filesystem integrity
• Long-term reliability

---

## Storage Layout

Installed:

ada0
SanDisk 256GB NVMe

Preserved:

ada1
3 TB SATA HDD

The secondary drive remains untouched for future logging, backups, packet capture, or NAS experimentation.

---

## Validation

Successfully verified

✓ BIOS POST

✓ UEFI boot

✓ USB installer

✓ NVMe detection

✓ SATA preservation

✓ ZFS installation

✓ First successful boot

---

## Initial Interface Assignment

LAN

igb0

192.168.1.1/24

WAN

ix0

Pending DHCP verification

---

## Notes

The firewall was temporarily connected behind the existing Deco router to allow safe staged deployment without impacting the production home network.

Future deployment will place OPNsense as the primary gateway.

---

## Lessons

Never install until storage devices have been positively identified.

Capture evidence throughout installation.

Preserve secondary storage until a production use case is selected.

Treat infrastructure deployment as an engineering project rather than a software installation.
