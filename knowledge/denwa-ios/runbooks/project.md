---
title: Dự án iOS (denwa-ios project scope & build)
project: itec-denwa
type: runbook
status: confirmed
source:
  - sources/denwa-ios/README.md
  - sources/denwa-ios/Denwa/Podfile
  - sources/denwa-ios/Denwa/Podfile.lock
  - sources/denwa-ios/Denwa/Denwa.xcodeproj/project.pbxproj
tags:
  - ios
  - xcode
  - cocoapods
---

# Dự án iOS (denwa-ios project)

## Phạm vi (Scope)

- Thư mục mã nguồn của ứng dụng iOS: `/Users/vti-sam/itec-denwa/sources/denwa-ios`.
- Tên ứng dụng trong tài liệu README: Denwa / ぷらっとCALL.
- Ứng dụng chính hỗ trợ các chức năng gọi điện VoIP, nhắn tin và quản lý danh bạ.

## Yêu cầu từ tài liệu README

- Xcode 26.2+
- iOS deployment target 15.6 theo README.
- CocoaPods 1.16.2+
- Ruby 3.0+

## Deployment target trong project

- Tại lần đối chiếu 2026-05-26, `Denwa.xcodeproj/project.pbxproj` có nhiều giá trị `IPHONEOS_DEPLOYMENT_TARGET` theo target/config, bao gồm 15.0, 15.6 và 18.5.
- Khi chỉnh cấu hình build hoặc xử lý lỗi App Store, cần kiểm tra target cụ thể thay vì chỉ dựa vào dòng yêu cầu 15.6 trong README.

## Lưu ý về CocoaPods/Xcode

- Phiên bản CocoaPods 1.16.2 không hỗ trợ định dạng dự án của Xcode 26 (`objectVersion = 70`).
- Trước khi chạy lệnh `pod install`, tài liệu README hướng dẫn thay đổi nội dung file `Denwa/Denwa.xcodeproj/project.pbxproj`:
  - từ `objectVersion = 70;`
  - sang `objectVersion = 60;`
- Xcode có thể tự động nâng cấp định dạng này trở lại 70; hãy lặp lại thao tác trên trước mỗi lần chạy `pod install`.
- Luôn mở file `Denwa.xcworkspace`, không mở file `.xcodeproj`.

## Xác minh (Verification)

- Các lệnh kiểm tra cú pháp được sử dụng trước đây:
  - `rtk xcrun --sdk iphoneos swiftc -parse -F denwa-ios/Denwa ...`
- Quá trình build Xcode đầy đủ có thể gặp lỗi trước cả bước kiểm tra cú pháp Swift do lỗi xử lý các xcframework/framework từ bên thứ ba hoặc do sự cố ký ứng dụng (signing)/liên kết (linking). Hãy báo cáo các sự cố này một cách riêng biệt với lỗi cú pháp Swift khi chúng xảy ra.

## Hướng màn hình trên App Store (App Store orientation)

- Sự cố kiểm duyệt App Store về đa nhiệm trên iPad (lỗi `ITMS-90474`) đã được xử lý bằng cách khai báo rõ ràng các hướng màn hình iPad được hỗ trợ cho tất cả các target liên quan.
- Kiểm tra lại các thiết lập hiện tại trong file Info.plist/target trước khi chỉnh sửa cấu hình hỗ trợ hướng màn hình.
