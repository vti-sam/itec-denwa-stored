# AGENTS.md

- `knowledge/` là nơi lưu tri thức dài hạn của project: requirement, decision, gotcha, runbook, architecture và lesson learned.
- Không bắt buộc đọc `knowledge/` trước mọi task. Chỉ đọc file liên quan, dùng `rtk rg` trong `knowledge/`, hoặc dùng `skills/knowledge-memory-sync/` khi task cần ngữ cảnh bền, có link cụ thể, hoặc User yêu cầu.
- Index/cache tìm kiếm nếu có (ví dụ: Qdrant) chỉ phục vụ tra cứu nội dung nằm trong `knowledge/`; bắt buộc sử dụng cơ chế Local Storage (lưu trữ SQLite/file cục bộ) thay vì Qdrant server ngoài để đảm bảo tính độc lập. Source-of-truth dài hạn của repo vẫn là `knowledge/`.
- Bố cục canonical cho tri thức mới là project-first: `knowledge/<project_or_domain>/<area>/...`. `type` trong YAML frontmatter dùng để phân loại requirement/decision/gotcha/runbook/architecture/lesson.
- Chọn `<project_or_domain>` theo tên chính thức trong source-of-truth hoặc folder/task đang xử lý; không hardcode danh sách solution/domain vào rule nếu không phải boundary kỹ thuật bắt buộc.
- Với architecture lớn, ưu tiên đặt dưới `architecture/<component>/`. Với runbook, đặt dưới `runbooks/`. Ghi chú gốc/raw notes đặt trong `_source_notes/` khi cần bảo toàn provenance; không tạo mặc định.
- Bắt buộc khai báo YAML frontmatter ở đầu mọi file tài liệu `.md` trong `knowledge/` khi tạo mới hoặc cập nhật lớn:

```yaml
---
title: <Human readable title>
project: <project_id>
type: requirement | decision | gotcha | runbook | architecture | lesson
status: draft | pending | confirmed | stale | archived
source:
  - <Backlog ticket / log file / meeting note>
tags:
  - <keyword>
---
```

- Dùng `type` trong frontmatter để phân loại tài liệu.
- Khi di chuyển/đổi tên/chỉnh sửa file trong `knowledge/`: cập nhật markdown link nội bộ liên quan.
- Viết ghi chú cô đọng, ưu tiên invariant, pitfall, verify command và nguồn xác minh. Ghi nhãn song ngữ Việt/Nhật nếu có thuật ngữ Nhật quan trọng.
