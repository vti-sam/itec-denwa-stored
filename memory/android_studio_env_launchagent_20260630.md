---
title: Android Studio environment variables via LaunchAgent
project: itec-denwa
type: runbook
status: archived
source:
  - Codex task setting persistent Android build environment variables on 2026-06-30
tags:
  - android
  - android-studio
  - build
  - launchagent
  - signing
scope: historical
captured_at: 2026-06-30
validity: historical_context
promote_to_knowledge: false
---

2026-06-30: Set persistent macOS user environment variables for Android Studio builds by creating and loading:

`~/Library/LaunchAgents/com.itec-denwa.android-env.plist`

The LaunchAgent runs at login and sets:

- `DENWA_ANDROID_ENV_SECRET_DIR=/Users/vti-sam/pm-control/itec-denwa/registry/keystore/projects/itec-denwa/android/env`
- `DENWA_ANDROID_KEYSTORE_DIR=/Users/vti-sam/pm-control/itec-denwa/registry/keystore/projects/itec-denwa/android/signing`

Immediate session values were also set with `launchctl setenv`, and read-back with `launchctl getenv` returned both expected paths.

Android Studio must be quit and opened again after this change so the app process inherits the updated launchd environment.
