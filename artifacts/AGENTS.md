# AGENTS.md

- Khi task đọc, tạo, sửa hoặc di chuyển file trong `project-store/artifacts/`, luôn đọc file rule này trước khi thao tác.
- `project-store/artifacts/` chỉ lưu artifact portable của dự án không thuộc workflow Google Sheets management.
- Không lưu source code, secret/token/credential, cache/index, build output hoặc nháp tạm trong subtree này.
- Nếu dữ liệu là export/cache quản trị từ Google Sheets, đặt trong `project-store/management/` thay vì `project-store/artifacts/`.
- Nếu artifact có nguồn hoặc mục đích dùng lại, ghi rõ nguồn trong tên file, metadata hoặc tài liệu đi kèm để có thể verify lại sau.
