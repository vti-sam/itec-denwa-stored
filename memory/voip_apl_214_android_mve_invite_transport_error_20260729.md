---
title: VOIP_APL-214 Android MVE INVITE transport error
project: itec-denwa
type: gotcha
status: stale
source:
  - ITEC_DENWA_APP-84
  - VOIP_APL-214
  - MVE SIP/system log 2026-07-29 18:18 JST
  - Android log 2026-07-30 13:58 JST
  - Android ApplicationExitInfo and native tombstones 2026-07-30
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/main/MainActivity.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/viewmodel/DenwaViewModel.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/call/log/host/contract/CallLogNetworkRecovery.kt
  - sources/denwa-android/app/src/main/java/jp/co/itec/denwa/ui/call/log/host/contract/CallLogViewModel.kt
  - sources/denwa-android/app/src/test/java/jp/co/itec/denwa/ui/call/log/host/contract/CallLogNetworkRecoveryTest.kt
  - sources/denwa-android/call/libs/webrtcsdk-release.aar
  - sources/denwa-android/call/src/main/java/vn/com/vti/call/impl/AudioCodecCallManager.kt
  - sources/denwa-android/call/src/main/java/vn/com/vti/call/impl/SipOperationGate.kt
  - sources/denwa-android/call/src/test/java/vn/com/vti/call/impl/SipNetworkChangePolicyTest.kt
  - sources/denwa-android/call/src/test/java/vn/com/vti/call/impl/SipOperationGateTest.kt
  - sources/denwa-android/call/src/test/java/vn/com/vti/call/impl/SipRecoveryPolicyTest.kt
  - sources/denwa-android/common/src/main/java/jp/co/itec/common/util/NetworkUtils.kt
  - sources/denwa-android commit 42b7cae0849318d95e16aee5085d3e34575a4d2d
  - sources/denwa-android commit 8ada2013165e40e76843ada4f28dffec062c5117
  - sources/denwa-android commit 6c738b8
  - sources/denwa-android commit 5e6d605fac426862513f01ce1155ef51002bd666
  - Google Drive file 1RFRrJstHb2EJW1bjwigh873IedO0oj3b
  - Google Drive file 1ei0CSAZmb3TBbSfjnc5RLVk3WSLFG33x
  - Google Drive file 1x7Lpgw-yPUsaLabRHRhib04ENNBnMBOX
  - Firebase App Distribution release 6ri7fin2tvh8o
tags:
  - android
  - mve
  - sip
  - invite
  - transport-error
  - native-crash
  - webrtc
scope: historical
captured_at: 2026-07-29
validity: historical_context
promote_to_knowledge: false
---

# Outcome

- Đã tạo ticket khách hàng `VOIP_APL-214` để nhờ 岡田電気 điều tra lỗi Android không nhận được SIP INVITE sau khi nhận push.
- Ticket được tạo dưới loại Bug, ưu tiên High, category MVE, giao cho 【岡田電機】野崎 祐也.
- Đã đính kèm log Android đã che thông tin nhạy cảm, trích đoạn MVE SIP log đã che thông tin nhạy cảm và video tái hiện.
- Phương án local dùng network-generation gate và `setRegistration(true)` đã được revert về `origin/prd` vì vẫn chưa giải quyết dứt điểm hiện tượng để app background lâu.
- Phương án hibernate SIP sau 10 phút ở background đã bị loại bỏ và code liên quan đã được đưa về `origin/prd`.
- Phương án local hiện tại trên Android `prd`: authenticate thông thường tái sử dụng registration đang hợp lệ; riêng incoming/register FCM push được phép warm recovery có kiểm soát để MVE chuyển pending INVITE xuống.
- User báo hiện tượng phía nhận của bug 84 đã hết trên thiết bị test hiện tại; chưa có end-to-end evidence độc lập để đóng toàn bộ ticket.
- Phát hiện thêm incident phía máy gọi: app có thể native crash khi người dùng mở app rồi gọi ngay trong lúc luồng `onResume` đang reconnect SIP. Đã triển khai hard guard, loading và dialog retry; chưa test lại trên máy thật.
- Đã build và upload APK DEV chứa hard guard/loading/retry lên `Denwa Object/Android` trên Google Drive. Riêng APK này được bật quyền tải cho bất kỳ ai có link sau khi link giới hạn tài khoản không dùng được.
- Đã commit fix tại `42b7cae0849318d95e16aee5085d3e34575a4d2d` và fast-forward `origin/prd` từ `983e3cd` lên commit này; read-back remote xác nhận SHA khớp.
- Các thay đổi local không thuộc fix trong `MainApplication.kt`, `ProfileUi.kt`, `env_debug.json` và `env_production.json` không được stage hoặc push.
- Chưa cài APK lên thiết bị hoặc chạy lại scenario crash trên máy thật.
- Phát hiện dialog mạng chung có thể xuất hiện khi màn lịch sử cuộc gọi khôi phục từ background và paging API chạy trước khi Android xác nhận Internet hoạt động. Đã triển khai local recovery riêng cho Call Log, giữ cache và không hiển thị dialog chặn màn hình cho lỗi `IOException` của paging.
- Đã build và upload APK DEV chứa Call Log network recovery lên `Denwa Object/Android`; file Drive được bật quyền tải bằng link và raw anonymous read-back trả HTTP `200`.
- Đã nâng Android DEV lên `1.0.4 (66)`, push source lên `origin/prd` và publish thành công Firebase App Distribution release `6ri7fin2tvh8o` cho group `staging-testers`.

# Evidence

- API gửi FCM thành công ở lần đầu và Android nhận push ưu tiên cao.
- Full-screen Intent được phép và màn hình `接続中` đã hiển thị, nên đây không phải lỗi thiếu quyền Full-screen Intent trong lần tái hiện này.
- MVE nhận REGISTER của `11213027` trên TCP port `42937` lúc `18:18:16.092` và trả `SIP/2.0 200 OK` lúc `18:18:16.093`.
- MVE gửi INVITE tới Contact mới ngay sau REGISTER, nhưng khoảng 168 ms sau ghi nhận `AcSIPCall::TransactionFail` với nguyên nhân `Transport Error`.
- MVE trả `SIP/2.0 408 Request Timeout` cho call leg phía phát và kết thúc hai call leg bằng `GWAPP_RECOVERY_ON_TIMER_EXPIRY / GENERAL_FAILED`.
- Call phía phát tồn tại trên MVE khoảng 3.98 giây.
- Android SDK ghi nhận `603 restarting SIP account`, sau đó `503 Unknown error 503`, rồi `200`; tuy nhiên MVE SIP log của lần tái hiện không có REGISTER response 503 tương ứng.
- Sau đó kết nối đăng ký của `11213027` tiếp tục đổi và TCP flow dùng cho INVITE bị loại bỏ.
- Bytecode của `webrtcsdk-release.aar` xác nhận khi không có active session, `handleNetworkChange()` đặt `shouldReregister`, gọi `register()`, phát `603 restarting SIP account`, xóa PJSIP account hiện tại rồi tạo account mới.
- Push handler trước fix gọi `authenticate(false)`, sau đó nhánh warm reconnect gọi `handleNetworkChange()` chỉ dựa trên `sdkLoggedIn` và SIP manager initialized, không yêu cầu evidence rằng Android network đã thực sự thay đổi.
- Android log ngày 2026-07-30 cho thấy REGISTER vừa nhận `200` thì app ghi `Warm SIP reconnect via handleNetworkChange`; SDK lập tức phát `603 restarting SIP account`, recreate account rồi mới trở lại `200`. Điều này xác nhận lần `603` đó do app kích hoạt SDK recovery, không phải MVE trả SIP 603.
- Trong cùng log, cuộc gọi `13025 → 13026` bị MVE trả `404 RELEASE_BECAUSE_NO_USER_FOUND`; đây là lỗi account/routing riêng, không phải chuỗi `603 → 200`.
- Android log lúc `14:42:56` cho thấy phương án chỉ reuse registration làm FCM push kết thúc ngay tại `Reusing existing SIP registration without network recovery`; không có REGISTER mới và placeholder incoming UI giữ `sessionId=-1`. Evidence này bác bỏ việc bỏ hoàn toàn warm recovery khỏi incoming push.
- Android `ApplicationExitInfo` trên Pixel 10a, Android 16, package `jp.co.itec.denwa.dev` version `1.0.4.dev_b(0065)_983e3cd` ghi nhận nhiều lần `APP CRASH(NATIVE)`, gồm `17:09:51` và `17:51:11` ngày 2026-07-30 với status `6`.
- Native tombstone của hai lần crash trên đều là `SIGABRT` ở thread `pool-16-thread-*`. Backtrace đi qua `libjingle_peerconnection_so.so` → `Java_org_webrtc_PeerConnectionFactory_nativeFreeFactory` → `org.webrtc.PeerConnectionFactory.dispose` → `com.audiocodes.mv.webrtcsdk.webrtc.ACWebRTCManager.deinitWebRTCInternal`.
- Vì tiến trình bị abort trong native WebRTC teardown nên không có Java `FATAL EXCEPTION` hoặc `AppLogger` hoàn chỉnh cho thời điểm crash.
- Source hiện tại xác nhận `MainActivity.onResume()` khởi chạy `callManager.authenticate(forceLogout = false)` bất đồng bộ, trong khi `AudioCodecCallManager.makeCall()` chỉ được bảo vệ bằng `makeCallMutex` và chưa chờ `sipAuthenticationMutex`. Điều này cho phép thao tác gọi bắt đầu khi SIP/WebRTC reconnect vẫn đang chạy.
- Bytecode SDK xác nhận `AudioCodesUA.logout()` gọi `ACWebRTCManager.deinitWebRTC()`, còn `deinitWebRTC()` chờ executor hoàn tất `deinitWebRTCInternal()` bằng `Future.get()`; đây là đường trực tiếp tới `PeerConnectionFactory.dispose()` trong tombstone.

# Android fix local đã revert

- Incoming push và `authenticate(false)` khi app resume dùng `setRegistration(true)` trên PJSIP account hiện tại và SDK executor; không dùng `handleNetworkChange()` làm thao tác wake SIP.
- Explicit credential update và force logout vẫn dùng full authentication; nếu existing account không sẵn sàng trong lúc có active call thì giữ nguyên call và không fallback full authentication.
- Push, resume và network recovery được serialize bằng `sipAuthenticationMutex`. Chỉ các request resume được coalesce với nhau; incoming push không bị dedupe vì chưa có `callId/sessionId`, nhưng một push/network/full-auth thành công có thể bao phủ các request resume đang chờ.
- Chỉ còn một `NetworkCallback` sống xuyên suốt vòng đời manager, không còn bị tạo/hủy theo trạng thái `603 → 200`.
- Baseline active network chỉ được ghi nhận một lần khi tracker khởi tạo. Callback cùng network handle bị bỏ qua; lost→available hoặc đổi network handle tạo một generation mới.
- Network generation được ghi ngay khi callback tới, kể cả SIP đang unauthenticated. Generation chưa xử lý được giữ pending, defer khi có active call và chỉ đánh dấu hoàn tất sau recovery thành công hoặc full authentication đã bao phủ đúng generation đó.
- `handleNetworkChange()` chỉ còn một call site, nằm sau network-generation gate; push, resume và credential flow không gọi trực tiếp.
- Unit test mới `SipRecoveryPolicyTest`: 16 test pass cho phân loại nguồn authenticate, baseline/callback trùng, lost→available, đổi network, generation đến trong recovery, coalesce resume và bảo đảm incoming push không bị drop.
- `:app:assembleDebug`: pass, tạo APK DEV `itec-denwa_debug_1.0.4.dev_b(0065)_038f95e.apk`.
- Full `:call:testDebugUnitTest` chạy 47 test: 46 pass và còn một failure cũ ngoài diff tại `MissedCallResolutionPolicyTest.normalTermination_stillDismissesIncomingNotification`.
- Google Drive read-back xác nhận file `itec-denwa_debug_1.0.4.dev_b(0065)_038f95e.apk`, kích thước `133102357` byte, SHA-256 `91f0c750f3f130b9e328820617f1be5085ede0d0ae7dbc8e1637f3dec43192cd`, file ID `1RFRrJstHb2EJW1bjwigh873IedO0oj3b`.

# Android fix đã push lên prd ngày 2026-07-30

- Authenticate thông thường, bao gồm app resume, chỉ tái sử dụng SIP khi app đang authenticated và SDK vẫn registered; luồng này không gọi `tryWarmReconnectBeforeLogin()` hoặc `handleNetworkChange()`.
- Incoming/register FCM push chụp generation của lần SIP registration thành công gần nhất rồi đi qua một entry point riêng. Chỉ entry point này được gọi `tryWarmReconnectBeforeLogin()`.
- Nếu đã có registration success generation mới sau khi push tới, push được coi là đã được bao phủ và không gọi `handleNetworkChange()` lần nữa. Nếu chưa có và warm SIP runtime sẵn sàng, app gọi recovery đúng một lần.
- Sau `handleNetworkChange()`, app chờ một registration success generation mới thay vì pass ngay vì giá trị `isAuthenticated=true` cũ. Mutex được giữ trong lúc chờ nên các push trùng được generation mới bao phủ, không tạo warm recovery chồng nhau.
- Nếu warm SIP runtime không sẵn sàng hoặc không sinh registration mới trong 5 giây, luồng fallback sang full login hiện có.
- `SipNetworkChangeTracker` dùng callback đầu tiên làm baseline, bỏ callback `onAvailable` trùng network và bỏ `onLost` cũ không thuộc active network. Recovery chỉ được phát khi lost→available, sau `onUnavailable`, hoặc khi network handle thực sự đổi.
- Không dùng `distinctUntilChanged()` bên ngoài tracker vì observer có thể được tạo lại và generation bắt đầu lại từ `1`; giữ operator này có thể nuốt một lần đổi mạng hợp lệ.
- Network recovery và authentication dùng chung `sipAuthenticationMutex`. Nếu đổi mạng trong active call, recovery được đánh dấu pending và thực hiện sau khi call kết thúc.
- `handleNetworkChange()` còn ba call site có kiểm soát: FCM warm recovery có registration-generation gate, callback đổi mạng đã xác minh và deferred recovery sau active call.
- `SipOperationGate` thay mutex authentication cũ để serialize authentication, logout, network recovery và bước tạo outgoing session. `makeCall()` giữ gate từ lúc chờ/recover SIP đến khi `AudioCodesUA.call()` tạo xong session.
- Timeout 15 giây chỉ bao quanh bước chờ gate và chuẩn bị SIP. Sau khi SDK bắt đầu `AudioCodesUA.call()`, timeout không còn áp dụng để tránh SDK đã tạo session nhưng UI lại cho retry tạo cuộc gọi trùng.
- Nếu foreground reconnect đến sau khi cuộc gọi đã bắt đầu, authenticate thường được skip. Force logout và incoming push giữ logic riêng, không bị policy này chặn.
- Bốn luồng gọi thường từ dialpad, contact detail, call log và call-log detail dùng loading chặn thao tác. Hết timeout, loading đóng và dialog cho phép `再試行` hoặc `キャンセル`; retry chạy lại đúng entry point ban đầu.
- `SipOperationGateTest` và `SipNetworkChangePolicyTest`: pass, bao phủ call chờ authentication, timeout không tạo call, SDK call không bị timeout sau khi bắt đầu, authentication chờ call creation và foreground reconnect skip khi call đã active.
- `:app:compileDebugKotlin` và `:app:assembleDebug`: pass; APK DEV là `itec-denwa_debug_1.0.4.dev_b(0065)_c21ee08.apk`.
- `:app:testDebugUnitTest`: pass.
- Full `:call:testDebugUnitTest` chạy 47 test: 46 pass; còn một failure cũ ngoài diff tại `MissedCallResolutionPolicyTest.normalTermination_stillDismissesIncomingNotification`.
- Google Drive read-back xác nhận APK kích thước `133119673` byte, SHA-256 `bf41a3893465109edd0cbd973e486157e81860bf2c35494e196575a2cc9f763c`, file ID `1ei0CSAZmb3TBbSfjnc5RLVk3WSLFG33x`.
- Kiểm tra ẩn danh sau khi cập nhật quyền trả HTTP `200`, `Content-Disposition: attachment` và `Content-Length: 133119673` tại raw download URL của file.
- Commit `42b7cae0849318d95e16aee5085d3e34575a4d2d` đã được push trực tiếp lên `origin/prd`; remote read-back trả đúng commit này. Dải fast-forward từ `983e3cd` bao gồm cả commit nền `c21ee08`.
- Chưa cài lên thiết bị hoặc chạy end-to-end background lâu với MVE.

# Android Call Log foreground network recovery local ngày 2026-07-30

- Dialog trong ảnh dùng cùng một nội dung cho `NoConnectivityException`, connect/socket timeout và unknown host; ảnh đơn lẻ không phân biệt được exception gốc.
- Luồng `MainActivity.onResume()` reconnect SIP chỉ log exception và không phát dialog này. Call Log paging gọi `Throwable.resolve()` khi remote refresh lỗi nên là nguồn phù hợp với dialog đang hiển thị trên màn lịch sử.
- Call Log paging hiện giữ dữ liệu Room cache và không gọi generic blocking dialog khi gặp `IOException`.
- Recovery chờ `NetworkCapabilities.NET_CAPABILITY_VALIDATED` tối đa 5 giây rồi yêu cầu paging refresh một lần. Các lỗi đồng thời dùng chung một recovery; retry được giới hạn bằng cooldown 30 giây để tránh vòng lặp.
- Log mới ghi exception gốc và kết quả recovery gồm `RETRY_REQUESTED`, `NETWORK_UNAVAILABLE`, `ALREADY_RECOVERING` hoặc `COOLDOWN`.
- Test đỏ ban đầu thất bại vì chưa có `CallLogNetworkRecovery` và `networkFailureOrNull`; sau khi triển khai, `CallLogNetworkRecoveryTest` pass bốn case: wrapped IOException, retry/cooldown, concurrent coalescing và network unavailable.
- `:app:testDebugUnitTest`, `:common:testDebugUnitTest` và `:app:assembleDebug`: pass.
- APK local `itec-denwa_debug_1.0.4.dev_b(0065)_42b7cae.apk` có kích thước `133119669` byte và SHA-256 `4705498715186aeebf0e2dcf9a330c7c374ae2785d46aa5f334bfffe2ef2fa79`.
- APK được upload với tên `itec-denwa_debug_1.0.4.dev_b(0065)_42b7cae_calllog-network-recovery.apk`, Drive file ID `1x7Lpgw-yPUsaLabRHRhib04ENNBnMBOX`. Drive read-back khớp kích thước và SHA-256; raw anonymous download trả HTTP `200`, `Content-Disposition: attachment` và `Content-Length: 133119669`.
- APK được build từ working tree hiện tại nên ngoài Call Log recovery còn chứa bốn thay đổi local đã tồn tại từ trước cho nút gửi debug log: `MainApplication.kt`, `ProfileUi.kt`, `env_debug.json` và `env_production.json`.
- Fix Call Log đã được commit tại `8ada2013165e40e76843ada4f28dffec062c5117` và fast-forward push lên `origin/prd`; remote read-back trả đúng SHA này.
- Tại thời điểm tạo APK Drive, bốn thay đổi cho nút gửi debug log/config chưa nằm trong commit `8ada201`; chúng được commit sau tại `6c738b8` trước lần publish Firebase build 66. APK Drive được build trước các commit này nên version suffix vẫn là `42b7cae`; SHA-256 dùng để định danh chính xác artifact.
- Chưa test Call Log recovery trên thiết bị thật.

# Android DEV Firebase 1.0.4 build 66 ngày 2026-07-30

- Bốn thay đổi cho nút gửi debug log và cấu hình `REPORT_LOG_ENABLED` được commit tại `6c738b8`; debug bật report log, production tắt report log.
- `DenwaVersion.VERSION_CODE` được nâng từ `65` lên `66`, giữ `VERSION_NAME=1.0.4`, tại commit `5e6d605fac426862513f01ce1155ef51002bd666`.
- Hai commit được fast-forward push lên `origin/prd`; remote read-back và local `prd` cùng trỏ tới `5e6d605fac426862513f01ce1155ef51002bd666`.
- Workflow dùng JDK 21, clean build variant `debug`, package `jp.co.itec.denwa.dev`, Firebase project `itec-denwa-vti-dev`, app id `1:16254034261:android:03f0360f1c351309b58fdc` và tester group `staging-testers`.
- Gradle `:app:assembleDebug` và `:app:appDistributionUploadDebug` kết thúc `BUILD SUCCESSFUL` sau 4 phút 37 giây.
- Firebase release ID `6ri7fin2tvh8o`; Console URL `https://console.firebase.google.com/project/itec-denwa-vti-dev/appdistribution/app/android:jp.co.itec.denwa.dev/releases/6ri7fin2tvh8o?utm_source=gradle`; tester URL `https://appdistribution.firebase.google.com/testerapps/1:16254034261:android:03f0360f1c351309b58fdc/releases/6ri7fin2tvh8o?utm_source=gradle`.
- APK metadata read-back xác nhận version code `66`, version name `1.0.4.dev_b(0066)_5e6d605`, kích thước `133119673` byte và SHA-256 `32802f58eb5dc402a003d4f259d86a6f36b0e0cd366d3d6545c01314cb4ddbfa`.
- Android worktree sạch sau publish.

# Unresolved

- Backtrace xác nhận vị trí crash trong AudioCodes/WebRTC teardown nhưng chưa chứng minh thao tác app nào trực tiếp gọi `deinitWebRTCInternal()`.
- Giả thuyết ưu tiên cần kiểm chứng: người dùng gọi ngay trong lúc `onResume` reconnect khiến `AudioCodesUA.call()` chạy đồng thời với SDK deinit/reinit `PeerConnectionFactory`.
- Hard guard, loading, timeout và retry đã được triển khai và verify local nhưng chưa test trên thiết bị; chưa có evidence xác nhận crash native đã hết.
- Cần thu log liên tục từ trước `onResume` đến native abort và đối chiếu timestamp của `authenticate`, `internalLogOut`, `handleNetworkChange`, login state và `makeCall`.
- Đã xác nhận app/SDK recreate PJSIP account trong thời điểm wake là điều kiện trực tiếp làm TCP Contact không ổn định; chưa có low-level socket error để kết luận phía nào phát FIN/RST.
- Chưa xác định Android SDK code 503 có phải là ánh xạ nội bộ từ Transport Error/408 hay là lỗi độc lập không xuất hiện trong MVE SIP trace.
- Chưa xác định cấu hình MVE giữ pending INVITE/call bao lâu trong luồng đánh thức bằng push và vì sao call kết thúc sau khoảng 4 giây.
- Đang chờ 岡田電気 điều tra MVE SIP/system log, việc chuyển Contact/TCP flow và đề xuất xử lý phía MVE.
- Chưa chạy end-to-end trên thiết bị với app background/screen off và MVE; build/test local chưa chứng minh cuộc gọi thực tế đã hết lỗi.
- Chưa có log exception đúng thời điểm dialog Call Log xuất hiện để xác nhận đó là `NoConnectivityException`, timeout hay unknown host; recovery xử lý chung các `IOException` của paging.
- Chưa tái hiện Call Log foreground network recovery trên thiết bị thật; unit test/build và raw APK read-back chưa chứng minh popup đã hết trong điều kiện thực tế.

# Retrieval keys

- ITEC_DENWA_APP-84
- VOIP_APL-214
- 11213026 11213027
- MVE v.7.40A.603.319
- Android SDK 603 503 200
- INVITE Transport Error
- REGISTER 200 OK
- SIP 408 Request Timeout
- GWAPP_RECOVERY_ON_TIMER_EXPIRY
- Full-screen Intent
- handleNetworkChange
- SipNetworkChangeTracker
- reuse existing SIP registration
- registration generation at push
- incoming push warm recovery
- caller native crash
- SIGABRT PeerConnectionFactory dispose
- ACWebRTCManager deinitWebRTCInternal
- onResume reconnect makeCall race
- Pixel 10a Android 16
- setRegistration true
- restarting SIP account
- NetworkChangeTracker
- NetworkRecoveryGate
- SipReregisterRequestGate
- rejected background 10-minute SIP hibernate
- Call Log foreground network dialog
- CallLogNetworkRecovery
- NET_CAPABILITY_VALIDATED
- 1x7Lpgw-yPUsaLabRHRhib04ENNBnMBOX
- Android DEV 1.0.4 build 66
- Firebase release 6ri7fin2tvh8o
