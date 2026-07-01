---
title: Android permission cleanup must verify merged manifests
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-06-30 android prd permission cleanup
  - sources/denwa-android commit 5d748ee
tags:
  - android
  - google-play
  - permissions
  - manifest-merge
scope: historical
captured_at: 2026-06-30
validity: historical_context
promote_to_knowledge: false
---

When cleaning Android permissions for Google Play review, checking only `app/src/main/AndroidManifest.xml` is not enough.

In the 2026-06-30 prd cleanup, the app source removed `READ_PHONE_STATE`, `READ_CONTACTS`, `READ_MEDIA_AUDIO`, `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`, `CALL_PHONE`, and `READ_CALL_LOG`. However, merged/packaged manifests initially still showed some permissions because dependencies such as `webrtcsdk-release.aar` and Firebase can add them during manifest merge.

The fix used `tools:node="remove"` in `app/src/main/AndroidManifest.xml` for dependency-added phone/storage permissions, then verified `app/build/intermediates/merged_manifest/debug/processDebugMainManifest/AndroidManifest.xml` and `app/build/intermediates/packaged_manifests/debug/processDebugManifestForPackage/AndroidManifest.xml`.

Release manifest tasks may be blocked locally without private signing/env files:
`privatekey/denwa-android/keystore/keystore.json` and `privatekey/denwa-android/env/env_production.secrets.json`.
