---
title: ITEC stored project config migration
project: itec-denwa
type: decision
status: archived
source:
  - project-store/config/project.yaml
  - project-store/config/AGENTS.md
  - Codex session 2026-07-18
tags:
  - bootstrap
  - project-store
  - configuration
  - management-sync
  - backlog
  - aws
scope: historical
captured_at: 2026-07-18
validity: historical_context
promote_to_knowledge: false
---

# ITEC stored project config migration

- Định danh ITEC, Google resource, Backlog binding và endpoint được chuyển vào `project-store/config/project.yaml`.
- Backlog API key, Google Sheets service account và bộ keystore Android/iOS/infra được chuyển khỏi root registry vào các path local bị nested Git ignore dưới `project-store/config/`.
- `management-sync`, `backlog-sync` và `aws-ops-check` đã resolve cấu hình từ stored project thay vì mapping riêng trong root registry.
- Bootstrap local đã resolve đúng `itec-denwa` và sinh `project-data.yaml` không còn tham chiếu service registry chung.
- Smoke test read-only xác nhận Google spreadsheet/key path, Backlog project nội bộ `ITEC_DENWA_APP` và AWS credential path vẫn được tìm thấy.
- Các thay đổi memory/artifact có sẵn trong stored repo trước migration được giữ nguyên, không reset hoặc clean.
