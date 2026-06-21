---
title: Checklist Excel hỗ trợ nhiều sheet và lịch sử thay đổi
project: itec-denwa
type: runbook
status: archived
source:
- memory/checklist_excel_multi_sheet_history.md
tags:
- checklist
- excel
- skill
- release
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

# Checklist Excel hỗ trợ nhiều sheet và lịch sử thay đổi

- `skills/checklist-excel` hỗ trợ nhiều block `## Checklist {sheet=<tên>}` và render mỗi block thành một sheet.
- Workbook luôn có sheet đầu tiên `変更履歴`, gồm block Thông tin cơ bản và đúng bảng Lịch sử thay đổi theo schema 7 cột.
- Nếu Markdown không khai báo lịch sử, parser tự tạo một dòng `Tạo mới` từ Version, Người tạo và Ngày tạo.
- Hậu tố `**Evidence:**` hoặc `**Evidence bắt buộc:**` được parser tách khỏi nội dung và đưa vào cột Evidence.
- CLI resolve parser và sample theo vị trí script, không phụ thuộc working directory.
- Checklist release app hiện render thành ba sheet: `変更履歴`, `Android`, `iOS`.
