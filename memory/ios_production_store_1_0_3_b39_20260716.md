---
title: iOS Production Store 1.0.3 build 39
project: itec-denwa
type: runbook
status: archived
source:
  - Codex release session 2026-07-16
  - scratch/ios-store-release/Denwa-prd-release-v1.0.3-b39-20260716-164449.xcarchive
  - scratch/ios-store-release/Denwa-prd-release-v1.0.3-b39-20260716-164449-export-upload.log
tags:
  - ios
  - app-store
  - production
  - release
  - jwt
  - app-review
scope: historical
captured_at: 2026-07-16
validity: historical_context
promote_to_knowledge: false
---

# Kết quả phát hành

- Source branch: `prd`.
- Bản sửa JWT được commit tại `29227c4` với nội dung serialize luồng refresh access token.
- Version/build: `1.0.3 (39)` cho cả app và notification extension.
- Scheme/configuration: `Denwa (P)` / `Release`.
- Bundle ID: `jp.co.itec.denwa.product`.
- API: `https://api.apl.purattocall.com`.
- Commit phát hành: `7f2e116259b2e24247f8fa04e10d81c90c228897`.
- Release tag: `denwa-v1.0.3-build39(Release)`.
- Upload log chứa `Upload succeeded` và `EXPORT SUCCEEDED`.
- Đã rút hồ sơ build 36, chọn build 39 và gửi lại phiên bản 1.0.3.
- Export compliance: standard encryption; France availability là `No`.
- Release mode giữ nguyên `Manually release this version`.
- App availability được read-back là đúng 2 quốc gia: Japan và Vietnam.
- App Review submission ID `0e5987bf-8d92-4445-94ad-63ac6e2a41bb`, trạng thái cuối `Waiting for Review` lúc 17:09 JST.

# Lưu ý

- Các cảnh báo thiếu dSYM của MVWebRTC/WebRTC không chặn upload.
- `GooglePlistProduction` được chọn trong build setting, nhưng plist đóng gói vẫn có Firebase project `itec-denwa-vti-dev` và bundle `jp.co.itec.denwa.dev`. Đây là cấu hình đã tồn tại trong các archive Production trước, không phát sinh từ build 39 và chưa được thay đổi trong lần phát hành này.
- Checkout chính vẫn giữ thay đổi cục bộ build DEV 38 trong `project.pbxproj`; phát hành build 39 được thực hiện trong scratch worktree để không ghi đè thay đổi đó.
