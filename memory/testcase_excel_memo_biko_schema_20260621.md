---
title: Testcase Excel memo and biko schema
project: itec-denwa
type: lesson
status: archived
source:
- memory/testcase_excel_memo_biko_schema_20260621.md
tags:
- testcase
- excel
- markdown
- skill
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

2026-06-21: `skills/testcase-excel` schema was updated so Round 1 and Round 2 result sections both use the header `メモ`. The former Round 2 header `Note` must not be generated.

The final testcase-wide remarks column is now `備考`, not `メモ`. Markdown block format should use `備考:` for testcase-wide remarks. `ラウンド1メモ:` and `ラウンド2メモ:` remain unchanged for per-round memo fields.

The parser remains backward-compatible with legacy standalone `メモ:` as an alias for final remarks, but newly generated/normalized Markdown should emit `備考:`. The renderer output was verified on 2026-06-21: workbooks have no `Note` header, exactly two `メモ` headers for rounds, and tail header `備考`.
