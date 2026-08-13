---
title: iOS DEV TestFlight 1.0.4 build 41
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-17
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.4-b41-20260717-archive.log
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.4-b41-20260717-export-upload.log
tags:
  - ios
  - testflight
  - devrelease
  - build-41
scope: historical
captured_at: 2026-07-17
validity: historical_context
promote_to_knowledge: false
---

# Kết quả

- Source: `sources/denwa-ios`, nhánh remote `prd`, commit `421b9d95f11330123a0e766fc41e540d2ca6ec20` (`fix(ios): use neutral placeholder avatar`).
- Dùng worktree tạm để giữ nguyên checkout iOS chính đang có thay đổi local.
- Scheme/configuration: `DevRelease`.
- Version/build upload thành công: `1.0.4 (41)`; app và notification extension dùng cùng version/build.
- Bundle ID: `jp.co.itec.denwa.product`.
- API xác minh trực tiếp trong archive: `https://api-dev.apl.purattocall.com`.
- Firebase project xác minh trực tiếp trong archive: `itec-denwa-vti-dev`.
- Archive: `scratch/ios-testflight/Denwa-prd-devrelease-v1.0.4-b41-20260717.xcarchive`.

# Upload

- App Store Connect trả về `Upload succeeded`, `Uploaded package is processing` và `EXPORT SUCCEEDED` lúc 15:51 JST ngày 2026-07-17.
- Cảnh báo thiếu dSYM của các framework MVWebRTC/WebRTC đóng gói sẵn không chặn upload.

# Gotcha

- Build `1.0.3 (40)` bị từ chối vì build number `40` đã được sử dụng trước đó.
- Build `1.0.3 (41)` bị từ chối vì version train `1.0.3` đã đóng sau khi phiên bản này được Apple duyệt.
- DEV TestFlight tiếp theo phải dùng marketing version cao hơn `1.0.3`; lần này `1.0.4 (41)` đã thành công.
- CodeGraph lần đầu khởi tạo trên worktree tạm bị hết bộ nhớ; chạy lại với `NODE_OPTIONS=--max-old-space-size=8192` thành công.
- Script `project-store/skills/ios-debug-testflight-publish/scripts/publish_debug_testflight.sh` vẫn tham chiếu đường dẫn CodeGraph cũ, nên workflow được chạy thủ công bằng đường dẫn hiện tại.
