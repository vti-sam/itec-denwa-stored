---
title: Tạo preview avatar trung tính dùng chung cho VOIP_APL-197
project: itec-denwa
type: requirement
status: archived
source:
  - Backlog customer issue VOIP_APL-197
  - project-store/artifacts/design/voip-apl-197/README.md
tags:
  - avatar
  - android
  - ios
  - VOIP_APL-197
scope: historical
captured_at: 2026-07-17
validity: historical_context
promote_to_knowledge: false
---

# Kết quả

- Đã đọc task KH `VOIP_APL-197`: đổi icon mặc định Android/iOS từ hình mang cảm giác nam giới sang thiết kế trung tính, không phân biệt giới tính.
- Đã tạo một thiết kế avatar đầu-vai trừu tượng, không tóc, không khuôn mặt, không trang phục hoặc phụ kiện thể hiện giới tính.
- Đã xuất bản master 1024 x 1024 và các kích thước preview Android/iOS tại `project-store/artifacts/design/voip-apl-197/`.
- Các file PNG có nền ngoài vòng tròn trong suốt và alpha hợp lệ.
- Chưa thay thế asset trong source Android hoặc iOS; cần User duyệt preview trước khi tích hợp.

# Xác nhận với KH trên Backlog

- Sau khi User duyệt bản tiếng Việt, đã đăng comment tiếng Nhật vào `VOIP_APL-197` để xin xác nhận thiết kế trước khi tích hợp.
- Comment ID: `1558812759`.
- Đã gửi notification cho `片山　剛` và `ITEC_久保`.
- Đã gắn ba ảnh và read-back thành công:
  - `before-android.png`: attachment ID `1126093180`.
  - `before-ios.png`: attachment ID `1126093179`.
  - `after-neutral-common.png`: attachment ID `1126093178`.
- Source Android/iOS vẫn chưa thay đổi trong bước này.

# Tích hợp tạm thời vào Android và iOS

- Sau khi User duyệt plan, đã thay trực tiếp asset hiện tại nhưng giữ nguyên tên resource và toàn bộ code tham chiếu.
- Android:
  - Thay `sources/denwa-android/app/src/main/res/drawable/ic_placeholder_avatar_male.png` bằng bản 512 x 512.
  - `:app:processDebugResources` chạy thành công.
- iOS:
  - Thay ba file PNG 1x/2x/3x trong `ic_avatar_placeholder.imageset` bằng các bản 170 x 170, 340 x 340 và 510 x 510.
  - Asset Catalog đã đi qua bước `CompileAssetCatalogVariant` không có lỗi asset.
  - Build đầy đủ dừng do các module dependency Swift hiện không resolve được, gồm RxSwift, Kingfisher và Firebase; lỗi không liên quan đến thay đổi ảnh.
- Hash của bốn file trong source khớp với artifact đã duyệt.
- Không thay `Contents.json`, code tham chiếu, tên resource hoặc file project iOS.
- `sources/denwa-ios/Denwa/Denwa.xcodeproj/project.pbxproj` đã có thay đổi từ trước và được giữ nguyên.
- Android đã push asset lên `origin/prd` tại commit `b816bc7` (`fix(ui): use neutral placeholder avatar`).
- iOS đã push ba asset lên `origin/prd` tại commit `421b9d9` (`fix(ios): use neutral placeholder avatar`). Commit iOS được tạo từ worktree sạch dựa trên production build 39 nên không mang theo thay đổi build number DEV 38 cũ trong checkout chính.

# Lưu ý

- Bản sinh ảnh ban đầu tạo nền caro giả, không có alpha thật. Đã render lại trên nền chroma-key và tách nền cục bộ trước khi xuất các kích thước cuối.

# Kiểm tra simulator và nguyên nhân tester còn thấy avatar cũ

Ngày 2026-07-17, đã build lại Android Debug và iOS `DevRelease` cho simulator để kiểm tra asset thực tế:

- Android `:app:assembleDebug` thành công với package `jp.co.itec.denwa.dev`, version code `64`, version `1.0.2.dev_b(0064)_77a4206`.
- Resource `drawable/ic_placeholder_avatar_male` trong APK trỏ tới `res/oh.png`; SHA-256 trong APK khớp tuyệt đối với source/artifact avatar trung tính.
- iOS simulator build thành công; `Assets.car` chứa `ic_avatar_placeholder` đủ kích thước 170, 340 và 510 pixel.
- Hash source Android/iOS tiếp tục khớp với artifact đã duyệt.
- Source mỗi nền tảng chỉ có một placeholder avatar đang được code sử dụng trong luồng profile/contact/call/message.

Kết luận chẩn đoán:

- Android và iOS chỉ hiển thị placeholder trung tính khi trường avatar từ API rỗng hoặc tải ảnh thất bại.
- Khi API trả `avatarUrl`, Android Coil và iOS Kingfisher tải ảnh remote và ghi đè placeholder; cache ảnh có thể tiếp tục hiển thị nội dung cũ nếu URL không đổi.
- API đọc trực tiếp cột `users.avatar_url` cho profile/contact/call/message và không thay bằng placeholder mới.
- iOS DEV TestFlight `1.0.4 (41)` vừa upload thành công nhưng còn processing tại thời điểm kiểm tra; tester có thể vẫn đang dùng build cũ.

# Ảnh bằng chứng trên simulator

Đã đăng nhập bằng account test trên Android emulator và iPhone simulator, mở màn hình Lịch sử cuộc gọi và chụp ảnh runtime thực tế:

- Android: `scratch/simulator-screenshots/avatar-check/android-avatar-proof.png`.
- iOS: `scratch/simulator-screenshots/avatar-check/ios-avatar-proof.png`.
- Các user không có `avatarUrl` như `Hường 1` và `Hường 6` hiển thị avatar trung tính trên cả hai nền tảng.
- Các user có `avatarUrl` như `Hường 7` và `Nam 13011` tiếp tục hiển thị ảnh remote, đúng logic hiện tại.
- Credential và OTP không được ghi vào artifact hoặc memory.
