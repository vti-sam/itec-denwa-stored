---
title: iOS VOIP_APL-199 first-launch tenant logo fix
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-14
  - sources/denwa-ios/Denwa/Denwa/Common/AppBar/AppBarView.swift
  - sources/denwa-ios/Denwa/Denwa/DataSupportLayer/LocalResourceRepository.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/CallLogs/CallLogs/Controller/CallLogViewController.swift
tags:
  - ios
  - voip-apl-199
  - tenant-logo
  - first-launch
scope: historical
captured_at: 2026-07-14
validity: historical_context
promote_to_knowledge: false
---

# Bối cảnh

Trên lần khởi động đầu tiên sau khi cài ứng dụng, logo tenant không hiển thị ở màn hình Danh bạ và Tin nhắn. Sau khi đóng và mở lại ứng dụng, logo hiển thị bình thường.

# Nguyên nhân

Các tab chính được khởi tạo trước khi API tenant trả về URL logo. `AppBarView` chỉ đọc URL đã lưu một lần khi khởi tạo. Sau khi API hoàn tất, `CallLogViewController` lưu URL và chỉ tải lại AppBar của chính nó, nên AppBar của Danh bạ và Tin nhắn không nhận được cập nhật trong phiên chạy đầu tiên. Lần mở tiếp theo hoạt động vì URL đã tồn tại trong `UserDefaults`.

# Đối ứng

- Phát `tenantImageDidUpdateNotification` sau khi `LocalResourceRepository` lưu URL logo.
- Mọi `AppBarView` lắng nghe sự kiện và tải URL mới trên main queue.
- Bỏ lệnh tải lại riêng trong `CallLogViewController` để tránh gọi trùng.

# Verify

- Debug simulator build qua `Denwa.xcworkspace`: thành công.
- Release simulator build qua `Denwa.xcworkspace`: thành công.
- Không build trực tiếp `Denwa.xcodeproj`; cách này không liên kết các dependency CocoaPods và báo lỗi không tìm thấy module.

# TestFlight

- Version/build: `1.0.3 (31)`; app và notification extension dùng cùng version/build.
- Scheme/configuration: `Denwa` / `Release`.
- Bundle ID: `jp.co.itec.denwa.product`.
- Endpoint: `https://api.apl.purattocall.com`.
- Firebase plist: `GooglePlistProduction`.
- Archive: `scratch/ios-product-testflight/Denwa-prd-release-v1.0.3-b31-20260714.xcarchive`.
- Upload hoàn tất lúc 13:56 JST ngày 2026-07-14. App Store Connect trả về `Upload succeeded` và `Uploaded package is processing`.
- Cảnh báo thiếu dSYM của các framework MVWebRTC/WebRTC đóng gói sẵn không chặn upload.
- Thay đổi chưa được commit hoặc push tại thời điểm ghi nhận.
