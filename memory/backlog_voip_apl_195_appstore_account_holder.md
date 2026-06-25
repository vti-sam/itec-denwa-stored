---
title: Backlog VOIP_APL-195 App Store Account Holder support request
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-06-22 Backlog customer issue creation
  - Backlog issue VOIP_APL-195
tags:
  - backlog
  - app-store
  - account-holder
  - attachment
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

Created customer Backlog issue `VOIP_APL-195` in project `VOIP_APL` for urgent App Store submission support. The issue was assigned to `片山　剛`, priority `高`, issue type `タスク`, and included two App Store Connect screenshots as attachments.

Backlog attachment upload gotcha: `POST /api/v2/attachments` returned `Undefined resource`. The working endpoint for temporary upload before issue creation was `POST /api/v2/space/attachment`, then pass returned IDs as `attachmentId[]` when creating the issue.

The created issue description included `#image(app-review-contact-information.png)` and `#image(app-information-name-error.png)` while also attaching both PNG files.
