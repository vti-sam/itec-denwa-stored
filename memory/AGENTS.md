# AGENTS.md

- `project-store/memory/` lưu lịch sử phiên và ghi chú tác nhân dạng historical trong repo stored.
- Nội dung trong folder này chỉ dùng để truy vết, khôi phục ngữ cảnh hoặc phát hiện gotcha cũ; không coi là source-of-truth active.
- Khi nội dung có giá trị bền, promote sang `project-store/knowledge/` với source/evidence rõ và metadata knowledge chuẩn.
- File Markdown trong folder này phải có YAML frontmatter ở đầu. Reuse metadata chuẩn của knowledge và thêm các field historical:

```yaml
---
title: <Human readable title>
project: <project_id>
type: requirement | decision | gotcha | runbook | architecture | lesson
status: archived | stale
source:
  - <Codex session / task log / evidence path>
tags:
  - <keyword>
scope: historical
captured_at: <YYYY-MM-DD>
validity: historical_context
promote_to_knowledge: false
---
```

- `type` vẫn phân loại bản chất nội dung; không thêm type riêng là `memory`.
- `status: archived` nghĩa là dữ liệu lịch sử còn hữu ích để truy vết. `status: stale` nghĩa là chỉ giữ để audit, không dùng làm cơ sở hành động nếu chưa verify lại.
- Link nội bộ nên viết từ repo root bằng tiền tố `project-store/`.
