---
title: Cấu hình Release/Debug trên Android
project: itec-denwa
type: runbook
status: confirmed
source:
  - sources/denwa-android/env/env_staging.json
  - sources/denwa-android/app/build.gradle.kts
  - sources/denwa-android/call/src/main/java/vn/com/vti/call/impl/AudioCodecTimberLog.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/main/profile/ProfileUi.kt
tags:
  - android
  - build-config
  - backup
  - logging
---

# Cấu hình Release/Debug trên Android (denwa-android release/debug config)

## Tự động sao lưu (Auto Backup)

- Các bản build Debug và Staging nên tắt tính năng Tự động sao lưu của Android (Android Auto Backup) thông qua các lớp phủ manifest (manifest overlays) nếu việc khôi phục thông tin xác thực/cơ sở dữ liệu gây ra trạng thái đăng nhập/phiên làm việc bị cũ sau khi gỡ cài đặt và cài đặt lại.
- Dữ liệu cục bộ liên quan không được phép tự động khôi phục một cách ngoài ý muốn trong quá trình khảo sát Debug/Staging:
  - JWT/Thông tin xác thực API trong DataStore `credential`.
  - Thông tin xác thực SIP/MVE trong DataStore `call_credential`.
  - Room Database `denwa.db`.
  - Dữ liệu cài đặt Firebase.
- Hành vi manifest của bản Release được giữ nguyên một cách có chủ đích trong bản vá trước đó.

## Tham số Staging CALL_PUSH_FCM

- Môi trường Staging có thể yêu cầu bật `CALL_PUSH_FCM` để hành vi của push-token FCM cuộc gọi khớp với kỳ vọng kiểm thử cuộc gọi đến.
- Trước khi thay đổi cấu hình này, hãy kiểm tra lại file `env/env_staging.json` hiện tại, `BuildConfig` được tạo ra, và luồng push-token của AudioCodes/MVE.
- Không khẳng định rằng chỉ riêng cài đặt này là đủ để sửa các lỗi cuộc gọi đến/đăng ký nếu không có nhật ký (log) Staging thực tế tương ứng.

## Bộ lọc nhật ký AudioCodes SDK (AudioCodes SDK log filter)

- Nhật ký (log) của SDK/PJSIP có thể rất nhiều và nhiễu; bộ lọc cần giữ lại các luồng cuộc gọi/lỗi có độ ưu tiên cao trong khi loại bỏ các bản tin rác lặp đi lặp lại về SDP/ICE/dialog trace.
- Trước khi áp dụng các mẫu bộ lọc chính xác, hãy kiểm tra lại file `AudioCodecTimberLog.kt` hiện hành và các log mục tiêu.
- Cần cẩn thận để tránh ẩn mất các chi tiết về SIP/PJSIP cần thiết cho quá trình debug tính năng chuyển cuộc gọi (transfer) hoặc đăng ký (register).

## Nút báo cáo nhật ký (Report log button)

- Các bản build Product/Release nên hiển thị giao diện báo cáo nhật ký (report-log UI) khi có yêu cầu từ phía quyết định sản phẩm hiện tại.
- Ghi chú đa nền tảng trước đó: Màn hình Cài đặt của iOS `ProfileViewController.swift` đã loại bỏ macro chỉ dùng cho debug xung quanh nút báo cáo nhật ký.
- Tại lần đối chiếu 2026-05-26, nhãn hiển thị của Android trong `ProfileUi.kt` vẫn là `ログ報告 (Debug Mode)`; nếu cần hiển thị cho Product/Release, nên đổi sang cách gọi không mang nghĩa debug, ví dụ `ログ報告`.
