---
title: iOS and Android settings/report-log cleanup
project: itec-denwa
type: decision
status: archived
source:
  - Codex session 2026-07-13
  - Codex session 2026-07-30
  - sources/denwa-ios
  - sources/denwa-android
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/MainApplication.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/main/profile/ProfileUi.kt
  - sources/denwa-android/common/src/main/java/jp/co/itec/common/logger/FileLogger.kt
  - sources/denwa-android/env/env_debug.json
  - sources/denwa-android/env/env_production.json
  - User-provided Android runtime log 2026-07-30
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

## Outcome

- iOS Report Log trên màn Profile chỉ được compile khi có `REPORT_LOG_ENABLED`.
- `Development` và `DevRelease` bật `REPORT_LOG_ENABLED`; `Release` production không bật cờ này.
- Ngày 2026-07-30, Android Report Log được chuyển từ `context.isDebugMode()` sang
  `BuildConfig.REPORT_LOG_ENABLED`. Cấu hình Debug đặt cờ thành `true`, còn
  Production/Release đặt cố định thành `false`.
- Thay đổi này cho phép bản Debug DEV hiện nút dù build type đang đặt
  `isDebuggable = false`, đồng thời giữ nút bị ẩn trên Release.
- Sau khi xác nhận nút đã nhận click nhưng `rotateLogForUpload()` trả `null`,
  điều kiện khởi tạo `FileLogger` trong `MainApplication` cũng được chuyển từ
  `isDebugMode()` sang `BuildConfig.REPORT_LOG_ENABLED`. Debug vì vậy ghi file
  log từ lúc ứng dụng khởi động; Release không khởi tạo file logger.
- Mục tự động chuyển tiếp cuộc gọi và navigation entry từ Settings/Profile đã được gỡ trên cả iOS và Android.
- Model, API và implementation Call Forwarding bên dưới được giữ nguyên để tránh thay đổi lan ngoài scope.

## Evidence

- Verify ngày 2026-07-13 thành công: iOS Debug/Release build và Android
  `assembleDebug`/`assembleRelease`.
- Verify ngày 2026-07-30: Android `assembleDebug` thành công; BuildConfig sinh ra
  có `REPORT_LOG_ENABLED = true`.
- Android `compileReleaseKotlin` thành công với cấu hình private placeholder chỉ
  dùng tạm ngoài repo; BuildConfig Release sinh ra có
  `REPORT_LOG_ENABLED = false`.
- Runtime log do User cung cấp ghi nhận `triggerUpload` lúc `17:58:40`, sau đó
  `rotateLogForUpload returned null` lúc `17:58:45`. Source inspection xác nhận
  `FileLogger` trước đó chỉ được plant khi `isDebugMode()`, trong khi Debug
  build có `isDebuggable = false`.
- Sau fix, Android `assembleDebug` thành công. Bytecode Debug của
  `MainApplication` có lời gọi `FileLogger.getInstance`.
- Android `compileReleaseKotlin` thành công. Bytecode Release của
  `MainApplication` không có tham chiếu tới `FileLogger`, phù hợp với
  `REPORT_LOG_ENABLED = false`.
- `env_debug.json` và `env_production.json` hợp lệ; `git diff --check` pass.

## Unresolved

- `assembleRelease` ngày 2026-07-30 chưa chạy đến bước compile/package vì máy
  thiếu Android signing config và production environment secret thật. Cần chạy
  lại full Release build khi các file private này có sẵn.

## Retrieval keys

- Android Report Log, `ログ報告 (Debug Mode)`, `REPORT_LOG_ENABLED`,
  `ProfileUi.kt`, `MainApplication.kt`, `FileLogger`, `rotateLogForUpload`,
  `isDebugMode`, `FLAG_DEBUGGABLE`, `isDebuggable = false`, `env_debug.json`,
  `env_production.json`, Debug, Release.
