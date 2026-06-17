---
title: Thông báo Push Notification trên API Backend
project: itec-denwa
type: architecture
status: confirmed
source:
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/config/FirebaseConfig.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/service/firebase/FCMService.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/service/firebase/VoipPushService.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/service/device/DeviceTokenService.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/model/request/device/RegisterDeviceTokenRequest.java
tags:
  - api
  - push
  - fcm
  - backend
---

# Thông báo trên API (denwa-api notifications)

## Thận trọng khi sửa đổi liên quan đến Push/API

- Hành vi của push VoIP/cuộc gọi/tin nhắn mang tính đa nền tảng (cross-platform); hãy xác nhận rõ ràng cả cấu trúc dữ liệu gửi từ backend (payload contract) lẫn cơ chế xử lý trên thiết bị di động trước khi thay đổi từ ngữ hoặc cách thức triển khai.
- Về cách diễn đạt trong báo cáo VoIP ở cấp độ hệ thống, hãy tham khảo `global/reports.md` và `global/voip-system.md`.

## Phương pháp tiếp cận điều tra (Investigation approach)

- Định vị chính xác đường dẫn của controller/service/mapper và các câu lệnh SQL liên quan trước khi thay đổi hành vi của API.
- Đối với các hành vi push liên quan đến Firebase/Admin hoặc hàng đợi (queue), hãy lần theo luồng từ lớp service đến payload model và các kỳ vọng của ứng dụng di động phía dưới.
- Không suy đoán hành vi của thiết bị di động chỉ dựa trên mã nguồn API; hãy xác minh trực tiếp phía nhận trên Android/iOS khi có liên quan đến các trường dữ liệu trong payload.
