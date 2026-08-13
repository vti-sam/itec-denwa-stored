---
title: PRD dev merge for API and frontend
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session 2026-06-21 merge dev into prd for denwa-api and denwa-front
tags:
  - prd
  - merge
  - frontend
  - api
  - cicd
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

2026-06-21: merged `origin/dev` into `prd` and pushed both source repos:

- `sources/denwa-api`: merge commit `776ae9f4` on `prd`, parented from `origin/prd` `766f3fc7` and `origin/dev` `af607744`.
- `sources/denwa-front`: merge commit `1893f87` on `prd`, parented from `origin/prd` `6573983` and `origin/dev` `b32f70a`.

Frontend `.gitlab-ci.yml` needed manual conflict handling. Keep the PRD-specific behavior that fetches the current task definition from the live PRD ECS service before registering the next revision. Bring over the DEV hardening pieces: `npm ci --cache`, mandatory `npm run type-check`, commit-short-SHA image tag, explicit `VITE_API_BASE_URL`, no manual ECS `stop-task`, expected task-definition check, and smoke tests for cache headers and bundled API host.

Frontend `.gitignore` was intentionally left as PRD, preserving `.codegraph/` ignore. The nginx cache header changes and `SelectRole.vue` error display from `dev` were merged.

Verification:

- Frontend: `.gitlab-ci.yml` parsed with Ruby YAML and `npm run type-check` passed.
- API: `bash ./mvnw test` passed with `JAVA_HOME=/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home`.
- API integration profile `bash ./mvnw -Papi-it verify` compiled, then failed because Testcontainers could not find Docker (`/var/run/docker.sock` missing). This is an environment blocker, not a compile failure.
- API local JDK 25 still fails Lombok-generated method resolution; use JDK 21 locally or JDK 17 in GitLab CI.
- `git diff --check` on API needs `core.whitespace=cr-at-eol` because XML files use CRLF and new CRLF lines are otherwise reported as trailing whitespace.

Untracked local file left untouched: `sources/denwa-api/src/main/java/jp/co/itec/denwa/service/.DS_Store`.
