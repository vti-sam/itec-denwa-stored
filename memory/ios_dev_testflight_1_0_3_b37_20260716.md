---
title: iOS DEV TestFlight 1.0.3 build 37
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-16
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b37-20260716-125817-export-upload.log
tags:
  - ios
  - testflight
  - devrelease
  - build-37
scope: historical
captured_at: 2026-07-16
validity: historical_context
promote_to_knowledge: false
---

# Kết quả

- Source: `sources/denwa-ios`, nhánh `prd`, commit `01ef21f` (`chore(ios): bump production build to 36`).
- Scheme/configuration: `DevRelease`.
- Version/build: `1.0.3 (37)`; app và notification extension dùng cùng version/build.
- Bundle ID: `jp.co.itec.denwa.product`.
- API xác minh trực tiếp trong archive: `https://api-dev.apl.purattocall.com`.
- Firebase plist xác minh trực tiếp trong archive: `GooglePlistDevelopment`.
- Archive: `scratch/ios-testflight/Denwa-prd-devrelease-v1.0.3-b37-20260716-125817.xcarchive`.

# Upload

- App Store Connect trả về `Upload succeeded` và `Uploaded package is processing` lúc 13:02 JST ngày 2026-07-16.
- Export kết thúc bằng `EXPORT SUCCEEDED`.
- Cảnh báo thiếu dSYM của các framework MVWebRTC/WebRTC đóng gói sẵn không chặn upload.
- File `sources/denwa-ios/Denwa/Denwa.xcodeproj/project.pbxproj` còn thay đổi build number từ 36 lên 37; chưa commit hoặc push.

# Gotcha

- Script `project-store/skills/ios-debug-testflight-publish/scripts/publish_debug_testflight.sh` đang tham chiếu đường dẫn CodeGraph cũ `skills/codegraph-local/scripts/codegraph_project.py` và dừng trước khi build.
- Workflow lần này chạy thủ công bằng đường dẫn hiện tại `skills/knowledge-code/codegraph-local/scripts/codegraph_project.py`; chưa sửa runbook/script vì ngoài phạm vi upload.
