---
title: ITEC memory stored migration and management fetch
project: itec-denwa
type: decision
status: archived
source:
  - Codex session 2026-06-21
tags:
  - memory
  - project-store
  - management
  - bootstrap
scope: historical
captured_at: 2026-06-21
validity: historical_context
promote_to_knowledge: false
---

ITEC root `memory/*.md` files were migrated into `project-store/memory/` with historical frontmatter.

Bootstrap, knowledge-memory sync, report context, and AGENTS rules were aligned so future memory notes use `project-store/memory/` and the stored repo folder list includes `memory`.

Management YAML was fetched from Google Sheets without resetting the already-dirty `project-store` worktree. Google Drive `modifiedTime` returned `FAILED_PRECONDITION`, so the fetch used the full-fetch fallback and exported WBS, Risks, Decisions, Stakeholders, and Communications. Cập nhật 2026-07-18: bootstrap không còn pull/clone stored repo; dự án tự quản lý nested repo và `project-store/config/project.yaml`.
