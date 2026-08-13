---
title: Add project-local MVE users sync skill
project: itec-denwa
type: lesson
status: archived
source:
  - project-store/skills/mve-users-sync/SKILL.md
  - project-store/skills/mve-users-sync/scripts/fetch_mve_users.py
tags:
  - mve
  - sip-users
  - skill
  - dev
  - prd
scope: historical
captured_at: 2026-06-30
validity: historical_context
promote_to_knowledge: false
---

# Add project-local MVE users sync skill

Created `project-store/skills/mve-users-sync/` as a project-specific skill for fetching and auditing DEV/PRD MVE SIP registrations without mixing this workflow into generic management or source-code skills.

The skill uses DB `master_schema.system_settings` as the runtime source for each MVE endpoint and uses registry MVE Basic Auth only inside the script. Default output excludes DB passwords, MVE Basic Auth password, SIP passwords, and MVE password hashes.

Validated with:

```bash
rtk uv run --with pyyaml python /Users/vti-sam/.codex/skills/.system/skill-creator/scripts/quick_validate.py project-store/skills/mve-users-sync
rtk uv run --with pyyaml --with 'psycopg[binary]' python project-store/skills/mve-users-sync/scripts/fetch_mve_users.py --env all
```

Fetch verification returned DEV `25` users from `c2.cd-demo-mve.com` and PRD `30` users from `app-mve.purattocall.com`.
