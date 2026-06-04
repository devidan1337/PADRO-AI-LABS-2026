# Lessons Learned

## Format

### Lesson Title
- Context:
- Mistake or discovery:
- Technical cause:
- Fix:
- Security relevance:
- Career relevance:

Lesson:
GitHub authentication failed because WSL was a fresh Linux environment and did not yet possess an SSH keypair.

Resolution:
Generated ed25519 SSH keypair, registered public key with GitHub, validated via ssh -T.

Concept Learned:
Trust relationships in Git are based on keypairs rather than account passwords.

Lab: 01

Lesson:
Codex can be used as an implementation engineer while maintaining architectural control.

Observation:
Providing explicit constraints such as "Do not modify existing files without asking" resulted in disciplined behavior and predictable outputs.

Takeaway:
Agent supervision and instruction quality directly impact implementation outcomes.
