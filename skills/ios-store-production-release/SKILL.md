---
name: ios-store-production-release
description: Build, version, tag, upload, configure, and submit the itec-denwa iOS production release to App Store Connect. Use when Codex needs to release sources/denwa-ios to the App Store, bump MARKETING_VERSION/CURRENT_PROJECT_VERSION, archive Release, upload a build, create or update an App Store version, set country availability, handle export compliance, or submit App Review.
---

# iOS Store Production Release

## Overview

Use this project-store skill for the `itec-denwa` iOS production App Store workflow. Keep it separate from iOS DEV TestFlight because production releases require App Store version metadata, country availability, export compliance, App Review submission, and public release mode checks.

## Fixed Targets

- iOS source: `sources/denwa-ios`.
- Git branch: `prd`.
- Workspace: `sources/denwa-ios/Denwa/Denwa.xcworkspace`.
- Project: `sources/denwa-ios/Denwa/Denwa.xcodeproj`.
- Scheme/configuration: `Release`.
- Targets to version: `Denwa` and `MVWebRTCNotificationServiceExtension`.
- App Store Connect app id: `6758184620`.
- App name: `ぷらっとCALL (puratto CALL)`.
- Main bundle id: `jp.co.itec.denwa.product`.
- Team id: `84S993H7LR`.
- Release tag format: `denwa-v<marketing_version>-build<build_number>(Release)`.

## Required Context

- Read root `AGENTS.md`, `project-store/AGENTS.md`, and `sources/AGENTS.md` before touching files or source workflow.
- Use `skills/source-code-intel/` rules for anything under `sources/`.
- Run CodeGraph before source workflow actions and again after fetching the release snapshot.
- If the user's `sources/denwa-ios` checkout is dirty, do not overwrite it. Prefer a scratch worktree under `scratch/release-ios-<version>-b<build>`.
- Treat App Store Connect credentials, signing identities, provisioning details, keychain state, and browser session state as secrets. Do not print secret contents.

## Workflow

1. Confirm the requested marketing version and next App Store Connect build number; never reuse a build number for the same version train.
2. Fetch the newest remote `prd` with `--no-tags` into `refs/remotes/origin/prd`, verify the fetched SHA, and create or refresh a clean scratch worktree from that exact remote ref. Do not build from a stale local branch.
3. Run `pod install` under `Denwa` when CocoaPods files may be stale.
4. Update `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` for both the app and notification extension.
5. Archive `Release` for generic iOS device and export/upload to App Store Connect.
6. Commit the version bump in the scratch worktree, push to remote `prd`, and push the release tag.
7. Wait for the uploaded build to finish processing enough for selection in App Store Connect.
8. Create or update the App Store version, fill release notes, select the build, and resolve export compliance.
9. Adjust country availability only when explicitly requested. For Japan/Vietnam-only release, set availability to Japan and Vietnam and answer France availability as `No` in export compliance.
10. Submit the version for App Review and verify the status reaches `Waiting for Review`, `In Review`, or another explicit App Store Connect state.
11. Report commit, tag, archive path, upload log path, selected build, availability scope, and App Review status.
12. Save useful deployment facts or gotchas in `project-store/memory/` and sync Qdrant per root rules.

## Browser And Store Rules

- Use Chrome/browser tooling when App Store Connect work depends on the user's logged-in session.
- Before clicking final App Review submission controls, make sure the user request already authorizes store submission; otherwise ask.
- Country availability changes are production external side effects. Ask before changing availability unless the user has explicitly requested the country scope.
- App Store Connect can keep stale export compliance modal state. After changing availability, reopen or update the compliance flow and verify `Missing Compliance` disappears.
- If France is included and standard encryption is selected, Apple may require export compliance documentation. Removing France from availability avoids the France-specific documentation path only when business scope allows it.

## Verification

- Before version bump/archive, record `refs/remotes/origin/prd` SHA after fetch and confirm the scratch worktree `HEAD` equals it.
- `git log -1` in the scratch worktree shows the release commit.
- `git ls-remote` or remote web UI confirms `prd` and the release tag were pushed.
- After push, confirm `origin/prd` and the release tag dereference to the release commit.
- Export/upload log contains upload success and export success.
- App Store Connect shows the intended version and build selected.
- Build row does not show `Missing Compliance`.
- App Review submission shows zero draft items after submit and version status is `Waiting for Review` or later.

## Resources

- Read `references/checklist.md` when actually executing or auditing a production iOS store release.
