---
title: Frontend select-role login error display fix
project: itec-denwa
type: gotcha
status: archived
source:
- memory/front_select_role_error_message_20260620.md
tags:
- frontend
- authentication
- whitelist
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

2026-06-20: The admin multi-role flow can receive backend errors from `/auth/admin/login-with-role`, including IP whitelist denial `MSG_ERR_00050`, after the user selects `システム管理者`.

Root cause for "no message shown" on the UI was in `src/views/authen-author/SelectRole.vue`: it called `handleLocalApiError(error, errorMessage)` but did not render `errorMessage` in the template. Commit `63442be` on `denwa-front` branch `dev` adds the same `v-alert` pattern used by `Login.vue` and clears `errorMessage` before submit.
