---
title: DEV admin account synchronization
project: itec-denwa
type: lesson
status: archived
source:
- memory/dev_admin_account_sync_20260619.md
tags:
- dev
- database
- admin
- authentication
scope: historical
captured_at: '2026-06-19'
validity: historical_context
promote_to_knowledge: false
---

Synchronized the requested admin accounts in `denwa_dev` to match the approved PRD account model:

- Reset the existing Katayama and Higashitani system admins (`role=0`).
- Reset the existing Okada master MVE admin (`role=3`) and the active Okada tenant user (`role=2`).
- Created the three requested `pcall.admin` system admins (`role=0`) with master/admin mappings. Their approved passwords use an uppercase initial `P`.
- Transaction verification confirmed exactly one active master row per login, expected roles, master/admin mappings, and BCrypt matches.
- No source, whitelist, or deployment change was made for this DEV database operation.
