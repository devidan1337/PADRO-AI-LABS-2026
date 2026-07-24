# PAL Validation Evidence Standard

## Evidence classes

- Public: sanitized diagrams, procedures, outcomes
- Internal: private addressing, management details, raw operational output
- Restricted: credentials, keys, tokens, configuration exports, packet captures with sensitive content

## Naming

```text
YYYY-MM-DD-labXX-sequence-description.ext
```

## Minimum metadata

- date/time/timezone
- operator
- system/lab
- related change/commit
- source and destination zone for network tests
- expected and actual result
- redaction status

## Rules

- Never capture or publish passwords/private keys.
- Create sanitized copies; do not overwrite originals.
- Hash critical evidence when chain-of-custody matters.
- Keep raw logs and configuration exports out of public Git.
- Link evidence from reports using stable relative paths.
- Review screenshots for browser sessions, addresses, usernames, and serial numbers.
