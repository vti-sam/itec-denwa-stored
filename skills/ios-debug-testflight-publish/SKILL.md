---
name: ios-debug-testflight-publish
description: Build and upload the itec-denwa iOS debug/DEV app to TestFlight. Use when Codex needs to fetch latest iOS code from sources/denwa-ios, build the DevRelease scheme, export with App Store Connect upload settings, or rerun the project-specific iOS DEV TestFlight workflow.
---

# iOS Debug TestFlight Publish

## Overview

Use this project-store skill for the `itec-denwa` iOS DEV TestFlight workflow. It is intentionally narrow: it updates the iOS checkout on `prd`, prepares the `DevRelease` build, archives the app, and uploads to App Store Connect/TestFlight internal testing.

## Fixed Targets

- iOS source: `sources/denwa-ios`.
- Git branch: `prd`.
- Workspace: `sources/denwa-ios/Denwa/Denwa.xcworkspace`.
- Scheme/configuration: `DevRelease`.
- App bundle id: `jp.co.itec.denwa.product`.
- Notification extension target: `MVWebRTCNotificationServiceExtension`.
- DEV API endpoint in build settings: `https://api-dev.apl.purattocall.com`.
- Google plist setting: `GooglePlistDevelopment`.
- Export method: App Store Connect upload with `testFlightInternalTestingOnly=true`.
- Team id: `84S993H7LR`.

## Required Context

- Read root `AGENTS.md`, `project-store/AGENTS.md`, and `sources/AGENTS.md` before running the workflow.
- Use `skills/knowledge-code/source-code-intel/` rules for anything under `sources/`.
- Run CodeGraph before source workflow actions and again after pulling code so the local index matches the checked-out iOS tree.
- Do not print App Store Connect credentials, Apple account state, provisioning profile contents, or keychain details.

## Quick Command

Run from repo root:

```bash
rtk bash project-store/skills/ios-debug-testflight-publish/scripts/publish_debug_testflight.sh
```

The script defaults to the current marketing version and the next build number, but applies project history safeguards:

- `1.0.0` is not allowed because App Store Connect already closed that version train.
- build `26` was already uploaded for `1.0.1` on 2026-07-02, so the automatic minimum next build is `27`.

Override when needed:

```bash
rtk bash project-store/skills/ios-debug-testflight-publish/scripts/publish_debug_testflight.sh --marketing-version 1.0.1 --build-number 27
```

Use `--skip-pull` only when the user explicitly confirms using the current local iOS checkout. Use `--archive-only` to verify archive/export preparation without TestFlight upload.

## Workflow

1. Confirm no uncommitted changes exist in `sources/denwa-ios`. If the iOS worktree is dirty, stop and ask the user how to proceed.
2. Ensure CodeGraph for `sources/denwa-ios`.
3. Fetch the newest remote `prd` explicitly with `--no-tags`, then fast-forward the local `prd` branch to `refs/remotes/origin/prd`. Do not publish from a stale local branch. The helper script prepends common macOS Git helper paths so `git-credential-osxkeychain` can be found.
4. Ensure CodeGraph again after pull.
5. Run `pod install` under `sources/denwa-ios/Denwa`; `DevRelease` can fail if CocoaPods project files are stale.
6. Update `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` for both `Denwa` and `MVWebRTCNotificationServiceExtension`.
7. Archive `DevRelease` for generic iOS device.
8. Export/upload with App Store Connect TestFlight settings.
9. Report the final source commit after fetch/fast-forward, version/build, archive path, upload log path, and whether the log contains `Upload succeeded` and `EXPORT SUCCEEDED`.
10. If the run produced a useful deployment fact or gotcha, save a memory note under `project-store/memory/` and sync Qdrant per root rules.

## Preconditions

- Xcode, CocoaPods, Ruby `xcodeproj`, Apple signing access, and App Store Connect upload permission must be available locally.
- `sources/denwa-ios` must be on branch `prd`.
- The iOS worktree should be clean before release. The script's normal version bump leaves `Denwa/Denwa.xcodeproj/project.pbxproj` dirty afterward; commit, stash, or deliberately handle that change after upload.
- Network and Git credentials for `sources/denwa-ios` must be available.

## Troubleshooting

- If `git pull` fails with `git-credential-osxkeychain` missing, rerun through the bundled script or prepend `/Library/Developer/CommandLineTools/usr/libexec/git-core` to `PATH`.
- If the archive fails because `Pods-Denwa.*.xcconfig` or `DevRelease` CocoaPods settings are missing, run `pod install` from `sources/denwa-ios/Denwa`.
- If App Store Connect rejects `1.0.0`, bump `MARKETING_VERSION` to `1.0.1` or newer. Android does not need this because Android/Firebase primarily keys releases by `versionCode`, while iOS TestFlight uses the App Store version train.
- If App Store Connect rejects the build as already used or too low, increment `CURRENT_PROJECT_VERSION` for both the app and notification extension.
- Missing dSYM warnings for prebuilt `MVWebRTCFramework`, `MVWebRTCInterface`, `MVWebRTCNativeCall`, or `WebRTC` were non-blocking during the 2026-07-02 upload.
- `Uploaded package is processing` means upload succeeded but TestFlight processing still needs App Store Connect time.

## Resources

- `scripts/publish_debug_testflight.sh`: deterministic wrapper for CodeGraph, Git pull, CocoaPods, version bump, archive, and TestFlight upload.
