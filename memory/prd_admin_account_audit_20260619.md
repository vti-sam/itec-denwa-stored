---
title: PRD admin account audit findings
project: itec-denwa
type: lesson
status: archived
source:
- memory/prd_admin_account_audit_20260619.md
tags:
- prd
- database
- admin
- authentication
scope: historical
captured_at: '2026-06-19'
validity: historical_context
promote_to_knowledge: false
---

Read-only verification against `denwa_prd` established these operational rules:

- System administrators are stored in `master_schema.admin` with role `0`; login mapping uses `master_schema.account_mapping` with tenant ID `master` and account type `0`.
- Passwords use Spring Security BCrypt. Never store or log plaintext credentials.
- System-admin source IP control is a global application property (`ip.whitelist.system.admin`), not a per-account database relation. Changing it requires application configuration/deployment, not a DB-only update.
- The live master admin table requires non-null `admin_full_name_kana` and `admin_tel`; existing operational data uses the full name as kana and `0` for telephone when unavailable.
- The live table has no uniqueness constraint on `admin_name`; write scripts must perform explicit existence checks and be idempotent.
- Tenant `111` uses schema `111_schema`. A tenant user is stored in `111_schema.users`, while a tenant administrator is a separate row in `111_schema.admin` with account type `0` mapping.
- Read-only audit script: `scratch/prd_admin_audit.py`. It excludes password hashes and refresh tokens from output.

Evidence: live PRD metadata queried with `transaction_read_only=on`, plus backend source under `sources/denwa-api`.

Follow-up verification on 2026-06-19: the three customer-supplied passwords for the already-existing active accounts did not match the BCrypt hashes currently stored in PRD. No plaintext passwords or hashes were persisted in this note.

Role correction after API/FE trace: the customer label `岡田電機管理者` maps to `MVE_ADMIN` (`role=3`) in this product, not tenant admin (`role=1`). The frontend exposes the MVE-only `/admin/maintenance` route as `岡田電機管理`, and the backend protects `/mve-admin/**` with `MVE_ADMIN`. The requested Okada source IPs are already present in the production MVE-admin whitelist.

Completed on 2026-06-19:

- Reset the two existing system-admin passwords and the active Okada tenant-user password.
- Created the Okada master MVE-admin account with role `3` and master/admin mapping.
- Created three requested system-admin accounts with role `0` and master/admin mappings.
- Independent read-back verified one active row per master account, expected roles, mappings, and BCrypt matches. The active Okada tenant user remains role `2` and also matches the requested password.
- Added the two requested source IPs to the production system-admin whitelist and pushed commit `11fff36e` to GitLab branch `prd`; the pipeline owns deployment.
- Local Maven verification is blocked by installed JDK 25 causing Lombok-generated methods not to compile. GitLab PRD CI explicitly uses Java 17.

Follow-up password correction: reset the three `pcall.admin` system-admin accounts so the initial `P` is uppercase. Transaction verification confirmed each new BCrypt password matches and each previous lowercase-initial password is rejected; refresh tokens and failure counters were cleared.
