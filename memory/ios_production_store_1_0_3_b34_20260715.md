---
title: iOS Production Store 1.0.3 build 34
project: itec-denwa
type: runbook
status: archived
source:
  - Codex release session 2026-07-15
  - scratch/ios-store-release/Denwa-prd-release-v1.0.3-b34-20260715-230024-archive.log
  - scratch/ios-store-release/Denwa-prd-release-v1.0.3-b34-20260715-230024-export-upload.log
tags:
  - ios
  - app-store
  - production
  - release
  - app-review
scope: historical
captured_at: 2026-07-15
validity: historical_context
promote_to_knowledge: false
---

# Kết quả phát hành

- Source branch: `prd`.
- Version/build: `1.0.3 (34)` cho cả app và notification extension.
- Scheme/configuration: `Denwa` / `Release`.
- Bundle ID: `jp.co.itec.denwa.product`.
- API: `https://api.apl.purattocall.com`.
- Commit: `6c7d356b9a8f34efb553126f055cf602b0f73c12`.
- Release tag: `denwa-v1.0.3-build34(Release)`.
- Archive: `scratch/ios-store-release/Denwa-prd-release-v1.0.3-b34-20260715-230024.xcarchive`.
- Upload log chứa `Upload succeeded` và `EXPORT SUCCEEDED`.
- App Store Connect đã chọn build 34 cho phiên bản 1.0.3.
- Export compliance: standard encryption; France availability là `No` vì app chỉ khả dụng tại Japan và Vietnam.
- Release mode giữ nguyên `Manually release this version`.
- App Review submission mới đạt trạng thái `Waiting for Review`; draft submissions còn 0.

# Lưu ý

- Các cảnh báo thiếu dSYM của thư viện MVWebRTC/WebRTC không chặn upload.
- `GooglePlistProduction` được chọn trong build setting, nhưng plist đóng gói vẫn có Firebase project `itec-denwa-vti-dev` và bundle `jp.co.itec.denwa.dev`. Đây là cấu hình đã tồn tại trong các archive Production trước (build 27-31), không phát sinh từ build 34 và chưa được thay đổi trong lần phát hành này.
