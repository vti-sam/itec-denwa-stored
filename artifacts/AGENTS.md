# AGENTS.md

- `artifacts/` lưu file dự án cần giữ lại và không do workflow Google Sheets management tạo hoặc đọc như cache sheet; input gốc từ KH/onsite cũng đặt ở đây nếu cần lưu bền hoặc sync Drive.
- Đây là folder snapshot chính để đồng bộ Google Drive cùng `knowledge/`; không lưu secret, key, cache/index hoặc file nháp tạm.
- Subfolder trong `artifacts/` phải phản ánh loại dữ liệu hoặc workflow sở hữu file; không tạo subfolder theo workaround của một lần xử lý.
- Nếu tài liệu đã được phân tích thành tri thức bền, ghi bản tổng hợp vào `knowledge/` và giữ file gốc/bản xuất ra trong `artifacts/`.
- Khi di chuyển/đổi tên file trong `artifacts/`, cập nhật link nội bộ liên quan.
