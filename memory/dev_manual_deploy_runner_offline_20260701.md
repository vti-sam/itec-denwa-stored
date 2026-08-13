---
title: DEV manual deploy khi GitLab runner devops offline
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-01 GitLab/AWS CI/CD pending check and manual DEV deploy
tags:
  - gitlab
  - runner
  - cicd
  - ecs
  - ecr
  - dev
  - denwa-api
  - denwa-front
scope: historical
captured_at: 2026-07-01
validity: historical_context
promote_to_knowledge: false
---

2026-07-01: DEV pipelines pending do GitLab runner tag `devops` offline, không phải do AWS/ECS.

- `denwa-api` pipeline `714154` / IID `482`, ref `dev`, commit `0a4d84b72a2ed54a332a2ae0c82c962f0cdfffab`, job `build_and_push_to_ecr_dev` pending.
- `denwa-front` pipeline `714151` / IID `222`, ref `dev`, commit `a60030a7c8e6a75fc8fa3289b8f87e68f6fa5233`, job `test_frontend_dev` pending.
- GitLab runner `1024` tag `devops` active but offline. Runner manager `497` last contacted `2026-06-30T23:03:28+07:00`, private IP `10.1.37.188`; no matching EC2 instance found in AWS account `668426476432` across available regions.

Manual DEV deploy was performed from `origin/dev` snapshots in `scratch/manual-deploy-20260701-191454/` because runner was unavailable:

- API: Maven package with tests skipped succeeded, Docker image built as linux/amd64 and pushed to ECR tag `itec-denwa-backend:1.1.1-482`, digest `sha256:9a07eb50d1d13750b49e186feeec5e2ce0dced423b9c61e6ff436256e3b7f598`.
- Frontend: Node 18 type-check succeeded, Docker image built with `VITE_API_BASE_URL=https://api-dev.apl.purattocall.com`, pushed to ECR tags `itec-denwa-frontend:1.0.0-222` and `itec-denwa-frontend:1.0.0-222-a60030a7`, digest `sha256:cc469977fbd75197bb1947130e524d8117f51647a4c214c476d8f1aff946d48a`.
- ECS DEV backend service `denwa-backend-task-service-4mh4rz2a` updated to task definition `denwa-backend-task:269` and reached `PRIMARY:COMPLETED`, running `1/1`.
- ECS DEV frontend service `denwa-frontend-service` updated to task definition `denwa-frontend:149` and reached `PRIMARY:COMPLETED`, running `1/1`.

Manual deploy intentionally did not stop running ECS tasks before `update-service`; this avoided the older CI gotcha where stopping tasks first could make ECS restart the previous revision while deployment was pending.

Verification:

- Running backend task image digest matched ECR digest for `1.1.1-482`.
- Running frontend task image digest matched ECR digest for `1.0.0-222`.
- Frontend smoke passed for `https://dev.apl.purattocall.com/admin/login`: `cache-control: no-cache`, CSP header present, asset cache `max-age=31536000`, bundled JS contained `api-dev.apl.purattocall.com`.
- Backend DEV smoke returned HTTP `200` for `/swagger-ui/index.html` and `/v3/api-docs`; `/` and `/actuator/health` returned `401` due auth.

Important: GitLab pipeline status remained `pending` after manual AWS deploy because runner `devops` was still offline. Retry will not help until runner is restored or an online runner with matching tag is attached.
