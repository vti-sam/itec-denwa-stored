---
title: Project store tracking commit
project: itec-denwa
type: lesson
status: archived
source:
- memory/project_store_tracking_commit.md
tags:
- project-store
- git
- excel-skills
scope: historical
captured_at: '2026-06-18'
validity: historical_context
promote_to_knowledge: false
---

Commit `417511d` từng track nhầm dữ liệu portable của `project-store` vào repo cha. Cleanup commit `b306e8d` khôi phục boundary: repo cha ignore toàn bộ `project-store/`, còn `project-store/.git` quản lý repo stored độc lập theo `registry/projects.yaml`. Rider phải giữ mapping riêng cho `$PROJECT_DIR$/project-store`. Repo stored hiện có thay đổi chưa commit tại `artifacts/notes/release_wbs_draft_jp_2026-06-10.md`.
