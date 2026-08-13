---
title: DEV manual deploy API and Front when GitLab runner stuck 2026-07-03
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-03 manual DEV deploy for API and Front
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

2026-07-03: GitLab DEV pipelines for API and Front failed because matching runner `devops` was unavailable, so a manual local deploy to AWS DEV was performed.

GitLab CI status:

- API pipeline `715653` / IID `483`, ref `dev`, commit `558188435bd37604a6e63b239eb5b481ef539823`, failed at job `build_and_push_to_ecr_dev` with `failure_reason: stuck_pending_no_matching_runners`.
- Front pipeline `715654` / IID `223`, ref `dev`, commit `1f9ec82cc02ad5a4b8b0a7b55c58f3727f353c62`, failed at job `test_frontend_dev` with `failure_reason: stuck_pending_no_matching_runners`.

Manual deploy source:

- Temporary snapshot root: `scratch/manual-deploy-20260703-175134/`.
- API snapshot: `origin/dev` at `558188435bd37604a6e63b239eb5b481ef539823`.
- Front snapshot: `origin/dev` at `1f9ec82cc02ad5a4b8b0a7b55c58f3727f353c62`.

Build and push:

- API Maven package with tests skipped succeeded using JDK 21.
- API Docker image built as `linux/amd64` and pushed to ECR tag `itec-denwa-backend:1.1.1-483`, digest `sha256:e8d12cd30ac2ec79299b0746f6eb9cbebebf4775535c5c2a82a8bfc4a4e19844`.
- Front `npm ci` and `npm run type-check` passed in Node 18 container.
- Front Docker image built with `VITE_API_BASE_URL=https://api-dev.apl.purattocall.com` and pushed to ECR tags `itec-denwa-frontend:1.0.0-223` and `itec-denwa-frontend:1.0.0-223-1f9ec82`, digest `sha256:eb766921cf13e16dda18ee6ba3e1c2785a92ab3448b1b42b031a4578024ab96d`.

ECS update:

- Backend service `denwa-backend-task-service-4mh4rz2a` updated to task definition `denwa-backend-task:270`, reached `PRIMARY:COMPLETED`, running `1/1`.
- Frontend service `denwa-frontend-service` updated to task definition `denwa-frontend:150`, reached `PRIMARY:COMPLETED`, running `1/1`.
- Manual deploy did not stop running ECS tasks before `update-service`.

Verification:

- Running backend task image digest matched ECR digest for `1.1.1-483`.
- Running frontend task image digest matched ECR digest for `1.0.0-223`.
- Backend DEV smoke returned HTTP `200` for `/swagger-ui/index.html` and `/v3/api-docs`; `/` and `/actuator/health` returned `401` due auth.
- Frontend smoke passed for `https://dev.apl.purattocall.com/admin/login`: HTTP `200`, `cache-control: no-cache`, CSP header present, asset cache `max-age=31536000`, bundled JS contained `api-dev.apl.purattocall.com`.
