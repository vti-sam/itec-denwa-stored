# REL-DEPLOY-01 アプリデプロイチェックリスト

## Thông tin cơ bản

| Mục | Nội dung |
| --- | --- |
| Tên tài liệu | Deploy app checklist chi tiết |
| Nguồn | REL-STORE-01_AndroidIOSストアリリース計画.md |
| Phạm vi | Android/iOS production release cho ぷらっとCALL |
| Version | 1.0.0 |
| Người tạo | VTI-SAM |
| Ngày tạo | 2026/06/19 |

## Lịch sử thay đổi

| Version | Người yêu cầu | Người cập nhật | Ngày cập nhật | Lý do | Sheet | Nội dung thay đổi |
| --- | --- | --- | --- | --- | --- | --- |
| 1.0.0 | ITEC | VTI-SAM | 2026/06/19 | Tạo mới | Android, iOS | Tạo checklist release production và yêu cầu evidence |

## Quy tắc ghi nhận

- Mỗi mục phải có trạng thái, người kiểm tra, thời gian và link/path evidence.
- Mục đánh dấu **Evidence bắt buộc** chỉ được Pass khi đã đính kèm ảnh chụp hoặc artifact tương ứng.
- Phải chụp version/build hiện tại trước khi sửa và chụp lại sau khi sửa.
- Release production chính thức đầu tiên dùng version hiển thị `1.0.0`, Android `versionCode = 1` và iOS build number `1`.
- Chỉ reset build identifier về `1` sau khi đã xác nhận package/bundle production chưa từng có build trên Store. Nếu đã tồn tại build production, build identifier mới phải lớn hơn build gần nhất.
- Không ghi password, signing key, token hoặc secret vào checklist/evidence.

## Checklist {sheet=Android}

### A. Xác nhận trước khi build

- [ ] ITEC xác nhận scope release và thời điểm public production. **Evidence:** văn bản xác nhận.
- [ ] Không còn ticket/bug blocker, hoặc đã có xác nhận chấp thuận release. **Evidence:** danh sách ticket/trạng thái.
- [ ] Production API `https://api.apl.purattocall.com` và Web `https://apl.purattocall.com` truy cập được. **Evidence:** ảnh/HTTP result có thời gian.
- [ ] MVE/SIP Phone production sẵn sàng cho smoke test. **Evidence:** xác nhận của ITEC/Okada.
- [ ] Account reviewer login được và không bị OTP/2FA chặn. **Evidence:** ảnh login thành công, che thông tin nhạy cảm.
- [ ] Source đúng branch/tag/commit release và working tree không chứa thay đổi ngoài scope. **Evidence:** commit SHA và ảnh/log Git.

### B. Version baseline và cấu hình production

- [ ] Chụp version hiển thị và `versionCode` hiện tại trong source trước khi sửa. **Evidence bắt buộc:** ảnh source/config trước thay đổi.
- [ ] Xác nhận package production chưa từng có artifact trên Google Play Console. **Evidence bắt buộc:** ảnh Play Console có package và thời gian.
- [ ] Ghi nhận baseline source hiện biết: `versionCode 53`; nếu source thực tế khác thì dùng giá trị thực tế và nêu lý do. **Evidence:** ảnh/source reference.
- [ ] Đặt version hiển thị mục tiêu thành `1.0.0`, không còn suffix debug/dev hoặc version cũ. **Evidence bắt buộc:** ảnh source/config sau thay đổi.
- [ ] Reset `versionCode` production về `1`. Nếu Play Console đã có artifact của package production thì dừng release và đặt versionCode lớn hơn bản gần nhất. **Evidence bắt buộc:** ảnh source và Play Console để đối chiếu.
- [ ] Package production là `jp.co.itec.denwa`. **Evidence:** ảnh Gradle/manifest hoặc output package inspection.
- [ ] App name production là `ぷらっとCALL`. **Evidence:** ảnh config và màn hình thiết bị.
- [ ] Release dùng production config, production API và không trỏ Dev/STG. **Evidence bắt buộc:** ảnh/config diff đã che secret.
- [ ] `CALL_PUSH_FCM` và cấu hình push production đúng theo release plan. **Evidence:** ảnh/config diff đã che secret.
- [ ] JDK/build tool đúng phiên bản yêu cầu của project. **Evidence:** log version/build environment.
- [ ] Review diff cuối cùng: chỉ có thay đổi thuộc scope release, không chứa credential/private file. **Evidence:** review/commit SHA.

### C. Build và ký release

- [ ] Clean build release thành công. **Evidence bắt buộc:** build log kết thúc thành công.
- [ ] Release được ký bằng production signing config; không ghi key/password vào evidence. **Evidence:** signing verification đã che dữ liệu nhạy cảm.
- [ ] Tạo AAB production thành công. **Evidence bắt buộc:** path, filename, kích thước và checksum SHA-256.
- [ ] Kiểm tra AAB có package, version name và versionCode đúng. **Evidence bắt buộc:** output bundle inspection.
- [ ] Lưu mapping file tương ứng đúng AAB/versionCode. **Evidence:** path và checksum.
- [ ] Cài release candidate trên thiết bị Android thật; app launch không crash. **Evidence bắt buộc:** ảnh app và device/OS info.
- [ ] Màn hình app/About hiển thị version `1.0.0` nếu có. **Evidence bắt buộc:** ảnh trên thiết bị.
- [ ] Không xuất hiện endpoint, banner hoặc label Dev/STG trong app production. **Evidence:** ảnh kiểm tra.

### D. QA smoke test Android

- [ ] Cài mới app production RC thành công. **Evidence:** ảnh/video ngắn.
- [ ] Cập nhật từ bản trước lên production RC thành công và dữ liệu hợp lệ được giữ lại. **Evidence:** ảnh trước/sau.
- [ ] Login bằng account test thành công. **Evidence bắt buộc:** ảnh sau login, che dữ liệu nhạy cảm.
- [ ] Tenant, user và quyền hiển thị đúng. **Evidence:** ảnh màn hình.
- [ ] Gọi mobile-to-mobile thành công, âm thanh hai chiều ổn định. **Evidence:** ảnh/video/call log.
- [ ] Gọi SIP Phone-to-mobile thành công. **Evidence:** ảnh/video/call log.
- [ ] Gọi mobile-to-SIP Phone thành công. **Evidence:** ảnh/video/call log.
- [ ] Incoming call và call UI hoạt động khi app foreground. **Evidence:** ảnh/video.
- [ ] Incoming call và call UI hoạt động khi app background. **Evidence:** ảnh/video.
- [ ] Incoming call và call UI hoạt động khi app bị kill. **Evidence bắt buộc:** ảnh/video và push/call log.
- [ ] Transfer call hoạt động đúng spec đã chốt. **Evidence:** ảnh/video/call log.
- [ ] Message/contact flow cơ bản Pass nếu thuộc scope. **Evidence:** ảnh kết quả hoặc ghi N/A có lý do.
- [ ] Không có crash, ANR hoặc lỗi blocker trong smoke test. **Evidence:** log/crash dashboard.
- [ ] Ghi rõ thiết bị, Android OS, mạng và thời gian test. **Evidence:** test record.

### E. Google Play review và public

- [ ] Upload đúng AAB production lên Google Play Console. **Evidence bắt buộc:** ảnh artifact/versionCode sau upload.
- [ ] Play Console nhận version name `1.0.0` và versionCode đúng, không có lỗi blocker. **Evidence bắt buộc:** ảnh Console.
- [ ] Store listing, screenshot và release note là bản đã được KH duyệt. **Evidence:** link/xác nhận duyệt.
- [ ] Data safety, App content, target API và policy declarations đầy đủ. **Evidence:** ảnh trạng thái Console.
- [ ] Reviewer account/review note đã nhập đầy đủ, không đưa password vào checklist. **Evidence:** ảnh đã che credential.
- [ ] Chọn managed publishing/manual release nếu cần approve trước nhưng chưa public. **Evidence:** ảnh setting.
- [ ] Submit review thành công và ghi lại thời gian submit. **Evidence bắt buộc:** ảnh trạng thái review.
- [ ] Sau khi approve, không upload build mới nếu không có blocker bắt buộc. **Evidence:** xác nhận release owner.
- [ ] ITEC xác nhận bằng văn bản thời điểm public. **Evidence bắt buộc:** link/email/chat xác nhận.
- [ ] Public production và ghi nhận thời gian thao tác/người thao tác. **Evidence bắt buộc:** ảnh trạng thái production.
- [ ] Store hiển thị đúng app `ぷらっとCALL` version `1.0.0`. **Evidence bắt buộc:** ảnh trang Store.
- [ ] Cài mới/cập nhật trực tiếp từ Google Play thành công. **Evidence:** ảnh trên thiết bị.
- [ ] Login, call và push flow chính Pass sau public. **Evidence bắt buộc:** smoke-test record.
- [ ] Theo dõi API/log/crash sau public; không có blocker trong cửa sổ monitor đã chốt. **Evidence:** dashboard/log summary.
- [ ] Lưu AAB, mapping, checksum, commit/tag và release record ở vị trí được quản lý. **Evidence:** link/path artifact.

## Checklist {sheet=iOS}

### A. Xác nhận trước khi build

- [ ] ITEC xác nhận scope release và thời điểm public production. **Evidence:** văn bản xác nhận.
- [ ] Không còn ticket/bug blocker, hoặc đã có xác nhận chấp thuận release. **Evidence:** danh sách ticket/trạng thái.
- [ ] Production API `https://api.apl.purattocall.com` và Web `https://apl.purattocall.com` truy cập được. **Evidence:** ảnh/HTTP result có thời gian.
- [ ] MVE/SIP Phone production sẵn sàng cho smoke test. **Evidence:** xác nhận của ITEC/Okada.
- [ ] Account reviewer login được và không bị OTP/2FA chặn. **Evidence:** ảnh login thành công, che thông tin nhạy cảm.
- [ ] Source đúng branch/tag/commit release và working tree không chứa thay đổi ngoài scope. **Evidence:** commit SHA và ảnh/log Git.

### B. Version baseline và cấu hình production

- [ ] Chụp `MARKETING_VERSION` và `CURRENT_PROJECT_VERSION` hiện tại trước khi sửa. **Evidence bắt buộc:** ảnh project setting/source trước thay đổi.
- [ ] Xác nhận bundle ID production chưa từng có build trên App Store Connect. **Evidence bắt buộc:** ảnh App Store Connect có bundle ID và thời gian.
- [ ] Ghi nhận baseline source hiện biết: build `19`; nếu source thực tế khác thì dùng giá trị thực tế và nêu lý do. **Evidence:** ảnh/source reference.
- [ ] Đặt version hiển thị (`MARKETING_VERSION`) thành `1.0.0`, không còn suffix debug/dev hoặc version cũ. **Evidence bắt buộc:** ảnh project setting/source sau thay đổi.
- [ ] Reset build number (`CURRENT_PROJECT_VERSION`) production về `1`. Nếu App Store Connect đã có build của bundle ID production thì dừng release và đặt build number lớn hơn bản gần nhất. **Evidence bắt buộc:** ảnh source và App Store Connect để đối chiếu.
- [ ] Build từ `Denwa.xcworkspace`, không build nhầm project. **Evidence:** ảnh Xcode workspace/scheme.
- [ ] Bundle ID production là `jp.co.itec.denwa.product`. **Evidence:** ảnh signing/build setting.
- [ ] App name production là `ぷらっとCALL`. **Evidence:** ảnh config và Home Screen.
- [ ] Scheme/configuration là Release và dùng `Production.xcconfig`, production API. **Evidence bắt buộc:** ảnh scheme/build setting đã che secret.
- [ ] Push Notifications, Background Modes, PushKit/APNs/CallKit capabilities production hợp lệ. **Evidence:** ảnh Signing & Capabilities.
- [ ] Orientation/device support đúng scope đã duyệt và không tái phát lỗi review trước. **Evidence:** ảnh setting/test.
- [ ] Review diff cuối cùng: chỉ có thay đổi thuộc scope release, không chứa credential/private file. **Evidence:** review/commit SHA.

### C. Archive, ký và upload

- [ ] Clean build Release thành công. **Evidence bắt buộc:** build log kết thúc thành công.
- [ ] Signing certificate, provisioning profile, Team và entitlements production hợp lệ. **Evidence:** ảnh signing validation đã che dữ liệu nhạy cảm.
- [ ] Archive thành công từ đúng workspace/scheme/configuration. **Evidence bắt buộc:** ảnh Organizer có version/build/time.
- [ ] Validate App thành công, không có lỗi blocker. **Evidence bắt buộc:** validation result.
- [ ] Upload App Store Connect thành công. **Evidence bắt buộc:** upload result có version/build.
- [ ] Build được App Store Connect xử lý thành công. **Evidence bắt buộc:** ảnh processed build.
- [ ] Lưu dSYM/symbol tương ứng đúng archive/build. **Evidence:** path và checksum.
- [ ] Cài release candidate qua TestFlight/Ad Hoc trên thiết bị iPhone thật; app launch không crash. **Evidence bắt buộc:** ảnh app và device/iOS info.
- [ ] Màn hình app/About hiển thị version `1.0.0` nếu có. **Evidence bắt buộc:** ảnh trên thiết bị.
- [ ] Không xuất hiện endpoint, banner hoặc label Dev/STG trong app production. **Evidence:** ảnh kiểm tra.

### D. QA smoke test iOS

- [ ] Cài mới app production RC thành công. **Evidence:** ảnh/video ngắn.
- [ ] Cập nhật từ bản trước lên production RC thành công và dữ liệu hợp lệ được giữ lại. **Evidence:** ảnh trước/sau.
- [ ] Login bằng account test thành công. **Evidence bắt buộc:** ảnh sau login, che dữ liệu nhạy cảm.
- [ ] Tenant, user và quyền hiển thị đúng. **Evidence:** ảnh màn hình.
- [ ] Gọi mobile-to-mobile thành công, âm thanh hai chiều ổn định. **Evidence:** ảnh/video/call log.
- [ ] Gọi SIP Phone-to-mobile thành công. **Evidence:** ảnh/video/call log.
- [ ] Gọi mobile-to-SIP Phone thành công. **Evidence:** ảnh/video/call log.
- [ ] Incoming call và CallKit UI hoạt động khi app foreground. **Evidence:** ảnh/video.
- [ ] Incoming call và CallKit UI hoạt động khi app background. **Evidence:** ảnh/video.
- [ ] Incoming call và CallKit UI hoạt động khi app bị kill. **Evidence bắt buộc:** ảnh/video và push/call log.
- [ ] Transfer call hoạt động đúng spec đã chốt. **Evidence:** ảnh/video/call log.
- [ ] Message/contact flow cơ bản Pass nếu thuộc scope. **Evidence:** ảnh kết quả hoặc ghi N/A có lý do.
- [ ] Không có crash hoặc lỗi blocker trong smoke test. **Evidence:** log/crash dashboard.
- [ ] Ghi rõ thiết bị, iOS version, mạng và thời gian test. **Evidence:** test record.

### E. App Store review và public

- [ ] Chọn đúng processed build `1.0.0` trong App Store Connect. **Evidence bắt buộc:** ảnh version/build đã chọn.
- [ ] Store listing, screenshot và release note là bản đã được KH duyệt. **Evidence:** link/xác nhận duyệt.
- [ ] Privacy, App content, export compliance và policy declarations đầy đủ. **Evidence:** ảnh trạng thái App Store Connect.
- [ ] Reviewer account/review note đã nhập đầy đủ, không đưa password vào checklist. **Evidence:** ảnh đã che credential.
- [ ] Chọn manual release nếu cần approve trước nhưng chưa public. **Evidence:** ảnh setting.
- [ ] Submit review thành công và ghi lại thời gian submit. **Evidence bắt buộc:** ảnh trạng thái review.
- [ ] Sau khi approve, không upload build mới nếu không có blocker bắt buộc. **Evidence:** xác nhận release owner.
- [ ] ITEC xác nhận bằng văn bản thời điểm public. **Evidence bắt buộc:** link/email/chat xác nhận.
- [ ] Public production và ghi nhận thời gian thao tác/người thao tác. **Evidence bắt buộc:** ảnh trạng thái Ready for Distribution/production.
- [ ] App Store hiển thị đúng app `ぷらっとCALL` version `1.0.0`. **Evidence bắt buộc:** ảnh trang Store.
- [ ] Cài mới/cập nhật trực tiếp từ App Store thành công. **Evidence:** ảnh trên thiết bị.
- [ ] Login, call và push flow chính Pass sau public. **Evidence bắt buộc:** smoke-test record.
- [ ] Theo dõi API/log/crash sau public; không có blocker trong cửa sổ monitor đã chốt. **Evidence:** dashboard/log summary.
- [ ] Lưu archive, dSYM, checksum, commit/tag và release record ở vị trí được quản lý. **Evidence:** link/path artifact.
