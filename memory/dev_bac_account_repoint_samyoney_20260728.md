---
title: Đổi account Bạc DEV sang samyoney, đồng bộ password và sửa email .com
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session 2026-07-28
  - Live DEV database transaction and read-back on 2026-07-28
  - scratch/db-backups/denwa_dev_bac_to_samyoney_20260728T074647Z.json
  - scratch/db-backups/denwa_dev_samyoney_com_fix_20260728T084402Z.json
tags:
  - dev
  - database
  - mobile-user
  - account
  - authentication
scope: historical
captured_at: 2026-07-28
validity: historical_context
promote_to_knowledge: false
---

## Outcome

Trên database DEV `denwa_dev`, active mobile account tenant `112` có UUID
`78d18d29-d981-462e-a63b-1949e7022e0c` được đổi login từ
`bac.vuongtoan@vti.com.vn` sang `samyoney@gmail.com.vn`.

Giữ nguyên UUID, SIP `13003`, role `2`, phone type `1`,
`user_status = '3'` và `delete_flag = '0'`. Password BCrypt của target được
đồng bộ trực tiếp trong database từ account Son UUID
`7969c23d-ba32-4f6d-ae19-559f9b3ac04c`; không đọc, ghi hoặc lưu plaintext
password. Refresh token được giữ rỗng và các bộ đếm lỗi được reset về `0`.

Mapping mobile tenant `112`, `account_type = '1'` được đổi sang email mới.
Account Son vẫn giữ trạng thái tạm soft-delete phục vụ test
`ITEC_DENWA_APP-267`.

Sau khi phát hiện hậu tố email không đúng mục đích sử dụng, account trên được
đổi từ `samyoney@gmail.com.vn` sang `samyoney@gmail.com`. Chỉ `user_name` của
user và mapping mobile tương ứng được đổi; UUID, SIP, trạng thái, role,
phone type và password được giữ nguyên.

## Evidence

- Transaction dừng nếu database không phải `denwa_dev`, target Bạc không còn
  đúng UUID/SIP/trạng thái active, source Son không còn password BCrypt hợp lệ,
  email đích đã tồn tại hoặc mapping nguồn không có đúng một bản ghi.
- In-transaction verification xác nhận target mới active với SIP `13003` và
  password hash bằng source Son.
- Independent read-back xác nhận email mới có đúng một mapping, email cũ có
  active row count và mapping count bằng `0`, password target khớp source Son,
  còn account Son vẫn soft-deleted và không có SIP.
- Snapshot metadata không chứa secret nằm tại
  `scratch/db-backups/denwa_dev_bac_to_samyoney_20260728T074647Z.json`.
- Transaction sửa hậu tố email dừng nếu database không phải `denwa_dev`,
  target không còn đúng UUID/SIP/trạng thái active, email `.com` đã tồn tại
  hoặc mapping `.com.vn` không có đúng một bản ghi tenant `112`.
- Independent read-back sau lần sửa xác nhận `samyoney@gmail.com` có đúng một
  user active và một mapping mobile tenant `112`; email `.com.vn` không còn
  user hoặc mapping, SIP `13003` không bị trùng và password target vẫn khớp
  source Son.
- Snapshot metadata lần sửa hậu tố không chứa secret nằm tại
  `scratch/db-backups/denwa_dev_samyoney_com_fix_20260728T084402Z.json`.

## Unresolved

Chưa chạy login smoke test bằng `samyoney@gmail.com`; User sẽ kiểm tra trên
app. Account Son vẫn cần được restore sau khi User hoàn tất test.

## Retrieval keys

- samyoney@gmail.com.vn
- samyoney@gmail.com
- bac.vuongtoan@vti.com.vn
- son.nguyenhong1@vti.com.vn
- 78d18d29-d981-462e-a63b-1949e7022e0c
- 7969c23d-ba32-4f6d-ae19-559f9b3ac04c
- tenant 112
- SIP 13003
- ITEC_DENWA_APP-267
