---
title: Admin deleted user list visibility fix
project: itec-denwa
type: lesson
status: archived
source:
- memory/admin_deleted_user_list_visibility_20260620.md
tags:
- backend
- dev
- user-status
- tenant-admin
- system-admin
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

2026-06-20: Backlog issue ITEC_DENWA_APP-208 reported that Tenant Admin user list and System Admin tenant-detail user popup only showed `利用中` accounts and did not show deleted accounts.

DEV DB evidence through SSH tunnel to RDS showed deleted users are stored as `user_status = '4'` and `delete_flag = '1'`:

- `111_schema`: 20 active rows with `user_status=3/delete_flag=0`, 60 deleted rows with `user_status=4/delete_flag=1`.
- `112_schema`: 30 deleted rows with `user_status=4/delete_flag=1`.
- No DEV records had `delete_flag=1` with a non-deleted status.

Root cause: backend list queries filtered only `delete_flag = '0'`, so deleted users were never returned to the frontend even though frontend already maps `USER_STATUS[4]` to `削除済み`.

Fix pushed on `sources/denwa-api` branch `dev`: commit `5bd70d71 fix: show deleted users in admin lists`.

Changed mapper queries:

- `UserMapper.xml#searchUsers`
- `UserMapper.xml#getUserCount`
- `UserMapper.xml#getUserCountByAdmin`
- `UserMapper.xml#getListUserByAdmin`

Each list query now uses `(delete_flag = '0' OR user_status = '4')`. Auth, detail-for-edit, and other operational queries continue to use the existing delete filtering.

Regression fixture was also corrected so `deleted-user-uuid` uses `user_status='4'` with `delete_flag='1'`, matching real DEV data. Local verification passed:

```bash
DOCKER_HOST=unix://$HOME/.colima/default/docker.sock TESTCONTAINERS_RYUK_DISABLED=true rtk bash ./mvnw -Dtest=VoipWebApiRegressionIT test
```

Result: `Tests run: 104, Failures: 0, Errors: 0, Skipped: 0`.

Follow-up test hardening pushed on `sources/denwa-api` branch `dev`: commit `af607744 test: guard deleted user fixture state`. The two deleted-list regression cases now assert `deleted-user-uuid` has `delete_flag='1'` before calling the list APIs, preventing future false-pass if fixture data is accidentally changed back to an active delete flag.

CI/CD note: `.gitlab-ci.yml` deploys branch `dev` to ECS DEV after build and ECR push. This machine did not have AWS credentials or GitLab CLI/token at the time of the fix, so pipeline/ECS live status could not be read locally after push.
