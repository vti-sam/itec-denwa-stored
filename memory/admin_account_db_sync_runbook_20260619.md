---
title: Durable runbook for admin account DB synchronization
project: itec-denwa
type: runbook
status: archived
source:
- memory/admin_account_db_sync_runbook_20260619.md
tags:
- database
- admin
- runbook
- dev
- stg
- prd
scope: historical
captured_at: '2026-06-19'
validity: historical_context
promote_to_knowledge: false
---

The reusable DEV/STG/PRD admin-account database procedure is stored at:

`project-store/knowledge/denwa-api/runbooks/admin-account-db-sync.md`

Use that runbook instead of re-analyzing schema or adapting the old one-environment scripts. It contains the verified environment/database/tunnel mapping, a parameterized `--env dev|stg|prd` Python script, audit/apply commands, role and mapping invariants, BCrypt verification, whitelist boundary, and the 2026-06-19 deployment history.
