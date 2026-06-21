---
title: STG multi-role admin whitelist bypass
project: itec-denwa
type: lesson
status: archived
source:
- memory/stg_multirole_admin_whitelist_bypass_20260619.md
tags:
- stg
- authentication
- whitelist
- admin
scope: historical
captured_at: '2026-06-19'
validity: historical_context
promote_to_knowledge: false
---

Investigated STG admin login for a multi-role admin account from the admin web flow.

- `/auth/admin/login` returns `200 ES200` with `roles` for multi-role accounts before calling `AuthService.processCheckTenant(...)`, so the IP whitelist is not evaluated in that first step.
- The frontend then stores the temporary login credentials in `sessionStorage` and calls `/auth/admin/login-with-role` after role selection.
- Backend `/auth/admin/login-with-role` is public in `SecurityConfig.PUBLIC_APIS`; when `role != tenant_admin`, `AuthController.loginAdminWithRole(...)` directly calls `authService.systemAdminLogin(...)`.
- `systemAdminLogin(...)` authenticates and issues tokens but does not call `processCheckTenant(...)`, so selecting `master_admin` can bypass `ip.whitelist.system.admin`.
- Repro on STG with the provided multi-role account showed `/auth/admin/login` returning roles and `/auth/admin/login-with-role` returning an access token. Adding `X-Forwarded-For: 8.8.8.8` still returned success for both calls.
- Fix direction: centralize/check master-role IP whitelist before returning `roles` for master-capable accounts and before issuing tokens in `/auth/admin/login-with-role` for `master_admin`/MVE admin roles.
- Implemented on backend `dev` and pushed commit `30aa19ae` (`fix: enforce whitelist on master role login`). The fix validates master mapping and calls the existing `processCheckTenant(...)` whitelist logic before issuing a token from `/auth/admin/login-with-role` for non-tenant role selection.
- Local runtime verification is possible without Docker: open the dev DB tunnel on `127.0.0.1:15432`, run backend with JDK 21, profile `dev`, `server.ssl.enabled=false`, `server.port=18080`, `spring.main.allow-circular-references=true`, `spring.main.lazy-initialization=true`, and override `ip.whitelist.system.admin=1.2.3.4`.
- Local-only gotcha: `WebConfig.corsFilter(...)` returns `FilterRegistrationBean<CorsFilter>`, which Spring Security tries to resolve as a `CorsFilter` by bean name on first request. Temporarily renaming the bean method to `corsFilterRegistration(...)` lets local API verification proceed; do not commit this workaround unless intentionally fixing the CORS bean.
- Local API verification after the dev fix: `/auth/admin/login` returned roles, then `/auth/admin/login-with-role` with `role=master_admin` returned HTTP `401` and `MSG_ERR_00050`, with no access token.
