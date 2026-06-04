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
