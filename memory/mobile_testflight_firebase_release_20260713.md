---
title: iOS production TestFlight and Android DEV Firebase release 2026-07-13
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-13
  - sources/denwa-ios
  - sources/denwa-android
tags:
  - ios
  - testflight
  - production
  - android
  - firebase-app-distribution
  - debug
scope: historical
captured_at: 2026-07-13
validity: historical_context
promote_to_knowledge: false
---

Published the requested local working-tree changes without pulling, committing, tagging, or pushing.

## iOS

- Source branch/commit: `prd` at `28e0b35`, with the requested uncommitted Settings/Profile changes.
- Scheme/configuration: `Denwa` / `Release`.
- Bundle ID: `jp.co.itec.denwa.product`.
- Production endpoint: `https://api.apl.purattocall.com`.
- Firebase plist: `GooglePlistProduction`.
- Initial upload of `1.0.1 (28)` was rejected because App Store Connect had closed the approved `1.0.1` train.
- Final uploaded version/build: `1.0.2 (28)`.
- Archive: `scratch/ios-product-testflight/Denwa-prd-release-v1.0.2-b28-20260713.xcarchive`.
- Upload result: `Upload succeeded`, `Uploaded package is processing`, and `EXPORT SUCCEEDED`.
- Missing dSYM warnings remained for the prebuilt MVWebRTC/WebRTC frameworks and did not block upload.

## Android

- Source branch/commit: `prd` at `0b54280`, with the requested uncommitted Settings/Profile changes.
- Variant/package: `debug` / `jp.co.itec.denwa.dev`.
- Firebase project/group: `itec-denwa-vti-dev` / `staging-testers`.
- Version: `1.0.1.dev_b(0062)_0b54280`.
- Firebase release ID: `5moth92v8n1to`.
- Firebase Console: `https://console.firebase.google.com/project/itec-denwa-vti-dev/appdistribution/app/android:jp.co.itec.denwa.dev/releases/5moth92v8n1to?utm_source=gradle`.
- Tester link: `https://appdistribution.firebase.google.com/testerapps/1:16254034261:android:03f0360f1c351309b58fdc/releases/5moth92v8n1to?utm_source=gradle`.
- APK SHA256: `f6dd5c28b885711f1af6d70f452047b50f5a1b5b9bc1127e2d53a341f75b94a9`.
- Gradle result: `BUILD SUCCESSFUL`.
