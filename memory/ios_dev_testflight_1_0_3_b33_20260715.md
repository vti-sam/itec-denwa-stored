---
title: iOS DEV TestFlight 1.0.3 build 33
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-15
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b33-20260715-224641-archive.log
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b33-20260715-224641-export-upload.log
tags:
  - ios
  - testflight
  - devrelease
  - dev-environment
scope: historical
captured_at: 2026-07-15
validity: historical_context
promote_to_knowledge: false
---

# Kết quả

- Source sửa lỗi được push lên nhánh `prd` tại commit `4ac8d26`.
- Commit version sau upload là `ce55dbd`, đồng bộ local và `origin/prd`.
- Scheme/configuration: `DevRelease`.
- Version/build: `1.0.3 (33)`; app và notification extension dùng cùng version/build.
- Bundle ID: `jp.co.itec.denwa.product`.
- API: `https://api-dev.apl.purattocall.com`.
- Firebase: `GooglePlistDevelopment`, project `itec-denwa-vti-dev`.
- Export option dùng `testFlightInternalTestingOnly=true`.

# Upload

- App Store Connect xác nhận `Upload succeeded` và `Uploaded package is processing` lúc 22:50 JST ngày 2026-07-15.
- `xcodebuild -exportArchive` kết thúc với `EXPORT SUCCEEDED`.
- Archive: `scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b33-20260715-224641.xcarchive`.
- Cảnh báo thiếu dSYM của các framework MVWebRTC/WebRTC đóng gói sẵn không chặn upload.

# Nội dung chính

- Session Keychain không đầy đủ sau khi xoá/cài lại app được xoá và điều hướng về Login.
- Notification chỉ được hỏi sau khi đăng nhập; Microphone/Camera được hỏi theo hành động gọi.
- Hồ sơ người dùng được lưu trước khi mở Main để History không hiện dữ liệu mẫu từ XIB.
