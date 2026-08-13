---
title: Android build variants reduced to debug and release
project: itec-denwa
type: decision
status: archived
source:
  - Codex Android staging cleanup on 2026-06-26
tags:
  - android
  - build
  - staging
  - firebase
scope: historical
captured_at: 2026-06-26
validity: historical_context
promote_to_knowledge: false
---

2026-06-26: Android staging build was removed again per user request. The Android app should expose only `debug` and `release` variants.

Cleanup applied:

- Removed the `staging` build type creation from Android build-logic.
- Removed `STAGING` handling and staging secret candidate names from `DenwaBuildType`.
- Removed staging signing fallback alias from the signing convention plugin.
- Removed staging source/config files from the working tree where present: `app/src/staging`, `env/env_staging.json`, and `appDistributionStaging.sh`.
- Removed the extra production Firebase Android client for package `jp.co.itec.denwa.stg` from both app release `google-services.json` and registry production google-services.

Verification:

- `:app:tasks --all` shows `assembleDebug`, `assembleRelease`, `appDistributionUploadDebug`, and `appDistributionUploadRelease`.
- No `assembleStaging` or `appDistributionUploadStaging` task remains.
