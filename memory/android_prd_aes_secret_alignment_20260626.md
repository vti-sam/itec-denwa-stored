---
title: Android PRD AES secret alignment for OTP/login decrypt
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex Android PRD Firebase Distribution deploy on 2026-06-26
tags:
  - android
  - production
  - firebase-distribution
  - aes
  - otp
scope: historical
captured_at: 2026-06-26
validity: historical_context
promote_to_knowledge: false
---

2026-06-26: PRD Android login/OTP decrypt issue was caused by Android release `ENCRYPTION_SECRET` being out of sync with AWS PRD Secrets Manager `/denwa/prd/all` field `aes-key`.

Operational rule: for production Android release builds, `registry/keystore/projects/itec-denwa/android/env/production.secrets.json` `buildConfig.ENCRYPTION_SECRET.value` must match AWS PRD `/denwa/prd/all` `aes-key`.

Fix applied:

- Updated `registry/keystore/projects/itec-denwa/android/env/production.secrets.json` to match AWS PRD `aes-key`.
- Rebuilt Android release with JDK 21 and registry production signing/env symlinks.
- Verified generated release `BuildConfig` uses package `jp.co.itec.denwa`, PRD API/socket endpoints, and an `ENCRYPTION_SECRET` matching AWS PRD.
- Uploaded release to Firebase project `p-call-70ece`, Android app `jp.co.itec.denwa`, group `production-early-access-testers`, release `1ln5pjfu5cl6o`.

Avoid changing AWS PRD `aes-key` just to match a local Android file unless existing encrypted data migration/impact has been checked.
