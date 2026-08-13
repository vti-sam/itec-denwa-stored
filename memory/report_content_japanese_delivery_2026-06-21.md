---
title: Report Content Japanese Delivery Cleanup
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session on 2026-06-21
  - project-store/artifacts/reports/AGENTS.md
  - skills/checklist-excel/SKILL.md
tags:
  - reports
  - checklist-excel
  - japanese-delivery
scope: historical
captured_at: 2026-06-21
validity: historical_context
promote_to_knowledge: false
---

# Report Content Japanese Delivery Cleanup

On branch `pm-control`, report artifacts were checked against the report rules and Excel skills after the initial structure refactor.

Key lesson:

- Structure and rendering can pass while the report content is still not suitable for customer delivery.
- Official report Markdown/Excel should be Japanese by default. Vietnamese content is only acceptable when the file or bundle explicitly marks it as a translation, such as `ベトナム語版`.
- `skills/checklist-excel/` previously defaulted to Vietnamese labels and `VTI SAM`; it was updated to Japanese labels and `VTI-SAM` so future generated checklists do not regress.
- For checklist workbooks, read back generated `.xlsx` cells and scan for legacy markers such as `Thông tin`, `Lịch sử`, `VTI SAM`, hardcoded `<br>`, and literal `\n`.

Commits:

- Root repo: `eccdabe chore: align checklist excel skill with japanese reports`
- Stored repo: `44a02bb docs: polish report contents for japanese delivery`
