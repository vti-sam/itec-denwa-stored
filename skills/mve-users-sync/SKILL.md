---
name: mve-users-sync
description: Fetch and audit itec-denwa MVE SIP user registrations for DEV and PRD using project registry credentials, database system_settings, and the live MVE INI API. Use when Codex needs to list MVE users, compare DB SIP state with MVE registrations, verify DEV/PRD MVE targets, or avoid mixing this project-specific MVE workflow into generic management/source-code skills.
---

# MVE Users Sync

## Overview

Use this project-store skill for `itec-denwa` MVE user/SIP registration checks. Keep this workflow separate from generic management, Backlog, and source-code skills.

## Rules

- Read root `AGENTS.md` and `registry/AGENTS.md` before reading registry credential files.
- Run commands from repo root so `registry/`, `skills/`, and `project-store/` resolve correctly.
- Treat `registry/keystore/` values, DB passwords, MVE Basic Auth password, SIP passwords, and MVE password hashes as sensitive. Do not print them in responses or logs.
- Prefer read-only checks. This skill must not write DB rows or PUT MVE INI content unless the user explicitly requests a write workflow and approves a separate plan.
- Use DB only to discover runtime MVE target state and optional DB-side SIP/account counts. MVE Basic Auth is not stored in DB in the current repo snapshot; load it from registry.

## Environment Mapping

The script uses local SSH tunnels that match the project DB runbook:

| Environment | Database | Local DB port | DB credential key |
|---|---|---:|---|
| `dev` | `denwa_dev` | `15432` | `databases.dev` |
| `prd` | `denwa_prd` | `25432` | `databases.prd` |

For each environment, fetch `master_schema.system_settings` where `delete_flag = B'0'` and build the MVE INI URL as:

```text
https://<domain>/api/v1/files/ini
```

Load MVE Basic Auth from:

```text
registry/keystore/projects/itec-denwa/infra/staging/application.properties
```

Only read `mve.username` and `mve.password`; do not use `mve.file.ini` as the target when the task asks for DEV/PRD because DB `system_settings` is the runtime source for the endpoint.

## Quick Commands

Fetch both environments and print a grouped text report:

```bash
rtk uv run --with pyyaml --with 'psycopg[binary]' python project-store/skills/mve-users-sync/scripts/fetch_mve_users.py --env all
```

Fetch one environment as JSON:

```bash
rtk uv run --with pyyaml --with 'psycopg[binary]' python project-store/skills/mve-users-sync/scripts/fetch_mve_users.py --env prd --format json
```

Export CSV:

```bash
rtk uv run --with pyyaml --with 'psycopg[binary]' python project-store/skills/mve-users-sync/scripts/fetch_mve_users.py --env all --format csv --output scratch/mve-users.csv
```

## Output Policy

- Default output includes only `username`, `authname`, and `ip_group`.
- Do not include `password_hash` unless the user explicitly asks for MVE hash values and understands it is sensitive.
- In final responses, summarize counts and SIP usernames by environment/IP group. Avoid pasting credential paths with values.

## Troubleshooting

- If DB connection fails, verify the local SSH tunnel for the target port is running.
- If MVE fetch returns unauthorized, verify `mve.username` and `mve.password` in registry, but do not print them.
- If counts differ between DB and MVE, state that DB SIP rows and live MVE INI registrations are different sources and may legitimately diverge during registration/deletion workflows.
