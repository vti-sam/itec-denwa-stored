---
title: Android debug Firebase release 2026-07-02
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session 2026-07-02 Android debug deploy
tags:
  - android
  - firebase-app-distribution
  - debug
  - deployment
scope: historical
captured_at: 2026-07-02
validity: historical_context
promote_to_knowledge: false
---

Fetched and uploaded Android debug release from `sources/denwa-android` on branch `prd`.

- Pull result: updated from `71907b0` to `7b5c026`.
- Commit: `7b5c026 234 => enable external speaker when call video`.
- Variant: `debug`.
- Firebase project: `itec-denwa-vti-dev`.
- Android package: `jp.co.itec.denwa.dev`.
- Firebase app id: `1:16254034261:android:03f0360f1c351309b58fdc`.
- Tester group: `staging-testers`.
- Version suffix shown by Gradle: `1.0.0.dev_b(0059)_56686e8`.
- Release id: `4ot1ikbf2s0oo`.

Command used:

```bash
JAVA_HOME="/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home" \
ITEC_PROJECT_DIR="/Users/vti-sam/pm-control/itec-denwa/sources/denwa-android" \
rtk bash appDistributionDebug.sh
```

Verification:

- `:app:assembleDebug` passed.
- `:app:appDistributionUploadDebug` passed.
- Gradle finished with `BUILD SUCCESSFUL` in 4m 49s.

Operational note:

- Initial `git pull --ff-only` failed because `git-credential-osxkeychain` was not on PATH. Retrying with `/Library/Developer/CommandLineTools/usr/libexec/git-core` prepended to PATH allowed Git credential lookup and pull succeeded.
