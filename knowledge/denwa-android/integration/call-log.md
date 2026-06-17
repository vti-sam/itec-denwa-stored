---
title: Lịch sử cuộc gọi và Paging trên Android
project: itec-denwa
type: architecture
status: confirmed
source:
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/call/log/host/CallLogUi.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/call/log/host/contract/CallLogViewModel.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/usecase/call/FetchCallLogUseCase.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/database/datasource/calllog/CallLogsDataSource.kt
tags:
  - android
  - call-log
  - paging
  - voicemail
---

# Nhật ký cuộc gọi trên Android (denwa-android call log)

## Việc hủy bỏ phân trang (Paging cancellation)

Sự cố:

- Màn hình lịch sử cuộc gọi có thể hiển thị lỗi tiếng Nhật chung `処理時にエラーが発生しました。もう一度確認してください。` (Đã xảy ra lỗi trong quá trình xử lý. Vui lòng kiểm tra lại.)
- Nhật ký hệ thống (log) xuất hiện lỗi `androidx.paging.SingleRunner$CancelIsolatedRunnerException: Cancelled isolated runner`.
- Đây là lỗi hủy nội bộ của thư viện Jetpack Paging do các yêu cầu refresh chồng chéo lên nhau, chứ không phải lỗi từ backend hay do xác thực thất bại.

Quyết định/hướng khắc phục:

- Các sự kiện làm mới trong `CallLogUi.kt` nên gọi `data.refresh()` chỉ khi cả `data.loadState.refresh` lẫn `data.loadState.mediator?.refresh` đều không ở trạng thái `LoadState.Loading`.
- Tại lần đối chiếu 2026-05-26, event refresh trong `CallLogUi.kt` đã có guard loading, nhưng nhánh pull-to-refresh vẫn gọi `data.refresh()` trực tiếp; cần kiểm tra lại điểm này trước khi khẳng định lỗi chồng chéo refresh đã được xử lý toàn bộ.
- Hàm `DefaultRemoteMediator.load()` nên ném lại (rethrow) `CancellationException` riêng biệt thay vì chuyển hướng nó qua hàm xử lý lỗi chung `onError`.
- Hàm `ComposeInteractViewModel.Throwable.resolve()` nên bỏ qua `CancellationException` để việc hủy bỏ này không hiển thị thành hộp thoại thông báo lỗi chung cho người dùng.

## Bản ghi tin nhắn thoại bị cũ (Voice message stale record)

Kịch bản:

- Cuộc gọi đi trên Android bị hết thời gian chờ (timeout).
- Người dùng vào màn hình ghi âm tin nhắn thoại và nhấn Hủy (Cancel).
- Lịch sử cuộc gọi không được hiển thị hoặc tải lên (upload) tin nhắn thoại của cuộc gọi trước đó.

Rủi ro/Cách khắc phục:

- `UploadCallLogUseCase` gửi nhật ký cuộc gọi, sau đó kiểm tra bảng cục bộ `sync_call_log_voice_message` theo UUID cuộc gọi cục bộ và tải lên bất kỳ file nào khớp.
- Việc truy vấn qua DAO chỉ nên trả về các hàng có `syncedAt IS NULL`.
- Việc tải lên tin nhắn thoại thành công sẽ xóa hàng đang chờ xử lý cục bộ thay vì giữ lại hàng đã đồng bộ hóa.
- Xóa bỏ các biểu thức không có tác dụng (no-op) xung quanh luồng tải lên nếu vẫn còn tồn tại.

## Nhãn hiển thị khi đã kết nối cuộc gọi (Connected call label)

- Trạng thái `CallSession.State.Connected` ánh xạ tới chuỗi `R.string.label_on_a_call`.
- Chuỗi tiếng Nhật kỳ vọng là `通話中` (Đang trong cuộc gọi), chứ không phải `電話中`.
- Hãy giữ cho cả tài nguyên mặc định và các biến thể tài nguyên tiếng Việt được đồng bộ nếu tài nguyên này được chỉnh sửa.
