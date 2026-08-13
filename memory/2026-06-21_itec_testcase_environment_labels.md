---
title: ITEC testcase environment labels
project: itec-denwa
type: gotcha
status: archived
source:
  - project-store/artifacts/reports/testcases/TC-UAT-WEB-01_VoIPWeb受入テストケース/TC-UAT-WEB-01_VoIPWeb受入テストケース.md
  - project-store/artifacts/reports/testcases/TC-UAT-WEB-02_VoIPWeb受入テストケース_ベトナム語版/TC-UAT-WEB-02_VoIPWeb受入テストケース_ベトナム語版.md
  - project-store/artifacts/reports/testcases/TC-IT-API-01_VoIPWebAPI結合テスト/TC-IT-API-01_VoIPWebAPI結合テストケース.md
tags:
  - testcase
  - excel
  - environment
scope: historical
captured_at: 2026-06-21
validity: historical_context
promote_to_knowledge: false
---

ITEC testcase documents must not force every environment to `ローカル`.

- UAT Web cases that use `https://dev.apl.purattocall.com/...` and `https://apl.purattocall.com/...` are labeled `環境: DEV / PRD`, with `ラウンド1名: 第1回（DEV）` and `ラウンド2名: 第2回（PRD）`.
- API integration tests backed by local Maven/Failsafe/Testcontainers evidence remain `環境: ローカル`, with `第1回（ローカル）` and `第2回（ローカル）`.
- The testcase Excel skill validator should require round labels when `環境` contains multiple targets such as `DEV / PRD`.
