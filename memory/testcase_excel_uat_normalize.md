---
title: Testcase Excel UAT normalize workflow
project: itec-denwa
type: lesson
status: archived
source:
- memory/testcase_excel_uat_normalize.md
tags:
- testcase
- excel
- uat
- normalize
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

`skills/testcase-excel` now has `scripts/testcase_normalize.py` for converting legacy UAT Markdown tables into canonical block format before rendering Excel. For UAT web testcase artifacts, run normalization with `--expected-count 104` before render so the Markdown uses readable blocks and `実行手順` steps are written as `①`, `②`, `③`.

UAT testcase workbooks use `分類列名: 優先度` and `分類値: H,M,L`, so the renderer shows the classification column as `優先度` and dashboard labels as High / Medium / Low. API IT testcase workbooks keep the existing `種別` values `N,A,B` and dashboard labels Normal / Abnormal / Boundary.

2026-06-20 update: UAT memo cleanup policy is to keep only meaningful notes, such as real `備考` values or execution results other than `未実施`. Do not store noisy trace lines like original No, original TC ID, original category, or `実行結果: 未実施` in the rendered memo column.

2026-06-20 update: UAT Web testcase Markdown and Excel must be fully Japanese for all descriptive content. Keep only technical tokens such as testcase IDs, URLs, CSV, OTP, SIP, MVE, UAT, and issue IDs when they are part of the source content.
