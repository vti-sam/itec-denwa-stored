---
title: Frontend PRD publish 2026-07-06
project: itec-denwa
type: runbook
status: archived
source:
  - Codex Front PRD publish task on 2026-07-06
  - sources/denwa-front
  - AWS ECS PRD verification
  - GitLab pipeline 716412
tags:
  - frontend
  - prd
  - publish
  - gitlab
  - ecs
scope: historical
captured_at: 2026-07-06
validity: historical_context
promote_to_knowledge: false
---

2026-07-06: Published `sources/denwa-front` to PRD by merging `origin/dev` into `prd` and pushing merge commit `986845fa63da4b16cbd11c1102bab0a02974cf09`.

GitLab pipeline:

- Project: `itec_denwa_app/denwa-front`
- Pipeline: `716412`, IID `226`
- Ref: `prd`
- Status: `success`
- Jobs `test_frontend_prd`, `build_and_push_to_ecr_prd`, and `deploy_to_ecs_prd` all succeeded.

AWS PRD frontend:

- Cluster: `denwa-prd-cluster`
- Service: `denwa-frontend-prd-service`
- Task definition: `denwa-frontend-prd:18`
- Image: `668426476432.dkr.ecr.ap-northeast-1.amazonaws.com/itec-denwa-frontend:1.0.0-226`
- ECR tags: `1.0.0-226`, `1.0.0-226-986845fa`
- Image digest: `sha256:f08002b93c685deec6ff05a83a2145a3f1fdf55da862b32c05c0e6a05b328454`
- Rollout: `COMPLETED`, running `1/1`, pending `0`
- ECS running container digest matched ECR.

Smoke:

- `https://apl.purattocall.com/admin/login` returned HTTP 200.
- HTML had `cache-control: no-cache`.
- Asset `/assets/index-DYyCTzJF.js` had immutable cache headers.
- Bundle contained `api.apl.purattocall.com`.

API PRD status checked during this task:

- `origin/prd` API commit: `6a0c5b1801c8c0ef48f1a5d1c9877b65a6fef59b`
- ECS backend service was already on `denwa-backend-prd:25`, image `itec-denwa-backend:1.1.1-486`, rollout `COMPLETED`, running `1/1`.
- The related GitLab pipeline IID `486` showed failed in GitLab, but ECS/ECR were already serving image tag `1.1.1-486`.
