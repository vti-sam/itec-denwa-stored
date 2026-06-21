# Kế hoạch release Android/iOS lên store cho ぷらっとCALL

Ngày cập nhật: 2026-06-16  
Dự án: `itec-denwa` / Denwa / `ぷらっとCALL`  
Phạm vi: chuẩn bị release mobile app Android/iOS lên Google Play và Apple App Store, gắn với API/infra production, MVE, SIP Phone, account test cho reviewer, store review và release production.

## 1. Kết luận vận hành

- Mốc `2026-06-30` là ngày **public production chính thức**, không phải ngày bắt đầu store review.
- App phải được submit review trước đó, mục tiêu submit là `2026-06-19`, ngày dự phòng là `2026-06-22`.
- Sau khi được approve, không upload build mới nếu không bắt buộc; giữ app ở trạng thái có thể public và chỉ public sau quyết định cuối cùng của ITEC vào `2026-06-29` hoặc ngày `2026-06-30`.
- Version hiển thị cho cả Android/iOS thống nhất về `1.0.0`.
- Việc đầu tiên trước build RC là hạ/chốt version hiển thị về `1.0.0` ở source Android/iOS và xác nhận lại store metadata.
- Android `versionCode` và iOS `build number` không phải version hiển thị; chúng vẫn phải tuân thủ quy tắc tăng dần của Google Play/App Store Connect.

## 2. Thông tin đã tổng hợp

### 2.1. App và môi trường

| Hạng mục | Giá trị hiện biết | Ghi chú |
|---|---|---|
| Tên app | `ぷらっとCALL` | iOS/Android config đều dùng tên này |
| Dự án | `itec-denwa` | Workspace hiện tại |
| Android package production | `jp.co.itec.denwa` | Từ `sources/denwa-android/app/build.gradle.kts` |
| iOS bundle production | `jp.co.itec.denwa.product` | Từ `Production.xcconfig` |
| Production API | `https://api.apl.purattocall.com` | Dùng cho Android/iOS production |
| Production web/admin | `https://apl.purattocall.com` | Theo infra runbook |
| Firebase Android package production | `jp.co.itec.denwa` | Từ `google-services.json` hiện có |
| MVE/SIP | Có liên quan trực tiếp release | Cần Okada/ITEC xác nhận cấu hình production |

### 2.2. Version mục tiêu

| Platform | Version hiển thị mục tiêu | Build/version code | Việc cần làm |
|---|---:|---:|---|
| Android | `1.0.0` | `versionCode` hiện thấy trong source: `53` | Đổi `VERSION_NAME` về `1.0.0`; giữ hoặc tăng `VERSION_CODE` theo bản đã upload lên Play Console |
| iOS | `1.0.0` | `CURRENT_PROJECT_VERSION` hiện thấy: `19` | `MARKETING_VERSION` đã là `1.0.0`; xác nhận build number dùng submit |

Lưu ý:

- Không đặt Android `versionCode` thành `1.0.0` vì Play Console yêu cầu số nguyên.
- Không đặt iOS build number thành `1.0.0` nếu App Store Connect cần build number dạng tăng dần; `1.0.0` là `MARKETING_VERSION`.
- Nếu Play Console/App Store đã từng nhận build cao hơn, build number/version code mới phải lớn hơn bản đã upload, kể cả khi version hiển thị là `1.0.0`.

### 2.3. Source-of-truth đã dùng

| Nguồn | Nội dung dùng trong kế hoạch |
|---|---|
| `raw/release_wbs_draft_jp_2026-06-10.md` | WBS release 2026-06-30, mốc review/public, vai trò ITEC/VTI/Okada |
| `management/WBS.yaml` | WBS cache hiện tại: DENWA-WBS-028 đến DENWA-WBS-043 |
| `knowledge/denwa-android/runbooks/project.md` | Android build/private files/JDK 21 |
| `knowledge/denwa-android/runbooks/release-debug.md` | Android release config, production behavior |
| `knowledge/denwa-ios/runbooks/project.md` | iOS project, Xcode/CocoaPods, app name, App Store orientation note |
| `knowledge/denwa-infra/architecture/ARCH-INFRA-01_インフラ構造設計.md` | Production domain/API routing |
| `knowledge/denwa-infra/runbooks/prd_backend_secret_recovery_2026-06-13.md` | Production API/frontend status và rủi ro secret/DB |
| Apple/Google official docs | Checklist submit/reviewer account/access info |

## 3. WBS release đã tổng hợp

| ID | Nhóm | Nội dung | Owner chính | Deadline | Trạng thái hiện biết | Điều kiện hoàn tất |
|---|---|---|---|---:|---|---|
| DENWA-WBS-028 | Release planning | Xác định scope release và điều kiện go/no-go ngày 30/06 | 片山 剛 | 2026-06-12 | Completed | Scope và điều kiện release đã được tổng hợp xong; output: WBS |
| DENWA-WBS-029 | API/infra | Chuẩn bị API production | VTI_SAM | 2026-06-12 | Completed | `stg` -> `prd`; chuẩn bị đã hoàn tất; output: Infra |
| DENWA-WBS-030 | API/infra | Kiểm tra nhanh API production | VTI_SAM | 2026-06-12 | Completed | Đã xác nhận; output: Testcase |
| DENWA-WBS-031 | MVE | Xác nhận MVE production | 野崎 祐也 | 2026-06-15 | Completed | MVE production liên kết được với API/app |
| DENWA-WBS-032 | SIP Phone | Chuẩn bị SIP Phone production | 野崎 祐也 | 2026-06-17 | Awaiting Customer | SIP account, số điện thoại, tenant/SIPP tenant, IP Group sẵn sàng |
| DENWA-WBS-033 | Document | Bổ sung hướng dẫn SIP Phone vào Web Manual | VTI_SAM | 2026-06-17 | Awaiting Customer | Tenant Admin có tài liệu đăng ký/cấu hình SIP Phone |
| DENWA-WBS-034 | Integration | Kiểm tra tích hợp mobile app/API/MVE | VTI_SAM | 2026-06-18 | Awaiting Customer | Gọi đi/gọi đến/push/call/transfer/kết thúc cuộc gọi pass |
| DENWA-WBS-035 | SIP Phone check | Kiểm tra SIP Phone trên production | 野崎 祐也 | 2026-06-18 | Awaiting Customer | SIP Phone <-> mobile call và kết thúc cuộc gọi pass |
| DENWA-WBS-036 | UAT/bugfix | Sửa lỗi UAT và xác nhận lại | VTI_SAM | 2026-06-18 | In Progress | Lỗi nghiêm trọng đã xử lý, tồn đọng được ITEC chấp thuận; ghi chú hiện tại: hầu hết lỗi đã được giải quyết |
| DENWA-WBS-037 | Store prep | Chuẩn bị App Store/Google Play submission info | VTI_SAM | 2026-06-18 | In Progress | Metadata, screenshot, privacy, review note, 3 account test sẵn sàng |
| DENWA-WBS-038 | Mobile app | Tạo release candidate kết nối production | VTI_SAM | 2026-06-19 | In Progress | Android/iOS install được, version/signing/prod connection đã xác nhận |
| DENWA-WBS-039 | Store review | Submit App Store/Google Play review | VTI_SAM | 2026-06-19 | Open | App ở trạng thái submitted/in review; ngày dự phòng 2026-06-22 |
| DENWA-WBS-040 | Hold after approval | Sau approve, chưa public cho user | VTI_SAM | 2026-06-26 | Open | Store approve và app sẵn sàng public, không upload build mới |
| DENWA-WBS-041 | Final decision | Quyết định public hoặc hoãn | 鈴木 克成 | 2026-06-29 | Open | Có quyết định rõ bằng văn bản; nếu còn lỗi nghiêm trọng thì không public |
| DENWA-WBS-042 | Production release | Public app cho user | 鈴木 克成 | 2026-06-30 | Open | User tải/cập nhật được từ store; sau public kiểm tra nhanh production |
| DENWA-WBS-043 | Monitoring | Theo dõi sau release | VTI_SAM | 2026-07-03 | Open | Có log monitor, hướng xử lý issue/hotfix; MVE/SIP cần Okada standby |

## 4. Checklist release tổng thể

### 4.1. Bước 0 - Chốt/hạ version về 1.0.0

- [ ] Android: sửa `DenwaVersion.VERSION_NAME` về `1.0.0`.
- [ ] Android: xác nhận `VERSION_CODE` là số nguyên lớn hơn mọi bản đã upload lên Play Console.
- [ ] Android: build output/release note không còn hiển thị `0.0.x` hoặc suffix không mong muốn cho production.
- [ ] iOS: xác nhận `MARKETING_VERSION = 1.0.0` cho target app chính.
- [ ] iOS: xác nhận `CURRENT_PROJECT_VERSION`/build number lớn hơn mọi build đã upload lên App Store Connect.
- [ ] Store metadata: version release hiển thị là `1.0.0` cho cả Google Play và App Store.
- [ ] QA/test evidence đặt tên theo `1.0.0` để tránh nhầm với bản dev/staging.

### 4.2. Điều kiện trước khi build RC

- [ ] Scope release ngày `2026-06-30` đã được ITEC xác nhận.
- [ ] Danh sách ticket/bugfix trong release đã chốt.
- [ ] Các lỗi UAT blocker đã fix hoặc có văn bản ITEC đồng ý release sau.
- [ ] Production API `https://api.apl.purattocall.com` sẵn sàng.
- [ ] Production web/admin `https://apl.purattocall.com` truy cập được.
- [ ] Secret/runtime production không trỏ nhầm staging nếu release thật.
- [ ] Firebase/APNs/push production đã xác nhận.
- [ ] MVE production endpoint/credential/callback/allowlist được Okada xác nhận.
- [ ] SIP Phone production account/số điện thoại/tenant/IP Group được Okada hoặc ITEC xác nhận.
- [ ] 3 account test đã tạo, login được, có dữ liệu test đủ cho reviewer.
- [ ] Account test không bị OTP/2FA/email verification chặn; nếu bắt buộc OTP thì có fixed OTP reusable.

### 4.3. Android build checklist

- [ ] Dùng source đúng branch/tag release.
- [ ] Dùng JDK 21 cho Gradle command trên máy local.
- [ ] `applicationId = jp.co.itec.denwa`.
- [ ] App name production là `ぷらっとCALL`.
- [ ] `VERSION_NAME = 1.0.0`.
- [ ] `VERSION_CODE` hợp lệ và tăng dần.
- [ ] Build type release dùng `env_production.json`.
- [ ] `APPLICATION_ENDPOINT` và `SOCKET_ENDPOINT` là `https://api.apl.purattocall.com`.
- [ ] `CALL_PUSH_FCM = true` theo production config hiện tại.
- [ ] Release signed bằng production key, không dùng debug/staging key.
- [ ] AAB release tạo thành công.
- [ ] Mapping/Proguard/R8 mapping được lưu để debug crash.
- [ ] Cài thử build release trên thiết bị thật.
- [ ] Smoke test login, call, push, transfer, messaging/contact nếu thuộc scope.
- [ ] Upload internal testing/production draft theo quyền Play Console.

### 4.4. iOS build checklist

- [ ] Mở `Denwa.xcworkspace`, không build trực tiếp `.xcodeproj`.
- [ ] Dùng configuration `Release` với `Production.xcconfig`.
- [ ] App name production là `ぷらっとCALL`.
- [ ] `APP_BUNDLE_ID = jp.co.itec.denwa.product`.
- [ ] `ROOT_URL = https://api.apl.purattocall.com`.
- [ ] `MARKETING_VERSION = 1.0.0`.
- [ ] `CURRENT_PROJECT_VERSION`/build number hợp lệ và tăng dần.
- [ ] Signing/capabilities/provisioning profile production hợp lệ.
- [ ] PushKit/APNs/CallKit entitlement đúng production.
- [ ] Archive release thành công.
- [ ] Upload App Store Connect thành công và build processed.
- [ ] dSYM/symbol được lưu hoặc upload crash tool nếu có.
- [ ] TestFlight/smoke test pass nếu dùng TestFlight để xác nhận RC.
- [ ] Kiểm tra lại lỗi App Store orientation/iPad multitasking không tái phát.

### 4.5. QA smoke test trước submit

| ID | Test | Android | iOS | Điều kiện pass |
|---|---|---:|---:|---|
| QA-01 | Cài mới app production RC | [ ] | [ ] | Launch không crash |
| QA-02 | Update từ bản cũ nếu có | [ ] | [ ] | Không mất trạng thái bất thường |
| QA-03 | Login bằng Account 1 | [ ] | [ ] | Login thành công |
| QA-04 | Login bằng Account 2 | [ ] | [ ] | Login thành công |
| QA-05 | Login bằng Account 3 | [ ] | [ ] | Login thành công |
| QA-06 | Tenant/user info | [ ] | [ ] | Dữ liệu đúng tenant test |
| QA-07 | Gọi mobile -> mobile | [ ] | [ ] | Gọi/nhận/kết thúc ổn định |
| QA-08 | Gọi SIP Phone -> mobile | [ ] | [ ] | Push/call UI hoạt động |
| QA-09 | Gọi mobile -> SIP Phone | [ ] | [ ] | Kết nối và kết thúc được |
| QA-10 | Transfer call | [ ] | [ ] | Transfer thành công hoặc theo spec đã chốt |
| QA-11 | Push khi foreground/background/kill | [ ] | [ ] | Không có blocker |
| QA-12 | Missed call/voice message nếu thuộc scope | [ ] | [ ] | Notification/log đúng |
| QA-13 | Chat/message nếu thuộc scope | [ ] | [ ] | Gửi/nhận/sync cơ bản pass |
| QA-14 | Logout/login lại | [ ] | [ ] | Session ổn định |
| QA-15 | Permission camera/mic/photo/notification | [ ] | [ ] | Prompt và behavior đúng |
| QA-16 | Crash/error log | [ ] | [ ] | Không có crash blocker |

## 5. Store submission checklist

### 5.1. Google Play

- [ ] App package đúng `jp.co.itec.denwa`.
- [ ] Upload AAB release `1.0.0`.
- [ ] `versionCode` lớn hơn bản đã upload trước đó.
- [ ] Release notes/changelog đã được KH duyệt.
- [ ] Store listing metadata/screenshot/video đã được KH duyệt.
- [ ] Privacy Policy URL truy cập được.
- [ ] Data safety khai báo đúng hành vi app và SDK.
- [ ] App content/sign-in details đã điền đầy đủ.
- [ ] Account test reusable, luôn truy cập được, không hết hạn mật khẩu.
- [ ] Nếu app có OTP/2FA, account review có bypass hoặc fixed OTP reusable.
- [ ] Content rating hoàn tất.
- [ ] Target audience/ads/declaration liên quan hoàn tất nếu có.
- [ ] Release mode đã chọn: managed publishing/manual rollout nếu muốn approve trước nhưng chưa public.
- [ ] Rollout production: 100% hoặc staged rollout theo quyết định ITEC.

### 5.2. App Store Connect

- [ ] App version tạo là `1.0.0`.
- [ ] Chọn đúng build `1.0.0`/build number đã upload.
- [ ] App Review Information đã điền contact/account/reviewer notes.
- [ ] Notes for Review mô tả rõ app cần login và các flow cần test.
- [ ] Screenshot/metadata không còn required item.
- [ ] Privacy Nutrition khai báo đúng dữ liệu app thu thập/sử dụng.
- [ ] Tracking/IDFA/ATT declaration hoàn tất nếu có.
- [ ] Export compliance hoàn tất nếu App Store Connect hỏi.
- [ ] Release option chọn manual release nếu muốn approve trước rồi public ngày `2026-06-30`.
- [ ] Không upload build mới sau khi approve trừ khi có blocker bắt buộc.

## 6. Account test cho reviewer

Password reviewer đã được ghi trực tiếp vào file nháp này theo xác nhận của User. Nếu chia sẻ file ra ngoài phạm vi store submission/KH review, cần rà lại quyền truy cập trước.

VTI đã chuẩn bị 3 account test tạm thời cho store review, đăng ký trong tenant test của iTEC là `111`. Cả 3 account dùng fixed OTP `123456`. Lý do chuẩn bị đủ 3 account là Transfer test cần tối thiểu 3 active accounts.

| Account | Platform | Username/Email | Password | Tenant/Role | Fixed OTP | Dữ liệu test | Ghi chú |
|---|---|---|---|---|---|---|---|
| Account 1 | Android/iOS | `account1@itec.hankyu-hanshin.co.jp` | `iTec@123456` | Tenant `111` / review account | `123456` | Cần kiểm tra trước submit | Dùng cho login/main flow |
| Account 2 | Android/iOS | `account2@itec.hankyu-hanshin.co.jp` | `iTec@123456` | Tenant `111` / review account | `123456` | Cần kiểm tra trước submit | Dùng cho call/push/transfer |
| Account 3 | Android/iOS | `account3@itec.hankyu-hanshin.co.jp` | `iTec@123456` | Tenant `111` / review account | `123456` | Cần kiểm tra trước submit | Dùng cho transfer/reviewer dự phòng |

Checklist account:

- [ ] Cả 3 account login được trên Android RC.
- [ ] Cả 3 account login được trên iOS RC.
- [ ] Account không bị khóa, hết hạn password hoặc giới hạn IP/vị trí.
- [ ] OTP/2FA/email verification đã tắt hoặc có mã fixed/reusable.
- [ ] Dữ liệu test không chứa dữ liệu thật/nhạy cảm.
- [ ] Có ít nhất 2 account có thể gọi cho nhau nếu reviewer cần test call.
- [ ] Có SIP Phone/account liên quan nếu reviewer cần test luồng SIP Phone.

## 7. Reviewer notes đề xuất

### 7.1. App Store Connect - Notes for Review

```text
Hello App Review Team,

This submission is for ぷらっとCALL version 1.0.0, build [BUILD_NUMBER].

The app requires sign-in to access the main VoIP calling and messaging features.

Test environment:
- Please use the production app build submitted in App Store Connect.
- The app connects to the production API environment.

Test accounts:
1. Username: account1@itec.hankyu-hanshin.co.jp
   Password: iTec@123456
   Role/Tenant: Tenant ID 111 / temporary review account
   OTP: 123456

2. Username: account2@itec.hankyu-hanshin.co.jp
   Password: iTec@123456
   Role/Tenant: Tenant ID 111 / temporary review account
   OTP: 123456

3. Username: account3@itec.hankyu-hanshin.co.jp
   Password: iTec@123456
   Role/Tenant: Tenant ID 111 / temporary review account
   OTP: 123456

Review steps:
1. Launch the app.
2. Sign in with one of the test accounts above.
3. Verify the main screen, contact/user information, and calling features.
4. If needed, use another test account or the prepared SIP Phone test environment to verify call behavior.
5. Sign out from the settings/profile screen after testing.

Notes:
- These accounts are prepared for review only.
- Two-factor authentication, email verification, and SMS verification are disabled for these accounts, or the reusable fixed OTP above can be used.
- Three active accounts are provided because the transfer feature requires at least three accounts for testing.
- No real payment or real personal data is required for review.
- If you need additional information, please contact us through App Store Connect.
```

### 7.2. Google Play Console - App Access Instructions

```text
The app requires sign-in to access its main VoIP calling and messaging features.

Please use one of the following test accounts:

Account 1
- Username: account1@itec.hankyu-hanshin.co.jp
- Password: iTec@123456
- Role/Tenant: Tenant ID 111 / temporary review account
- OTP: 123456

Account 2
- Username: account2@itec.hankyu-hanshin.co.jp
- Password: iTec@123456
- Role/Tenant: Tenant ID 111 / temporary review account
- OTP: 123456

Account 3
- Username: account3@itec.hankyu-hanshin.co.jp
- Password: iTec@123456
- Role/Tenant: Tenant ID 111 / temporary review account
- OTP: 123456

Review instructions:
1. Install and open the app.
2. Sign in with one of the test accounts above.
3. Verify the main screen, contact/user information, and calling features.
4. If needed, use another test account or the prepared SIP Phone test environment to verify call behavior.

Additional notes:
- These accounts are for review only.
- The credentials are reusable and do not expire.
- Two-factor authentication, email verification, and SMS verification are disabled for these accounts, or the reusable fixed OTP above can be used.
- Three active accounts are provided because the transfer feature requires at least three accounts for testing.
- No real payment or real personal data is required.
- If access fails, please contact us through Play Console.
```

## 8. Nội dung request KH/ITEC xác nhận

Đây là bản tiếng Việt để User review trước. Chỉ dịch sang tiếng Nhật sau khi User đồng ý.

```text
Kính gửi anh/chị,

Bên em đang chuẩn bị release ứng dụng ぷらっとCALL version 1.0.0 lên Google Play và App Store. Nhờ anh/chị xác nhận giúp các nội dung dưới đây trước khi bên em build RC và submit store review.

1. Thông tin release
- App: ぷらっとCALL
- Android package name: jp.co.itec.denwa
- iOS bundle ID: jp.co.itec.denwa.product
- Version hiển thị trên store: 1.0.0
- Môi trường reviewer sẽ test: Production
- Production API: https://api.apl.purattocall.com
- Dự kiến submit review: 2026-06-19
- Ngày dự phòng submit nếu chưa kịp: 2026-06-22
- Dự kiến public production: 2026-06-30 sau khi ITEC xác nhận cuối cùng
- Release mode đề xuất: manual release/managed publishing để approve trước nhưng chưa public ngay

2. Scope/changelog
Nhờ anh/chị xác nhận nội dung release note/changelog hiển thị trên store cho version 1.0.0:
[điền changelog]

3. Account test cho store reviewer
Bên em đã chuẩn bị 3 account test tạm thời để cung cấp cho Apple/Google reviewer. Các account này được đăng ký vào tenant test của iTEC là `111` và dùng fixed OTP `123456`:
- Account 1: account1@itec.hankyu-hanshin.co.jp / Tenant ID 111 / fixed OTP 123456
- Account 2: account2@itec.hankyu-hanshin.co.jp / Tenant ID 111 / fixed OTP 123456
- Account 3: account3@itec.hankyu-hanshin.co.jp / Tenant ID 111 / fixed OTP 123456
- Password chung: iTec@123456

Transfer test cần tối thiểu 3 active accounts, nên bên em chuẩn bị đủ 3 account để reviewer có thể kiểm tra luồng này khi cần. Nhờ anh/chị xác nhận các account này login được trên cả Android/iOS, không bị chặn bởi OTP/2FA/email verification ngoài fixed OTP nêu trên, không hết hạn mật khẩu, và có dữ liệu test đủ để reviewer thao tác flow chính.

4. Production/MVE/SIP Phone
Nhờ anh/chị xác nhận:
- API production đã sẵn sàng.
- MVE production đã có endpoint/credential/callback/allowlist đúng.
- SIP Phone production đã có account/số điện thoại/tenant/IP Group để kiểm tra.
- Các flow chính cần xác nhận gồm gọi đi, gọi đến, push/call, transfer, kết thúc cuộc gọi, SIP Phone <-> mobile nếu thuộc phạm vi review.

5. Store metadata và privacy
Nhờ anh/chị xác nhận:
- App name, mô tả, screenshot/video.
- Privacy Policy URL.
- Google Play Data Safety.
- App Store Privacy Nutrition/Tracking.
- Permission liên quan microphone, notification, contact/photo/camera/location nếu có.

Sau khi nhận xác nhận, bên em sẽ hạ/chốt version 1.0.0, build RC production, smoke test, upload và submit review theo kế hoạch.
```

## 9. Timeline vận hành

| Ngày | Mốc | Output cần có |
|---:|---|---|
| 2026-06-12 | Chốt scope/go-no-go criteria, API production | Scope release và API production ready |
| 2026-06-15 | MVE production | MVE production có thể liên kết app/API |
| 2026-06-17 | SIP Phone + manual | SIP Phone production và hướng dẫn Tenant Admin |
| 2026-06-18 | Integration/UAT/store prep | Flow chính pass, store metadata/review note/account test sẵn sàng |
| 2026-06-19 | Version 1.0.0 RC + submit review | Android/iOS RC production, upload và submit store |
| 2026-06-22 | Ngày dự phòng submit | Dùng nếu 6/19 chưa kịp |
| 2026-06-26 | Approve-ready | App đã approve hoặc đang xử lý nốt review issue |
| 2026-06-29 | Final go/no-go | ITEC quyết định public hoặc hoãn |
| 2026-06-30 | Production release | App public trên Google Play/App Store |
| 2026-07-01 đến 2026-07-03 | Monitoring | Crash/error/API/call/push/review được theo dõi |

## 10. Checklist ngày public production

- [ ] Store review đã approve cả Android và iOS.
- [ ] Không upload build mới sau approve.
- [ ] ITEC xác nhận bằng văn bản public ngày `2026-06-30`.
- [ ] Okada/ITEC sẵn sàng hỗ trợ MVE/SIP Phone nếu phát sinh lỗi.
- [ ] VTI sẵn sàng monitor app/API/log.
- [ ] Public/release production theo cơ chế manual release/managed publishing.
- [ ] Kiểm tra store listing hiển thị đúng app `ぷらっとCALL` version `1.0.0`.
- [ ] Cài mới/cập nhật app từ store trên Android.
- [ ] Cài mới/cập nhật app từ store trên iOS.
- [ ] Login bằng account test.
- [ ] Kiểm tra gọi đi/gọi đến/push/call flow chính.
- [ ] Ghi lại thời gian public, version/build, người thao tác, kết quả smoke test.

## 11. Theo dõi sau release

| Nhóm | Nội dung monitor | Owner đề xuất |
|---|---|---|
| App crash | Crash-free, fatal/non-fatal mới | VTI |
| API | Login, tenant/user, call/push API, error rate | VTI |
| MVE/SIP | Register/call/transfer/end call | Okada/ITEC, VTI hỗ trợ log |
| Store | Review/rating/reject follow-up nếu có | ITEC/VTI |
| Support | User report, issue phân loại hotfix/backlog | ITEC/VTI |

Hotfix trigger:

- App crash blocker sau launch/login/call.
- Không login được production.
- Push/call không hoạt động trên phần lớn thiết bị.
- SIP Phone/MVE production không liên kết được với mobile.
- Store metadata/privacy bị phản ánh sai nghiêm trọng.

## 12. Nội dung báo cáo trạng thái

### Sau khi submit

```text
Bên em đã submit bản ぷらっとCALL version 1.0.0 lên store.

- Android: version 1.0.0 / versionCode [VERSION_CODE] - trạng thái [status]
- iOS: version 1.0.0 / build [BUILD_NUMBER] - trạng thái [status]
- Thời gian submit: [ngày/giờ]
- Release mode: manual release/managed publishing

Bên em sẽ tiếp tục theo dõi trạng thái review. Nếu Apple/Google có câu hỏi hoặc reject, bên em sẽ phân tích và báo lại ngay.
```

### Sau khi approve

```text
Bản ぷらっとCALL version 1.0.0 đã được approve.

- Android: [status]
- iOS: [status]

Theo kế hoạch, app chưa public cho user ngay sau approve. Nhờ anh/chị xác nhận thời điểm public production dự kiến 2026-06-30. Sau khi nhận confirm, bên em sẽ tiến hành public và kiểm tra lại app trên store.
```

### Sau khi public

```text
Bên em đã public production bản ぷらっとCALL version 1.0.0 và kiểm tra nhanh trên store.

- Android: [store link/status/rollout %]
- iOS: [store link/status]
- Thời gian public: [ngày/giờ]
- Kết quả kiểm tra nhanh: app tải/cập nhật được, login được bằng account test, flow chính hoạt động.

Bên em sẽ tiếp tục monitor crash/error/API/call/push/review trong 24-72 giờ sau release.
```

## 13. Rủi ro chính

| Rủi ro | Dấu hiệu | Cách xử lý |
|---|---|---|
| Version chưa hạ/chốt đúng `1.0.0` | Store/build artifact còn `0.0.x` hoặc build cũ | Kiểm tra source, build artifact, store draft trước upload |
| Android `versionCode` không tăng | Play Console upload fail | Kiểm tra bản đã upload trước khi build/upload |
| iOS build number không tăng | App Store Connect không nhận/select build | Tăng build number nhưng giữ version `1.0.0` |
| Reviewer không login được | Reject/hỏi thêm account | Dùng reusable credentials, fixed OTP, test trước submit |
| Production API/secret trỏ nhầm staging | Reviewer thấy dữ liệu sai hoặc login lỗi | Verify endpoint/env/secret trước RC |
| MVE/SIP Phone chưa sẵn sàng | Call/push/transfer lỗi | Chốt trách nhiệm Okada/ITEC, chuẩn bị standby release day |
| Privacy/Data Safety sai | Required action/reject | Đối chiếu SDK/permission/data collection trước submit |
| Upload build mới sau approve | Có thể phải review lại | Chỉ upload build mới nếu blocker bắt buộc |
| Review kéo dài | Không kịp public 6/30 | Submit sớm, dùng ngày dự phòng 6/22, phản hồi review trong ngày |

## 14. Tài liệu tham khảo chính thức

- Apple - Submit an app: https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app/
- Apple - Overview of submitting for review: https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/overview-of-submitting-for-review/
- Google Play - Prepare your app for review: https://support.google.com/googleplay/android-developer/answer/9859455
- Google Play - Requirements for sign-in details: https://support.google.com/googleplay/android-developer/answer/15748846
- Google Play - Data safety section: https://support.google.com/googleplay/android-developer/answer/10787469
