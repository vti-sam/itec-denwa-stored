# iOS Production Store Checklist

## Preflight

- Confirm the target marketing version and next build number with the user or App Store Connect.
- Read root/project/source rules before editing.
- Check `sources/denwa-ios` branch and dirty state. Do not use it directly if it contains user changes.
- Ensure CodeGraph for `sources/denwa-ios`.
- Confirm Xcode, CocoaPods, Ruby `xcodeproj`, signing access, and App Store Connect upload permission are available.
- Check App Store Connect for existing versions and uploaded builds. Do not assume the local build number is safe.

## Scratch Worktree Pattern

Use a scratch worktree to avoid disturbing the user's checkout:

```bash
rtk git -C sources/denwa-ios fetch origin prd
rtk git -C sources/denwa-ios worktree add scratch/release-ios-<version>-b<build> origin/prd
```

In the scratch worktree:

- Run `pod install` from `Denwa` when needed.
- Update `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` on both `Denwa` and `MVWebRTCNotificationServiceExtension`.
- Archive `Release` for `generic/platform=iOS`.
- Export/upload using App Store Connect upload options and team id `84S993H7LR`.
- Keep archive/export logs under `scratch/ios-store-release/`.

## Git Publish

- Commit only the version bump.
- Push the commit to remote `prd`.
- Create and push tag `denwa-v<marketing_version>-build<build_number>(Release)`.
- Verify remote `prd` and tag point to the intended commit.

## App Store Connect

- Open App Store Connect app id `6758184620` using the user's Chrome session if needed.
- Create or update the iOS version matching `MARKETING_VERSION`.
- Fill "What's New in This Version" in natural Japanese. For minor fixes, `軽微な修正を行いました。` is acceptable when scope matches.
- Select the uploaded build matching `CURRENT_PROJECT_VERSION`.
- Resolve export compliance:
  - For standard encryption, answer the encryption questions consistently with the app.
  - If availability is Japan and Vietnam only, answer France availability as `No`.
  - Verify the build no longer shows `Missing Compliance`.
- Keep manual release unless the user asks for automatic release.
- Submit for App Review when the user request authorizes store submission.

## Availability Scope

- Do not change country availability unless explicitly requested.
- For Japan/Vietnam-only deployment:
  - Open Pricing and Availability.
  - Set Country or Region Availability to only Japan and Vietnam.
  - Confirm App Store Connect's warning that other countries will be removed and may take up to 24 hours.
  - Return to the version page and refresh export compliance if the France modal still shows the old answer.

## Final Verification

- Version page shows the intended version and build.
- `Missing Compliance` is absent.
- Draft submissions count is zero after submit.
- Version status is `Waiting for Review`, `In Review`, or another explicit submitted state.
- Report archive path, upload log path, pushed commit/tag, selected build, availability scope, and review status.
