---
title: Android Data Safety CSV update
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-06-30
  - scratch/data_safety_export.csv
  - sources/denwa-android/app/src/main/AndroidManifest.xml
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/model/profile/ProfileResponse.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/model/call/log/CallLogRequest.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/model/authentication/AuthenticationRequest.kt
tags:
  - android
  - google-play
  - data-safety
  - sip
scope: historical
captured_at: 2026-06-30
validity: historical_context
promote_to_knowledge: false
---

Updated `scratch/data_safety_export.csv` for Google Play Data Safety review.

Important decision: `userNameSIP` / SIP number is not a personal phone number. Do not map it to `PSL_PHONE` only because the UI/source sometimes labels it as phone. Use user/account identifiers and call/contact context where appropriate.

Applied CSV stance:

- `PSL_DATA_COLLECTION_ENCRYPTED_IN_TRANSIT=true` because app API endpoints and log upload use HTTPS.
- Removed approximate/precise location because the Android app has no location permission or source evidence for location collection.
- Selected user data items: name, email, user ID, in-app messages, photos, videos, audio, contacts/call-history context, crash logs, diagnostics, app interactions, in-app search, user-generated content, and device IDs.
- Marked collection as collected-only, not shared. Firebase/service-provider handling should be verified against current policy if privacy ownership changes.
- Kept account creation as outside-app enterprise account and did not add account/data deletion URLs because the current CSV says the app does not create accounts in-app and does not provide a deletion request mechanism.

Verification after write: CSV header unchanged, 782 data rows, 14 selected data items, and no missing usage details for selected items.
