---
title: DEV API 503 do ECS backend task startup failure
project: itec-denwa
type: lesson
status: archived
source:
- memory/dev_api_503_ecs_startup_20260620.md
tags:
- dev
- ecs
- login
- troubleshooting
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

2026-06-20: `https://api-dev.apl.purattocall.com` returned `HTTP 503` from `awselb/2.0` for `/auth/admin/login`, `/api/healcheck`, and `/api/health`, while `https://dev.apl.purattocall.com/admin/login` returned frontend `200`.

AWS read-only verification:

- ECS service `denwa-backend-task-service-4mh4rz2a` in cluster `denwa-dev-cluster` was `ACTIVE` with `desired=1`, `running=0`, `pending=0`.
- Deployment state was `FAILED`: `ECS deployment circuit breaker: tasks failed to start`.
- Target group `denwa-backend` had no target health entries, so the backend ALB returned 503.
- Task definition was `denwa-backend-task:248`, image tag `itec-denwa-backend:1.1.1-454`, profile `SPRING_PROFILES_ACTIVE=dev-cloud`.
- CloudWatch log group `/ecs/denwa-backend-task` showed Spring Boot startup failure due circular dependency:
  `jwtFilter -> mobileUserDetailsService -> userService.self`.
- Runtime/task definition did not set `SPRING_MAIN_ALLOW_CIRCULAR_REFERENCES` or `JAVA_TOOL_OPTIONS`.

Likely fix direction: add `spring.main.allow-circular-references=true` to the dev-cloud runtime configuration as a quick restore, or remove the `UserService self` circular dependency properly. This issue blocks testing account/password/IP whitelist because requests do not reach the application.

Restore action completed on 2026-06-20:

- Registered ECS task definition `denwa-backend-task:249` from `:248` with env `SPRING_MAIN_ALLOW_CIRCULAR_REFERENCES=true`.
- Updated ECS service `denwa-backend-task-service-4mh4rz2a` to `:249` and forced a new deployment.
- Deployment completed with `running=1`; target group `denwa-backend` became healthy.
- `https://api-dev.apl.purattocall.com/auth/admin/login` for `trang.nguyenthi2@vti.com.vn` returned `200 ES200` with role choices.
- `login-with-role` for `master_admin` returned `200 ES200` with access token, so the IP-whitelist denial behavior still needs separate investigation/fix on the real DEV environment.
