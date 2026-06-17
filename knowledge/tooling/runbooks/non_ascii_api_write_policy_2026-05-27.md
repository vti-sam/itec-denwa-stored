---
title: Non Ascii API Write Policy
project: tooling
type: runbook
status: confirmed
source:
  - migrated from memory/tooling/non_ascii_api_write_policy_2026-05-27.md
tags: [tooling, policy, non_ascii_api_write_policy_2026_05_27]
---

# Chính sách ghi dữ liệu non-ASCII qua API - 2026-05-27

## Bối cảnh

- Khi gửi nội dung tiếng Việt/tiếng Nhật lên Backlog bằng PowerShell here-string, chuỗi có thể bị biến thành dấu `?` trước khi Python/API nhận dữ liệu.
- Lỗi đã xảy ra với Backlog issue `SHARP_MULTI_DEVICE_POS-578`: description/comment chứa tiếng Việt và `釣銭機エラーガイダンスサブフォーム` bị mojibake.

## Quyết định

- Không truyền literal tiếng Việt/tiếng Nhật trực tiếp trong `powershell -Command`, here-string hoặc command inline dài khi ghi lên Backlog, Google Sheets hoặc API khác.
- Nội dung non-ASCII phải được lấy từ file UTF-8 hoặc script Python UTF-8.
- Với request form data trong Python, dùng:

```python
urllib.parse.urlencode(data, encoding="utf-8").encode("utf-8")
```

- Khi có thể, set header:

```text
Content-Type: application/x-www-form-urlencoded; charset=utf-8
```

## Verify bắt buộc

- Sau khi ghi nội dung non-ASCII lên Backlog/Google Sheets/API, đọc lại record/comment bằng API hoặc sync lại source-of-truth.
- Kiểm tra nội dung không bị mojibake, không xuất hiện dấu `?` thay cho tiếng Việt/tiếng Nhật.

