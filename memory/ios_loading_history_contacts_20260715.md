---
title: Sửa loading chậm và dữ liệu cũ trên iOS History Call và Danh bạ
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-15
  - sources/denwa-ios/Denwa/Denwa/Modules/Contacts/Contacts/Controller/ContactsViewController.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/CallLogs/CallLogs/Controller/CallLogViewController.swift
tags:
  - ios
  - loading
  - contacts
  - call-history
  - rxswift
scope: historical
captured_at: 2026-07-15
validity: historical_context
promote_to_knowledge: false
---

# Kết quả

- Danh bạ từng gọi trùng request khởi tạo từ `viewWillAppear` và giá trị rỗng ban đầu của ô tìm kiếm. Request mới nhất hiện là request duy nhất được phép cập nhật danh sách và điều khiển indicator.
- Tìm kiếm Danh bạ luôn reset `pageNum` về 1 để không dùng nhầm trang sau khi đã load more.
- History Call từng gọi trùng từ `transform` và `viewDidAppear` khi danh sách còn rỗng. Luồng khởi tạo hiện chỉ gọi một lần.
- Loading History Call được gắn với request danh sách; request logo tenant không còn bật global loading.
- Response cũ của Danh bạ và History Call bị bỏ qua khi đã có request mới hơn.

# Verify

- `git diff --check`: thành công.
- Debug simulator build bằng `Denwa.xcworkspace`, scheme `Denwa`, configuration `Debug`: thành công.
- Build number `32` trong `Denwa.xcodeproj/project.pbxproj` là thay đổi cục bộ có sẵn từ phiên TestFlight trước, không thuộc bản sửa loading này.

# Simulator smoke test

- Build Debug/DEV và Release/PRD cho iPhone 17 Pro Simulator đều thành công, app cài và mở được.
- Ba Store reviewer account của tenant ITEC `111` đều bị API DEV và PRD từ chối với thông báo dịch vụ đã bị hủy; không thể đi tiếp tới History Call và Danh bạ.
- Các Simulator khác trên máy không có app/session đăng nhập cũ để tái sử dụng.
- Simulator vẫn phù hợp để test đăng nhập, loading, Danh bạ và History Call. VoIP, CallKit, push notification, microphone và camera cần xác nhận thêm trên thiết bị thật.
