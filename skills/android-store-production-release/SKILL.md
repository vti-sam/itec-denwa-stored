---
name: android-store-production-release
description: Build, version, tag, upload, and submit the itec-denwa Android production release to Google Play. Use when Codex needs to release sources/denwa-android to the Play Store production track, bump Android VERSION_NAME/VERSION_CODE, build a release AAB, push prd/tag, or verify Google Play production review status.
---

# Android Store Production Release

## Overview

Use this project-store skill for the `itec-denwa` Android production Google Play workflow. Keep it separate from Android DEV Firebase App Distribution because store releases touch production versioning, Git tags, Play Console review, and rollout state.

## Fixed Targets

- Android source: `sources/denwa-android`.
- Git branch: `prd`.
- Version file: `build-logic/convention/src/main/kotlin/jp/co/itec/convention/DenwaVersion.kt`.
- Production package: `jp.co.itec.denwa`.
- Release script: `sources/denwa-android/buildProductReleaseAab.sh`.
- Google Play app: `ぷらっとCALL（puratto CALL）`.
- Track: production.
- Release tag format: `release_r<version_code_padded>_v<version_name>`, for example `release_r00060_v1.0.1`.

## Required Context

- Read root `AGENTS.md`, `project-store/AGENTS.md`, and `sources/AGENTS.md` before touching files or source workflow.
- Use `skills/knowledge-code/source-code-intel/` rules for anything under `sources/`.
- Run CodeGraph before source workflow actions and again after fetching the release snapshot.
- If the user's `sources/denwa-android` checkout is dirty, do not overwrite it. Prefer a scratch worktree under `scratch/release-android-<version>-r<code>`.
- Treat keystore files, Play Console credentials, service account JSON, and browser session state as secrets. Do not print secret contents.

## Workflow

1. Confirm the requested release version and next `VERSION_CODE`; never reuse a Play Store version code.
2. Fetch the newest remote `prd` with `--no-tags` into `refs/remotes/origin/prd`, verify the fetched SHA, and create or refresh a clean scratch worktree from that exact remote ref. Do not build from a stale local branch.
3. Update `DenwaVersion.kt` in the scratch worktree only.
4. Build the production release AAB with JDK 21.
5. Commit the version bump in the scratch worktree, push to remote `prd`, and push the release tag.
6. Upload the generated AAB to Google Play Console production track.
7. Set rollout to 100% unless the user explicitly asks for staged rollout.
8. Submit changes for review and verify Publishing overview shows the release is under review or otherwise accepted by Play Console.
9. Report commit, tag, AAB path, Play release name, rollout percentage, and review/publishing status.
10. Save useful deployment facts or gotchas in `project-store/memory/` and sync FalkorDB per root rules.

## Browser And Store Rules

- Use Chrome/browser tooling when Google Play Console work depends on the user's logged-in session.
- Before clicking final submit/review controls, make sure the user request already authorizes store submission; otherwise ask.
- Play Console UI text may be localized. Verify by stable objects where possible: app package, version code, production track, release name, and Publishing overview status.
- Managed publishing can mean Google approval is not the same as public availability. Report that distinction when it appears.

## Verification

- Before version bump/build, record `refs/remotes/origin/prd` SHA after fetch and confirm the scratch worktree `HEAD` equals it.
- `git log -1` in the scratch worktree shows the release commit.
- `git ls-remote` or remote web UI confirms `prd` and the release tag were pushed.
- After push, confirm `origin/prd` and the release tag dereference to the release commit.
- The AAB exists under `app/build/outputs/bundle/release/`.
- Google Play Console production release includes the intended version code/name.
- Publishing overview no longer lists the production release as a draft change after submission.

## Failure Handling

- If remote `prd` changes after the release snapshot is created, stop and rebuild from a newly verified remote SHA; do not push the stale scratch commit.
- If version validation or the AAB build fails, keep the previous Play release untouched and fix the scratch worktree before retrying.
- If commit/tag push partially succeeds, read back remote `prd` and tag SHAs before any retry; do not create a second tag or force push.
- If Play upload or submission status is ambiguous, use read-only Console verification first. Do not upload the same version code again or click final submission repeatedly.
- If credentials, signing material, or User authorization is missing, report the blocked gate without printing secrets or expanding the release scope.

## Completion Criterion

Complete only when the remote commit/tag, AAB version, production track, rollout percentage and Publishing overview state all match the approved release request with no unresolved draft or ambiguous submission.

## Resources

- Read `references/checklist.md` when actually executing or auditing a production Android store release.
