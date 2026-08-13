---
title: Android PRD release r00058 submitted to Google Play and pushed
project: itec-denwa
type: runbook
status: archived
source:
  - Codex Android PRD release submission task on 2026-06-30
  - sources/denwa-android
  - Google Play Console publishing overview
tags:
  - android
  - release
  - google-play
  - git
  - aab
scope: historical
captured_at: 2026-06-30
validity: historical_context
promote_to_knowledge: false
---

2026-06-30: Android production release r00058 was submitted to Google Play review and pushed to Git.

Google Play status after submission:

- Changes moved from "not submitted for review" to "under review".
- Submitted changes: production release `58 (1.0.0_b(0058)_5d748ee)`, Japan country/region addition, and Data Safety questionnaire.
- Managed publishing is enabled, so after Google approval a manual publish action may still be required.

Android repo state:

- Repo: `sources/denwa-android`
- Branch: `prd`
- Commit pushed to `origin/prd`: `3bfb6d95afe3bed1444749157e37a079a45feb2d` (`bump version code to 58 (v1.0.0)`)
- Tag pushed: `release_r00058_v1.0.0`
- Tag note includes the Google Play submission version and AAB path.

AAB submitted to Google Play:

`sources/denwa-android/app/build/outputs/bundle/release/itec-denwa_release_1.0.0_b(0058)_5d748ee.aab`
