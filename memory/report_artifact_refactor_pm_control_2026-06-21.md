---
title: Report Artifact Refactor On pm-control
project: itec-denwa
type: lesson
status: archived
source:
  - Codex task: implement pm-control report artifact refactor and skill verification
tags:
  - reports
  - testcase-excel
  - pm-control
scope: historical
captured_at: 2026-06-21
validity: historical_context
promote_to_knowledge: false
---

# Report Artifact Refactor On pm-control

ITEC Denwa stored repo was refactored on branch `pm-control` to follow the report artifact naming rules used in SMJ:

- Report categories are ASCII/kebab-case folders: `architecture/`, `release/`, `security/`, `testcases/`.
- Bundle folders now start with stable document IDs such as `ARCH-INFRA-01`, `REL-STORE-01`, `SEC-WEB-01`, `TC-UAT-WEB-01`, and `TC-IT-API-01`.
- Testcase Markdown docs were normalized to `TC-<phase>-<domain>-<seq2>`, Japanese sheet names, author `VTI-SAM`, environment `ローカル`, and row IDs such as `UAT-WEB-001` / `IT-API-001`.
- Testcase Excel files were regenerated with `skills/testcase-excel/scripts/testcase_render.py`.

Verification notes:

- `testcase_validate.py` passed for 3 renderable testcase documents: UAT web, UAT web Vietnamese version, and Web API integration.
- `test_program_spec.py` and `test_testcase_excel.py` passed after fetching root branch `pm-control`.
- Workbook read-back confirmed no stale markers: `<br>`, literal `\n`, `WEB_UAT_TC`, `API_IT_TC`, `Round 1`, `Round 2`, `REL-CHK-01`, `VTI SAM`, or `VTI_SAM`.
- Raw Maven Failsafe XML files still use generated filenames beginning with `TEST-jp.co...`; these were kept as execution evidence rather than renamed into document IDs.
