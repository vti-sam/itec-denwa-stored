---
title: SIP phone DOCX builder template gotcha
project: itec-denwa
type: gotcha
status: archived
source:
  - project-store/artifacts/sip-phone-requirement-20260609/sip-phone-requirement-summary.md
  - project-store/artifacts/sip-phone-requirement-20260609/sip-phone-requirement-summary.docx
tags:
  - docx-builder
  - sip-phone
  - template
scope: historical
captured_at: 2026-07-01
validity: historical_context
promote_to_knowledge: false
---

Khi tạo tài liệu SIP phone cho OKADADENKI, cần dùng `skills/docx-builder/scripts/build_docx.py` thay vì tự dựng DOCX thủ công.

Để template sinh đủ trang bìa, `改訂履歴` và mục lục, không dùng `--no-cover`. Markdown phải có heading `## 改訂履歴` và bảng có các cột `版数`, `改訂日`, `改訂者`, `改訂内容` để script parse được revision history.

Với tiêu đề cover, truyền `--title "SIP-phone yêu cầu hỗ trợ từ OKADADENKI"` để template tách thành hai dòng đẹp hơn: `SIP-phone` và `yêu cầu hỗ trợ từ OKADADENKI`.
