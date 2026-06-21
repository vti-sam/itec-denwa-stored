# AGENTS.md

- `project-store/` là snapshot dữ liệu dự án được quản lý bởi Git repo stored khai báo trong `registry/projects.yaml`.
- Chỉ đặt các folder dữ liệu portable trong subtree này: `knowledge/`, `memory/`, `artifacts/`, `management/`.
- `memory/` chỉ lưu lịch sử phiên và ghi chú tác nhân dạng historical; không dùng làm source-of-truth active. Khi nội dung có giá trị bền, promote sang `knowledge/` với source/evidence rõ.
- Không lưu source code, secret, token, cache/index, build output hoặc file nháp tạm trong `project-store/`.
- Khi bootstrap workspace, fetch/pull repo stored về đúng `project-store/` trước khi dùng các workflow cần dữ liệu dự án.
- Sau khi sửa nội dung trong `project-store/knowledge/`, `project-store/memory/`, `project-store/artifacts/` hoặc `project-store/management/`, cập nhật repo stored bằng Git; không dùng Google Drive/rclone làm snapshot backend mặc định.
- Link nội bộ trong snapshot nên viết từ repo root bằng tiền tố `project-store/` khi tài liệu được tham chiếu từ ngoài subtree.
