---
title: iOS DEV TestFlight 1.0.3 build 38 JWT fix
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-16
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b38-20260716-162118-export-upload.log
tags:
  - ios
  - testflight
  - devrelease
  - jwt
  - build-38
scope: historical
captured_at: 2026-07-16
validity: historical_context
promote_to_knowledge: false
---

# Kết quả

- Source: `sources/denwa-ios`, nhánh `prd`, commit nền `01ef21f`, kèm thay đổi local sửa concurrent JWT refresh trong `ApiManage.swift`.
- Scheme/configuration: `DevRelease`.
- Version/build: `1.0.3 (38)`; app và notification extension dùng cùng version/build.
- Bundle ID: `jp.co.itec.denwa.product`.
- API xác minh trực tiếp trong archive: `https://api-dev.apl.purattocall.com`.
- Firebase plist xác minh trực tiếp trong archive: `GooglePlistDevelopment`.
- Archive: `scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b38-20260716-162118.xcarchive`.

# Upload

- App Store Connect trả về `Upload succeeded` và `Uploaded package is processing` lúc 16:25 JST ngày 2026-07-16.
- Export kết thúc bằng `EXPORT SUCCEEDED`.
- Cảnh báo thiếu dSYM của các framework MVWebRTC/WebRTC đóng gói sẵn không chặn upload.
- Source fix JWT và build number 38 chưa commit hoặc push.

# Phạm vi fix cần test

- Khi nhiều API cùng trả `ACCESS_TOKEN_EXPIRED`, chỉ một request refresh-token được gửi.
- Sau khi refresh trả `ES200`, toàn bộ request chờ phải retry thành công và không hiện dialog JWT.
