---
title: DB-TABLE-01 ERD Draw.io relationship render
project: itec-denwa
type: gotcha
status: archived
source:
  - project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書_ERD.md
  - project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書_ERD.drawio
  - project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書_ERD.svg
  - project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書_ERD.png
  - project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/output/DB-TABLE-01_テーブル定義書_ERD.yaml
tags:
  - db-table
  - erd
  - drawio
  - yaml
scope: historical
captured_at: 2026-06-25
validity: historical_context
promote_to_knowledge: false
---

`DB-TABLE-01_テーブル定義書` ERD được render bằng `skills/drawio-erd` theo luồng YAML trước, sau đó xuất `.drawio`, `.svg` và `.png`. Skill `drawio-erd` giữ nhánh `layout: erd_uml`; skill `drawio-flow-chart` chỉ dành cho flow/architecture/process diagram generic.

Quy ước artifact hiện tại: `output/` chỉ là vùng tạm cho YAML, QA JSON và trial export. Deliverable chính thức của bundle phải nằm ở parent folder cạnh tài liệu chính. Với Excel, dùng PNG parent để tránh lỗi tương thích khi mở workbook. SVG parent có thể giữ làm artifact vector/tham chiếu, nhưng không nhúng trực tiếp vào `.xlsx`.

YAML đã có danh sách `relationships` riêng và mỗi `edge` đều tham chiếu bằng `relationship_id`. Kết quả verify tại thời điểm ghi chú:

- ERD Markdown `関係一覧`: 9 quan hệ.
- YAML `relationships`: 9 quan hệ.
- YAML `edges`: 9 line render.
- Mỗi relationship có `source_cardinality` cho phía FK và `target_cardinality` cho phía PK/unique. Default đang dùng `source_cardinality: "0..*"` và `target_cardinality: "1"`.
- Không có relationship thiếu edge hoặc edge không map relationship.
- Mỗi edge trong `.drawio` có `source`/`target` và anchor `exitX/entryX`, không dùng endpoint rời.
- Mỗi edge trong `.drawio` dùng marker ERD chuyên nghiệp: `ERone` cho phía PK/unique và `ERzeroToMany` cho phía FK. Không bật endpoint text `1`/`0..*` mặc định vì làm rối khu nhiều quan hệ; chỉ bật `show_cardinality_labels` khi route có đủ khoảng trắng.
- Inline label trên ảnh chỉ hiển thị tên field như `tenant_uuid`, không dùng dạng `FK ... = PK ...`; quan hệ đầy đủ giữ trong YAML `relationships` và ERD Markdown `関係一覧`.
- Mỗi table trong `.drawio` phải là group/container kéo được cả block. Header và field rows là child của table cell với `parent=<table_id>` và `part=1`; edge attach vào table cell, không attach vào row child.
- Excel `DB-TABLE-01_テーブル定義書.xlsx` nhúng PNG qua cơ chế ảnh chuẩn của openpyxl (`xl/media/*.png` và content type `image/png`). Không inject SVG trực tiếp vào `.xlsx` vì có thể làm Excel lỗi khi mở.

Hai line dễ bị nhầm là thiếu đã được render trực tiếp trong master schema:

- `sip_accounts.tenant_uuid` -> `tenants.tenant_uuid`
- `tenant_account_history.tenant_id` -> `tenant_contract_info.tenant_id`

Deliverable chính nằm trong:

- `project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書_ERD.md`
- `project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書_ERD.drawio`
- `project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書_ERD.svg`
- `project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書_ERD.png`
- `project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/DB-TABLE-01_テーブル定義書.xlsx`

File trung gian nằm trong:

- `project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/output/DB-TABLE-01_テーブル定義書_ERD.yaml`
- `project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/output/DB-TABLE-01_テーブル定義書_ERD.qa.json`
- `project-store/artifacts/reports/database/DB-TABLE-01_テーブル定義書/output/DB-TABLE-01_テーブル定義書_ERD.preview.png`
