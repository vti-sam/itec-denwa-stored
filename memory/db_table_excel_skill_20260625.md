---
title: DB Table Excel skill and FK header alias
project: itec-denwa
type: gotcha
status: archived
source:
  - project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書.md
  - skills/db-table-excel/
tags:
  - db-table-excel
  - table-definition
  - spreadsheet
scope: historical
captured_at: '2026-06-25'
validity: historical_context
promote_to_knowledge: false
---

`skills/db-table-excel` renders Japanese `テーブル定義書` Markdown to Excel using the shared `program-spec-excel` monochrome style. The workflow is validate first, then render:

```bash
rtk uv run skills/db-table-excel/scripts/db_table_validate.py <input.md>
rtk uv run --with openpyxl skills/db-table-excel/scripts/db_table_render.py <input.md> [output.xlsx]
```

Gotcha from `DB-TABLE-01_テーブル定義書.md`: most `外部キー情報` tables use the last header `参照先カラムリスト`, but `messages` and `short_message` use the legacy alias `カラムリスト`. The validator and renderer intentionally accept both variants.

2026-06-25 layout update: table sheets use a wider 36-column grid. `テーブル情報` is rendered compactly only through column R, while `カラム情報`, `インデックス情報`, `外部キー情報`, and enum/value tables span through AJ for readability. Regression test checks `A4:R4` exists and `A4:AJ4` does not for the compact table info section.

2026-06-25 customer-facing format update: rendered workbooks normalize author metadata to `VTI` instead of `VTI-SAM`, fill blank creation date with the render date, and always include one default `更新履歴` row: `0.0.1 / - / VTI / <date> / 初版作成 / 全体 / 初版作成`. Boolean-like `Yes/No` values in `Not Null`, `主キー`, and `ユニーク` render as `○` or blank in Excel while the Markdown source remains unchanged.
