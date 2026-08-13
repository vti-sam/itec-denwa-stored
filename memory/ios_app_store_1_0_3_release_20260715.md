---
title: iOS App Store release 1.0.3 build 31
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-15
  - sources/denwa-ios
  - sources/denwa-api/src/main/resources/templates/activeAccount.html
  - App Store Connect app 6758184620
tags:
  - ios
  - app-store
  - release
  - activation-email
scope: historical
captured_at: 2026-07-15
validity: historical_context
promote_to_knowledge: false
---

# Kết quả

- API đã sửa email kích hoạt để hiển thị tên ứng dụng từ `APP_NAME` và trỏ liên kết iOS đến trang App Store Nhật Bản của ぷらっとCALL.
- API commit `e7ccd49a98e17c34b821166ce435fc45a422cc89` đã push lên nhánh `prd`.
- iOS version `1.0.3`, build `31`; commit `6a613862b34a8a8fec162aa981a50d5b16e4eb99` đã push lên nhánh `prd`.
- Tag annotated `denwa-v1.0.3-build31(Release)` đã push và trỏ tới commit iOS trên.
- Archive sử dụng để phát hành: `scratch/ios-product-testflight/Denwa-prd-release-v1.0.3-b31-20260714.xcarchive`.

# Verify

- API: Maven test thành công, 3 test pass.
- iOS: Release simulator build qua workspace thành công.
- URL App Store Nhật Bản trả về HTTP 200 và mở đúng trang ぷらっとCALL.
- App Store Connect đã gắn build `1.0.3 (31)` và hoàn tất khai báo export compliance.
- Phạm vi phân phối giữ nguyên 2 quốc gia: Japan và Vietnam.
- Chế độ phát hành: manual release; cập nhật toàn bộ người dùng sau khi chủ động release.
- Nội dung cập nhật: `軽微な修正を行いました。`
- Hồ sơ đã gửi Apple Review ngày 2026-07-15; trạng thái sau submit là `Waiting for Review`, Draft Submissions bằng 0.

# Lưu ý

- Việc push API không đồng nghĩa production API đã được deploy; phiên này không thực hiện deploy backend.
- Apple có thể mất tới 48 giờ để review theo thông báo trên App Store Connect.
