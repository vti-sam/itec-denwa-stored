---
title: Android MRs 377 376 375 merged and Firebase release 2026-07-03
project: itec-denwa
type: decision
status: archived
source:
  - Codex session GitLab Android MR merge and Firebase DEV distribution upload
tags:
  - android
  - gitlab
  - merge-request
  - firebase-app-distribution
  - deployment
scope: historical
captured_at: 2026-07-03
validity: historical_context
promote_to_knowledge: false
---

2026-07-03: merged non-draft Android merge requests into `prd`, skipped the draft MR, then built and uploaded Android DEV debug release to Firebase App Distribution.

Merged MRs:

- `itec_denwa_app/denwa-android!377`: `224 => show pop-up maintain`.
  - Source branch: `develop_224`.
  - Source commit: `7c8997076ab1f876f81440e3f670fc5381607b92`.
  - Merge commit from GitLab API: `f1f6fa22bf4cbe5a4aa5fffc13095d452df1b4e8`.
- `itec_denwa_app/denwa-android!376`: `226 => sv top = 403`.
  - Source branch: `develop_226`.
  - Source commit: `49d2eeaca24424034d5d2e70d68bba05d77bffec`.
  - Merge commit from GitLab API: `fc3abb3aae8ed6337ca0eea40303604200e588cb`.
- `itec_denwa_app/denwa-android!375`: `240 => fix bug push notifi when voice message`.
  - Source branch: `develop_240`.
  - Source commit: `c960aab0f6e5607a5a72562c98657806238e0c77`.
  - Merge commit from GitLab API: `031f440c26f147a10fcba7cba8f1569ee2d50254`.

Skipped:

- `itec_denwa_app/denwa-android!365`: still opened and draft.

Firebase DEV release:

- Local final commit after pull: `031f440 Merge branch 'develop_240' into 'prd'`.
- Local version bump: `DenwaVersion.VERSION_CODE` changed from `59` to `61` so the release does not reuse build `60`.
- Variant: `debug`.
- Firebase project: `itec-denwa-vti-dev`.
- Android package: `jp.co.itec.denwa.dev`.
- Firebase app id: `1:16254034261:android:03f0360f1c351309b58fdc`.
- Tester group: `staging-testers`.
- Version: `1.0.0.dev_b(0061)_031f440`.
- APK: `app/build/outputs/apk/debug/itec-denwa_debug_1.0.0.dev_b(0061)_031f440.apk`.
- Release id: `0afs0f99d1m0o`.
- Firebase Console: `https://console.firebase.google.com/project/itec-denwa-vti-dev/appdistribution/app/android:jp.co.itec.denwa.dev/releases/0afs0f99d1m0o?utm_source=gradle`.

Verification:

- GitLab API read-back returned `state: merged` for MRs `!377`, `!376`, and `!375`.
- GitLab API showed only draft MR `!365` remained opened.
- Local `origin/prd` contains source commits `7c8997076ab1f876f81440e3f670fc5381607b92`, `49d2eeaca24424034d5d2e70d68bba05d77bffec`, and `c960aab0f6e5607a5a72562c98657806238e0c77`.
- GitLab API returned no pipelines for the three Android merge commits.
- `:app:assembleDebug` passed.
- `:app:appDistributionUploadDebug` passed.
- Gradle finished with `BUILD SUCCESSFUL` in 3m 30s.
