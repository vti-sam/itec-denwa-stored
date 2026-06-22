---
title: PRD user CSV upload 500 fix deployment
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-06-22 PRD user CSV upload deploy
tags:
  - denwa-api
  - user-csv-upload
  - prd
  - ecs
  - circular-dependency
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

2026-06-22: DEV fix for bulk user CSV upload was merged to `prd` and pushed as merge commit `e33f95fa`, but the first PRD deploy image `itec-denwa-backend:1.1.1-461` failed to start on ECS task definition `denwa-backend-prd:18`.

Runtime failure in CloudWatch was a Spring Boot startup cycle: `jwtFilter -> mobileUserDetailsService -> userService`, caused by direct self-injection in `UserService` (`@Autowired private UserService self`) while PRD profile disables circular references. Test profile hid this because `application-test.properties` enables circular references and lazy initialization.

Immediate rollback restored PRD to `denwa-backend-prd:12`. Follow-up commit `92d15393` on `prd` added `@Lazy` to the `UserService self` injection, preserving the transactional self-proxy while avoiding eager circular dependency at startup.

Local verification:
- `UserCsvMissingTenantIT` passed with `-Dspring.main.allow-circular-references=false`.
- Upload CSV regression passed for `UserCsvMissingTenantIT,ExternalUserCsvUploadDataIT,UserCsvErrorFileWriterIT`; `user_chuakytudacbiet.csv` and `user_ko phai Katakana.csv` returned HTTP 400 locally.

PRD deployment verification:
- GitLab pipeline `708097` for `92d15393` succeeded.
- ECS service `denwa-backend-prd-service` reached steady state on task definition `denwa-backend-prd:19`, image version `1.1.1-462`, running 1/1.
- Direct PRD API calls to `https://api.apl.purattocall.com/tenant/insert-user-csv` for `scratch/Data test/user_chuakytudacbiet.csv` and `scratch/Data test/user_ko phai Katakana.csv` returned HTTP 400, not 500.

Deploy script gotcha: the PRD deploy job stops running tasks before `update-service`; ECS may temporarily restart the old task definition and the job can appear stuck while waiting for old task draining to finish. Check ECS service deployments directly before assuming deploy failure.
