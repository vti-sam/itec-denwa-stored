---
title: DEV MVE tenant users sanitized to test accounts
project: itec-denwa
type: lesson
status: archived
source:
  - DEV database update and read-back verification on 2026-06-30
tags:
  - dev
  - database
  - mve
  - sip
  - tenant-user
scope: historical
captured_at: 2026-06-30
validity: historical_context
promote_to_knowledge: false
---

2026-06-30: Sanitized DEV tenant user rows after DEV MVE was confirmed to point to `c2.cd-demo-mve.com`.

Pre-update backup was saved at `scratch/db-backups/denwa_dev_sanitize_mve_dev_accounts_backup_20260630T065048Z.json`; the backup intentionally excluded password/hash/token columns.

Actions applied to `denwa_dev` only:

- Replaced the 25 non-deleted tenant users that correspond to live DEV MVE SIP registrations with test account names in the form `mve-dev+<full_sip>@vti.com.vn`.
- Preserved `user_name_sip` and `password_sip` so DB SIP state still matches MVE.
- Cleared `user_password`, refresh token fields, login/reset counters, address, and product/customer profile text for the 25 sanitized rows.
- Rebuilt `master_schema.account_mapping` mobile mappings (`account_type='1'`) for the 25 sanitized tenant users.
- Soft-deleted 7 non-MVE tenant user rows in tenants `112`, `500`, and `504`; no hard delete was performed.

Post-update read-back verified:

- DEV DB SIP set matches live DEV MVE exactly: 25/25.
- Non-deleted tenant users in the touched scope are exactly 25.
- Mobile mappings in the touched scope are exactly 25 and all use `mve-dev+...@vti.com.vn`.
- No non-deleted tenant user in the touched scope overlaps with PRD tenant users or PRD master admins.

Important limitation:

- Existing API batch logic (`UserService.syncUserStatus`, `UserService.registUserStatus`, and `INIHandler.getAllUserMapFromMve`) only syncs MVE SIP registration/status state. It does not fetch or overwrite account profile fields such as `user_name`, names, kana, memo, address, or `account_mapping`.
- Tenant admin tables are separate from tenant users. A later audit still showed active DEV tenant admin names overlapping PRD; those were outside this tenant-user sanitize update.
