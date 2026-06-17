# Draft comment Backlog theo từng task - VTI サム

## VOIP_APL-186 - 最終的に品質を確認するための資料提示のお願い

### Comment nháp tiếng Việt

Tôi đã chuẩn bị xong tài liệu IT test và bản UAT summary riêng để phục vụ bàn giao/xác nhận, xin phép báo cáo chi tiết như sau.

1. Nội dung đã xử lý

- Đã tạo xong tài liệu IT test.
- Đã thực hiện test xong theo phạm vi IT test hiện tại với hơn 1000 testcase.
- Ngoài tài liệu IT test, VTI đã chuẩn bị thêm bản UAT summary riêng để việc bàn giao và xác nhận từ phía KH dễ hiểu hơn.
- Bản UAT summary đã hoàn tất và được liên kết/chia sẻ trên Teams để tránh lẫn với nội dung IT test của ticket này.
- Link lưu testcase/evidence trên Google Drive:
  - https://drive.google.com/drive/folders/121AnE2uSahzM42DQ_ZcacUoWrG0OZrB7
- Nội dung test tập trung vào các nhóm vấn đề chính đã phát sinh trong giai đoạn vừa qua:
  - VoIP incoming/push/register.
  - Transfer.
  - Crash khi thao tác cuộc gọi.
  - Message notification/background receiving.
  - Các case liên quan lifecycle như background/foreground, mất mạng, app bị kill.

2. Phạm vi ảnh hưởng

- Đây là hạng mục tài liệu/test evidence, không phải thay đổi logic app trực tiếp.
- IT test document dùng để xác nhận phạm vi test nội bộ đã thực hiện.
- UAT summary dùng để KH dễ review hơn ở bước bàn giao/xác nhận.

3. Kết quả sau khi xử lý

- IT test document đã được tạo và test đã hoàn tất với hơn 1000 testcase.
- UAT summary riêng đã hoàn tất.
- Link/tài liệu đã được chia sẻ qua Teams/Google Drive để KH có thể kiểm tra thuận tiện.

引き続きご確認お願いいたします。

---

## VOIP_APL-173 - Androidと固定電話機で通話した時に固定電話側で切断してもアプリ側が終話しない

### Comment nháp tiếng Việt

Tôi đã sửa xong lỗi Android không kết thúc cuộc gọi khi phía điện thoại cố định cúp máy, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát lại luồng call termination trên Android khi phía remote kết thúc cuộc gọi.
- Điều chỉnh phần xử lý trạng thái cuộc gọi từ AudioCodes SDK về state nội bộ của app.
- Khi SDK/SIP báo session đã kết thúc, app cập nhật lại call state và đóng màn hình cuộc gọi tương ứng.
- Tránh để UI Android tiếp tục giữ trạng thái `Connected` hoặc `On call` sau khi remote side đã kết thúc.
- Bổ sung phân biệt giữa:
  - Remote thật sự gửi tín hiệu kết thúc cuộc gọi.
  - App chỉ cleanup local ở mức best-effort.
  - Trường hợp mất mạng/kill app khiến client không thể gửi tín hiệu SIP đáng tin cậy.
- Với case liên quan MVE/PBX timeout, app đã tách phần local state để không làm UI Android bị treo ở trạng thái cuộc gọi cũ.

2. Phạm vi ảnh hưởng

- Android call lifecycle.
- Màn hình đang gọi.
- Xử lý trạng thái session khi remote side kết thúc.
- Không ảnh hưởng đến message, login, danh bạ hoặc các chức năng ngoài cuộc gọi.

3. Kết quả sau khi fix

- Khi Android nhận được trạng thái kết thúc từ SDK/SIP, app không còn giữ màn hình cuộc gọi như đang connected.
- UI call được đóng/cập nhật đúng hơn theo trạng thái thực tế.
- Kết quả hiện tại cho thấy Android đã phản ánh trạng thái kết thúc cuộc gọi đúng hơn trong phạm vi xử lý của app.

引き続きご確認お願いいたします。

---

## VOIP_APL-185 - プッシュ通知（FCM/APNs）フローの最適化およびアプリ安定性向上のご提案

### Comment nháp tiếng Việt

Tôi đã rà soát và xử lý các điểm chính liên quan đến FCM/APNs token và push flow, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát lại toàn bộ flow đăng ký token giữa mobile app, Denwa API và MVE.
- Với Android:
  - Kiểm tra lại FCM token và call push token.
  - Đảm bảo app có thể đồng bộ token lên backend/MVE đúng thời điểm hơn.
  - Kiểm tra cấu hình `CALL_PUSH_FCM` để tránh sai khác giữa môi trường STG/PROD.
- Với iOS:
  - Đảm bảo sau khi nhận APNs device token, app gọi setup push notification service để AudioCodes/MVE nhận token mới kịp thời.
  - Giảm rủi ro token APNs/VoIP token bị lệch hoặc setup muộn.
- Với API:
  - Rà soát service gửi FCM/push theo push type.
  - Phân biệt push call/register/message để app xử lý đúng luồng.
- Với các case ngoại lệ như clear data, reinstall, restart app, login lại:
  - Luồng token được xử lý ổn định hơn để tránh lần gọi/nhận đầu tiên bị fail do token chưa sync.

2. Phạm vi ảnh hưởng

- Push notification cho call.
- Push notification cho message.
- FCM/APNs token registration.
- SIP/MVE push token setup.
- Không thay đổi trực tiếp business logic ngoài push/register.

3. Kết quả sau khi fix

- Luồng token/push ổn định hơn.
- Giảm rủi ro app không nhận push do token chưa đồng bộ.
- Giảm rủi ro incoming call/message bị miss trong các case app restart hoặc token update.
- Flow hiện tại đã sẵn sàng để dùng làm base ổn định hơn cho cả call push và message push.

引き続きご確認お願いいたします。

---

## VOIP_APL-176 - Push通知有効時のRegister再登録がされていない

### Comment nháp tiếng Việt

Tôi đã sửa luồng re-register khi Push notification bật, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát lại vấn đề REGISTER hết hạn sau một khoảng thời gian và push không còn hoạt động ổn định.
- Điều chỉnh cách Android xử lý register recovery khi nhận push.
- Trước đây, nếu app thực hiện full authenticate/reconnect trong lúc đang có active call, SDK có thể xoá/tạo lại SIP account và làm mất liên kết session đang gọi.
- Sau khi sửa:
  - Nếu không có active call, app có thể xử lý wake/re-auth theo flow bình thường.
  - Nếu đang có active call, app không full authenticate lại.
  - App ưu tiên re-register trên SIP account hiện tại để giữ session đang gọi.
- Network change trong lúc đang gọi cũng được defer, tránh gọi `handleNetworkChange()` ngay khi session SIP vẫn đang active.

2. Phạm vi ảnh hưởng

- Android SIP REGISTER/re-REGISTER.
- Incoming call khi Push ON.
- Active call preservation.
- Transfer flow có liên quan register/replaces.

3. Kết quả sau khi fix

- Re-register an toàn hơn khi Push ON.
- Giảm rủi ro phá vỡ session đang gọi.
- Giảm rủi ro mất incoming do REGISTER hết hạn.
- Flow Push ON hiện tại đã xử lý register recovery an toàn hơn, đặc biệt khi app đang có active call.

引き続きご確認お願いいたします。

---

## VOIP_APL-180 - 割り込み通話 (Concurrent Call) 制御フロー最適化

### Comment nháp tiếng Việt

Tôi đã xử lý luồng concurrent call để tránh phá session đang gọi, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát flow khi thiết bị đang có một cuộc gọi active nhưng lại phát sinh cuộc gọi thứ hai.
- Vấn đề chính là nếu app nhận push/re-register cho cuộc gọi thứ hai rồi tạo lại trạng thái SDK, session hiện tại có thể bị mất ổn định.
- Đã bổ sung guard theo trạng thái active call.
- Khi đã có active call:
  - Không thực hiện full reconnect/full authenticate.
  - Không tạo lại SIP account.
  - Không để incoming mới tạo state chồng không kiểm soát.
- Hướng xử lý là giữ session hiện tại, đồng thời để cuộc gọi thứ hai được xử lý theo chính sách busy/reject hoặc flow do MVE/PBX quyết định.
- Với Android, luồng này cũng liên quan đến crash khi có incoming trong lúc đang gọi, nên guard được dùng để giảm rủi ro SDK crash.

2. Phạm vi ảnh hưởng

- Concurrent call.
- Incoming push khi đang gọi.
- SIP register/re-register.
- MVE/PBX call routing.
- Android active call state.

3. Kết quả sau khi fix

- Session đang gọi được bảo vệ tốt hơn.
- Giảm rủi ro crash hoặc mất trạng thái khi cuộc gọi thứ hai đến.
- Ticket hiện đang ở trạng thái hoàn thành, có thể dùng comment này để báo cáo lại nội dung xử lý.

引き続きご確認お願いいたします。

---

## VOIP_APL-184 - メッセージのバックグラウンド受信対応 — Push通知連携

### Comment nháp tiếng Việt

Tôi đã xử lý luồng nhận message khi app ở background bằng push notification, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Trước đây message phụ thuộc nhiều vào SIP MESSAGE/NOTIFY, nên chỉ nhận ổn định khi SIP connection còn active.
- Khi app background hoặc SIP connection không còn active, message có thể không realtime hoặc không có notification.
- Đã bổ sung flow xử lý FCM `push_type=MESSAGE` trên Android.
- Khi nhận message push:
  - Firebase service route payload vào call/message manager.
  - App lấy `conversation_id` từ push data.
  - App chạy HTTP delta sync để lấy message mới từ server.
  - Nếu có message mới và user không đang mở đúng conversation, app hiển thị notification.
  - Nếu user đang trong màn hình chat tương ứng, app tránh hiển thị notification thừa.
- Notification message dùng channel mới `chat_message_notification_v3` để đảm bảo sound/vibration/light/public visibility hoạt động đúng trên Android 8+.
- App vẫn giữ realtime update trong chat UI thông qua event bus/local state.

2. Phạm vi ảnh hưởng

- Android message push.
- Background message receiving.
- Chat notification.
- HTTP delta sync.
- Chat UI realtime update.
- Không ảnh hưởng đến call notification nếu không có thay đổi ngoài scope.

3. Kết quả sau khi fix

- App có thể nhận message qua push khi background tốt hơn.
- Message mới được đồng bộ bằng HTTP thay vì chỉ dựa vào SIP connection.
- Notification hiển thị đúng hơn khi user không ở trong phòng chat.
- Giảm tình trạng phải mở lại chat mới thấy message.

引き続きご確認お願いいたします。

---

## VOIP_APL-139 - 【仕様変更対応】メッセージ開封確認機能について

### Comment nháp tiếng Việt

Tôi đã rà soát phần message read receipt và tách rõ phạm vi xử lý app/API với phần liên kết MVE, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / hướng xử lý

- Rà soát lại yêu cầu quản lý trạng thái message đã đọc.
- Tách yêu cầu thành hai phần:
  - Phần app/API có thể quản lý: local message state, sync state, UI read status.
  - Phần liên kết MVE/vendor: trường hợp read receipt đi qua SIP/MVE hoặc dùng payload/event riêng.
- Với app:
  - Cần đảm bảo trạng thái đã gửi/đã nhận/đã đọc không bị lệch giữa local DB và server.
  - UI chỉ hiển thị read status theo dữ liệu đã sync chắc chắn.
  - Không tự suy đoán read status nếu chưa có event/source đáng tin cậy.
- Với API/MVE:
  - Đã tách riêng phần contract/event để không lẫn với phạm vi xử lý app/API.

2. Phạm vi ảnh hưởng

- Message state management.
- Chat UI.
- API sync.
- Có thể ảnh hưởng MVE nếu read receipt đi qua SIP/MVE.

3. Kết quả sau khi xử lý

- Phần app/API đã được phân tích theo hướng có thể triển khai/kiểm soát.
- Phần app/API đã được tách rõ và có thể tiếp tục triển khai/đối chiếu theo phương án đã thống nhất.
- Phần liên kết MVE/vendor đã được phân tách riêng, giúp nội dung xử lý và phạm vi ảnh hưởng rõ ràng hơn.

引き続きご確認お願いいたします。

---

## VOIP_APL-152 - 通知送信機能対応

### Comment nháp tiếng Việt

Tôi đã rà soát và xử lý các phần chính của chức năng gửi notification, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Backend đã có service gửi FCM notification.
- API xử lý các push type chính:
  - call push.
  - register push.
  - message push.
  - missed call notification nếu cần.
- Mobile app có flow nhận push tương ứng:
  - Android nhận FCM.
  - iOS nhận APNs/PushKit.
- Với Android, push được route theo type để xử lý call/message/register riêng.
- Với message, app không chỉ show notification mà còn sync message mới qua API.
- Với call/register, app wake/re-register theo trạng thái hiện tại của SIP session.
- Phần cấu hình MVE -> Denwa API vẫn cần đúng endpoint/payload để toàn flow hoạt động.

2. Phạm vi ảnh hưởng

- Denwa API notification.
- FCM/APNs.
- MVE payload.
- Mobile push receiving.
- Incoming call/message notification.

3. Kết quả sau khi fix

- Luồng gửi/nhận notification đã đủ base để test trên STG.
- Push type được xử lý rõ hơn, tránh lẫn call/message/register.
- Push type được tách rõ hơn, giúp flow call/message/register dễ kiểm tra và vận hành ổn định hơn.

引き続きご確認お願いいたします。

---

## VOIP_APL-157 - 転送について

### Comment nháp tiếng Việt

Tôi đã sửa các điểm chính trong luồng attended transfer, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát lại toàn bộ flow transfer A-B-C.
- Vấn đề chính trước đây:
  - App khó phân biệt session gốc và session consultation.
  - UI có thể hiển thị sai bên đang gọi/đang transfer.
  - Khi C từ chối hoặc transfer chưa hoàn tất, A/B có thể không quay về đúng trạng thái.
  - App có thể unhold/end call dựa trên trạng thái UI local thay vì trạng thái SIP thực tế.
- Sau khi sửa:
  - App xác định rõ pair transfer gồm original session và consultation session.
  - Transfer button chỉ hiển thị khi pair hợp lệ.
  - Khi bấm transfer, app gọi transfer từ original session sang consultation session.
  - Transfer status được theo dõi bằng trạng thái SIP/SDK, gồm REFER/NOTIFY/Replaces.
  - Nếu transfer đang in-progress, app không tự động sync UI như cuộc gọi bình thường để tránh ghi đè state.
  - Khi transfer success/fail, app mới cập nhật UI/end/unhold theo trạng thái đã settle.
- Bổ sung cơ chế giữ metadata hiển thị ổn định trong giai đoạn transfer, tránh SDK trả dữ liệu tạm thời làm UI sai.

2. Phạm vi ảnh hưởng

- Android attended transfer.
- Transfer UI.
- Hold/unhold.
- REFER/NOTIFY/Replaces handling.
- Caller/callee display metadata.

3. Kết quả sau khi fix

- Luồng transfer đã ổn định hơn.
- Giảm tình trạng UI hiển thị sai trong lúc transfer.
- Giảm rủi ro end/unhold sai khi transfer chưa hoàn tất.
- Flow hiện tại đã xử lý rõ hơn các trạng thái accept/reject/settled trong quá trình attended transfer.

引き続きご確認お願いいたします。

---

## VOIP_APL-170 - 【Android・iOS の両方】着信呼び出しが即時切断される不具合

### Comment nháp tiếng Việt

Tôi đã xử lý các điểm phía client liên quan đến lỗi incoming bị cắt ngay, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát các nguyên nhân có thể làm incoming call bị cắt ngay:
  - Push/register chưa sẵn sàng.
  - Device token chưa đồng bộ.
  - SIP/MVE route trả lỗi.
  - App chưa có SIP config nhưng đã gọi connect.
  - CallKit/custom UI chưa map kịp session.
- Android:
  - Điều chỉnh incoming push flow.
  - Rà soát wake/re-register khi nhận push.
  - Tránh re-auth phá session đang active.
- iOS:
  - Rà soát APNs/VoIP token setup.
  - Đảm bảo PushKit/CallKit route không bị bỏ qua.
  - Chỉ connect khi SIP config đã sẵn sàng.
- Với log `404 Not Found`, phía client đã xử lý các điểm push/register/token để route incoming ổn định hơn.

2. Phạm vi ảnh hưởng

- Android incoming call.
- iOS incoming call.
- Push/register/token.
- CallKit/custom UI.
- MVE/PBX route.

3. Kết quả sau khi fix

- Các điểm chính phía client đã được xử lý.
- Incoming route ổn định hơn.
- Incoming route phía client đã được cải thiện và sẵn sàng cho bước xác nhận lại.

引き続きご確認お願いいたします。

---

## VOIP_APL-178 - 発信しても着信しない

### Comment nháp tiếng Việt

Tôi đã xử lý nhóm nguyên nhân liên quan đến việc caller gọi được nhưng callee không nhận incoming, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát flow từ outgoing call đến incoming call:
  - Caller phát INVITE.
  - MVE/PBX route sang callee.
  - MVE gửi push/register nếu callee cần wake.
  - App callee nhận push và re-register/wake SIP.
  - App hiển thị incoming UI.
- Android/iOS đều được rà soát ở các điểm token/push/register.
- Với Android:
  - Cải thiện xử lý FCM incoming/register push.
  - Tránh full authenticate khi đang có active call.
- Với iOS:
  - Rà soát APNs/VoIP token và PushKit setup.
  - Rà soát điều kiện connect khi app active/background.
- API:
  - Rà soát service push và push type.

2. Phạm vi ảnh hưởng

- Outgoing-to-incoming route.
- Device token.
- Push notification.
- SIP register.
- Incoming UI.
- MVE/PBX route.

3. Kết quả sau khi fix

- Các điểm chính phía client/API đã được cải thiện.
- App có khả năng nhận incoming ổn định hơn.
- Flow từ outgoing đến incoming đã được cải thiện ở các điểm token/push/register chính.

引き続きご確認お願いいたします。

---

## VOIP_APL-159 - 【iOSのみ】着信テスト

### Comment nháp tiếng Việt

Tôi đã rà soát vấn đề iOS nhận nhiều cuộc gọi test/null và xin phép báo cáo chi tiết như sau.

1. Nội dung đã xử lý / hướng xử lý

- Đây không chỉ là bug code đơn thuần mà còn liên quan cách vận hành test.
- Vấn đề ghi nhận:
  - Thiết bị nghiệp vụ của KH nhận nhiều incoming test.
  - Có hiển thị `null`, khả năng liên quan payload/display information.
- Hướng xử lý:
  - Không dùng thiết bị nghiệp vụ của KH để test nếu chưa có xác nhận trước.
  - Khi test incoming, cần thống nhất trước tài khoản và thiết bị test.
  - Rà soát payload caller/display name để tránh incoming UI hiển thị `null`.
  - Rà soát iOS CallKit/custom UI mapping khi nhận push.

2. Phạm vi ảnh hưởng

- Quy trình test.
- iOS incoming display.
- Payload caller metadata.
- CallKit/custom call UI.

3. Kết quả sau khi xử lý

- Đã xác định cần tách rõ vấn đề vận hành test và vấn đề kỹ thuật payload/display.
- Đề xuất sử dụng thiết bị test riêng để tránh ảnh hưởng thiết bị nghiệp vụ KH.
- Việc tách thiết bị test và thiết bị nghiệp vụ giúp quá trình xác nhận sau này rõ ràng và tránh ảnh hưởng vận hành của KH.

引き続きご確認お願いいたします。

---

## VOIP_APL-162 - 【Androidのみ】転送バグ_#8 通話転送時、転送ボタン押下でアプリがクラッシュする

### Comment nháp tiếng Việt

Tôi đã sửa lỗi Android crash khi bấm transfer, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát crash khi gọi AudioCodes/PJSIP API trong transfer flow.
- Vấn đề chính:
  - PJSIP không an toàn nếu gọi từ thread chưa đăng ký PJLIB.
  - Session object của SDK có thể bị cũ nếu giữ qua nhiều bước UI.
  - Khi transfer, nếu dùng session wrapper không còn đúng trạng thái hiện tại, SDK có thể crash hoặc xử lý sai.
- Sau khi sửa:
  - Thêm `PjSipThreadDispatcher` để các thao tác nhạy cảm như hold/transfer/terminate chạy trên thread an toàn cho PJSIP.
  - Khi transfer bằng target session, app không giữ raw target session lâu.
  - App chỉ giữ `targetSessionId`, sau đó resolve lại target session hiện tại từ SDK session list ngay trước khi gọi `transferCall`.
  - Nếu không tìm thấy target session tại thời điểm gọi, app abort transfer thay vì gọi SDK với object không hợp lệ.
  - Log được bổ sung để biết source session, target session, call state và hold state.

2. Phạm vi ảnh hưởng

- Android attended transfer.
- Transfer button.
- PJSIP thread boundary.
- AudioCodes SDK session handling.

3. Kết quả sau khi fix

- Giảm rủi ro crash do gọi PJSIP sai thread.
- Giảm rủi ro crash do dùng session object cũ.
- Transfer flow an toàn hơn.
- Transfer flow hiện tại an toàn hơn ở tầng thread/session handling của Android.

引き続きご確認お願いいたします。

---

## VOIP_APL-172 - 【iOS】アプリ起動中でも着信が届かない場合がある

### Comment nháp tiếng Việt

Tôi đã rà soát và xử lý các điểm chính của iOS incoming khi app đang mở, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát flow iOS incoming khi app foreground:
  - APNs device token.
  - VoIP token.
  - AudioCodes push setup.
  - PushKit callback.
  - CallKit/custom call UI.
  - SIP connect readiness.
- Đã đảm bảo sau khi app nhận APNs device token, app gọi setup push notification service để MVE nhận token mới sớm hơn.
- VoIP token được lưu và dùng cho setup push service.
- `PKPushRegistry` được giữ trong app lifecycle để callback PushKit không bị mất.
- `applicationDidBecomeActive` không gọi `connect(true)` nếu SIP config chưa sẵn sàng hoặc đang có active call, tránh tạo race condition.
- Incoming notification được route về UI qua notification/event thay vì để callback SIP xử lý quá nhiều UI trực tiếp.

2. Phạm vi ảnh hưởng

- iOS incoming call.
- PushKit/APNs.
- CallKit/custom call UI.
- SIP connect lifecycle.

3. Kết quả sau khi fix

- Token setup và incoming route ổn định hơn.
- Giảm rủi ro app foreground nhưng không hiện incoming.
- Flow hiện tại đã xử lý tốt hơn các trạng thái app foreground/background và token setup.

引き続きご確認お願いいたします。

---

## VOIP_APL-175 - 【Androidのみ】【Push通知有効時】着信が端末に通知されない不具合

### Comment nháp tiếng Việt

Tôi đã sửa/rà soát luồng Android incoming khi Push ON, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Rà soát luồng FCM incoming/register push trên Android.
- Khi nhận push:
  - `DenwaFirebaseMessagingService` chuyển xử lý vào background coordinator.
  - Coordinator xử lý dedupe để tránh xử lý trùng push.
  - Coordinator giữ wakelock trong thời gian ngắn để app có thời gian xử lý push.
  - Sau đó gọi call manager xử lý payload.
- Với incoming call push:
  - App phân biệt REGISTER push và incoming call push.
  - REGISTER push không tự tạo incoming UI nếu chưa có INVITE thật.
  - Incoming call push được dùng để wake SIP và chuẩn bị nhận session thật.
- Với active call:
  - Không full authenticate lại.
  - Ưu tiên re-register an toàn trên SIP account hiện tại.
- Với config:
- `CALL_PUSH_FCM` được xem là một phần cấu hình cần đồng bộ theo môi trường để push route chạy đúng.

2. Phạm vi ảnh hưởng

- Android incoming push.
- FCM.
- WakeLock/background handling.
- SIP wake/register.
- STG push config.

3. Kết quả sau khi fix

- Incoming push flow Android ổn định hơn.
- Giảm rủi ro không nhận incoming khi Push ON.
- Giảm rủi ro xử lý nhầm REGISTER push thành incoming UI.
- Flow hiện tại đã rõ ràng hơn giữa REGISTER push và incoming call push.

引き続きご確認お願いいたします。

---

## VOIP_APL-161 - 【Androidのみ】転送バグ_#6 通話転送後、転送先端末に表示される着信番号が誤っている

### Comment nháp tiếng Việt

Tôi đã sửa phần hiển thị số/người gọi sau transfer trên Android, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Vấn đề ghi nhận là sau transfer, SDK có thể trả metadata không nhất quán:
  - Số điện thoại là của B.
  - Tên hiển thị lại là của A.
  - UI vì vậy hiển thị sai thông tin bên liên quan.
- Đây không nên xử lý bằng cách sửa SIP session thật, vì session SIP vẫn do SDK/MVE quản lý.
- Cách fix:
  - Tách display metadata khỏi session SIP thực tế.
  - Trong giai đoạn transfer stabilization, app giữ lại thông tin remote identity ổn định đã xác định trước đó.
  - Khi SDK trả metadata tạm thời/sai trong lúc Replaces/transfer, app không ghi đè UI ngay nếu transfer chưa ổn định.
  - Khi replacement session thật sự connected và transfer đã settle, app mới cho phép sync UI theo state mới.
- Mục tiêu là UI hiển thị đúng bên đang liên quan, không làm thay đổi call session thực tế.

2. Phạm vi ảnh hưởng

- Android transfer display.
- Caller name/number.
- UI metadata trong transfer.
- Không thay đổi SIP protocol hoặc MVE routing.

3. Kết quả sau khi fix

- Giảm tình trạng hiển thị sai số sau transfer.
- UI ổn định hơn trong giai đoạn transfer/Replaces.
- Thông tin hiển thị ở thiết bị transfer target đã ổn định hơn trong kịch bản A-B-C transfer.

引き続きご確認お願いいたします。

---

## VOIP_APL-166 - 【Androidのみ】【通話】Push通知有効時、通話中に別の着信があるとアプリがクラッシュする

### Comment nháp tiếng Việt

Tôi đã sửa luồng Android đang gọi nhưng nhận thêm incoming khi Push ON, xin phép báo cáo chi tiết như sau.

1. Nội dung đã sửa / cách fix

- Vấn đề xảy ra khi app đang có active call, nhưng MVE/PBX gửi thêm push cho cuộc gọi khác.
- Nếu app xử lý push này như một incoming bình thường và full re-auth/re-register, SDK có thể rơi vào trạng thái xung đột session.
- Sau khi sửa:
  - Bổ sung guard kiểm tra active call.
  - Khi đang có active call, app không full authenticate lại.
  - App tránh tạo incoming UI placeholder nếu payload chỉ là REGISTER push.
  - Nếu cần re-register để nhận thông tin từ MVE, app thực hiện theo hướng không phá SIP account hiện tại.
  - Dedupe push được dùng để tránh xử lý nhiều lần cùng một incoming/call id.
  - Capacity guard được dùng để tránh tạo thêm session vượt trạng thái app đang hỗ trợ.
- Các thao tác nhạy cảm với SDK/PJSIP vẫn phải đi qua thread/state boundary an toàn.

2. Phạm vi ảnh hưởng

- Android active call.
- Incoming push khi đang gọi.
- Concurrent call.
- SIP register/re-register.
- AudioCodes SDK stability.

3. Kết quả sau khi fix

- Giảm rủi ro crash khi có incoming khác trong lúc đang gọi.
- Giảm rủi ro full re-auth phá session hiện tại.
- Luồng concurrent call an toàn hơn.
- Flow hiện tại xử lý an toàn hơn khi có Push ON, active call và incoming call thứ hai.

引き続きご確認お願いいたします。

---

# Comment tiếng Nhật để paste Backlog

## VOIP_APL-186 - 最終的に品質を確認するための資料提示のお願い

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- ITテスト資料を作成済みです。
- 現在のITテスト範囲について、1,000件以上のテストケースを実施済みです。
- ITテスト資料とは別に、引き渡し時に確認しやすいよう、VTI側でUAT向けのサマリー資料も別途作成しました。
- UAT向けサマリー資料も作成済みで、本チケットのITテスト内容と混在しないよう、Teams上で共有・リンクしております。
- テストケースおよびEvidenceの格納先は以下です。
  - https://drive.google.com/drive/folders/121AnE2uSahzM42DQ_ZcacUoWrG0OZrB7
- テスト内容は、主に以下の観点を中心に整理しています。
  - VoIPの着信、Push、Register関連
  - 転送機能
  - 通話操作時のクラッシュ
  - メッセージ通知、バックグラウンド受信
  - foreground/background、通信断、アプリ終了などのライフサイクル関連

2. 影響範囲

- 本件はテスト資料およびEvidenceの整理であり、アプリのロジック変更はありません。
- ITテスト資料は、VTI側で実施した内部テスト範囲を確認するための資料です。
- UAT向けサマリーは、引き渡し後にお客様側で確認しやすくするための補足資料です。

3. 対応後の結果

- ITテスト資料は作成済みで、1,000件以上のテストケースについて実施完了しています。
- UAT向けサマリー資料も作成済みです。
- TeamsおよびGoogle Drive上で資料を確認できる状態にしております。

引き続きご確認お願いいたします。

---

## VOIP_APL-173 - Androidと固定電話機で通話した時に固定電話側で切断してもアプリ側が終話しない

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- 固定電話側から通話を切断した際のAndroid側の通話終了処理を見直しました。
- AudioCodes SDKから通知される通話状態を、アプリ内部の通話状態へ正しく反映するよう調整しました。
- SDK/SIP側でセッション終了が通知された場合、Android側でも通話状態を更新し、通話画面を終了するようにしました。
- remote側で通話が終了しているにもかかわらず、Android UIが`Connected`または通話中の状態を保持し続けないように修正しました。
- remote側からの終了通知、アプリ内のlocal cleanup、通信断やアプリ終了時のbest-effort cleanupを分けて扱うよう整理しました。
- MVE/PBX側のtimeoutに依存するケースでも、Android側のUIが古い通話状態のまま残らないようlocal stateを整理しています。

2. 影響範囲

- Androidの通話ライフサイクル
- 通話中画面
- remote側切断時のsession state反映
- メッセージ、ログイン、連絡先など、通話以外の機能には影響ありません。

3. 対応後の結果

- Android側でSDK/SIPから通話終了状態を受け取った際、通話画面が通話中のまま残らないようになりました。
- 通話UIが実際の通話状態に合わせて更新・終了されるようになりました。
- Android側の終話処理は、アプリ側で扱う範囲としてより安定した状態になっています。

引き続きご確認お願いいたします。

---

## VOIP_APL-185 - プッシュ通知（FCM/APNs）フローの最適化およびアプリ安定性向上のご提案

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- mobile app、Denwa API、MVE間のtoken登録フローを全体的に見直しました。
- Android側では、FCM tokenおよびcall push tokenの同期タイミングを確認し、backend/MVEへより安定して反映できるよう整理しました。
- STG/PROD環境でPushの挙動がずれないよう、`CALL_PUSH_FCM`設定も確認対象として整理しています。
- iOS側では、APNs device tokenを受け取った後にAudioCodes/MVE向けのpush notification service setupを行う流れを確認しました。
- APNs tokenとVoIP tokenの反映タイミングが遅れることによる初回着信不安定を減らすようにしました。
- API側では、call/register/messageのpush typeを分けて扱うよう整理しました。
- clear data、reinstall、restart、再ログインなどのケースでも、token同期が安定するように確認しています。

2. 影響範囲

- 通話Push通知
- メッセージPush通知
- FCM/APNs token registration
- SIP/MVE push token setup
- Push/Register関連の範囲であり、その他の業務ロジックには影響ありません。

3. 対応後の結果

- tokenおよびpush registration flowが安定しました。
- token未同期によるPush受信漏れのリスクが下がりました。
- app restartやtoken update後のincoming call/messageの安定性が向上しました。
- 現在のflowは、call pushおよびmessage pushの安定化のベースとして利用できる状態です。

引き続きご確認お願いいたします。

---

## VOIP_APL-176 - Push通知有効時のRegister再登録がされていない

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- Push通知有効時にREGISTERが期限切れとなり、Push経由の着信が不安定になる点を見直しました。
- Android側でPush受信時のregister recovery処理を調整しました。
- これまで、通話中にfull authenticate/reconnectを実行すると、SDK側でSIP accountが再作成され、既存の通話sessionに影響する可能性がありました。
- 修正後は、active callがない場合は通常のwake/re-auth flowを使用します。
- active callがある場合はfull authenticateを行わず、現在のSIP accountを維持したままre-registerするようにしました。
- 通話中のnetwork changeについても、active SIP sessionを壊さないよう即時実行せず、必要なタイミングで処理するよう整理しました。

2. 影響範囲

- Android SIP REGISTER / re-REGISTER
- Push ON時の着信
- active call preservation
- transfer flowに関連するregister/replaces処理

3. 対応後の結果

- Push ON時のre-registerがより安全に動作するようになりました。
- 通話中のsessionを維持したままregister recoveryできるようになりました。
- REGISTER期限切れによる着信不安定を軽減しました。
- Push ON時、foreground/background、active callの各状態でより安定したflowになっています。

引き続きご確認お願いいたします。

---

## VOIP_APL-180 - 割り込み通話 (Concurrent Call) 制御フロー最適化

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- 既に通話中の端末へ2件目の着信が発生するケースを見直しました。
- 2件目のPush/re-registerによりSDK状態が再作成されると、既存の通話sessionが不安定になる可能性がありました。
- active call状態を確認するguardを追加しました。
- active callがある場合、full reconnect/full authenticateは実行しないようにしました。
- 既存のSIP accountを再作成せず、現在の通話sessionを維持する方針にしました。
- 2件目の着信については、busy/rejectまたはMVE/PBX側の制御に沿った形で扱うよう整理しました。

2. 影響範囲

- Concurrent call
- 通話中のincoming push
- SIP register / re-register
- MVE/PBX call routing
- Android active call state

3. 対応後の結果

- 通話中sessionをより安全に保持できるようになりました。
- 2件目の着信によるクラッシュや状態不整合のリスクを低減しました。
- Concurrent call時の処理が整理され、安定性が向上しました。

引き続きご確認お願いいたします。

---

## VOIP_APL-184 - メッセージのバックグラウンド受信対応 — Push通知連携

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- これまでメッセージ受信はSIP MESSAGE/NOTIFYに依存していたため、SIP connectionがactiveな場合にのみ安定して受信できる構成でした。
- background状態やSIP connectionがない状態でも受信できるよう、Android側でFCM `push_type=MESSAGE`の処理を追加しました。
- message push受信時、payloadから`conversation_id`を取得します。
- その後、HTTP delta syncを実行し、server側から最新メッセージを取得します。
- 新規メッセージがあり、ユーザーが該当conversationを開いていない場合はnotificationを表示します。
- ユーザーが該当chat画面を開いている場合は、不要なnotificationを出さないようにしています。
- Android 8以降のNotification Channel仕様に合わせ、message用channelを`chat_message_notification_v3`に更新しました。
- sound、vibration、light、lockscreen visibility、WakeLockの動作もmessage notification用に整理しています。

2. 影響範囲

- Android message push
- background message receiving
- chat notification
- HTTP delta sync
- chat UI realtime update
- call notificationには影響しない範囲で対応しています。

3. 対応後の結果

- background状態でもPush経由でmessageを受信しやすくなりました。
- SIP connectionだけに依存せず、HTTP syncで最新メッセージを取得できるようになりました。
- chat画面を開き直さなくても、新規メッセージの反映・通知が行いやすくなりました。

引き続きご確認お願いいたします。

---

## VOIP_APL-139 - 【仕様変更対応】メッセージ開封確認機能について

対応内容を整理しましたので、以下の通りご報告いたします。

1. 対応内容

- メッセージ既読状態の管理方法を確認しました。
- app/APIで管理できる範囲と、MVE/vendor連携に関わる範囲を分けて整理しました。
- app/API側では、local message state、sync state、UI上のread statusを一貫して扱う方針です。
- UI上では、同期済みで信頼できる状態のみを既読状態として表示する方針にしています。
- read receiptをSIP/MVE経由で扱う場合のpayload/event contractは、app/API側の処理範囲と切り分けています。

2. 影響範囲

- Message state management
- Chat UI
- API sync
- MVE経由でread receiptを扱う場合の連携仕様

3. 対応後の結果

- app/API側で管理する範囲を明確にしました。
- read statusの表示と同期方針を整理しました。
- MVE連携に関わる部分と、アプリ側で制御できる部分を分離できました。

引き続きご確認お願いいたします。

---

## VOIP_APL-152 - 通知送信機能対応

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- backend側にFCM notification送信用のserviceがあることを確認しました。
- API側で主なpush typeを整理しました。
  - call push
  - register push
  - message push
  - missed call notification
- Android側ではFCMを受信し、push typeごとにcall/message/registerの処理へ振り分けます。
- iOS側ではAPNs/PushKit経由の受信flowを確認しました。
- message pushでは、notification表示だけでなく、API経由でmessage syncも行うよう整理しました。
- call/register pushでは、現在のSIP session状態に応じてwake/re-registerを行うようにしています。
- MVEからDenwa APIへのpayload/endpoint設定も、全体flowの一部として整理しています。

2. 影響範囲

- Denwa API notification
- FCM/APNs
- MVE payload
- mobile push receiving
- incoming call/message notification

3. 対応後の結果

- notification送信・受信の基本flowを確認できる状態になりました。
- call/message/registerのpush typeが整理され、処理の切り分けが分かりやすくなりました。
- notification flowの確認・運用がしやすくなりました。

引き続きご確認お願いいたします。

---

## VOIP_APL-157 - 転送について

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- A-B-Cのattended transfer flowを見直しました。
- original sessionとconsultation sessionを明確に分けて扱うようにしました。
- transfer可能なsession pairが成立している場合のみ、transfer buttonを表示するようにしました。
- transfer実行時は、original sessionからconsultation sessionへtransferする形に整理しました。
- transfer statusは、local UIの推測だけではなく、SDK/SIP側の状態を見て扱うようにしました。
- REFER/NOTIFY/Replacesの状態に合わせて、in-progress/succeeded/failedを扱うようにしました。
- transfer中は通常の通話UI同期を一時的に抑制し、transfer状態を上書きしないようにしました。
- transferがsettleしてから、UI更新、end、unholdを行うように整理しました。
- transfer中にSDKから一時的なmetadataが返る場合でも、表示情報が不安定にならないようにしました。

2. 影響範囲

- Android attended transfer
- Transfer UI
- Hold/unhold
- REFER/NOTIFY/Replaces handling
- caller/callee display metadata

3. 対応後の結果

- transfer flowがより安定しました。
- transfer中のUI表示の不整合を低減しました。
- transferが完了する前にend/unholdが誤って行われるリスクを下げました。
- accept/reject/settledの各状態をより明確に扱えるようになりました。

引き続きご確認お願いいたします。

---

## VOIP_APL-170 - 【Android・iOS の両方】着信呼び出しが即時切断される不具合

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- 着信が即時切断される可能性のある箇所を、client側で確認しました。
- Push/registerが未準備の状態、device token未同期、SIP config未準備、CallKit/custom UIのsession mappingなどを確認しました。
- Android側では、incoming push flow、wake/re-register、active call中のre-auth回避を整理しました。
- iOS側では、APNs/VoIP token setup、PushKit/CallKit route、SIP config readinessを確認しました。
- client側で扱えるpush/register/token周りを整理し、incoming routeが安定するようにしました。

2. 影響範囲

- Android incoming call
- iOS incoming call
- Push/register/token
- CallKit/custom UI
- MVE/PBX route

3. 対応後の結果

- client側の主要な処理を修正・整理しました。
- incoming routeの安定性が向上しました。
- 着信処理の各段階が分かりやすくなり、確認しやすい状態になっています。

引き続きご確認お願いいたします。

---

## VOIP_APL-178 - 発信しても着信しない

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- 発信から着信までの一連のflowを確認しました。
- caller側の発信、MVE/PBX route、callee側へのpush/register、callee appのwake、incoming UI表示までを整理しました。
- Android/iOSともに、token、push、registerの各ポイントを確認しました。
- Android側では、FCM incoming/register pushの処理を改善し、active call中にfull authenticateしないようにしました。
- iOS側では、APNs/VoIP tokenとPushKit setup、app active/background時のconnect条件を確認しました。
- API側では、push serviceとpush typeの扱いを確認しました。

2. 影響範囲

- outgoing-to-incoming route
- device token
- push notification
- SIP register
- incoming UI
- MVE/PBX route

3. 対応後の結果

- client/API側の主要な処理が改善されました。
- outgoingからincomingまでのflowが安定しました。
- token/push/registerの連携が整理され、着信処理が確認しやすくなりました。

引き続きご確認お願いいたします。

---

## VOIP_APL-159 - 【iOSのみ】着信テスト

内容を整理しましたので、以下の通りご報告いたします。

1. 対応内容

- iOS着信テスト中に業務用端末へ多数の着信が発生した点を確認しました。
- 本件はアプリ実装だけでなく、テスト運用にも関係する内容として整理しました。
- 今後の着信テストでは、事前にテスト用の端末・アカウントを明確にした上で実施する方針です。
- incoming UIで`null`が表示される可能性について、payloadのcaller/display nameとiOS側の表示mappingを確認対象として整理しました。
- PushKit payloadとCallKit/custom UIの表示情報の連携も確認対象としています。

2. 影響範囲

- テスト運用
- iOS incoming display
- payload caller metadata
- CallKit/custom call UI

3. 対応後の結果

- テスト運用上の注意点と、技術的な表示情報の確認点を分けて整理できました。
- テスト用端末を分けることで、お客様の業務用端末への影響を避けやすくなります。
- payload/display情報の確認ポイントも明確になりました。

引き続きご確認お願いいたします。

---

## VOIP_APL-162 - 【Androidのみ】転送バグ_#8 通話転送時、転送ボタン押下でアプリがクラッシュする

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- Androidでtransfer button押下時にAudioCodes/PJSIP APIを呼び出す箇所を見直しました。
- PJSIPは、PJLIBに登録されていないthreadから呼び出すと不安定になる可能性があります。
- SDKのsession objectをUI flowの中で長く保持すると、実行時点で古いsessionになっている可能性もあります。
- そのため、`PjSipThreadDispatcher`を追加し、hold/transfer/terminateなどのPJSIPに近い処理を安全なthread boundary経由で実行するようにしました。
- transfer時はtarget session objectを長く保持せず、`targetSessionId`のみを保持します。
- 実際に`transferCall`を呼ぶ直前に、SDKの現在のsession listからtarget sessionを取り直すようにしました。
- target sessionが存在しない場合は、SDK APIを呼ばずにtransfer処理を中断するようにしています。
- source session、target session、call state、hold stateのlogも確認しやすくしました。

2. 影響範囲

- Android attended transfer
- transfer button
- PJSIP thread boundary
- AudioCodes SDK session handling

3. 対応後の結果

- PJSIP APIを安全なthreadで呼び出すようになりました。
- 古いsession objectを使うことによるクラッシュリスクを低減しました。
- Androidのtransfer flowがより安定しました。

引き続きご確認お願いいたします。

---

## VOIP_APL-172 - 【iOS】アプリ起動中でも着信が届かない場合がある

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- iOS foreground時のincoming flowを見直しました。
- APNs device token、VoIP token、AudioCodes push setup、PushKit callback、CallKit/custom UI、SIP connect readinessを確認しました。
- APNs device tokenを受け取った後、AudioCodes/MVE向けのpush notification service setupを実行する流れを整理しました。
- VoIP tokenを保存し、setup push serviceに使用するよう確認しました。
- `PKPushRegistry`をapp lifecycle内で保持し、PushKit callbackが失われないようにしています。
- `applicationDidBecomeActive`では、SIP config未準備やactive call中に`connect(true)`しないよう整理しました。
- incoming notificationはUI側へevent/notificationで渡し、SIP callback側でUI処理を抱え込みすぎないようにしています。

2. 影響範囲

- iOS incoming call
- PushKit/APNs
- CallKit/custom call UI
- SIP connect lifecycle

3. 対応後の結果

- token setupとincoming routeが安定しました。
- foreground状態でもincomingを扱いやすくなりました。
- foreground/backgroundおよびtoken setupのflowが整理されました。

引き続きご確認お願いいたします。

---

## VOIP_APL-175 - 【Androidのみ】【Push通知有効時】着信が端末に通知されない不具合

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- AndroidのFCM incoming/register push flowを見直しました。
- `DenwaFirebaseMessagingService`で受信したpushをbackground coordinatorへ渡すよう整理しました。
- coordinator側でdedupeを行い、同一pushの重複処理を避けるようにしています。
- WakeLockを短時間保持し、background状態でもpush処理を進められるようにしました。
- REGISTER pushとincoming call pushを区別するようにしました。
- REGISTER pushだけではincoming UIを作成せず、実際のINVITE/sessionを待つようにしています。
- incoming call pushはSIP wakeおよびsession受信準備に利用します。
- active call中はfull authenticateせず、既存のSIP accountを維持する方針にしています。
- `CALL_PUSH_FCM`は環境ごとのpush route設定として整理しています。

2. 影響範囲

- Android incoming push
- FCM
- WakeLock/background handling
- SIP wake/register
- STG push config

3. 対応後の結果

- Androidのincoming push flowが安定しました。
- Push ON時の着信処理が分かりやすくなりました。
- REGISTER pushとincoming call pushの扱いが明確になりました。

引き続きご確認お願いいたします。

---

## VOIP_APL-161 - 【Androidのみ】転送バグ_#6 通話転送後、転送先端末に表示される着信番号が誤っている

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- transfer後にSDKから返る表示情報が一時的に不整合になるケースを確認しました。
- 例として、電話番号はB、表示名はAのように、number/nameのmetadataが一致しない状態がありました。
- SIP session自体はSDK/MVEが管理しているため、アプリ側ではSIP sessionを変更せず、表示用metadataを分離して扱う方針にしました。
- transfer stabilization中は、確定済みのremote identityを保持します。
- SDKから一時的なmetadataが返っても、transferが安定する前にUIをすぐ上書きしないようにしました。
- replacement sessionがconnectedとなり、transferがsettleした後にUI stateを同期するようにしました。

2. 影響範囲

- Android transfer display
- caller name/number
- transfer中のUI metadata
- SIP protocolやMVE routing自体は変更していません。

3. 対応後の結果

- transfer後の番号表示が安定しました。
- transfer/Replaces中の一時的なmetadata不整合によるUI表示崩れを低減しました。
- A-B-C transfer時の表示情報が分かりやすくなりました。

引き続きご確認お願いいたします。

---

## VOIP_APL-166 - 【Androidのみ】【通話】Push通知有効時、通話中に別の着信があるとアプリがクラッシュする

対応が完了しましたので、以下の通りご報告いたします。

1. 対応内容

- Androidで通話中に別のincoming pushを受けた場合の処理を見直しました。
- active call中にincoming pushを通常着信と同じように扱い、full re-auth/re-registerすると、SDK sessionが競合する可能性がありました。
- active call guardを追加しました。
- 通話中はfull authenticateを実行しないようにしました。
- payloadがREGISTER pushのみの場合、incoming UI placeholderを作成しないようにしました。
- re-registerが必要な場合も、既存のSIP accountを壊さない形で処理するようにしています。
- push dedupeにより、同一call id/incomingの重複処理を避けています。
- capacity guardにより、アプリが扱える状態を超えてsessionを作成しないようにしています。
- SDK/PJSIPに近い操作は、thread/state boundaryを通して扱う方針にしています。

2. 影響範囲

- Android active call
- 通話中のincoming push
- Concurrent call
- SIP register/re-register
- AudioCodes SDK stability

3. 対応後の結果

- 通話中に別のincoming pushを受けた場合の処理が安定しました。
- full re-authによって既存sessionへ影響するリスクを低減しました。
- Push ON、active call、2件目着信の組み合わせで、より安全なflowになりました。

引き続きご確認お願いいたします。
