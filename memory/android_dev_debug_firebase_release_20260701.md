---
title: Android DEV debug Firebase release 2026-07-01
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session 2026-07-01 Android DEV debug deploy
tags:
  - android
  - firebase-app-distribution
  - dev
  - debug
  - deployment
scope: historical
captured_at: 2026-07-01
validity: historical_context
promote_to_knowledge: false
---

Built and uploaded Android DEV debug release from `sources/denwa-android` working tree on branch `prd`.

Build/upload command used JDK 21 and the DEV Firebase Distribution service account from registry:

- Variant: `debug`
- Firebase project: `itec-denwa-vti-dev`
- Android package: `jp.co.itec.denwa.dev`
- Firebase app id: `1:16254034261:android:03f0360f1c351309b58fdc`
- Tester group: `staging-testers`
- Version: `1.0.0.dev_b(0059)_71907b0`
- Release id: `5mrbmhrdup728`

Verification:

- `:call:testDebugUnitTest` passed.
- `:app:testDebugUnitTest` passed.
- `:app:assembleDebug` passed.
- `:app:appDistributionUploadDebug` passed.
- Gradle finished with `BUILD SUCCESSFUL` in 7m 13s.

Note:

- Build included local uncommitted Android call bug fixes in `AudioCodecCallManager.kt`, `MainActivity.kt`, and related unit tests.
- DEV debug config used `https://api-dev.apl.purattocall.com` for both API and socket endpoint.
