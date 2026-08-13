---
title: DEV son.nguyenhong1 active user email repoint
project: itec-denwa
type: lesson
status: archived
source:
  - DEV database update and sanitized login smoke test on 2026-06-26
tags:
  - dev
  - database
  - authentication
  - mobile-user
scope: historical
captured_at: 2026-06-26
validity: historical_context
promote_to_knowledge: false
---

2026-06-26: DEV `denwa_dev` had `son.nguyenhong1@vti.com.vn` mapped to tenant `112` as account type `1`, but the non-deleted user row in `112_schema.users` had `user_status='0'`, so mobile login returned `MSG_ERR_00064` account-not-active after password reset.

Temporary DEV remediation:

- Soft-deleted old non-active user UUID `593b5a21-9c8c-46f7-a7d3-abd7ef8dc9ea` by setting `user_status='4'`, `delete_flag='1'`, and clearing `user_name_sip`.
- Repointed active Huong test user UUID `4d82f0c7-21df-40ca-92d6-6d84eda9b730` from `huong.nguyenthi+4@vti.com.vn` to `son.nguyenhong1@vti.com.vn`.
- Kept tenant `112`, role `2`, `user_status='3'`, `delete_flag='0'`, SIP `13012`, and `phone_type='1'`.
- Deleted the old `huong.nguyenthi+4@vti.com.vn` mobile-user mapping; kept exactly one `master_schema.account_mapping` row for `son.nguyenhong1@vti.com.vn` with `tenant_id='112'`, `account_type='1'`.
- Reset login/reset-password counters and cleared refresh token on the active row.

Sanitized smoke test against `https://api-dev.apl.purattocall.com/auth/user/login` returned HTTP `200`, code `ES200`, and a `preToken` field. Passwords, hashes, tokens, and OTP values were not stored in this note.
