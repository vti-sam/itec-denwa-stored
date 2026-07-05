---
title: Android DEV debug Firebase release 2026-07-03
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session 2026-07-03 Android DEV debug deploy
tags:
  - android
  - firebase-app-distribution
  - dev
  - debug
  - deployment
scope: historical
captured_at: 2026-07-03
validity: historical_context
promote_to_knowledge: false
---

Built and uploaded Android DEV debug release from `sources/denwa-android` on branch `prd`.

- Commit: `acadfe0 Merge branch 'develop_241' into 'prd'`.
- Local version bump: `DenwaVersion.VERSION_CODE` changed from `59` to `60`.
- Variant: `debug`.
- Firebase project: `itec-denwa-vti-dev`.
- Android package: `jp.co.itec.denwa.dev`.
- Firebase app id: `1:16254034261:android:03f0360f1c351309b58fdc`.
- Tester group: `staging-testers`.
- Version: `1.0.0.dev_b(0060)_acadfe0`.
- APK: `app/build/outputs/apk/debug/itec-denwa_debug_1.0.0.dev_b(0060)_acadfe0.apk`.
- Release id: `2onngu1ejqgro`.
- Firebase Console: `https://console.firebase.google.com/project/itec-denwa-vti-dev/appdistribution/app/android:jp.co.itec.denwa.dev/releases/2onngu1ejqgro?utm_source=gradle`.

Verification:

- `:app:assembleDebug` passed.
- `:app:appDistributionUploadDebug` passed.
- Gradle finished with `BUILD SUCCESSFUL` in 5m 13s.

Operational note:

- The project publish wrapper enforces a clean Android worktree before running. Because this release intentionally bumped `DenwaVersion.VERSION_CODE`, the upload was run directly through `appDistributionDebug.sh` after pulling `prd` and syncing CodeGraph.
