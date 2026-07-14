---
title: Khôi phục đăng nhập DEV và STG cho tài khoản Katayama
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session 2026-07-14
  - sources/denwa-api DEV commit a4523ede and STG merge commit 8ea8bc2e8424f513bfb6d88c978756df8e78867b
  - sources/denwa-front DEV commit 5630b7d and STG merge commit a492b9c722954aa1d84b309a27adf5a1a514c9a8
  - sources/denwa-api PRD commit 30ff4a110f47214f85a279fde880ca0fe18b1fab
  - sources/denwa-front PRD commit ba0be0b84e8c8e43f81f4e68213ec6219002b6dd
  - scratch/katayama_account_before_20260714_161307.json
tags:
  - authentication
  - admin
  - dev
  - stg
  - database
  - deployment
scope: historical
captured_at: '2026-07-14'
validity: historical_context
promote_to_knowledge: false
---

Đã xác định lỗi có cả ở API và frontend, sau đó sửa trên `dev`, hợp nhất vào `stg` và triển khai.

- API đổi mật khẩu trước đây chỉ cập nhật bảng `admin` của schema đang chọn, khiến mật khẩu trong `master_schema`, `111_schema` và `113_schema` lệch nhau. Bản sửa cập nhật cùng một BCrypt hash cho toàn bộ context được mapping trong một transaction và luôn khôi phục `TenantContext` ban đầu.
- Frontend trước đây có thể xử lý lỗi chung rồi reject `undefined`, nên màn hình chọn vai trò không nhận được lỗi 401 để hiển thị. `loginWithRole` nay giữ nguyên Axios error cho `SelectRole.vue` xử lý.
- Backend: DEV commit `a4523ede`, STG merge commit `8ea8bc2e8424f513bfb6d88c978756df8e78867b`, pipeline `499` thành công, ECS STG chạy task definition revision `175`, image `1.1.1-499`.
- Frontend: DEV commit `5630b7d`, STG merge commit `a492b9c722954aa1d84b309a27adf5a1a514c9a8`, pipeline `234` thành công, ECS STG chạy task definition revision `44`, image `1.0.0-234`.
- Trang đăng nhập STG trả về HTTP 200 sau triển khai.
- Bundle frontend live có `rawError: true` tại API `login-with-role`.
- Test trực tiếp bằng Chrome trên bản STG sau triển khai với tài khoản khách và mật khẩu sai xác nhận màn hình hiển thị `アカウントまたはパスワードが正しくありません。`. Sau test đã đặt lại số lần đăng nhập sai về `0`.
- Test API `login-with-role` bằng tài khoản giả hợp lệ về định dạng trả HTTP 401 và trường chi tiết có cùng thông báo lỗi, không làm tăng bộ đếm của tài khoản khách.
- Backend `mvn verify` thành công với ba test, gồm hai regression test đồng bộ mật khẩu đa context. Frontend type-check, lint file thay đổi và build STG đều thành công.

Đã đồng bộ dữ liệu đăng nhập của `katayama-ta@itec.hankyu-hanshin.co.jp` trên DEV và STG cho ba ngữ cảnh quản trị: quản trị hệ thống, tenant `111` và tenant `113`.

- Bảo đảm mỗi ngữ cảnh có đúng một bản ghi quản trị đang hoạt động và mapping `account_type = 0`.
- Kích hoạt tenant `111` và `113`, đưa trạng thái xóa về hợp lệ.
- Đồng bộ mật khẩu tenant theo bản ghi quản trị hệ thống của chính từng môi trường; tuyệt đối không sao chép hash giữa DEV và STG và không ghi mật khẩu hoặc BCrypt hash vào biên bản.
- Xóa số lần đăng nhập/đặt lại mật khẩu thất bại, token và trạng thái khóa.
- Giữ nguyên mapping `account_type = 1` hiện có của tenant `111` trên STG.
- Read-back độc lập xác nhận toàn bộ bản ghi đích đang hoạt động, số lần thất bại bằng `0` và các password context khớp nhau.

Hai ràng buộc schema cần lưu ý khi tạo mới bản ghi quản trị:

- `lock_reset_password_time` là `NOT NULL`; khi khôi phục tài khoản phải gán thời điểm hợp lệ thay vì `NULL`.
- `mail_sent` của bảng quản trị tenant là `NOT NULL`; khi sao chép account giữa môi trường cần lấy giá trị từ bản ghi tenant nguồn phù hợp.

Không có mật khẩu thật trong phiên nên chưa thể đi qua màn hình chọn vai trò bằng chính tài khoản khách. Việc xác minh màn hình chọn vai trò dựa trên regression test, build, bundle live và phản hồi 401 thực tế của API; khách cần thực hiện lần đăng nhập thành công cuối cùng cho cả quản trị hệ thống và quản trị tenant.

Ở giai đoạn sửa DEV/STG chưa thay đổi PRD và không xóa Store review account.

## Phát hành PRD

Sau khi DEV/STG được xác nhận, chỉ cherry-pick hai commit sửa lỗi lên `prd`, không merge các thay đổi STG khác:

- Backend PRD commit `30ff4a11`, pipeline `500` thành công, ECS revision `27`, image `1.1.1-500`, rollout hoàn tất và chạy `1/1`.
- Frontend PRD commit `ba0be0b8`, pipeline `235` thành công, ECS revision `20`, image `1.0.0-235`, rollout hoàn tất và chạy `1/1`.
- Smoke test production xác nhận trang đăng nhập tải bình thường, bundle live có `rawError: true` tại `login-with-role`, API chọn role trả HTTP 401 với thông báo `アカウントまたはパスワードが正しくありません。` cho account kiểm thử giả.
- Audit DB PRD chỉ đọc xác nhận Katayama có mapping quản trị tại `master` và tenant `111`; hai password hash đang khác nhau, role lần lượt là `0` và `1`, các bộ đếm lỗi đều bằng `0`. Không sửa dữ liệu PRD. Lần đổi/reset mật khẩu tiếp theo trên code mới sẽ đồng bộ hai context.

Đối chiếu Git xác nhận hotfix ngày 2026-07-10 `7d314c29` không chạm luồng đổi/reset mật khẩu admin. Không có bằng chứng để quy lỗi degrade mật khẩu cho thay đổi ngày 10/7; nguyên nhân là luồng multi-role từ năm 2025 không mở rộng xử lý đổi mật khẩu vốn chỉ cập nhật một schema.
