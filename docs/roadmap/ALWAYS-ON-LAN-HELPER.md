# Future Project: Always-On LAN Helper Node

## Purpose

This future project adds a low-cost, low-power device to PADRO-AI-LABS-2026 that remains online even when the main lab desktop is unavailable, sleeping, rebooting, or under maintenance.

The always-on node is not intended to be an AI compute device. It is an infrastructure helper.

## Primary Functions

The always-on LAN helper should provide:

* Wake-on-LAN support for PADRO-WIN-CORE
* Tailscale presence on the home network
* Basic uptime monitoring
* Lightweight health checks
* Future alert relay capability
* Basic syslog or log forwarding support
* Simple dashboard or status endpoint
* Future support for remote recovery workflows

## Candidate Hardware

Minimum practical class:

```text
Raspberry Pi 3 Model B / B+
1GB RAM
Ethernet
Low power draw
Enough CPU for Tailscale, wake helper, and basic monitoring
```

Preferred class:

```text
Raspberry Pi 4 Model B 2GB
Better CPU
More RAM
True Gigabit Ethernet
Better long-term headroom
```

Ultra-budget option:

```text
Raspberry Pi Zero 2 W
Very low cost
Low power
Enough CPU for simple helper tasks
Limited by 512MB RAM and weak Ethernet options
Better for lightweight Wi-Fi helper use than core LAN infrastructure
```

## Recommendation

The preferred purchase target is the lowest-cost Raspberry Pi 4 Model B 2GB available from a reputable source.

If Pi 4 pricing is inflated, a used Raspberry Pi 3B or 3B+ is acceptable for Wake-on-LAN, Tailscale, and basic monitoring.

The Zero 2 W should only be selected if the goal is lowest possible cost and the limitations of Wi-Fi, adapters, and 512MB RAM are acceptable.

## VLAN Placement

The always-on node should be placed on the AI VLAN or an infrastructure sub-zone of the AI VLAN.

Recommended logical placement:

```text
AI VLAN / Lab Infrastructure Segment
```

The node should have limited firewall access.

Allowed:

* Outbound internet for updates
* Tailscale connectivity
* Wake-on-LAN to lab host
* Monitoring access to approved lab nodes
* SSH from trusted Tailnet devices

Denied:

* Broad access to personal devices
* Broad access to work devices
* Public inbound internet access
* Unrestricted access to sensitive networks

## Future Network Role

Potential future roles:

```text
PADRO-AI-LAN-HELPER
PADRO-AI-WAKE
PADRO-AI-MON-LITE
PADRO-AI-EDGE-LITE
```

Preferred hostname:

```text
PADRO-AI-LAN
```

## Security Requirements

The always-on node should follow these requirements:

* SSH key authentication only
* Password SSH disabled after setup
* Root SSH disabled
* Automatic updates considered
* Tailscale enabled
* No public port forwarding
* Minimal installed services
* Logs reviewed periodically
* Configuration documented in the repository

## Portfolio Value

This project demonstrates:

* Secure remote access design
* Power availability planning
* Network segmentation
* Infrastructure monitoring
* Low-power edge administration
* Defensive architecture
* Operational resilience
* Practical home lab governance

This is a strong GRC, security, network operations, and AI infrastructure artifact because it shows that the lab is designed for availability, control, and risk reduction rather than just experimentation.

