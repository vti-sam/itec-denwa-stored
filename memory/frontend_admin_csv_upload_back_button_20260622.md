---
title: System Admin CSV upload back button alignment fix
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-06-22
  - sources/denwa-front/src/views/tenant-management/UserCsvRegist.vue
tags:
  - denwa-front
  - system-admin
  - csv-upload
  - ui
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

Bug UI: `/admin/tenant/user-csv-regist` showed the `戻る` button directly below the upload card, while `/tadmin/user/csv-regist` showed it near the footer. Expected behavior for System Admin upload from Tenant Detail is to align with the Tenant Admin CSV upload screen.

Fix: pushed `sources/denwa-front` commit `0a17289` on `dev`, adding the same `min-height: 631px` content wrapper in `src/views/tenant-management/UserCsvRegist.vue`.

Verification:

```bash
rtk npm run type-check
/Users/vti-sam/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node node_modules/vite/bin/vite.js build
```
