---
title: Đổi ba account OTP cố định DEV sang test1, test2, test3
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session 2026-07-29
  - sources/denwa-api/src/main/resources/config/application-dev-cloud.properties
  - Git commit 0beb20e7fbca4a687ed38630bc032b64444bf126
  - GitLab pipeline 733378 / IID 516
  - Live DEV database transaction and read-back on 2026-07-29
  - scratch/db-backups/denwa_dev_fixed_otp_account_repoint_20260729T125458Z.json
  - scratch/db-backups/denwa_dev_test2_password_sync_20260729T211527Z.json
  - sources/denwa-android/app/src/androidTest/java/jp/co/itec/denwa/DenwaCallFlowInstrumentedTest.kt
  - Android commit 983e3cd7f12e4bccc198696a343644c2df7a19ef
tags:
  - dev
  - fixed-otp
  - account
  - authentication
  - sip
scope: historical
captured_at: 2026-07-29
validity: historical_context
promote_to_knowledge: false
---

## Outcome

Ba mobile account active của tenant `112` trên database DEV `denwa_dev` được
đổi email, giữ nguyên UUID, SIP, role, phone type, trạng thái và password:

- SIP `13025`: `huong.nguyenthi+25@vti.com.vn` thành `test1@vti.com.vn`.
- SIP `13026`: `huong.nguyenthi+26@vti.com.vn` thành `test2@vti.com.vn`.
- SIP `13027`: `huong.nguyenthi+27@vti.com.vn` thành `test3@vti.com.vn`.

Mapping mobile tenant `112`, `account_type = '1'` được đổi đồng bộ sang ba
email mới. Whitelist OTP cố định của profile API `dev-cloud` cũng được đổi sang
ba email mới và deploy lên API DEV.

Password hash của `test2@vti.com.vn` sau đó được đồng bộ từ
`test1@vti.com.vn`, đồng thời reset bộ đếm đăng nhập lỗi và token cũ. Trên máy
ảo Android, account `test2` đã đăng nhập thành công, mở bàn phím quay số và gọi
SIP `13025`; màn hình đã chuyển sang trạng thái kết nối.

Prototype Appium TypeScript chạy ngoài app ban đầu đã bị loại bỏ vì không đúng
yêu cầu tích hợp trực tiếp trong project Android. Ba testcase hiện được viết
bằng Kotlin instrumentation tại
`sources/denwa-android/app/src/androidTest/java/jp/co/itec/denwa/DenwaCallFlowInstrumentedTest.kt`.
Credential cố định chỉ nằm trong test APK, không nằm trong APK production.

Testcase gọi thường chỉ thành công khi quan sát được `通話中`; hết timeout hoặc
chuyển sang `留守番電話` không còn được tính là thành công. Testcase máy nhỡ
riêng chờ `留守番電話`, chờ recorder tự chuyển sang trạng thái ghi âm, ghi 3
giây, bấm `送信` và chỉ thành công khi xuất hiện `送信完了`.

Trước khi mở màn hình đăng nhập, Kotlin instrumentation cấp toàn bộ runtime
permission nguy hiểm trong `AppConst.permissions` cho app đích để dialog hệ
thống không chặn thao tác. Login và OTP không còn coi một lần click là thành
công: test chỉ dừng retry khi đã chuyển sang màn OTP hoặc Main/Dialpad, bỏ qua
thời gian loading và giữ khoảng nghỉ 2 giây giữa các lần click để tránh request
chồng nhau.

Runtime log trên Android 12 cho thấy helper cũ bắt đầu test lúc `10:19:35`
nhưng chỉ phát hai request login tại `10:20:35.188` và `10:20:35.540`, rồi
timeout. Cả hai request đều mang đúng account Test2. Nguyên nhân thuộc test
helper: selector dùng unmerged semantics nên có thể giữ node mô tả bên ngoài
thay vì node Button có action thật; thời điểm chống retry chỉ được cập nhật sau
khi `performClick()` trả success nên action đã phát request nhưng trả lỗi có
thể bị click lại ngay. Helper hiện dùng merged semantics, ghi thời điểm trước
khi dispatch click và log toàn bộ action bằng tag `DenwaE2E`.

Lần chạy tiếp theo trên máy thật `moto g52j` Android 12 xác nhận thêm một nguyên
nhân trực tiếp: bàn phím mềm che hoàn toàn nút Login. Compose semantics vẫn tìm
thấy node và báo dispatch click, nhưng app không nhận action nên không phát
request API. Helper dùng chung hiện đóng bàn phím, chờ UI idle và
`performScrollTo()` để đưa target vào viewport trước khi click.

Đã tách thêm testcase transfer độc lập cho Test2. Test đăng nhập
`test2`, gọi `13025`, chờ kết nối và ghi nhận profile ban đầu. Thao tác transfer
được thực hiện hoàn toàn trên máy bên ngoài; Test2 chỉ quan sát chuỗi trạng thái
`通話中` → `転送中` → `通話中` và xác nhận profile session cuối khác profile
ban đầu. Timeout nối cuộc gọi ban đầu là 60 giây; timeout chờ thao tác transfer
sau khi nối máy là 10 phút.

## Evidence

- Transaction dừng nếu database không phải `denwa_dev`, ba SIP không còn map
  đúng ba email nguồn, account không active, email đích đã tồn tại hoặc mapping
  nguồn không còn đúng một bản ghi.
- Independent DB read-back xác nhận `test1`, `test2`, `test3` lần lượt giữ SIP
  `13025`, `13026`, `13027`, đều có `user_status = '3'`, `delete_flag = '0'`,
  `phone_type = '1'`, `role = '2'` và đúng một mapping mobile. Ba email Huong cũ
  không còn user hoặc mapping.
- Maven test hoàn tất với 8 test pass, không có failure hoặc error.
- GitLab pipeline IID `516` thành công cho commit
  `0beb20e7fbca4a687ed38630bc032b64444bf126`.
- ECS DEV chạy task definition `denwa-backend-task:288`, image
  `itec-denwa-backend:1.1.1-516`, profile `dev-cloud`; rollout hoàn tất với
  running/desired là `1/1` và image digest khớp ECR.
- Live API smoke xác nhận `test1@vti.com.vn` và `test3@vti.com.vn` login thành
  công, tạo pre-token và verify OTP cố định thành công với response `ES200`.
- API DEV read-back sau đồng bộ password xác nhận `test2@vti.com.vn` đăng nhập
  thành công với response `ES200`.
- App Android DEV được build, cài lên AVD `Medium_Phone_Test2` và Appium
  UiAutomator2 tạo session thành công. Smoke test tìm được selector email và nút
  đăng nhập bằng accessibility ID.
- Appium TypeScript typecheck và Android `:app:compileDebugKotlin` đều thành
  công; npm audit không còn vulnerability.
- Full Appium case trên `Medium_Phone_Test2` đã đăng nhập `test2`, verify OTP,
  chờ loading, mở dialpad, nhập `13025` và xác nhận `発信中`. Đích không bắt máy
  trong 15 giây nên không có `通話中`; test kết thúc thành công và tự ngắt cuộc
  gọi.
- Lệnh one-shot `npm test` chạy pass hai lần liên tiếp từ trạng thái không có
  Appium server. Cả hai lần đều tự start Appium, hoàn tất login/OTP/dial/call,
  cleanup session và xác nhận server đã dừng trước lần chạy kế tiếp.
- Nhánh `留守番電話` được chạy thực tế thành công: Appium phát hiện popup, bấm
  `キャンセル`, không để lại warning cleanup và kết thúc one-shot bằng
  `[E2E] PASS`.
- Sau khi tách testcase, TypeScript typecheck, Android
  `:app:compileDebugKotlin` và cài APK DEV lên `Medium_Phone_Test2` đều thành
  công.
- `npm test` được chạy lại và pass: Test2 đăng nhập, gọi `13025`, phát hiện
  `留守番電話`, bấm `キャンセル` và dọn session.
- Prototype TypeScript trước khi bị loại bỏ đã chạy tới nhánh thực tế chưa bắt
  máy: Test2 đăng nhập và gọi `13025`, phát hiện `留守番電話`, tự cancel/dọn
  session rồi fail đúng tại điều kiện kết nối ban đầu.
- Sau khi User làm rõ yêu cầu, toàn bộ `sources/denwa-android/e2e/appium/`
  được đưa ra khỏi source tree và thay bằng Kotlin instrumentation test trong
  module `app`. Kotlin test class đã compile thành công. Việc đóng gói, cài và
  chạy trên thiết bị thật do User thực hiện nên chưa có runtime result cho bản
  Kotlin.
- Log thiết bị thật ngày 2026-07-30 xác nhận helper cũ phát hai request
  `POST /auth/user/login` cách nhau khoảng 352 ms ngay sát timeout 60 giây,
  sau đó fail tại `clickUntilStateChanged`. Đây không phải lỗi validation hoặc
  API vì request body đã có đúng account và password Test2.
- Ảnh chụp máy thật trước fix tại
  `scratch/denwa-login-e2e-20260730.png` cho thấy bàn phím che toàn bộ nút
  Login; chỉ còn nhìn thấy liên kết quên mật khẩu.
- Sau khi bổ sung đóng bàn phím và cuộn target, Android instrumentation build
  thành công và chạy trên thiết bị thật `ZY32FRWTS3`. Login và OTP đều chỉ cần
  một lần click, lần lượt chuyển qua loading, OTP và Main/Dialpad.
- Full testcase `loginTest2AndPlaceCall` trên máy thật đã nhập `13025`, quan sát
  `発信中` lúc `10:31:25`, đạt `通話中` lúc `10:32:08`, tự kết thúc cuộc gọi và
  hoàn tất `OK (1 test)` trong 50,837 giây. Ảnh trạng thái gọi nằm tại
  `scratch/denwa-e2e-after-fix-20260730.png`.
- Build xác nhận trước push thành công bằng
  `:app:assembleDebugAndroidTest` sau khi chạy tuần tự và tắt incremental KSP.
  Phần Kotlin instrumentation và các Compose semantics phục vụ test được commit
  riêng tại `983e3cd7f12e4bccc198696a343644c2df7a19ef`
  (`test(android): add end-to-end call instrumentation`). Remote read-back xác
  nhận `origin/prd` và local `prd` cùng trỏ tới commit này. Các thay đổi
  `MainActivity`, `AudioCodecCallManager` và `SipRecoveryPolicyTest` không nằm
  trong commit.

## Unresolved

Success path của testcase transfer vẫn cần chạy khi phía `13025` sẵn sàng bắt
máy và thực hiện transfer để xác nhận đủ ba trạng thái cùng profile session
mới. Testcase ghi âm và gửi lời nhắn cũng chưa được chạy lại trên máy thật sau
fix bàn phím/viewport.

## Retrieval keys

- test1@vti.com.vn
- test2@vti.com.vn
- test3@vti.com.vn
- huong.nguyenthi+25@vti.com.vn
- huong.nguyenthi+26@vti.com.vn
- huong.nguyenthi+27@vti.com.vn
- SIP 13025
- SIP 13026
- SIP 13027
- otp.review.accounts
- denwa-backend-task:288
- GitLab pipeline 516
- Appium login call test2
- Medium_Phone_Test2
- e2e dialpad 13025
- Kotlin Android instrumentation Test2
- 通話中 転送中 profile session
- Android commit 983e3cd
