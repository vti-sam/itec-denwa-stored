---
title: Xác thực ứng dụng Android (denwa-android auth)
project: itec-denwa
type: architecture
status: confirmed
source:
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/main/MainActivity.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/module/fcm/BackgroundIncomingCallCoordinator.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/module/call/CallCredentialManagerImpl.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/viewmodel/DenwaViewModel.kt
tags:
  - android
  - auth
  - token
  - sip
---

# Xác thực ứng dụng Android (denwa-android auth)

## Bảo vệ chống xóa thông tin xác thực API (API credential clear guard)

Bối cảnh từ 2026-05-17:

- Nhật ký hệ thống (log) cho thấy các yêu cầu API thành công với Bearer token, sau đó xuất hiện ngoại lệ `HttpAuthenticationRequiredException: Api required authentication but authentication value is null or empty` từ `CookiesInterceptor`.
- Điều này chỉ ra rằng thông tin xác thực API cục bộ bị xóa/mất trước khi yêu cầu được gửi đi, chứ không hẳn là do backend từ chối JWT.

Quyết định:

- Tiến trình khởi chạy nhanh ứng dụng (fast-path app initialization) sau khi đã ở trạng thái đã xác thực không được phép xóa thông tin xác thực API vì các lỗi khởi tạo tùy ý.
- `AppInitializationUseCase.fetch(Unit)` bao gồm các API lấy thông tin cá nhân/cài đặt, Firebase token, xác thực SIP/MVE, tải tenant và đưa công việc vào hàng đợi; các lỗi về mạng/SIP/FCM cần phải giữ lại thông tin xác thực API.
- Chỉ xóa thông tin xác thực khi gặp ngoại lệ `UnauthorizedException` với tham số `forceEndSession=true`.

## Sự sai lệch giữa HTTP token và SIP cache (HTTP token vs SIP cache divergence)

Rủi ro:

- HTTP auth token có thể bị thiếu hoặc không hợp lệ trong khi thông tin xác thực SIP vẫn được lưu trong cache.
- Cần tránh việc đánh thức/đăng ký/gọi SIP (SIP wake/register/call) dựa trên các endpoint cũ khi thiếu thông tin xác thực HTTP.

Hành vi an toàn (conservative) mong muốn:

- Xóa `CallCredentialManager` khi xác thực/khởi tạo HTTP thất bại hoặc khi thông tin xác thực bị xóa một cách tường minh.
- Code hiện tại cần được kiểm tra trước khi khẳng định đã có guard này: tại lần đối chiếu 2026-05-26, `MainActivity.onResume()` vẫn gọi `callManager.authenticate(forceLogout = false)` khi không có active call và có mạng, không kiểm tra trực tiếp `CredentialManager.getAuthToken()`.
- Code hiện tại cần được kiểm tra trước khi khẳng định đã có guard này: tại lần đối chiếu 2026-05-26, `BackgroundIncomingCallCoordinator.handleIncomingPush()` chưa inject/check `CredentialManager`, mà chỉ xử lý dedupe/WakeLock rồi gọi `callManager.onPushNotificationReceived(...)`.

Đánh đổi:

- Nếu bổ sung guard HTTP token, tiến trình đánh thức/kết nối lại SIP cho cuộc gọi đến sẽ không chạy cho đến khi tiến hành xác thực lại/khởi tạo lại. Đây là đánh đổi có chủ đích nhằm tránh việc sử dụng endpoint SIP đã cũ.
