# AGENTS.md

- `project-store/` là snapshot dữ liệu và cấu hình riêng của dự án, được quản lý bằng nested Git repo do User clone thủ công.
- Chỉ đặt các folder portable của project trong subtree này: `config/`, `knowledge/`, `memory/`, `artifacts/`, `management/`, `skills/`.
- `skills/` chỉ chứa skill portable đặc định cho project stored hiện tại. Skill ở đây có thể chứa `SKILL.md`, metadata và script deterministic phục vụ workflow project; không dùng làm nơi chứa source code ứng dụng.
- `memory/` chỉ lưu lịch sử phiên và ghi chú tác nhân dạng historical; không dùng làm source-of-truth active. Khi nội dung có giá trị bền, promote sang `knowledge/` với source/evidence rõ.
- `config/project.yaml` là source-of-truth portable cho định danh, resource ID, service binding và đường dẫn local của project.
- Secret/token/key thật chỉ được đặt trong `config/secrets.local.yaml` hoặc `config/keystore.local/`; hai path này phải bị ignore khỏi nested Git repo.
- Không lưu source code ứng dụng, secret tracked, cache/index, build output hoặc file nháp tạm trong `project-store/`.
- Trước khi bootstrap workspace, User clone repo stored về đúng `project-store/`; bootstrap không fetch/pull repo này.
- Sau khi sửa nội dung portable trong `project-store/`, kiểm tra nested Git repo; không dùng Google Drive/rclone làm snapshot backend mặc định.
- Link nội bộ trong snapshot nên viết từ repo root bằng tiền tố `project-store/` khi tài liệu được tham chiếu từ ngoài subtree.
