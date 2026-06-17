---
title: Xác thực và Token APNs/VoIP trên iOS
project: itec-denwa
type: architecture
status: confirmed
source:
  - sources/denwa-ios/Denwa/Denwa/Resources/AppDelegate.swift
  - sources/denwa-ios/Denwa/Denwa/DataSupportLayer/LocalResourceRepository.swift
  - sources/denwa-ios/Denwa/Denwa/MVWebRTCAppCore/Model/ACPersistantCache.swift
tags:
  - ios
  - auth
  - token
  - apns
---

# Xác thực và Token trên iOS (denwa-ios auth and tokens)

## Device Token / APNs Token

- Hàm `registerDeviceTokenIfNeeded()` gửi APNs Device Token lên backend.
- Token được cập nhật từ `application(_:didRegisterForRemoteNotificationsWithDeviceToken:)` và lưu trữ trong `LocalResourceRepository`.
- Việc đăng ký token được kích hoạt khi khởi động ứng dụng và sau khi đăng nhập thành công trong `OTPViewController`.

## Token của AudioCodes/MVE

- Thư viện AudioCodes yêu cầu cả hai loại token: `apnsToken` và `voipToken` thông qua lệnh `phoneUA.setPushNotificationsTeamId`.
- VoIP token được cập nhật thông qua hàm `pushRegistry(_:didUpdate:for:)` trong `PKPushRegistryDelegate`.
- Bản sửa lỗi trước đó đã bổ sung lệnh `callManager.attemptToSetupPushNotificationService()` bên trong `didRegisterForRemoteNotificationsWithDeviceToken` để MVE nhận được APNs token mới nhất một cách kịp thời thay vì phải đợi VoIP token hoặc tiến trình đăng nhập.

## Thông tin xác thực MVE (MVE credentials)

- Thông tin tài khoản SIP được cấu hình trong hàm `setupPhoneUAForUser` bên trong `ACCallManager` bằng cách sử dụng thông tin đăng nhập mới nhất.
- Tiến trình đăng xuất (logout) cần dọn dẹp trạng thái này thông qua `clearData()` và `resetConfiguration()`.
