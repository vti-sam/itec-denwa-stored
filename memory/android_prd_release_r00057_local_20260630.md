---
title: Android PRD release r00057 built and tagged locally
project: itec-denwa
type: runbook
status: archived
source:
  - Codex Android PRD version bump/tag/build task on 2026-06-30
tags:
  - android
  - release
  - git
  - aab
  - production
scope: historical
captured_at: 2026-06-30
validity: historical_context
promote_to_knowledge: false
---

2026-06-30: Android production release version code was bumped from 56 to 57 while keeping version name `1.0.0`.

Local Android repo state after the task:

- Branch: `prd`
- Commit: `edf581a` (`bump version code to 57 (v1.0.0)`)
- Local tag: `release_r00057_v1.0.0`
- Built AAB: `sources/denwa-android/app/build/outputs/bundle/release/itec-denwa_release_1.0.0_b(0057)_edf581a.aab`

Verification:

- `buildProductReleaseAab.sh` completed successfully after the commit.
- The output AAB size was 61.7M.
- Branch `prd` was ahead of `origin/prd` by 1 local commit after commit/tag creation.

Push was not attempted in this task.
