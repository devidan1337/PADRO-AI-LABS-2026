# Remote Access Architecture

## Purpose
Provide secure private remote access to PADRO-AI-LABS without exposing public inbound ports.

## Current Design
- Tailscale installed on Windows host
- Tailscale installed inside Ubuntu WSL
- Ubuntu WSL has its own Tailnet identity
- Remote access is private through the Tailnet
- No router port forwarding
- No public SSH exposure

## Access Flow
Remote Device → Tailscale → Windows Host / Ubuntu WSL → Lab Services

## Security Rules
- Use SSH over Tailscale only
- Avoid exposing Ollama, Docker, dashboards, or Jupyter publicly
- Keep public services behind future VPS or Cloudflare Tunnel layer
- Use SSH keys before making this a regular workflow

## Future Enhancements
- Add SSH key-only authentication
- Add UFW rule allowing SSH only on tailscale0
- Add VPS relay node
- Add Cloudflare Tunnel for selected portfolio-facing dashboards
- Add logging and monitoring for remote access
