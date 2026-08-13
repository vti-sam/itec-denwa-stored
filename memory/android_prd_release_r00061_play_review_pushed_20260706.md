---
title: Android PRD release r00061 submitted to Google Play and pushed
project: itec-denwa
type: runbook
status: archived
source:
  - Codex Android PRD release submission task on 2026-07-06
  - sources/denwa-android
  - Google Play Console publishing overview
tags:
  - android
  - release
  - google-play
  - git
  - aab
scope: historical
captured_at: 2026-07-06
validity: historical_context
promote_to_knowledge: false
---

2026-07-06: Android production release r00061 was submitted to Google Play review and pushed to Git.

Google Play status after submission:

- Changes moved from "not submitted for review" to "under review".
- Submitted change: production release `61 (1.0.1_b(0061)_1c44c1a)`.
- Managed publishing is enabled, so after Google approval a manual publish action may still be required.
- Play Console still displayed the quick check panel after submission, with no error markers and an estimated maximum of 9 minutes remaining at the final check.

Android repo state:

- Repo: `sources/denwa-android`
- Branch: `prd`
- Commit pushed to `origin/prd`: `1c44c1a2763f2c9c636e6219ed567a41cfbe782d` (`release: bump android version to 1.0.1 (61)`)
- Tag pushed: `release_r00061_v1.0.1`
- Version name was kept at `1.0.1`; version code was bumped from `60` to `61`.

AAB submitted to Google Play:

`scratch/release-android-1.0.1-r00061/app/build/outputs/bundle/release/itec-denwa_release_1.0.1_b(0061)_1c44c1a.aab`

SHA256:

`cfacd5c37cef98901af37c0d35c5fbba64e4c0aaf41afc4e59b256b839dba85c`
