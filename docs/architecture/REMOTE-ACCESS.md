# Remote Access Architecture

## Purpose

Provide secure private remote access to PADRO-AI-LABS without exposing public inbound ports.

The goal is to make the lab remotely reachable without exposing the home router, SSH, AI services, dashboards, development tools, or monitoring interfaces directly to the public internet.

## Current Design

* Tailscale installed on Windows host
* Tailscale installed inside Ubuntu WSL
* Ubuntu WSL has its own Tailnet identity
* Remote access is private through the Tailnet
* No router port forwarding
* No public SSH exposure
* Remote workstation joined to the same Tailnet
* SSH key authentication is the target access method

## Current Nodes

| Node           | Role                       | Notes                               |
| -------------- | -------------------------- | ----------------------------------- |
| PADRO-WIN-CORE | Main Windows lab host      | Physical desktop / WSL host         |
| PADRO-AI-CORE  | Ubuntu WSL lab environment | Main Linux lab workspace            |
| PADRO-GRAM     | Remote access workstation  | Remote device used to reach the lab |

## Access Flow

Remote Device → Tailscale → Windows Host / Ubuntu WSL → Lab Services

Expanded flow:

```text
PADRO-GRAM
    |
    | Tailscale private overlay network
    |
PADRO-AI-CORE / Ubuntu WSL
    |
    | Local lab services
    |
PADRO-AI-LABS-2026 repo, Docker, Ollama, monitoring, automation tools
```

## Current Repository Context

Current Ubuntu WSL user:

```text
d4n
```

Current local repository path:

```text
/home/d4n/projects/PADRO-AI-LABS-2026
```

Expected SSH format from a remote machine:

```bash
ssh d4n@<PADRO-AI-CORE-TAILSCALE-IP>
```

## Security Rules

* Use SSH over Tailscale only
* Avoid exposing Ollama, Docker, dashboards, or Jupyter publicly
* Keep public services behind future VPS or Cloudflare Tunnel layer
* Use SSH keys before making this a regular workflow
* Do not commit SSH keys or secrets to the Git repository
* Avoid using Administrator/root accounts for daily remote access
* Keep public-facing services separate from private administrative access

## Power Availability Configuration

The main lab Windows host has been configured for improved remote availability.

Applied power policy:

```text
Computer sleep on AC power: never
Display timeout on AC power: 15 minutes
Hibernate on AC power: never
```

Commands applied on the Windows lab host:

```powershell
powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-ac 15
powercfg /change hibernate-timeout-ac 0
```

This allows the lab machine to remain reachable while plugged in, while still allowing the display to turn off.

## Sleep and Wake Limitation

If the main lab machine enters sleep or hibernation, Tailscale, WSL, SSH, Docker, Ollama, and local lab services may become unreachable.

The near-term approach is to prevent sleep while plugged in.

The long-term approach is to add a low-power always-on LAN helper device.

## Always-On LAN Helper Concept

A future low-power device should provide basic availability support even when the main lab desktop is sleeping, rebooting, or unavailable.

Potential functions:

* Wake-on-LAN support for PADRO-WIN-CORE
* Tailscale presence on the home network
* Basic uptime monitoring
* Lightweight health checks
* Future alert relay capability
* Simple status endpoint
* Remote recovery support

Recommended placement:

```text
AI VLAN / Lab Infrastructure Segment
```

The always-on device should not be treated as the primary AI compute node. It should be treated as a lightweight infrastructure helper.

## Future Enhancements

* Add SSH key-only authentication
* Disable password-based SSH after key login is confirmed
* Disable root SSH login
* Restrict SSH to the Tailscale interface where possible
* Add a low-power always-on LAN helper node
* Add Wake-on-LAN support for PADRO-WIN-CORE
* Add lightweight monitoring from the always-on node
* Add Tailscale subnet routing if needed
* Add VPS relay for selected public-facing or notification workflows
* Add Cloudflare Tunnel for selected portfolio-facing services
* Add centralized logging and alerting
* Document recovery procedures

