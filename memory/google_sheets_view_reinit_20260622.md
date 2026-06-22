---
title: Google Sheets management view reinitialization
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-06-22 Google Sheets view reinit
  - skills/management-sync/scripts/init_project_sheets.py
tags:
  - google-sheets
  - management-sync
  - init-sheets
  - wbs
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

Reinitialized the management Google Sheets view after the visible sheet layout diverged from `skills/management-sync`.

Workflow used:

- Fetch all management tables first so Project summary and Gantt use current YAML snapshots.
- Run `skills/management-sync/scripts/init_project_sheets.py` directly for full view rebuild.
- Run `skills/management-sync/scripts/clear_filters.py` after init.
- Run `skills/management-sync/scripts/update_today_line.py` after filters are cleared.
- Fetch all management tables again and dry-run all tables to confirm `No changes`.

Gotcha: `manage.py init-sheets --dry-run` does not forward `--dry-run` as expected through the wrapper argument parser. Use the direct script for dry-run/options, or verify wrapper behavior before relying on it.

Verification from 2026-06-22:

- Init formatted Project, WBS, Risks, Decisions, Stakeholders and Communications sheets.
- Clear filters removed Basic Filter from 7 sheets, including legacy `WBS_JP / WBS_日本語`.
- Today line updated for `WBS / WBS` and `WBS_JP / WBS_日本語`.
- Data dry-run for WBS, Risks, Decisions, Stakeholders and Communications returned `No changes`.
