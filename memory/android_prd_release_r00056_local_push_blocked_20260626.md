---
title: Android PRD release r00056 built locally but push blocked
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex Android PRD release/tag/build task on 2026-06-26
tags:
  - android
  - release
  - git
  - aab
  - production
scope: historical
captured_at: 2026-06-26
validity: historical_context
promote_to_knowledge: false
---

2026-06-26: Android production release version code was bumped from 55 to 56 while keeping version name `1.0.0`.

Local Android repo state:

- Branch: `prd`
- Commit: `824e764` (`bump version code to 56 (v1.0.0)`)
- Local tag: `release_r00056_v1.0.0`
- Built AAB: `sources/denwa-android/app/build/outputs/bundle/release/itec-denwa_release_1.0.0_b(0056)_824e764.aab`

Push blocker:

- `git push origin prd` and remote tag checks failed because local Git is configured with `credential.helper=osxkeychain`, but `git-credential-osxkeychain` is not available in this environment.
- Error: `fatal: could not read Username for 'https://git.vti.com.vn': Device not configured`.

Until Git credentials are fixed, branch `prd` remains ahead of `origin/prd` by 1 local commit and the release tag exists only locally.
