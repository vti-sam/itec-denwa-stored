---
title: DEV mobile user email reverted to Huong test account
project: itec-denwa
type: lesson
status: archived
source:
  - DEV database update on 2026-06-26
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

2026-06-26: Reverted DEV tenant `112` active mobile user UUID `4d82f0c7-21df-40ca-92d6-6d84eda9b730` from `son.nguyenhong1@vti.com.vn` back to `huong.nguyenthi+4@vti.com.vn`.

Post-update verified state:

- `112_schema.users`: active row `user_status='3'`, `delete_flag='0'`, role `2`, phone type `1`, SIP `13012`, email `huong.nguyenthi+4@vti.com.vn`.
- `master_schema.account_mapping`: exactly one mobile mapping for `huong.nguyenthi+4@vti.com.vn` with tenant `112`, account type `1`.
- Old `son.nguyenhong1@vti.com.vn` rows remain soft-deleted/non-active.

No password hashes, refresh tokens, or OTP values were stored in this note.
