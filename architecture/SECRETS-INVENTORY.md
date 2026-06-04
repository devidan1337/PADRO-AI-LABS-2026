# Secrets Inventory

## Current Secrets

### GitHub SSH Key

Owner:
Dan

Purpose:
GitHub authentication

Location:
~/.ssh/id_ed25519

Authority Granted:
Push/pull repository changes

Rotation Method:
Generate new key pair

Revocation Method:
Remove public key from GitHub

---

### OpenAI API Key

Status:
Not yet deployed

---

### Anthropic API Key

Status:
Not yet deployed

---

### Telegram Bot Token

Status:
Not yet deployed

---

### VPS Credentials

Status:
Not yet deployed

---

### Tailscale Authentication

Status:
Not yet deployed

## Secret Inventory Table

| Secret             | Status  | Owner | Location          | Authority Granted  | Rotation Method        | Revocation Method             |
| ------------------ | ------- | ----- | ----------------- | ------------------ | ---------------------- | ----------------------------- |
| GitHub SSH Key     | Active  | Dan   | ~/.ssh/id_ed25519 | Repository access  | Generate new key pair  | Remove public key from GitHub |
| OpenAI API Key     | Planned | Dan   | Not deployed      | Model/API access   | Rotate API key         | Delete key in provider portal |
| Anthropic API Key  | Planned | Dan   | Not deployed      | Model/API access   | Rotate API key         | Delete key in provider portal |
| Telegram Bot Token | Planned | Dan   | Not deployed      | Bot control        | Regenerate token       | Revoke via BotFather          |
| VPS SSH Key        | Planned | Dan   | Not deployed      | VPS administration | Generate new key pair  | Remove authorized key         |
| Tailscale Identity | Planned | Dan   | Not deployed      | Mesh VPN access    | Re-authenticate device | Remove device from tailnet    |

## Secret Locations Discovered

### WSL

Current locations requiring protection:

* ~/.ssh/
* ~/.config/
* ~/.npm/
* ~/.local/
* ~/.cache/

### Repository

Verified secret-free locations:

* reports/
* architecture/
* roadmap/
* labs/
* memory/

### Future Locations

* .env
* .env.local
* Hermes configuration
* Telegram configuration
* VPS credentials
* Tailscale configuration
