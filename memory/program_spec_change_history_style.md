---
title: Program Spec change-history style normalization
project: itec-denwa
type: lesson
status: archived
source:
- memory/program_spec_change_history_style.md
tags:
- program-spec-excel
- testcase-excel
- spreadsheet
scope: historical
captured_at: '2026-06-18'
validity: historical_context
promote_to_knowledge: false
---

Sheet `変更履歴` của `program-spec-excel` được chuẩn hóa trong `spec_render.normalize_change_history_sheet`: luôn dùng grid 21, `基本情報` có span `[6,15]`, `更新履歴` có 7 cột span `[3,3,3,3,3,3,3]`, đồng nhất với `testcase-excel`. Các dòng lịch sử hoàn toàn trống bị loại bỏ trước khi render. Workbook mẫu đã được sinh lại và kiểm tra trực quan.
