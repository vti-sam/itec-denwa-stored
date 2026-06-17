# Deploy app checklist ngắn gọn

Nguồn: `release_plan_android_ios_store.md`  
Phạm vi: Android/iOS production release cho `ぷらっとCALL`

## 1. Trước khi build

- [ ] ITEC xác nhận scope release và ngày public production.
- [ ] Ticket/bug blocker đã xử lý hoặc được ITEC chấp thuận release sau.
- [ ] Production API/Web truy cập được.
- [ ] MVE/SIP Phone production đã sẵn sàng.
- [ ] Account test reviewer login được và không bị OTP/2FA chặn.
- [ ] Version hiển thị Android/iOS thống nhất là `1.0.0`.
- [ ] Android `versionCode` và iOS build number đã tăng so với bản đã upload trước đó.

## 2. Android release candidate

- [ ] Source đúng branch/tag release.
- [ ] Package production là `jp.co.itec.denwa`.
- [ ] App name là `ぷらっとCALL`.
- [ ] Build release dùng production config và production API.
- [ ] Release signed bằng production key.
- [ ] Tạo AAB thành công.
- [ ] Cài thử trên thiết bị thật và app launch không crash.
- [ ] Lưu mapping file để debug crash nếu cần.

## 3. iOS release candidate

- [ ] Build từ `Denwa.xcworkspace`.
- [ ] Bundle ID production là `jp.co.itec.denwa.product`.
- [ ] App name là `ぷらっとCALL`.
- [ ] Build Release dùng `Production.xcconfig` và production API.
- [ ] Signing/provisioning/capabilities production hợp lệ.
- [ ] Archive thành công.
- [ ] Upload App Store Connect thành công và build processed.
- [ ] Lưu dSYM/symbol để debug crash nếu cần.

## 4. QA smoke test

- [ ] Cài mới/cập nhật app production RC trên Android.
- [ ] Cài mới/cập nhật app production RC trên iOS.
- [ ] Login được bằng account test.
- [ ] Thông tin tenant/user hiển thị đúng.
- [ ] Gọi mobile to mobile hoạt động.
- [ ] Gọi SIP Phone to mobile hoạt động.
- [ ] Gọi mobile to SIP Phone hoạt động.
- [ ] Push notification/call UI hoạt động ở foreground/background/kill.
- [ ] Transfer call hoạt động theo spec đã chốt.
- [ ] Message/contact flow cơ bản pass nếu thuộc scope.
- [ ] Không có crash hoặc lỗi blocker.

## 5. Submit store review

- [ ] Google Play upload đúng AAB `1.0.0`.
- [ ] App Store Connect chọn đúng build `1.0.0`.
- [ ] Store listing, screenshot, release note đã được KH duyệt.
- [ ] Privacy/Data safety/App content đã khai báo đầy đủ.
- [ ] Reviewer account và review note đã nhập đầy đủ.
- [ ] Chọn manual release/managed publishing nếu cần approve trước nhưng chưa public.
- [ ] Sau khi approve, không upload build mới nếu không có blocker bắt buộc.

## 6. Public production

- [ ] Android và iOS đã được store approve.
- [ ] ITEC xác nhận bằng văn bản thời điểm public.
- [ ] Okada/ITEC sẵn sàng hỗ trợ MVE/SIP Phone nếu phát sinh lỗi.
- [ ] VTI sẵn sàng monitor app/API/log.
- [ ] Public/release production trên Google Play và App Store.
- [ ] Kiểm tra store hiển thị đúng app `ぷらっとCALL` version `1.0.0`.
- [ ] Cài mới/cập nhật app từ store trên Android và iOS.
- [ ] Login, call, push flow chính pass sau public.
- [ ] Ghi lại thời gian public, version/build, người thao tác và kết quả smoke test.
