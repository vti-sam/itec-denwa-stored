---
title: PRD Katayama tenant admin lock and password reset
project: itec-denwa
type: lesson
status: archived
source:
  - Live PRD database audit and update on 2026-06-22
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/security/UserDetailsImpl.java
  - sources/denwa-api/src/main/resources/jp/co/itec/denwa/mapper/admin/AdminMapper.xml
tags:
  - prd
  - database
  - admin
  - authentication
  - tenant-admin
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

Katayama's PRD account `katayama-ta@itec.hankyu-hanshin.co.jp` had separate active admin rows for system admin and tenant admin contexts:

- `master_schema.admin`: role `0`, login failure counter was `0`.
- `111_schema.admin`: role `1`, login failure counter was `4`.
- `113_schema.admin`: role `1`, login failure counter was `3`.

The authentication code blocked login when the stored login failure counter was `>= 4`, so the tenant `111` admin row was locked even though the master/system admin row could still log in. This was not a same-row role conflict; it was separate-context state in tenant schemas.

Temporary PRD remediation on 2026-06-22 reset the tenant admin password for `111_schema` and `113_schema`, set both login and reset-password failure counters to `0`, cleared refresh tokens, and preserved roles. Independent read-back verified both tenant admin rows had role `1`, counters `0`, no refresh token, and `master_schema.admin` remained role `0` with its existing refresh token.

Code fix prepared in `sources/denwa-api`:

- `UserDetailsImpl.isLoginFailureLimitExceeded()` now uses `>= 5`.
- `AdminMapper.xml` resets failure counters and clears refresh tokens when updating tenant-admin mail password or admin reset password.
- Tenant admin tables require non-null `lock_reset_password_time`, so reset/update logic uses `CURRENT_TIMESTAMP` rather than `NULL`.
