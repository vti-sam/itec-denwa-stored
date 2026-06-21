---
title: Deploy app checklist Excel và quy tắc reset version production
project: itec-denwa
type: runbook
status: archived
source:
- memory/deploy_app_checklist_excel_version_reset.md
tags:
- release
- android
- ios
- checklist
- versioning
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

# Deploy app checklist Excel và quy tắc reset version production

- Checklist release được tách thành hai sheet `Android` và `iOS`, có cột trạng thái, evidence, người/thời gian kiểm tra và ghi chú.
- Production chính thức đầu tiên dùng version hiển thị `1.0.0`, Android `versionCode = 1`, iOS `CURRENT_PROJECT_VERSION = 1`.
- Chỉ reset build identifier về `1` khi đã có evidence xác nhận package/bundle production chưa từng có artifact trên Store.
- Nếu Store đã có build production, phải dùng build identifier lớn hơn build gần nhất; không reset.
- Baseline source trước reset đang được ghi nhận trong release plan là Android `versionCode 53` và iOS build `19`; phải chụp evidence trước/sau thay đổi.
- Không lưu password, signing key, token hoặc secret trong checklist/evidence.
