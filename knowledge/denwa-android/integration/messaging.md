---
title: Nhắn tin và FCM Push trên Android
project: itec-denwa
type: architecture
status: confirmed
source:
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/module/fcm/DenwaFirebaseMessagingService.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/module/chat/NewMessageSyncDispatcherImpl.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/main/chat/contract/ChatViewModel.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/database/datasource/chat/impl/ChatLocalDataSourceImpl.kt
tags:
  - android
  - messaging
  - fcm
  - notification
---

# Nhắn tin trên Android (denwa-android messaging)

## Thông báo có tin nhắn mới (New-message notification)

Luồng xử lý (Flow):

- FCM `push_type=MESSAGE` -> `DenwaFirebaseMessagingService` -> `AudioCodecCallManager.onPushNotificationReceived()` -> `handleNewMessagePush()`.
- `handleNewMessagePush()` gọi `NewMessageSyncDispatcher.dispatch()` sau khi đồng bộ hóa delta qua HTTP (HTTP delta sync).
- Thành phần liên kết ứng dụng (app binding) gọi `NewMessageNotificationHelper.showIfNeeded()` khi có tin nhắn mới và người dùng không ở trong phòng chat của cuộc hội thoại đó.

Hành vi thông báo từ ngày 2026-05-18:

- Kênh thông báo (Notification Channel) cho tin nhắn mới đã được nâng cấp lên `chat_message_notification_v3` do các kênh trên Android 8+ không thể thay đổi sau khi được tạo.
- Các ID kênh cũ `chat_message_notification` và `chat_message_notification_v2` nên được xóa bỏ khi helper tạo kênh mới.
- Thông báo/Kênh thông báo tin nhắn mới nên bật âm thanh mặc định, chế độ rung, đèn nhấp nháy, hiển thị công khai trên màn hình khóa (public lockscreen visibility), và giữ hành vi của WakeLock để làm sáng màn hình khi thiết bị đang ở trạng thái không hoạt động (not interactive).
- Việc này không được ảnh hưởng đến thông báo cuộc gọi, đồng bộ tin nhắn, hoặc logic loại bỏ trùng lặp tin nhắn trừ khi nhiệm vụ hiện tại yêu cầu.

## Nhận trùng lặp Push tin nhắn (Duplicate message push)

- Logic loại bỏ trùng lặp tin nhắn push (message push dedupe) phải được đối chiếu lại với code Android/iOS hiện tại trước khi khẳng định hành vi chính xác.
- Về cách diễn đạt trong báo cáo, không quy đây thành vấn đề của riêng một nền tảng trừ khi có bằng chứng thực tế rõ ràng.
