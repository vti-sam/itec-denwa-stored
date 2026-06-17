---
title: Vòng đời cuộc gọi và CallKit trên iOS
project: itec-denwa
type: architecture
status: confirmed
source:
  - sources/denwa-ios/Denwa/Denwa/CallService/IncomingCallHandler.swift
  - sources/denwa-ios/Denwa/Denwa/ClientModel/ACCallManager.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/Call/VoiceCall/Controller/VoiceCallViewController.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/Call/VideoCall/Controller/VideoCallViewController.swift
tags:
  - ios
  - callkit
  - call-lifecycle
  - sip
---

# Vòng đời cuộc gọi trên iOS (denwa-ios call lifecycle)

## Dọn dẹp cuộc gọi đã kết thúc (Terminated call cleanup)

- Khi phía đối tác tắt máy (remote terminates) hoặc phiên kết nối kết thúc, tiến trình dọn dẹp (cleanup) phải giữ cho trạng thái của CallKit và giao diện cuộc gọi tùy chỉnh (custom call UI) luôn nhất quán.
- Kiểm tra lại cơ chế xử lý luồng hiển thị màn hình (route/window/session handling) hiện tại trước khi trích dẫn các chi tiết triển khai cũ.

## Cuộc gọi nhỡ và CallKit ảo (Missed call and ghost CallKit)

- Giao diện CallKit và Push VoIP có thể xuất hiện trước khi bản tin SIP INVITE/phiên kết nối thực tế được ánh xạ một cách hoàn chỉnh.
- Cần có log về vòng đời SIP, cơ chế timeout/dọn dẹp cho giao diện CallKit khi bản tin SIP INVITE/phiên kết nối không xuất hiện, và sự tương quan với việc dọn dẹp cuộc gọi nhỡ (MISSED_CALL) hoặc session ID.
- Không khẳng định cơ chế hẹn giờ (timer) hoặc deadlock chính xác trừ khi mã nguồn hoặc log hiện hành xác nhận rõ ràng.

## Kết thúc cuộc gọi trong luồng đa cuộc gọi (Multicall terminate)

- Việc kết thúc một cuộc gọi trong luồng đa cuộc gọi (multicall flow) không được phép đóng màn hình của một cuộc gọi đang hoạt động khác không liên quan.
- Xác minh lại cơ chế kiểm tra định danh cuộc gọi/phiên kết nối (call/session identity checks) hiện tại trước khi chỉnh sửa.

## Tắt ứng dụng khi đang trong cuộc gọi (App terminate while in call)

- Việc dọn dẹp khi tắt ứng dụng cục bộ chỉ là giải pháp cố gắng hết sức (best-effort).
- Để xem các tác động đa nền tảng/phía máy chủ, hãy đọc file `global/voip-system.md`.

## Lưu lịch sử chuyển cuộc gọi trước khi kết thúc tất cả cuộc gọi (Transfer history before end all calls)

- Luồng chuyển cuộc gọi trên iOS có một ghi chú trước đó yêu cầu lưu lại lịch sử chuyển cuộc gọi trước khi kết thúc tất cả các cuộc gọi.
- Hãy coi đây là một lưu ý kỹ thuật cần thận trọng; kiểm tra lại mã nguồn hiện tại trước khi thay đổi hành vi chuyển cuộc gọi hoặc kết thúc tất cả cuộc gọi.

## Khóa tránh xung đột kết nối trùng lặp (Connect race lock)

- Việc gọi trùng lặp `connect(true)` hoặc đăng nhập SDK trùng lặp trong quá trình kích hoạt ứng dụng/khởi động lạnh (cold start) có thể làm mất ổn định cơ chế xử lý cuộc gọi đến.
- Sử dụng cơ chế khóa/bảo vệ trạng thái (lock/state guard) xung quanh luồng đăng nhập SDK nếu luồng chạy hiện tại có khả năng bị gọi lại (re-enter) khi đang ở trạng thái CONNECTING hoặc CONNECTED.
