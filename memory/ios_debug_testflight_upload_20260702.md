---
title: iOS DEV debug TestFlight upload 2026-07-02
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-02
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.1-b26-20260702-export-upload.log
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.1-b26-20260702-archive.log
tags:
  - ios
  - testflight
  - devrelease
  - app-store-connect
scope: historical
captured_at: 2026-07-02
validity: historical_context
promote_to_knowledge: false
---

Fetched and built `sources/denwa-ios` branch `prd` for a DEV/debug TestFlight upload.

Final source baseline:

- Branch: `prd`
- Commit: `69141526d085be09628250ff148517571a262527` (`Merge branch 'fix/itec_denwa_app-233' into 'prd'`)
- Scheme/configuration: `DevRelease`
- Bundle ID: `jp.co.itec.denwa.product`
- Version/build uploaded: `1.0.1 (26)`
- Endpoint in archive: `ROOT_URL=https://api-dev.apl.purattocall.com`
- Firebase plist setting: `GOOGLE_PLIST_FILE_NAME=GooglePlistDevelopment`
- Export option: `testFlightInternalTestingOnly=true`

Gotchas handled:

- `rtk git fetch` failed because the wrapped Git could not use `credential-osxkeychain`; system `/usr/bin/git` worked with the macOS keychain.
- `DevRelease` archive initially failed because CocoaPods generated files did not include `Pods-Denwa.devrelease.xcconfig`. Running `pod install` regenerated the missing DevRelease pod config and synchronized `Pods/Manifest.lock` with `Podfile.lock`.
- App Store Connect rejected `1.0.0 (24)` because build `25` already existed.
- App Store Connect rejected `1.0.0 (26)` because version train `1.0.0` was closed after approval, so the debug TestFlight build was uploaded as `1.0.1 (26)`.
- The extension build/version were aligned with the parent app to avoid validation warnings: `CURRENT_PROJECT_VERSION=26`, `MARKETING_VERSION=1.0.1`.

Upload result:

- `xcodebuild -exportArchive` returned `EXPORT SUCCEEDED`.
- App Store Connect log showed `Upload succeeded` and `Uploaded package is processing`.
- Symbol upload warnings remained for prebuilt WebRTC/MVWebRTC frameworks because their dSYM files were not present in the archive. Upload still succeeded.

