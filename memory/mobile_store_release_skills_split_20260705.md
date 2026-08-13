---
title: Mobile store release skills split 2026-07-05
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session creating project-store mobile production release skills
tags:
  - android
  - ios
  - app-store
  - google-play
  - release
  - skill
scope: historical
captured_at: 2026-07-05
validity: historical_context
promote_to_knowledge: false
---

2026-07-05: production mobile release workflow was split into two project-local skills instead of one combined skill:

- `project-store/skills/android-store-production-release/`: Android Google Play production release workflow for `sources/denwa-android`, including version bump, scratch worktree, AAB build, Git push/tag, Play Console production upload, review submission, and verification.
- `project-store/skills/ios-store-production-release/`: iOS App Store production release workflow for `sources/denwa-ios`, including version/build bump, scratch worktree, Release archive/upload, Git push/tag, App Store Connect version/build setup, country availability, export compliance, App Review submission, and verification.

Existing DEV distribution skills remain separate:

- Android Firebase DEV: `project-store/skills/android-dev-firebase-publish/`.
- iOS DEV TestFlight: `project-store/skills/ios-debug-testflight-publish/`.

Both new skills were validated with `quick_validate.py` via `uv --with pyyaml` because the system Python lacked `yaml`.
