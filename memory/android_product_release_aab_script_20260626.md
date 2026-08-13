---
title: Android product release AAB build script
project: itec-denwa
type: runbook
status: archived
source:
  - Codex Android AAB build script task on 2026-06-26
tags:
  - android
  - release
  - aab
  - signing
scope: historical
captured_at: 2026-06-26
validity: historical_context
promote_to_knowledge: false
---

2026-06-26: Added `sources/denwa-android/buildProductReleaseAab.sh` to build a production release AAB using registry-backed Android signing and environment secrets.

The script:

- Resolves workspace root from its own location.
- Creates temporary symlinks under `/tmp/denwa-android-prd-aab-build`.
- Maps registry `signing-config.json` to Gradle's expected `keystore.json`.
- Maps registry `production.secrets.json` to Gradle's expected `env_production.secrets.json`.
- Uses JDK 21 when available.
- Runs `./gradlew :app:bundleRelease`.

Verification on 2026-06-26 produced:

`sources/denwa-android/app/build/outputs/bundle/release/itec-denwa_release_1.0.0_b(0055)_faec0f8.aab`

Gotcha: Android signing config JSON still contains a staging entry in registry, so the signing convention plugin was adjusted to load only active signing configs `development` and `release` after the app build variants were reduced to debug/release.
