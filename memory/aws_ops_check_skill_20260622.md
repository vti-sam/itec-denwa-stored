---
title: AWS ops check skill added
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-06-22
  - skills/aws-ops-check/SKILL.md
  - skills/aws-ops-check/scripts/aws_ops_check.py
tags:
  - aws
  - ecs
  - ecr
  - cicd
  - database
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

Created project-local skill `skills/aws-ops-check/` for registry-driven read-only AWS, ECS, ECR, CI/CD evidence and DB connectivity checks.

Main entrypoint:

```bash
rtk uv run --with pyyaml --with psycopg2-binary python skills/aws-ops-check/scripts/aws_ops_check.py all --env dev --component frontend --commit HEAD --git-cwd sources/<source_repo> --url <smoke_url> --json
```

Validation performed:

- `quick_validate.py` passed.
- `auth` loaded AWS credentials from registry and matched account id.
- `discover` found DEV frontend ECS service.
- `ecs` described service/task definition/deployment.
- `wait-ecs` returned completed state.
- `ecr` compared live image tags with expected commit.
- `db` connected through DEV local tunnel and verified `current_database()`.
- `all` combined AWS/ECS/ECR/DB/smoke checks, and skipped GitLab clearly when no token was available.
