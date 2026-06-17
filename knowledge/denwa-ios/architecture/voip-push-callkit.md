---
title: iOS VoIP PushKit và CallKit integration
project: itec-denwa
type: architecture
status: confirmed
source:
  - sources/denwa-ios/Denwa/Denwa/Resources/AppDelegate.swift
  - sources/denwa-ios/Denwa/Denwa/CallService/IncomingCallHandler.swift
  - sources/denwa-ios/Denwa/Denwa/ClientModel/ACCallManager.swift
tags:
  - ios
  - pushkit
  - callkit
  - voip
---

# iOS VoIP PushKit và CallKit (denwa-ios VoIP PushKit and CallKit)

## Nguồn báo cáo chuẩn (Canonical report source)

Đối với các từ ngữ dùng trong báo cáo gửi ra ngoài, hãy đọc kỹ lại `docs/voip_system_issue_report_2026_04.md`, đặc biệt là các bảng liên quan đến iOS như `VOIP_APL-135`, `VOIP_APL-172` và `VOIP_APL-178`.

## Trùng lặp/Dội ngược giao diện cuộc gọi (Duplicate/bounce-back call UI)

- Cả giao diện gốc của CallKit và màn hình cuộc gọi tùy chỉnh (custom call screen) đều có thể tham gia vào cùng một luồng xử lý cuộc gọi đến.
- Các khu vực rủi ro: Hiển thị trùng lặp giao diện, hiện tượng dội ngược (bounce-back), hành động trả lời (answer) bị lặp, trạng thái đường dẫn/màn hình cuộc gọi chờ xử lý bị cũ.
- Hướng xử lý an toàn: Chuẩn hóa cơ chế xử lý trả lời cuộc gọi của CallKit, tránh các hành động trùng lặp giữa giao diện gốc và giao diện tùy chỉnh cho cùng một phiên kết nối, tái sử dụng hoặc dọn dẹp các màn hình/định tuyến cuộc gọi tùy chỉnh một cách chính xác.

## Hoàn thành Callback PushKit (PushKit callback completion)

- Callback nhận cuộc gọi đến của PushKit bắt buộc phải gọi handler hoàn thành (completion handler) của nó đúng một lần cho mỗi lần nhận push.
- Mô hình tốt nhất: Định tuyến cả hai loại callback (legacy và completion-handler) thông qua một helper dùng chung với cơ chế bảo vệ `defer`/gọi callback đơn lẻ.
- Tại lần đối chiếu 2026-05-26, code hiện tại chưa thể hiện helper dùng chung cho hai overload PushKit; overload có completion gọi `handleIncomingVoIPPush(payload:)` rồi gọi `completion()` trực tiếp.
- Tránh việc thoát hàm sớm (early returns) làm bỏ qua việc gọi completion handler.

## Luồng xử lý cuộc gọi đến khi ứng dụng bị tắt/sử dụng Wi-Fi (Killed-app / Wi-Fi incoming call route)

Sự cố quan sát được:

- Ứng dụng đã bị tắt đột ngột (killed app) khi kết nối Wi-Fi có thể nhận được bản tin REGISTER/INVITE nhưng dừng lại sau khi tạo nhật ký cuộc gọi (call log), trước khi định tuyến/hiển thị CallKit.
- Một rủi ro là việc gọi đồng bộ chặn luồng chính (`DispatchQueue.main.sync`) từ các luồng callback SIP cuộc gọi đến không phải luồng chính.

Hướng khắc phục:

- Không gọi lệnh chặn đồng bộ `DispatchQueue.main.sync` từ luồng callback SIP để xác định trạng thái foreground của ứng dụng.
- Sử dụng ảnh chụp nhanh (snapshot)/trạng thái foreground được lưu trong bộ nhớ đệm không gây chặn luồng.
- Gửi thông báo `.incomingCallNotification` một cách bất đồng bộ trên luồng chính để luồng callback SIP không phải đảm nhận công việc điều phối giao diện (UI routing).
- Giữ lại (retain) `PKPushRegistry`, đăng ký VoIP push trong quá trình khởi chạy ứng dụng, và định tuyến các callback PushKit thông qua helper dùng chung.
- `applicationDidBecomeActive` nên bỏ qua việc gọi `connect(true)` cho đến khi cấu hình SIP đã sẵn sàng.
- Sử dụng cơ chế dự phòng cửa sổ hiển thị (window fallback) từ cửa sổ chính (key window) sang cửa sổ phân cảnh hiển thị (visible scene window)/cửa sổ delegate để trình bày giao diện cuộc gọi.

## Liên kết IPv6 (IPv6 binding)

- Sự cố ứng dụng bị tắt khi dùng Wi-Fi trước đây có liên quan đến độ nhạy cảm của DNS/IPv6.
- Luồng kết nối/kiểm tra khả năng kết nối SIP nên ưu tiên sử dụng cấu hình `ACNetworkAddressFamily.unspecified` trừ khi nhiệm vụ hiện tại yêu cầu rõ ràng việc liên kết IPv4 hoặc IPv6 cụ thể.
- Tránh việc phân giải loại địa chỉ IP (IP-family resolution) đồng bộ trong luồng PushKit khi khởi động lạnh (cold-start).
