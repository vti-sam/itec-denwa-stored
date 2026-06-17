---
title: Chuyển cuộc gọi VoIP trên Android
project: itec-denwa
type: architecture
status: confirmed
source:
  - sources/denwa-android/call/src/main/java/vn/com/vti/call/impl/PjSipThreadDispatcher.kt
  - sources/denwa-android/call/src/main/java/vn/com/vti/call/impl/AudioCodecCallManager.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/call/dialer/transfer/contract/DialerTransferViewModel.kt
  - sources/denwa-android/call/src/test/java/vn/com/vti/call/impl/TransferReplacementStateTest.kt
tags:
  - android
  - voip
  - sip
  - transfer
---

# Chuyển cuộc gọi VoIP trên Android (denwa-android VoIP transfer)

## Nguồn báo cáo chuẩn (Canonical report source)

Đối với các từ ngữ dùng trong báo cáo gửi ra ngoài, hãy đọc kỹ lại `docs/voip_system_issue_report_2026_04.md`, đặc biệt là các bảng liên quan đến quá trình chuyển cuộc gọi trên Android như `VOIP_APL-161`, `VOIP_APL-162` và `VOIP_APL-176`.

## Duy trì phiên làm việc (Session preservation)

- Quá trình khôi phục chuyển cuộc gọi và khôi phục đăng ký (register recovery) yêu cầu phải duy trì các phiên SIP đang hoạt động (active SIP sessions) thay vì tự động kết nối lại, làm mới đăng nhập, hoặc làm mới mạng một cách mù quáng.
- Phân biệt rõ giữa trạng thái phiên rảnh rỗi (idle) và trạng thái phiên đang hoạt động/đang chuyển tiếp (active/transfer).
- Không thực hiện kết nối lại SDK hoặc làm mới mạng theo cách phá hủy các nhánh SIP (SIP legs) đang hoạt động hoặc có liên quan đến quá trình chuyển cuộc gọi.

## Bộ điều phối PJSIP / Phiên đích (PJSIP dispatcher / target session)

- Các thao tác nhạy cảm với PJSIP có thể gây crash ứng dụng hoặc hoạt động không đúng cách nếu sử dụng các đối tượng phiên đã cũ hoặc chạy trên luồng/thời điểm không an toàn.
- Mô hình an toàn hơn: Định tuyến các thao tác nhạy cảm với giữ/chuyển cuộc gọi thông qua một ranh giới điều phối/trạng thái (dispatcher/state boundary) và giải quyết các phiên đích hiện tại ở vị trí gần với lệnh gọi SDK nhất.
- Không trích dẫn chính xác chữ ký phương thức (method signature) hoặc giá trị độ trễ (delay values) trừ khi đã kiểm tra lại trong mã nguồn/nhật ký hệ thống hiện tại.

## Bảo vệ khi thay đổi mạng (Network-change guard)

- Sự thay đổi mạng hoặc làm mới đăng ký trong quá trình dọn dẹp REFER/NOTIFY/Replaces có thể làm mất ổn định quá trình chuyển cuộc gọi.
- Trì hoãn hoặc ngăn chặn việc làm mới mạng trong khi quá trình chuyển cuộc gọi đang diễn ra hoặc khi các phiên SIP được duy trì vẫn còn quan trọng.

## Trạng thái chuyển cuộc gọi và hiển thị (Transfer status and display)

- Giao diện và vòng đời chuyển cuộc gọi (Transfer UI/lifecycle) cần trạng thái tiến trình/thành công/thất bại đáng tin cậy, lý tưởng nhất là liên kết chặt chẽ với trạng thái SIP REFER/NOTIFY/Replaces.
- Tránh việc kết thúc cuộc gọi hoặc bỏ giữ cuộc gọi (unholding) chỉ dựa trên các giả định giao diện cục bộ.
- Siêu dữ liệu hiển thị (display metadata) nên được tách biệt khỏi hội thoại/phiên SIP thực tế.
- Trong quá trình chuyển cuộc gọi có tham vấn (attended transfer), màn hình cuộc gọi phải hiển thị chính xác thông tin của bên đích/liên hệ thay vì thông tin cũ của bên ban đầu.
