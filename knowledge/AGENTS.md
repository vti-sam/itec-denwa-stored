# AGENTS.md

- `project-store/knowledge/` lưu tri thức bền của project và là source-of-truth nội bộ.
- Trước khi tạo, sửa, di chuyển hoặc sắp xếp lại file trong subtree này, đọc rule gần nhất, kiểm tra cấu trúc hiện có và dùng `skills/knowledge-code/knowledge-memory-sync/` cho query/sync.
- Không tự tạo taxonomy, enum metadata hoặc trạng thái hiện tại nếu chưa có source/evidence.
- Chỉ lưu tri thức có thể tái sử dụng và có nguồn rõ như requirement, decision, architecture, runbook, glossary hoặc analysis.
- Không lưu raw file khách hàng, draft tạm, cache/index, credential hoặc source code ứng dụng trong subtree này.
- FalkorDB chỉ là index có thể rebuild; source-of-truth vẫn là Markdown trong `project-store/knowledge/`.
- Markdown knowledge phải bắt đầu bằng frontmatter:

```yaml
---
title: <Tiêu đề dễ đọc>
project: <project_id>
type: requirement | decision | gotcha | runbook | architecture | glossary | analysis
status: active | superseded | archived
source:
  - <source path, ticket, meeting hoặc evidence>
tags:
  - <keyword>
scope: durable
updated_at: <YYYY-MM-DD>
---
```

- `active` là nội dung còn dùng làm căn cứ hiện tại; `superseded` là nội dung đã có file khác thay thế; `archived` chỉ giữ để truy vết.
- Khi knowledge được promote từ memory, thêm path memory vào `source` để giữ evidence chain.
- Link nội bộ dùng path từ workspace root với prefix `project-store/`.
- Sau khi sửa knowledge, chạy lint rồi sync FalkorDB.
