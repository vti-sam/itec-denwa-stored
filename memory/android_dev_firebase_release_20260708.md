---
title: Android DEV Firebase release 2026-07-08
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session Android DEV Firebase App Distribution upload
tags:
  - android
  - firebase-app-distribution
  - debug
  - deployment
scope: historical
captured_at: 2026-07-08
validity: historical_context
promote_to_knowledge: false
---

2026-07-08: pulled `sources/denwa-android` on branch `prd`, built the Android debug DEV APK, and uploaded it to Firebase App Distribution.

- Pull result: fast-forwarded from `1c44c1a` to `0f83154`.
- Commit: `0f83154 Merge branch 'develop_244' into 'prd'`.
- Variant: `debug`.
- Firebase project: `itec-denwa-vti-dev`.
- Android package: `jp.co.itec.denwa.dev`.
- Firebase app id: `1:16254034261:android:03f0360f1c351309b58fdc`.
- Tester group: `staging-testers`.
- Version: `1.0.1.dev_b(0061)_0f83154`.
- APK: `sources/denwa-android/app/build/outputs/apk/debug/itec-denwa_debug_1.0.1.dev_b(0061)_0f83154.apk`.
- Release id: `6cdd4o5rqgjuo`.
- Firebase Console: `https://console.firebase.google.com/project/itec-denwa-vti-dev/appdistribution/app/android:jp.co.itec.denwa.dev/releases/6cdd4o5rqgjuo?utm_source=gradle`.
- Tester release link: `https://appdistribution.firebase.google.com/testerapps/1:16254034261:android:03f0360f1c351309b58fdc/releases/6cdd4o5rqgjuo?utm_source=gradle`.

Verification:

- CodeGraph `ensure` passed before and after pull for `sources/denwa-android`.
- `:app:assembleDebug` passed.
- `:app:appDistributionUploadDebug` passed.
- Gradle finished with `BUILD SUCCESSFUL` in 4m 57s.
- Android worktree was clean after upload when checked with `/usr/bin/git status --porcelain=v1 -uall`.

Operational note:

- The project wrapper `project-store/skills/android-dev-firebase-publish/scripts/publish_debug_dev_firebase.sh` stopped at the dirty-worktree check because `rtk git status --porcelain` returned a single `ok` line, while `/usr/bin/git status --porcelain=v1 -uall` showed the worktree was actually clean. The workflow was completed manually using `/usr/bin/git` for Git status/fetch/merge and `rtk` for CodeGraph/build/upload.
