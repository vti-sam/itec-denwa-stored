---
title: Frontend DEV ECS API base URL drift
project: itec-denwa
type: lesson
status: archived
source:
- memory/front_dev_api_base_url_ecs_env_20260620.md
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

2026-06-20: `denwa-frontend-service` DEV had task definition env `VITE_API_BASE_URL=https://api-stg.apl.purattocall.com` even though the deployed static bundle was built with `https://api-dev.apl.purattocall.com`.

Root cause: `.gitlab-ci.yml` build job passed the correct `--build-arg VITE_API_BASE_URL=https://api-dev.apl.purattocall.com`, but the deploy job only updated `.containerDefinitions[0].image` and preserved old task definition environment values.

Fix committed and pushed on `denwa-front` branch `dev`: `fd72e7e fix: set frontend api base url in ecs deploy`. The deploy jobs for DEV/STG/PRD now set `VITE_API_BASE_URL` explicitly in the ECS task definition.

Immediate DEV restore: registered `denwa-frontend:133` from `:132` with `VITE_API_BASE_URL=https://api-dev.apl.purattocall.com` and updated `denwa-frontend-service`. Verification: service primary deployment `COMPLETED`, target group `denwa-dev-ft-tg` healthy, and `https://dev.apl.purattocall.com` bundle contained `api-dev.apl.purattocall.com` and not `api-stg.apl.purattocall.com`.
