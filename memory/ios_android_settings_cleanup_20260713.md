---
title: iOS and Android settings cleanup 2026-07-13
project: itec-denwa
type: decision
status: archived
source:
  - Codex session 2026-07-13
  - sources/denwa-ios
  - sources/denwa-android
tags:
  - ios
  - android
  - settings
  - report-log
  - call-forwarding
scope: historical
captured_at: 2026-07-13
validity: historical_context
promote_to_knowledge: false
---

- iOS Report Log trên màn Profile chỉ được compile khi có `REPORT_LOG_ENABLED`.
- `Development` và `DevRelease` bật `REPORT_LOG_ENABLED`; `Release` production không bật cờ này.
- Mục tự động chuyển tiếp cuộc gọi và navigation entry từ Settings/Profile đã được gỡ trên cả iOS và Android.
- Model, API và implementation Call Forwarding bên dưới được giữ nguyên để tránh thay đổi lan ngoài scope.
- Verify thành công: iOS Debug/Release build và Android `assembleDebug`/`assembleRelease`.
