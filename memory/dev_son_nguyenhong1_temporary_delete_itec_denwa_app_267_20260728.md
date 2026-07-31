---
title: Tạm soft-delete account DEV để test ITEC_DENWA_APP-267
project: itec-denwa
type: lesson
status: stale
source:
  - Backlog ITEC_DENWA_APP-267
  - Live DEV database read-back on 2026-07-28
  - scratch/db-backups/denwa_dev_son_nguyenhong1_temp_delete_20260728T073701Z.json
  - sources/denwa-ios/Denwa/Denwa/Config/Service/EnumHandle.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/CallLogs/Dial/Controller/DialUseCase.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/CallLogs/CallLogs/Controller/CallLogViewController.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/CallLogs/CallLogDetail/Controller/CallLogDetailViewController.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/Contacts/ContactDetail/Controller/ContactDetailUseCase.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/Contacts/ContactDetail/Controller/ContactDetailViewModel.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/Contacts/ContactDetail/Controller/ContactDetailViewController.swift
  - sources/denwa-ios/Denwa/Denwa/Resources/Info.plist
  - sources/denwa-ios/Denwa/Denwa/Resources/Info-Production.plist
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/viewmodel/CallDestinationStatus.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/viewmodel/DenwaViewModel.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/call/dialer/host/contract/DialerViewModel.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/call/log/host/contract/CallLogViewModel.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/call/log/detail/contract/DetailCallLogViewModel.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/main/contact/detail/contract/DetailContactViewModel.kt
  - sources/denwa-android/app/src/test/java/jp/co/itec/denwa/ui/viewmodel/CallDestinationStatusTest.kt
  - iOS commit e6c5dfd4930cebfc75dcbfd53f49b9aa6cd6bb32
  - iOS prd commit e72cf214d99f4c14ea97c3267fa8e5b03554a6d6
  - Android commit 5819361810473880525a4c15fa7033c66547766d
  - scratch/ios-testflight/Denwa-fix-267-devrelease-v1.0.5-b44-20260728-180545.xcarchive
  - scratch/ios-testflight/Denwa-fix-267-devrelease-v1.0.5-b44-20260728-180545-export-upload.log
  - Firebase App Distribution release 6o1loftbn6o58
  - iOS commit ec3da04
  - Android commit e6d85cc
  - iOS prd merge commit 05fad25a9818ace3e7ca5ad2a5281354b748083f
  - Android prd merge commit 038f95e891fc64cc3423790111aaca1b3b66a03f
  - scratch/ios-testflight/Denwa-fix-267-devrelease-v1.0.5-b45-20260729-164257.xcarchive
  - scratch/ios-testflight/Denwa-fix-267-devrelease-v1.0.5-b45-20260729-164257-export-upload.log
  - Firebase App Distribution release 6fb7bcp1cda48
tags:
  - dev
  - database
  - mobile-user
  - account-deletion
  - ios
  - android
scope: historical
captured_at: 2026-07-28
validity: historical_context
promote_to_knowledge: false
---

## Outcome

Account `son.nguyenhong1@vti.com.vn` được tạm soft-delete trên database DEV
`denwa_dev` để User kiểm tra test case Backlog `ITEC_DENWA_APP-267`.

Target là tenant `112`, user UUID
`7969c23d-ba32-4f6d-ae19-559f9b3ac04c`. Trước thao tác, account đang active
với SIP `13005`, role `2`, `user_status = '3'`, `delete_flag = '0'` và có đúng
một mapping mobile `account_type = '1'`.

Thao tác đã đặt `user_status = '4'`, `delete_flag = '1'`, xóa SIP, xóa refresh
token và xóa mapping mobile. Password hash được giữ nguyên để có thể khôi phục
account sau khi test.

Sau khi User hoàn tất kiểm tra, account đã được khôi phục về trạng thái active
với `user_status = '3'`, `delete_flag = '0'`, SIP `13005` và đúng một mapping
mobile `son.nguyenhong1@vti.com.vn / 112 / 1`. Refresh token tiếp tục để trống
để account đăng nhập lại bằng password hiện có.

Theo yêu cầu test tiếp theo của User, account đã được soft-delete lần hai. Lần
này thao tác mô phỏng đúng mapper xoá của BE: chỉ đặt `user_status = '4'`,
`delete_flag = '1'`, cập nhật audit/version và xoá mapping mobile; SIP `13005`,
password và refresh token được giữ nguyên.

Đã xác nhận regression trên iOS: màn lịch sử chỉ chặn theo
`receiverDeleteFlag`, nên có thể vẫn gọi được account đã xoá khi dữ liệu lịch
sử đang cache hoặc bản ghi cuộc gọi mới có `receiver_id = NULL`. Luồng gọi
chính trên iOS đã được sửa tại Dial, danh sách lịch sử và chi tiết lịch sử:
ngay trước khi chuyển sang màn gọi, ứng dụng kiểm tra đích qua
`/users/details-by-phone`; nếu BE trả `phone.notfound` thì hiển thị
`Constants.destinationNotFound` và không tạo cuộc gọi SIP. Xử lý maintenance
và stopped tenant hiện có được giữ nguyên.

Android có cùng nguyên nhân ở bước kiểm tra trước cuộc gọi: helper cũ chỉ trả
HTTP status, còn Dial, danh sách lịch sử và chi tiết lịch sử chỉ chặn 403/503,
nên HTTP 400 có key `phone.notfound` vẫn đi tiếp tới SIP. Đã thêm resolver dùng
chính xác `keyMessage = phone.notfound` và áp dụng cho ba luồng này. Khi target
không tồn tại, Android hiển thị `msg_contact_unavailable` và dừng trước
`CallManager.makeCall`; maintenance, forbidden và behavior của lỗi 400 khác
được giữ nguyên.

Retest ngày 2026-07-29 phát hiện entry point Danh bạ chưa được cover trên iOS:
Contact Detail vẫn chỉ dựa vào `deleteFlag` từ dữ liệu cache, nên account đã
xóa vẫn có thể đi tới SIP call. Đã chuyển Contact Detail iOS sang dùng cùng
`resolveCallDestinationStatus` cho cả audio và video, đồng thời giữ lớp kiểm
tra `deleteFlag` hiện có. Android Contact Detail cũng còn dùng
`checkMaintenanceBeforeCall`; đã chuyển sang `checkCallDestinationBeforeCall`
để giữ nguyên FORBIDDEN/MAINTENANCE và bổ sung chặn `phone.notfound` trước
`CallManager.makeCall`.

Các thay đổi Contact Detail bổ sung ngày 2026-07-29 đã được commit và phát hành
lại trên DEV. Android dùng commit `e6d85cc`, bản
`1.0.4.dev_b(0065)_e6d85cc`, Firebase release `6fb7bcp1cda48`. iOS dùng
commit `ec3da04`, cấu hình `DevRelease`, version `1.0.5 (45)` và TestFlight
Internal. Build number `45` hiện là thay đổi local trong file project sau khi
upload.

Ngày 2026-07-29, build number `45` được commit vào nhánh iOS ticket tại
`a9a7cda`. Nhánh `fix/ITEC_DENWA_APP-267` đã được merge và push vào `prd` của
cả hai nền tảng. Android `prd` trỏ tới merge commit `038f95e`; iOS `prd` trỏ
tới merge commit `05fad25`. Conflict iOS chỉ nằm tại sáu build number `44/45`
trong file project và được resolve thành `45`; thay đổi VOIP_APL-209 đã có trên
`prd` được giữ nguyên.

Hai bản DEV chứa fix đã được phát hành để kiểm tra thiết bị. iOS dùng nhánh
`fix/ITEC_DENWA_APP-267` tại commit `e6c5dfd`, cấu hình `DevRelease`, version
`1.0.5 (44)` và TestFlight internal. Android dùng cùng nhánh ticket tại commit
`5819361`, bản Debug `1.0.4.dev_b(0065)_5819361`, Firebase project
`itec-denwa-vti-dev` và nhóm `staging-testers`.

Fix iOS cùng build number `44` đã được fast-forward và push lên nhánh `prd` tại
commit `e72cf21`. Hai plist DEV và Production đều khai báo
`ITSAppUsesNonExemptEncryption = false` để các bản upload tiếp theo không phải
trả lời lại câu hỏi export compliance khi ứng dụng chỉ dùng encryption thuộc
diện miễn trừ.

## Evidence

- Transaction chỉ chạy khi `current_database()` là `denwa_dev`, target có đúng
  UUID, login, trạng thái active, SIP `13005` và đúng một mapping tenant `112`.
- Post-update read-back xác nhận active row count bằng `0`, mapping count bằng
  `0`, target row có `user_status = '4'`, `delete_flag = '1'`, SIP rỗng,
  refresh token rỗng và password vẫn được cấu hình.
- Snapshot không chứa secret nằm tại
  `scratch/db-backups/denwa_dev_son_nguyenhong1_temp_delete_20260728T073701Z.json`.
- Trước restore, read-back xác nhận không có account active nào khác dùng email
  `son.nguyenhong1@vti.com.vn` hoặc SIP `13005`, và không còn mapping của email
  này.
- Transaction restore cập nhật đúng một user row và tạo đúng một mapping.
- Read-back độc lập sau restore xác nhận target có `user_status = '3'`,
  `delete_flag = '0'`, SIP `13005`, role `2`, password vẫn được cấu hình,
  refresh token rỗng, không có SIP conflict và mapping count bằng `1`.
- Trước lần xoá thứ hai, target đang active với SIP `13005`, password và
  refresh token được cấu hình, cùng đúng một mapping mobile tenant `112`.
- Transaction xoá lần hai cập nhật đúng một user row và xoá đúng một mapping.
- Read-back độc lập xác nhận target có `user_status = '4'`, `delete_flag = '1'`,
  vẫn giữ SIP `13005`, password và refresh token; active target count,
  `details-by-phone` match count và mapping count đều bằng `0`.
- Dữ liệu DEV xác nhận các lịch sử cũ gọi tới `13005` có `receiver_id` là UUID
  của Son và join ra `receiverDeleteFlag = '1'`, trong khi các cuộc gọi mới
  ngày 2026-07-28 có `receiver_id = NULL`, làm cờ xoá trong response lịch sử
  bị rỗng.
- Resolver iOS kiểm tra chính xác error key `phone.notfound` do BE trả về và
  dùng chung cho Dial, danh sách lịch sử và chi tiết lịch sử.
- `git diff --check` pass; CodeGraph đồng bộ lại 10 file và nhận diện resolver
  mới.
- Build iOS Debug và Release cho simulator đều thành công với exit code `0`.
- Unit test Android `CallDestinationStatusTest` gồm 5 case đã pass: success,
  exact `phone.notfound`, generic HTTP 400, maintenance và forbidden.
- Android Debug APK build thành công; `git diff --check` pass và CodeGraph đã
  đồng bộ 6 file, nhận diện `resolveCallDestinationStatus`.
- Android Release compile/build bị chặn trước task compile bởi thiếu private
  signing config và production environment secret của workspace, không phải
  compiler error từ source thay đổi.
- Archive iOS read-back xác nhận bundle `jp.co.itec.denwa.product`, version
  `1.0.5 (44)`, API `https://api-dev.apl.purattocall.com`, Google plist
  Development và Firebase project `itec-denwa-vti-dev`.
- App Store Connect trả `Uploaded package is processing`, `Upload succeeded`
  và `EXPORT SUCCEEDED` lúc 18:10 JST ngày 2026-07-28. Cảnh báo thiếu dSYM của
  các framework MVWebRTC/WebRTC đóng gói sẵn không chặn upload.
- Android resolver/test được commit và push lên
  `fix/ITEC_DENWA_APP-267` tại `5819361`; unit test hẹp pass trước commit.
- Contact Detail iOS dùng chung resolver cho cả audio và video; `.unavailable`
  hiển thị `Constants.destinationNotFound`, `.blocked` giữ nguyên maintenance
  và stopped tenant, còn `.available` tiếp tục permission/call flow.
- Contact Detail Android dùng `checkCallDestinationBeforeCall`;
  `UNAVAILABLE` hiển thị `msg_contact_unavailable`, `FORBIDDEN` và
  `MAINTENANCE` giữ behavior cũ, chỉ `AVAILABLE` mới đi tới
  `CallManager.makeCall`.
- Năm unit test `CallDestinationStatusTest` pass và Android Debug APK build
  thành công sau khi bổ sung Contact Detail.
- iOS `DevRelease` và production `Release` build cho generic Simulator đều
  thành công sau khi bổ sung Contact Detail.
- `git diff --check` pass trên cả hai source repo và CodeGraph đã sync lại ba
  file iOS cùng một file Android thay đổi.
- Firebase Gradle upload kết thúc `BUILD SUCCESSFUL`; output metadata xác nhận
  package `jp.co.itec.denwa.dev`, version code `65`, version name
  `1.0.4.dev_b(0065)_5819361`. Firebase release ID là `6o1loftbn6o58`.
- `plutil` xác nhận hai source plist hợp lệ và cùng trả
  `ITSAppUsesNonExemptEncryption = false`.
- Build iOS `DevRelease` và `Release` cho simulator đều thành công. Read-back
  từ cả hai app bundle xác nhận bundle identifier `jp.co.itec.denwa.product`,
  build number `44` và export compliance flag bằng `false`.
- Sau push, read-back Git xác nhận local `prd` và `origin/prd` cùng trỏ tới
  commit `e72cf21`.
- Firebase Gradle upload ngày 2026-07-29 kết thúc `BUILD SUCCESSFUL`; package
  `jp.co.itec.denwa.dev`, version code `65`, version name
  `1.0.4.dev_b(0065)_e6d85cc`, nhóm `staging-testers` và release ID
  `6fb7bcp1cda48`.
- Archive iOS ngày 2026-07-29 read-back xác nhận bundle
  `jp.co.itec.denwa.product`, version `1.0.5 (45)`, API
  `https://api-dev.apl.purattocall.com`, Google plist
  `GooglePlistDevelopment` và `ITSAppUsesNonExemptEncryption = false`.
- App Store Connect trả `Uploaded package is processing`, `Upload succeeded`
  và `EXPORT SUCCEEDED` cho build `1.0.5 (45)`. Cảnh báo thiếu dSYM của các
  framework MVWebRTC/WebRTC đóng gói sẵn không chặn upload.
- Sau merge, Android chạy pass năm unit test `CallDestinationStatusTest` và
  `assembleDebug` kết thúc `BUILD SUCCESSFUL`; iOS `DevRelease` build cho
  generic Simulator thành công với code signing bị tắt.
- Read-back remote xác nhận `origin/prd` Android và local cùng trỏ tới
  `038f95e891fc64cc3423790111aaca1b3b66a03f`; `origin/prd` iOS và local cùng
  trỏ tới `05fad25a9818ace3e7ca5ad2a5281354b748083f`.

## Unresolved

Account đang được giữ ở trạng thái soft-delete để User tiếp tục test. Sau khi
test xong phải restore đúng UUID về `user_status = '3'`, `delete_flag = '0'`,
giữ SIP `13005`, tạo lại mapping `son.nguyenhong1@vti.com.vn / 112 / 1` và
read-back độc lập trước khi chuyển memory về `archived`.

Chưa smoke test trên thiết bị iOS thật/TestFlight. Source hiện không có test
target tự động khả dụng cho luồng gọi này, nên verification hiện tại dựa trên
code flow, read-back DB và build Debug/Release.

Chưa smoke test Android trên thiết bị thật. Cần xác nhận cả bàn phím, lịch sử
và chi tiết lịch sử đều hiện dialog và không mở luồng gọi với SIP `13005`.
Release build cần private keystore và production environment secret mới có thể
verify đầy đủ.

Cần retest bổ sung audio và video từ Contact Detail/Danh bạ trên cả iOS và
Android, xác nhận `phone.notfound` hiển thị thông báo và không tạo SIP call.
Hai bản DEV mới chứa thay đổi Contact Detail đã được phát hành ngày 2026-07-29
và sẵn sàng cho retest sau khi TestFlight xử lý xong.

TestFlight build `1.0.5 (44)` cũ vẫn có thể cần xử lý `Missing Compliance` thủ
công. Build `1.0.5 (45)` mới đã chứa
`ITSAppUsesNonExemptEncryption = false`. Cần smoke test hai bản DEV trên thiết
bị trước khi chốt ticket.

## Retrieval keys

- ITEC_DENWA_APP-267
- son.nguyenhong1@vti.com.vn
- 7969c23d-ba32-4f6d-ae19-559f9b3ac04c
- tenant 112
- SIP 13005
- phone.notfound
- iOS call history receiverDeleteFlag
- iOS direct dial destination validation
- Android phone.notfound call validation
- Android dialpad call history detail
- iOS contact detail phone.notfound
- Android contact detail phone.notfound
- contacts cached deleteFlag
- iOS TestFlight DEV 1.0.5 build 44
- iOS TestFlight DEV 1.0.5 build 45
- iOS commit ec3da04
- iOS prd 05fad25
- iOS prd e72cf21 export compliance
- ITSAppUsesNonExemptEncryption false
- Firebase release 6o1loftbn6o58
- Firebase release 6fb7bcp1cda48
- Android 1.0.4.dev_b(0065)_5819361
- Android 1.0.4.dev_b(0065)_e6d85cc
- Android prd 038f95e
- temporary soft delete
- restore DEV mobile account
