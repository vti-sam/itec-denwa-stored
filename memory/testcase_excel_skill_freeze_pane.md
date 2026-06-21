---
title: Testcase Excel skill freeze pane update
project: itec-denwa
type: lesson
status: archived
source:
- memory/testcase_excel_skill_freeze_pane.md
tags:
- testcase-excel
- spreadsheet
- skill
scope: historical
captured_at: '2026-06-18'
validity: historical_context
promote_to_knowledge: false
---

`skills/testcase-excel/scripts/testcase_render.py` dùng freeze pane `AE7` để giữ header và các cột nhập testcase từ ID đến 期待される結果 khi cuộn ngang sang vùng kết quả. CLI phải resolve `spec_render.py`, `testcase_parse.py` và sample theo vị trí script, không phụ thuộc working directory.

2026-06-20 update: CLI output path được resolve theo Markdown input. Nếu không truyền output, script lưu `<input_stem>.xlsx` trực tiếp trong folder chứa input. Nếu truyền output chỉ là tên file, script cũng lưu vào folder input. Nếu truyền output có path rõ ràng, script tôn trọng path đó. Lệnh đã verify từ repo root:

```bash
rtk uv run --with openpyxl python skills/testcase-excel/scripts/testcase_render.py skills/testcase-excel/resources/testcase_sample.md
```

2026-06-20 update: Markdown table cells can use `<br>` for multiline testcase content. `skills/testcase-excel/scripts/testcase_parse.py` converts `<br>` to real Excel line breaks before rendering, so generated workbooks do not show literal `<br>`.

2026-06-20 update: `testcase_parse.py` also supports readable block format under `## テストケース {sheet=...}`. Each case can be written as `### <ID> <title>` with fields `ID`, `画面/機能カテゴリ`, `大項目`, `中項目`, `前提条件`, `実行手順`, `期待される結果`, and `種別`. Multiline Japanese fields are preserved as real Excel line breaks.
