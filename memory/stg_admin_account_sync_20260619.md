---
title: STG admin account synchronization
project: itec-denwa
type: lesson
status: archived
source:
- memory/stg_admin_account_sync_20260619.md
tags:
- stg
- database
- admin
- authentication
scope: historical
captured_at: '2026-06-19'
validity: historical_context
promote_to_knowledge: false
---

Synchronized the requested accounts in the live STG database `denwa_stg`.

- Runtime verification confirmed STG uses `denwa_stg` on the PRD RDS instance; the old standalone STG RDS endpoint in the local staging properties is stale.
- Reset the existing Katayama and Higashitani system admins (`role=0`).
- Reset the existing Okada master MVE admin (`role=3`) and active Okada tenant user (`role=2`).
- Created the three `pcall.admin` system admins (`role=0`) with master/admin mappings.
- The approved `pcall.admin` passwords use an uppercase initial `P`; transaction verification also rejected the lowercase-initial variants.
- Transaction verification confirmed the BCrypt passwords, expected roles and master mappings before commit.
- Post-commit read-back confirmed one active master row and one master/admin mapping for each of the six logins.
- STG configuration already contains the requested system-admin and MVE-admin IP addresses, so no whitelist/config/deployment change was required.
