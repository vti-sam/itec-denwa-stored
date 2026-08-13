---
title: AWS ops GitLab revision compare workflow
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session updating skills/aws-ops-check compare-revision workflow
tags:
  - aws
  - gitlab
  - ecs
  - ecr
  - deployment
scope: historical
captured_at: 2026-06-24
validity: historical_context
promote_to_knowledge: false
---

2026-06-24: updated `skills/aws-ops-check/` so "latest revision reflected in infra" checks compare GitLab source revision instead of only ECS/ECR latest state.

Use:

```bash
rtk uv run --with pyyaml python skills/aws-ops-check/scripts/aws_ops_check.py compare-revision --env dev --component backend --git-cwd sources/denwa-api --ref dev --json
rtk uv run --with pyyaml python skills/aws-ops-check/scripts/aws_ops_check.py compare-revision --env dev --component frontend --git-cwd sources/denwa-front --ref dev --json
```

The command resolves `origin/<ref>`, queries GitLab for the exact SHA pipeline, compares pipeline IID to the live ECR tag, checks ECS latest ACTIVE task definition, and verifies running task image/digest against ECR.

The script wraps AWS CLI calls with credentials from the registry CSV when shell env/profile credentials are absent, and it can read GitLab token from environment or `git credential fill`. Do not print token values.
