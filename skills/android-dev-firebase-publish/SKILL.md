---
name: android-dev-firebase-publish
description: Build and publish the itec-denwa Android debug/dev APK to Firebase App Distribution. Use when Codex needs to fetch latest Android code, build the debug variant from sources/denwa-android, upload to the DEV Firebase project, distribute to staging testers, or rerun the project-specific Android DEV App Distribution workflow.
---

# Android Dev Firebase Publish

## Overview

Use this project-store skill for the `itec-denwa` Android DEV Firebase App Distribution workflow. It is intentionally narrow: it fetches the Android source repo, builds the `debug` variant, and uploads it to the DEV Firebase App Distribution app.

## Fixed Targets

- Android source: `sources/denwa-android`.
- Git branch: `prd`.
- Build variant: `debug`.
- Firebase project: `itec-denwa-vti-dev`.
- Android package: `jp.co.itec.denwa.dev`.
- Firebase app id: `1:16254034261:android:03f0360f1c351309b58fdc`.
- Tester group: `staging-testers`.
- Project script: `sources/denwa-android/appDistributionDebug.sh`.

Do not use the removed `dev` or `staging` Android build types. Current Android variants are `debug` and `release`; DEV distribution uses `debug` with `.dev` package suffix.

## Required Context

- Read root `AGENTS.md`, `project-store/AGENTS.md`, and `sources/AGENTS.md` before running the workflow.
- Use `skills/source-code-intel/` rules for anything under `sources/`.
- Run CodeGraph before source workflow actions and again after pulling code so the local index matches the checked-out Android tree.
- Treat Firebase service account JSON files as secrets. Do not print credential contents.

## Quick Command

Run from repo root:

```bash
rtk bash project-store/skills/android-dev-firebase-publish/scripts/publish_debug_dev_firebase.sh
```

Use `--skip-pull` only when the user explicitly confirms using the current local Android checkout.

## Workflow

1. Confirm no uncommitted changes exist in `sources/denwa-android`. If the Android worktree is dirty, stop and ask the user how to proceed.
2. Ensure CodeGraph for `sources/denwa-android`.
3. Pull `prd` with `git pull --ff-only`. The helper script prepends `/Library/Developer/CommandLineTools/usr/libexec/git-core` to `PATH` so `git-credential-osxkeychain` can be found on macOS.
4. Ensure CodeGraph again after pull.
5. Use JDK 21. Gradle/Kotlin may fail under newer Java versions.
6. Run `appDistributionDebug.sh` with `ITEC_PROJECT_DIR` set to `sources/denwa-android`.
7. Report the final commit, version suffix, Firebase release id, Firebase Console link, and whether Gradle ended with `BUILD SUCCESSFUL`.
8. If the run produced a useful deployment fact or gotcha, save a memory note under `project-store/memory/` and sync Qdrant per root rules.

## Preconditions

- `sources/denwa-android/env/distribution/itec-denwa-distribution-dev-key.json` must exist locally.
- JDK 21 must be installed, preferably at `/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home`.
- Network and Git credentials for `https://git.vti.com.vn/itec_denwa_app/denwa-android.git` must be available.
- Firebase App Distribution permissions must be valid for the DEV service account.

## Troubleshooting

- If `git pull` fails with `git-credential-osxkeychain` missing, rerun through the bundled script or prepend `/Library/Developer/CommandLineTools/usr/libexec/git-core` to `PATH`.
- If Gradle fails with Java version errors, force JDK 21 via `DENWA_ANDROID_JAVA_HOME` or install JDK 21.
- If upload fails with `403 PERMISSION_DENIED`, verify the DEV Firebase service account and that the debug `google-services.json` still points to Firebase project number `16254034261`.
- If testers cannot see the release, confirm the upload targeted group `staging-testers` and app id `1:16254034261:android:03f0360f1c351309b58fdc`.

## Resources

- `scripts/publish_debug_dev_firebase.sh`: deterministic wrapper for CodeGraph, Git pull, JDK 21 setup, and Firebase debug upload.
