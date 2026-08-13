---
title: iOS debug TestFlight publish skill created
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-02 creating project-store skill ios-debug-testflight-publish
  - project-store/memory/ios_debug_testflight_upload_20260702.md
tags:
  - ios
  - testflight
  - devrelease
  - app-store-connect
  - skill
scope: historical
captured_at: 2026-07-02
validity: historical_context
promote_to_knowledge: false
---

Đã tạo skill `project-store/skills/ios-debug-testflight-publish/` để chạy nhanh workflow iOS debug/DEV lên TestFlight, tương tự skill Android Firebase.

Các điểm đã encode vào skill/script:

- Source iOS cố định: `sources/denwa-ios`, branch `prd`.
- Scheme/config build: `DevRelease`.
- Upload bằng App Store Connect/TestFlight internal testing, `testFlightInternalTestingOnly=true`, team `84S993H7LR`.
- Script chạy CodeGraph trước workflow source và sau `git pull --ff-only`.
- Script luôn chạy `pod install` trước archive vì lần upload 2026-07-02 từng fail do CocoaPods/DevRelease config stale.
- Script cập nhật `MARKETING_VERSION` và `CURRENT_PROJECT_VERSION` cho cả target app `Denwa` và extension `MVWebRTCNotificationServiceExtension`.
- `1.0.0` không được dùng tiếp vì App Store Connect đã đóng train sau khi bản đó được approve.
- Build `26` của version `1.0.1` đã upload thành công ngày 2026-07-02; script tự dùng tối thiểu build `27` khi không truyền `--build-number`.
- Warning thiếu dSYM cho prebuilt `MVWebRTCFramework`, `MVWebRTCInterface`, `MVWebRTCNativeCall`, `WebRTC` là warning đã gặp và không chặn upload trong lần 2026-07-02.

Lệnh nhanh:

```bash
rtk bash project-store/skills/ios-debug-testflight-publish/scripts/publish_debug_testflight.sh
```

Khi cần set rõ version/build:

```bash
rtk bash project-store/skills/ios-debug-testflight-publish/scripts/publish_debug_testflight.sh --marketing-version 1.0.1 --build-number 27
```
