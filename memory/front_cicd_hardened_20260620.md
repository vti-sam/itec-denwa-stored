---
title: Frontend CI/CD deployment hardening
project: itec-denwa
type: gotcha
status: archived
source:
- memory/front_cicd_hardened_20260620.md
tags:
- frontend
- cicd
- ecs
- dev
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

2026-06-20: Frontend pipeline was hardened on branch `dev` in commit `b32f70a`.

Key changes:

- Test jobs now run `npm run type-check` and fail the pipeline on type errors.
- Removed manual `aws ecs stop-task` from DEV/STG/PRD deploy jobs. ECS rolling deployment now controls task replacement.
- Build jobs push both the pipeline IID tag and a commit-short-SHA tag, for example `1.0.0-203` and `1.0.0-203-b32f70ab`.
- Deploy jobs verify the service is running the expected task definition.
- Deploy jobs smoke-test the frontend URL, HTML `cache-control: no-cache`, security header presence, asset cache header, and the expected bundled API host.

DEV verification after push:

- ECR image `itec-denwa-frontend:1.0.0-203` and `1.0.0-203-b32f70ab` were created.
- ECS service `denwa-frontend-service` completed deployment to task definition `denwa-frontend:135`.
- The task definition image is `668426476432.dkr.ecr.ap-northeast-1.amazonaws.com/itec-denwa-frontend:1.0.0-203`.
- `https://dev.apl.purattocall.com/admin/login` returns `cache-control: no-cache`.
- Live bundle contains `api-dev.apl.purattocall.com`, `login-with-role`, and `error-line`.
