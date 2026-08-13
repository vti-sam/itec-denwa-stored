---
title: ITEC testcase kind classification rule
project: itec-denwa
type: gotcha
status: archived
source:
  - project-store/artifacts/reports/testcases/TC-UAT-WEB-01_VoIPWeb受入テストケース/TC-UAT-WEB-01_VoIPWeb受入テストケース.md
  - project-store/artifacts/reports/testcases/TC-UAT-WEB-02_VoIPWeb受入テストケース_ベトナム語版/TC-UAT-WEB-02_VoIPWeb受入テストケース_ベトナム語版.md
  - skills/testcase-excel/SKILL.md
tags:
  - testcase
  - excel
  - classification
scope: historical
captured_at: 2026-06-21
validity: historical_context
promote_to_knowledge: false
---

Renderable testcase documents for ITEC should use `種別` with `N/A/B`, not priority labels.

- Do not keep `優先度`, `H/M/L`, or `分類列名: 優先度` in customer-facing testcase Markdown/Excel.
- UAT Web testcase rows were converted by aligning each `UAT-WEB-xxx` row with the existing API integration testcase classification for the corresponding `IT-API-xxx` row.
- The testcase Excel validator now rejects priority-style classification metadata and fields so this does not regress.
