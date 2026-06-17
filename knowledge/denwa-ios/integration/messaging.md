---
title: Nhắn tin và DB Migration trên iOS
project: itec-denwa
type: architecture
status: confirmed
source:
  - sources/denwa-ios/Denwa/Denwa/Modules/Messages/Chat/README.md
  - sources/denwa-ios/Denwa/Denwa/Modules/Messages/Chat/Domain/Entities/LocalMessageDBManager.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/Messages/Chat/Domain/UseCase/MessageManager/MessageManager.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/Messages/Chat/Domain/UseCase/ChatRetrySendMessageManager.swift
tags:
  - ios
  - messaging
  - database
  - push
---

# Nhắn tin trên iOS (denwa-ios messaging)

## Kiến trúc nhắn tin (Message architecture)

- Xử lý các hành vi dưới nền/VoIP liên quan đến nhắn tin một cách độc lập với luồng định tuyến cuộc gọi (call-routing) trừ khi log hiện tại chỉ ra có sự tương tác giữa chúng.
- Kiểm tra lại các thành phần như repository tin nhắn hiện hành, cơ sở dữ liệu cục bộ, bộ xử lý push (push handler) và luồng đồng bộ trước khi khẳng định hành vi chính xác.

## Vòng lặp di chuyển cơ sở dữ liệu tin nhắn cục bộ (Local message DB migration loop)

- Đã từng có một sự cố trước đó liên quan đến việc lặp vô hạn khi migrate cơ sở dữ liệu tin nhắn cục bộ.
- Hãy giữ thông tin này như một cảnh báo rủi ro; không khẳng định đây là hành vi hiện tại khi chưa kiểm tra kỹ lược đồ (schema) và mã nguồn migration.

## Xử lý gửi tin nhắn thất bại (Failed message handling)

- Tài liệu chat của iOS có đề cập đến việc xử lý các tin nhắn bị lỗi bằng cách sử dụng cơ sở dữ liệu SQLite cục bộ.
- Trước khi thay đổi hành vi thử lại/đồng bộ/xóa, hãy kiểm tra kỹ tài liệu README/tài liệu chat hiện tại và mã nguồn triển khai trong thư mục `sources/denwa-ios`.

## Nhận trùng lặp Push tin nhắn (Duplicate message push)

- Việc xử lý trùng lặp push có thể khác nhau tùy theo nền tảng, do đó từ ngữ sử dụng trong báo cáo cần được giữ ở mức thận trọng.
- Xác minh lại logic nhận dạng gói tin (payload fingerprint), phiên kết nối (session ID) hoặc ID tin nhắn hiện tại trước khi sửa đổi hành vi loại bỏ trùng lặp (dedupe).
