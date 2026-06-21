---
title: Drive sync delete commands
project: itec-denwa
type: runbook
status: archived
source:
- memory/drive_sync_delete_commands.md
tags:
- drive-sync
- deletion
- project-drive-sync
scope: historical
captured_at: '2026-06-17'
validity: historical_context
promote_to_knowledge: false
---

Added `sync-push` and `sync-pull` to `skills/project-drive-sync/scripts/drive_sync.py`. Existing `push`/`pull` remain copy-only and non-deleting. The new commands use `rclone sync`, so they delete files at the destination that are missing from the source; always run `--dry-run` before `--apply`.
