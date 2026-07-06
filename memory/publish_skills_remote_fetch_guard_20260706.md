---
title: Publish skills remote fetch guard added
project: itec-denwa
type: lesson
status: archived
source:
  - Codex publish skill update task on 2026-07-06
  - project-store/skills
tags:
  - publish
  - release
  - git
  - fetch
  - skill
scope: historical
captured_at: 2026-07-06
validity: historical_context
promote_to_knowledge: false
---

2026-07-06: Publish/release skills were tightened so future deploys fetch the newest remote ref before building or uploading.

Updated skill areas:

- Android DEV Firebase publish now fetches `origin/prd` with `--no-tags`, fast-forwards to `refs/remotes/origin/prd`, and prints the fetched SHA.
- iOS DEV TestFlight publish now fetches `origin/prd` with `--no-tags`, fast-forwards to `refs/remotes/origin/prd`, and prints the fetched SHA.
- DEV API/Front manual publish now fetches `origin/dev` with `--no-tags` into `refs/remotes/origin/dev` and records the fetched SHA in the summary.
- Android/iOS production store release checklists now require scratch worktrees from the verified remote-tracking ref, not stale local branches.

Reason:

Local source checkouts can be dirty, behind, or blocked by stale tag conflicts. Release workflows should use the fetched remote-tracking ref or stop, and should verify the base SHA before build/upload.
