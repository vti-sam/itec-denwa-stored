---
title: Frontend DEV SPA cache header hotfix
project: itec-denwa
type: gotcha
status: archived
source:
- memory/front_dev_spa_cache_headers_20260620.md
tags:
- frontend
- nginx
- ecs
- dev
- cache
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

2026-06-20: The DEV frontend symptom "IP whitelist message sometimes not shown" can happen when the browser keeps an old SPA shell. The UI fix for `SelectRole.vue` was already deployed, but `https://dev.apl.purattocall.com/admin/login` initially had no cache-control header for HTML.

Persistent fix pushed on `denwa-front` branch `dev`:

- `34bfc19 fix: emit cache headers in spa locations`
- Earlier related commits in the same chain: `0aa83c5`, `d5948ac`, `ce83ba6`, `59218b1`

Important runtime gotcha: the current frontend ECS image uses `/etc/nginx/nginx.conf` directly and does not include `/etc/nginx/conf.d/default.conf`. Hotpatching `conf.d/default.conf` passes `nginx -t` but has no effect. Hotpatch `/etc/nginx/nginx.conf` if an emergency runtime patch is needed.

Verification after hotpatching the active DEV container:

- `https://dev.apl.purattocall.com/admin/login` returns `cache-control: no-cache`.
- The active JS asset returns `cache-control: public, max-age=31536000, immutable`.
- Security headers remain present.
- Calling `https://api-dev.apl.purattocall.com/auth/admin/login-with-role` from non-whitelisted EC2 public IP `13.230.156.161` returned HTTP 401 with `MSG_ERR_00050` and Japanese whitelist-denial message.

Avoid building/pushing the frontend image from the current Mac Docker legacy builder for ECS hotfixes: the attempted ECR image failed with `CannotPullContainerError: layers from manifest don't match image configuration`. Prefer GitLab CI/CD or a Linux amd64 builder.
