---
title: DEV manual deploy API MR 412 and Front MR 244 2026-07-03
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-03 merge API MR 412 and Front MR 244, manual DEV deploy
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
captured_at: 2026-07-03
validity: historical_context
promote_to_knowledge: false
---

2026-07-03: merged API MR `!412` and Front MR `!244` into `dev`, fixed a Front type-check issue, then manually deployed to AWS DEV because GitLab runner `devops` was still not picking jobs.

Merged MRs:

- `itec_denwa_app/denwa-api!412`: `Hotfix ITEC_DENWA_APP-236 sub`.
  - Source branch: `hotfix-ITEC_DENWA_APP-236-subb`.
  - Source commit: `7c77a94aa654f03cf0e6aab45c5697bba221bf34`.
  - Merge commit: `409c255930adb85bbcbff1dacfe8e44decb2e39a`.
  - GitLab pipeline: `715790` / IID `484`, still `pending`; job `build_and_push_to_ecr_dev` had `runner: null`.
- `itec_denwa_app/denwa-front!244`: `Hotfix itec denwa app 236 subb`.
  - Source branch: `hotfix-ITEC_DENWA_APP-236-subb`.
  - Source commit: `c0150bef4bb6f275280c8ed50043e28365508243`.
  - Merge commit: `338b33df83dd573caac61238a905305c68e97cf7`.
  - Merge pipeline `715791` / IID `224` was canceled after a direct fix commit was pushed to `dev`.

Front fix:

- Direct `dev` commit: `1e0629e01d3cd12ad6396925726c4348a8479a1c` (`Fix tenant history timestamp formatting type`).
- Changed `formatDateTime` in `TenantDetails.vue` and `TenantEdit.vue` to accept `string | Date` and format `new Date(timestamp)`.
- Reason: `npm run type-check` failed because `history.changedAt` was `string | Date` but the local formatter accepted only `number`.
- Front fix pipeline: `715812` / IID `225`, still `pending`; job `test_frontend_dev` had `runner: null`.

Manual deploy source:

- API snapshot: `scratch/manual-deploy-20260703-182231/denwa-api` from `origin/dev` at `409c255930adb85bbcbff1dacfe8e44decb2e39a`.
- Front snapshot: `scratch/manual-front-deploy-20260703-183809` from `origin/dev` at `1e0629e01d3cd12ad6396925726c4348a8479a1c`.

Build and push:

- API Maven package with tests skipped succeeded using JDK 21.
- API Docker image built as `linux/amd64` and pushed to ECR tag `itec-denwa-backend:1.1.1-484`, digest `sha256:abd6cfb267a58e6480debb0f8348eff7a630f4ebc29cf8368fba9065171e3c95`.
- Front `npm ci` and `npm run type-check` passed after the fix.
- Front Docker image built with `VITE_API_BASE_URL=https://api-dev.apl.purattocall.com` and pushed to ECR tags `itec-denwa-frontend:1.0.0-225` and `itec-denwa-frontend:1.0.0-225-1e0629e`, digest `sha256:d071bd405652bc2e470ea98d724af2cf810dc1df0ace27ad9f4b2a8afcfe2f47`.

ECS update:

- Backend service `denwa-backend-task-service-4mh4rz2a` updated to task definition `denwa-backend-task:271`, reached `PRIMARY:COMPLETED`, running `1/1`.
- Frontend service `denwa-frontend-service` updated to task definition `denwa-frontend:151`, reached `PRIMARY:COMPLETED`, running `1/1`.
- Manual deploy did not stop running ECS tasks before `update-service`.

Verification:

- Running backend task image digest matched ECR digest for `1.1.1-484`.
- Running frontend task image digest matched ECR digest for `1.0.0-225`.
- Backend DEV smoke returned HTTP `200` for `/swagger-ui/index.html` and `/v3/api-docs`; `/` and `/actuator/health` returned `401` due auth.
- Frontend smoke passed for `https://dev.apl.purattocall.com/admin/login`: HTTP `200`, `cache-control: no-cache`, CSP header present, asset cache `max-age=31536000`, bundled JS contained `api-dev.apl.purattocall.com`.
