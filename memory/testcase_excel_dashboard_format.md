---
title: Testcase Excel dashboard format
project: itec-denwa
type: lesson
status: archived
source:
- memory/testcase_excel_dashboard_format.md
tags:
- testcase
- excel
- dashboard
- format
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

`skills/testcase-excel` dashboard labels use English metrics: `Coverage` for `(Pass+Fail)/(Total-N/A)` and `Pass Rate` for `Pass/Total`. Ratio cells must use Excel number format `0%`.

Dashboard groups `Priority`, `Round 1`, and `Round 2` should have medium borders at group boundaries so adjacent `Pass` metrics do not appear merged or ambiguous.

2026-06-20 update: `testcase-excel` supports optional `@meta` keys `ラウンド1名` and `ラウンド2名` to override dashboard round headers. Default is `Round 1 (DEV)` / `Round 2 (PRD)` for UAT. API IT local evidence should use `Round 1 (Local Run 1)` / `Round 2 (Local Run 2)` because both executions are local Testcontainers runs, not real DEV/PRD server tests.

2026-06-20 update: Markdown testcase files are the source-of-truth. Testcase body, round results, tester/date, evidence paths, memo, and `更新履歴` must be edited in the Markdown first, then Excel/Docx must be rendered from that Markdown. Do not finish by manually filling only the workbook; if workbook migration is unavoidable, backfill the Markdown and rerender before handoff.
