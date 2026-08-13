---
title: Android DEV Firebase publish skill created 2026-07-02
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-02 create stored Android DEV Firebase publish skill
tags:
  - android
  - firebase-app-distribution
  - debug
  - deployment
  - skill
scope: historical
captured_at: 2026-07-02
validity: historical_context
promote_to_knowledge: false
---

Created project stored skill `project-store/skills/android-dev-firebase-publish/` for the Android DEV Firebase App Distribution workflow.

Skill scope:

- Android source: `sources/denwa-android`.
- Branch: `prd`.
- Variant: `debug`.
- Firebase project: `itec-denwa-vti-dev`.
- Android package: `jp.co.itec.denwa.dev`.
- Firebase app id: `1:16254034261:android:03f0360f1c351309b58fdc`.
- Tester group: `staging-testers`.

Bundled script:

```bash
rtk bash project-store/skills/android-dev-firebase-publish/scripts/publish_debug_dev_firebase.sh
```

The script checks the Android worktree is clean, runs CodeGraph for `sources/denwa-android`, pulls `prd` with `--ff-only`, forces JDK 21, and calls `sources/denwa-android/appDistributionDebug.sh`.

Validation:

- `quick_validate.py` passed via `rtk uv run --with pyyaml`.
- `bash -n` passed for `publish_debug_dev_firebase.sh`.
- `publish_debug_dev_firebase.sh --help` passed without touching Firebase.
