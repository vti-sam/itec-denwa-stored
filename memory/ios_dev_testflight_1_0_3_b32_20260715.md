---
title: iOS DEV TestFlight 1.0.3 build 32
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-15
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b32-20260715-141123-archive.log
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b32-20260715-141123-export-upload.log
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

- Source: `sources/denwa-ios`, nhánh `prd`, commit `6a613862b34a8a8fec162aa981a50d5b16e4eb99`.
- Scheme/configuration: `DevRelease`.
- Version/build: `1.0.3 (32)`; app và notification extension dùng cùng version/build.
- Bundle ID: `jp.co.itec.denwa.product`.
- API trong archive: `https://api-dev.apl.purattocall.com`.
- Firebase plist trong archive: `GooglePlistDevelopment`.
- Export option dùng `testFlightInternalTestingOnly=true`.
- Archive: `scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b32-20260715-141123.xcarchive`.

# Upload

- App Store Connect xác nhận `Upload succeeded` và `Uploaded package is processing` lúc 14:15 JST ngày 2026-07-15.
- `xcodebuild -exportArchive` kết thúc với `EXPORT SUCCEEDED`.
- Metadata archive ghi nhận build `32` đã `Uploaded to Apple`, không có upload error.
- Cảnh báo thiếu dSYM của các framework MVWebRTC/WebRTC đóng gói sẵn không chặn upload.

# Lưu ý

- Script `project-store/skills/ios-debug-testflight-publish/scripts/publish_debug_testflight.sh` còn trỏ CodeGraph đến path cũ `skills/codegraph-local/`; phiên này chạy workflow tương đương bằng path hiện tại `skills/knowledge-code/codegraph-local/` mà không sửa skill.
- Sau upload, `sources/denwa-ios/Denwa/Denwa.xcodeproj/project.pbxproj` còn thay đổi version/build local và chưa commit/push theo phạm vi đã thống nhất.
