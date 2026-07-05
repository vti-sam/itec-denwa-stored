# Android Production Store Checklist

## Preflight

- Confirm the target version name and next integer version code with the user or source of truth.
- Read root/project/source rules before editing.
- Check `sources/denwa-android` branch and dirty state. Do not use it directly if it contains user changes.
- Ensure CodeGraph for `sources/denwa-android`.
- Use JDK 21; Gradle/Kotlin may fail with newer Java versions.
- Confirm release signing and production `google-services.json` are present without printing secrets.

## Scratch Worktree Pattern

Use a scratch worktree to avoid disturbing the user's checkout:

```bash
rtk git -C sources/denwa-android fetch origin prd
rtk git -C sources/denwa-android worktree add scratch/release-android-<version>-r<code> origin/prd
```

In the scratch worktree:

- Update `build-logic/convention/src/main/kotlin/jp/co/itec/convention/DenwaVersion.kt`.
- Set `VERSION_NAME` to the requested marketing version.
- Set `VERSION_CODE` to the next unused Play Store version code.
- Build with:

```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home
rtk bash buildProductReleaseAab.sh
```

The AAB should be under `app/build/outputs/bundle/release/` and normally includes version/build/commit in the filename.

## Git Publish

- Commit only the version bump.
- Push the commit to remote `prd`.
- Create and push tag `release_r<version_code_padded>_v<version_name>`.
- Verify remote `prd` and tag point to the intended commit.

## Google Play Console

- Open the Play Console using the user's Chrome session if needed.
- Select app package `jp.co.itec.denwa`.
- Open Production track and create or edit a release.
- Upload the AAB built from the exact pushed commit.
- Verify Play Console shows the intended version code and version name.
- Use 100% rollout unless the user asks for staged rollout.
- Submit changes for review when the user request authorizes store submission.

## Final Verification

- Check Publishing overview after submission.
- Report whether changes are under review, still draft, rejected by validation, or controlled by managed publishing.
- Include the release commit, tag, AAB path, release version code/name, and Play status in the final answer.
