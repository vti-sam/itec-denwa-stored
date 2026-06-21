---
title: Bootstrap pulls Drive snapshot by default
project: itec-denwa
type: lesson
status: archived
source:
- memory/bootstrap_drive_pull_default.md
tags:
- bootstrap
- drive-sync
- migration
scope: historical
captured_at: '2026-06-17'
validity: historical_context
promote_to_knowledge: false
---

Updated `scripts/bootstrap_project.py` so a normal bootstrap pulls the Google Drive snapshot for the default folders `knowledge/`, `artifacts/`, and `management/` before optional Google Sheets management fetch. Use `--skip-drive-pull` only when bootstrapping local config on a machine without rclone/Drive access.
