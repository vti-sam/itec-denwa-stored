---
title: denwa-api API IT Excel result evidence workflow
project: itec-denwa
type: lesson
status: archived
source:
- memory/denwa_api_it_excel_result_evidence_20260620.md
tags:
- denwa
- api
- it
- excel
- result
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

For local `denwa-api` API IT result evidence on this machine, Maven wrapper is not executable, so run through `bash ./mvnw`. Testcontainers needs Colima socket explicitly:

```bash
DOCKER_HOST=unix:///Users/vti-sam/.colima/default/docker.sock TESTCONTAINERS_RYUK_DISABLED=true bash ./mvnw -Papi-it verify
```

`TESTCONTAINERS_RYUK_DISABLED=true` is needed because Ryuk startup timed out under the current Colima/QEMU runtime. After successful runs on 2026-06-20, Docker had no leftover containers.

The API IT Excel result fill script is `scratch/fill_api_it_excel_results.py`. It parses Maven log and Failsafe XML evidence, verifies both summaries match, writes `Pass` results for both rounds into `TEST-IT-01_VoIPWebAPI結合テスト.xlsx`, and stores evidence under `project-store/artifacts/reports/testcase/VoIPWebAPI結合テストエビデンス/`.

2026-06-20 update: Evidence paths written into Excel/report should be short paths relative to `project-store/artifacts/reports/testcase`, for example `VoIPWebAPI結合テストエビデンス/TEST-IT-EVD-03_第2回Mavenログ.txt`. Do not write full repo paths into Excel cells.

When updating the rendered workbook's `変更履歴` sheet, use the merged span layout `A:C`, `D:F`, `G:I`, `J:L`, `M:O`, `P:R`, `S:U`. Raw writes to `A:G` break the layout. The testcase skill now exposes `append_history_row()` for this.
