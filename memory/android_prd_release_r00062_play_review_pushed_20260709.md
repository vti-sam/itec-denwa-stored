---
title: Android PRD release r00062 submitted to Google Play and pushed
project: itec-denwa
type: runbook
status: archived
source:
  - Codex Android PRD release submission task on 2026-07-09
  - sources/denwa-android
  - Google Play Console publishing overview
tags:
  - android
  - release
  - google-play
  - git
  - aab
scope: historical
captured_at: 2026-07-09
validity: historical_context
promote_to_knowledge: false
---

2026-07-09: Android production release r00062 was submitted to Google Play review and pushed to Git.

Google Play status after submission:

- Changes moved from "not submitted for review" to "under review".
- Submitted change: production release `62 (1.0.1_b(0062)_0b54280)`.
- Rollout shown by Play Console: full rollout.
- Managed publishing is enabled, so after Google approval a manual publish action may still be required.
- Play Console showed one non-blocking warning for version code 62: the App Bundle contains native code but no native debug symbols were uploaded, which affects crash/ANR analysis.

Android repo state:

- Repo: `sources/denwa-android`
- Branch: `prd`
- Commit pushed to `origin/prd`: `0b5428023193968917ed4b8c4a8225d61e0d3dea` (`release: bump android version to 1.0.1 (62)`)
- Tag pushed: `release_r00062_v1.0.1`
- Version name was kept at `1.0.1`; version code was bumped from `61` to `62`.
- Remote verification confirmed `refs/heads/prd` and `refs/tags/release_r00062_v1.0.1^{}` both point to `0b5428023193968917ed4b8c4a8225d61e0d3dea`.

AAB submitted to Google Play:

`scratch/release-android-1.0.1-r00062/app/build/outputs/bundle/release/itec-denwa_release_1.0.1_b(0062)_0b54280.aab`

SHA256:

`18792c2430d59a1a99db0fbd065ceb1a2f25adcba9378841e2b768bdeff28f84`

Build note:

- An earlier AAB built before the version bump commit used suffix `_0f83154`; it was not uploaded. The uploaded AAB was rebuilt after the release commit and uses suffix `_0b54280`.
