# Remote Access Diagram

## Current Design

```mermaid
flowchart TD
    A[PADRO-GRAM Remote Workstation] -->|Tailscale| B[PADRO-AI-CORE Ubuntu WSL]
    A -->|Tailscale| C[PADRO-WIN-CORE Windows Host]
    C --> B
    B --> D[PADRO-AI-LABS-2026 Repository]
    B --> E[Docker / Lab Services]
    B --> F[Ollama / Local AI Tools]
    B --> G[Monitoring and Automation Tools]
```

## Future Design With Always-On LAN Helper

```mermaid
flowchart TD
    A[PADRO-GRAM Remote Workstation] -->|Tailscale| B[PADRO-AI-LAN Always-On Helper]
    A -->|Tailscale SSH| C[PADRO-AI-CORE Ubuntu WSL]
    C --> D[PADRO-WIN-CORE Windows Host]
    B -->|Wake-on-LAN| D
    B -->|Health Checks| C
    B -->|Health Checks| D
    B -->|Future Alerts| E[Phone / Telegram / Email]
    C --> F[PADRO-AI-LABS-2026 Repository]
    C --> G[Docker / Ollama / Monitoring]
```

## Design Principle

The always-on helper is not the main lab. It is the recovery, monitoring, and availability node.

The main lab remains on PADRO-WIN-CORE and PADRO-AI-CORE. The helper exists to keep the environment reachable, observable, and recoverable.
