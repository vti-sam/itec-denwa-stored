---
title: Tenant Admin User List back navigation search restore fix
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-06-22
  - sources/denwa-front/src/views/user-management/UserList.vue
tags:
  - denwa-front
  - tenant-admin
  - user-list
  - search-condition
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

Bug `[Admin][PROD][ユーザー一覧] Clear điều kiện search khi nhấn Back từ màn hình Detail` nằm ở frontend `sources/denwa-front/src/views/user-management/UserList.vue`.

Nguyên nhân: `onMounted()` có restore `listScreenStore.searchCondition` khi quay lại từ `/tadmin/user/details/:userUuid`, nhưng sau đó lại overwrite các field filter `userName`, `fullName`, `status`, `createdDateFrom`, `createdDateTo` về `null`. Ngoài ra request search merge `committedFilters` sau `userListRequest`, nên nếu không restore `committedFilters` thì API request vẫn có thể bị filter rỗng.

Fix đã áp dụng: khi Back từ Detail về List, giữ lại saved request, đồng bộ `committedFilters` theo saved request, và set lại `createdDateFromString`/`createdDateToString` bằng `formatDate()` để DatePicker hiển thị lại ngày đã search.

Verify:

```bash
rtk npm run type-check
/Users/vti-sam/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node node_modules/vite/bin/vite.js build
```

Ghi chú: `rtk npm run build` bằng Homebrew Node `v25.9.0` fail trước khi compile source do `vite-plugin-vue-devtools`/`@vue/devtools-kit` báo `localStorage.getItem is not a function`; build pass khi chạy Vite bằng bundled Node `v24.14.0`.
