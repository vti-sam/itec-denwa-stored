---
title: PRD/STG activation mismatch for test mobile user
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex PRD/STG read-only DB and API check on 2026-06-26
tags:
  - authentication
  - mobile
  - production
  - staging
  - account-activation
scope: historical
captured_at: 2026-06-26
validity: historical_context
promote_to_knowledge: false
---

2026-06-26: Khi điều tra user mobile `96tx1mrt2@mozmail.com` / SIP `11800`, PRD và STG có trạng thái khác nhau.

- PRD `denwa_prd`: `master_schema.account_mapping` có đúng một mapping `tenant_id=111`, `account_type=1`; `111_schema.users` có `user_status=3`, `role=2`, `phone_type=1`, `delete_flag=0`. Live API `https://api.apl.purattocall.com/auth/user/forgot-password` trả `ES200`.
- STG `denwa_stg`: cùng email có mapping `tenant_id=111`, `account_type=1`; `111_schema.users` có active row `user_status=0`, `role=2`, `user_name_sip=11800`, `phone_type=1`, `delete_flag=0`. Live API `https://api-stg.apl.purattocall.com/auth/user/forgot-password` trả `MSG_ERR_00064` (`アカウントはまだ有効化されていません。再度ご確認ください。`).

Kết luận vận hành tại thời điểm kiểm tra: lỗi "chưa kích hoạt" khớp với STG, không khớp với PRD hiện tại. Khi khách báo ảnh từ app nhưng Web PRD hiển thị `利用中`, cần kiểm tra app/build đang dùng production endpoint hay staging endpoint trước khi sửa dữ liệu PRD.

Update cùng ngày: đã đổi mobile STG config để trỏ về PRD endpoint nhằm tránh nhầm lẫn khi build lại app:

- Android `sources/denwa-android/env/env_staging.json`: `APPLICATION_ENDPOINT` và `SOCKET_ENDPOINT` đều trỏ `https://api.apl.purattocall.com`.
- iOS `sources/denwa-ios/Denwa/Denwa/Config/Environment/Staging.xcconfig`: `ROOT_URL` trỏ `https://api.apl.purattocall.com`.

Update tiếp theo: quyết định bỏ hẳn môi trường STG trong app để tránh nhầm lẫn.

- Android: xoá build type/config/script/source set STG, thêm build type/source set `dev`, chuyển Firebase Distribution command sang `:app:assembleDev :app:appDistributionUploadDev --groups=staging-testers`.
- Android Dev vẫn dùng `env_development.json`, trỏ API `https://api-dev.apl.purattocall.com`.
- iOS: xoá build configuration `Staging` khỏi Xcode project; `xcodebuild -project Denwa/Denwa.xcodeproj -list` chỉ còn `Debug` và `Release`.
- Deploy thử Android Dev build ban đầu upload fail ở bước `appDistributionUploadDev` với `403 PERMISSION_DENIED`. Sau khi đăng nhập `gcloud`, xác nhận service account `firebase-adminsdk-fbsvc@itec-denwa-vti-dev.iam.gserviceaccount.com` đã có `roles/firebaseappdistro.admin` trên project `itec-denwa-vti-dev`.
- Root cause upload 403: `app/src/dev/google-services.json` trỏ tới project number `481015855356`, trong khi project `itec-denwa-vti-dev` hiện tại là `16254034261`. Upload bằng `--appId=1:16254034261:android:03f0360f1c351309b58fdc` thành công, chứng minh IAM đúng và cấu hình app id bị lệch.
- Fix: cập nhật `app/src/dev/google-services.json` về project number `16254034261`, app id `1:16254034261:android:03f0360f1c351309b58fdc`, package `jp.co.itec.denwa.dev`, và bỏ client `jp.co.itec.denwa.stg` khỏi file Dev. Sau đó chạy command chuẩn có `clean` thì `:app:appDistributionUploadDev --groups=staging-testers` upload thành công.
- Firebase Console ban đầu không hiện app `.dev` vì Android app `jp.co.itec.denwa.dev` đang ở trạng thái soft-deleted (`state=DELETED`, `expireTime=2026-07-26`). Gọi Firebase Management API `:undelete` đã khôi phục app id `1:16254034261:android:03f0360f1c351309b58fdc` về `ACTIVE` và đổi display name thành `iTEC Denwa Dev`. Project hiện có 3 Android apps active: `.dev`, `.stg`, và production.
- Thay đổi tạm sau đó: Android Dev `env/env_development.json` được đổi `APPLICATION_ENDPOINT` từ `https://api-dev.apl.purattocall.com` sang `https://api.apl.purattocall.com` để bản Firebase Dev gọi PRD API. Sau đó đổi tiếp `SOCKET_ENDPOINT` từ `http://10.1.43.56:8080` sang `https://api.apl.purattocall.com` để giống production. Deploy lại thành công lên Firebase App Distribution app `.dev` với release `27g2ri8uunto8`; generated `BuildConfig.java` xác nhận cả `APPLICATION_ENDPOINT` và `SOCKET_ENDPOINT` đều là `https://api.apl.purattocall.com`.
- PRD Android App Distribution deploy: Release APK build/sign thành công sau khi map registry secret bằng env vars `DENWA_ANDROID_KEYSTORE_DIR` và `DENWA_ANDROID_ENV_SECRET_DIR`. Registry production distribution service account thuộc project `p-call-70ece` nên upload vào Firebase project `itec-denwa-vti-dev` bị 403; dùng service account `firebase-adminsdk-fbsvc@itec-denwa-vti-dev.iam.gserviceaccount.com` thì upload được. Release PRD `1es2opf1r66fo` được tạo cho app `jp.co.itec.denwa`, version `1.0.0_b(0055)_cd31c88`, với cả API/socket PRD. Firebase group `production-early-access-testers` được tạo mới và release đã distribute vào group này, nhưng group hiện có `testerCount=0`.
- Sau đó batch-add toàn bộ 29 tester từ group `staging-testers` sang `production-early-access-testers` bằng Firebase App Distribution API `groups:batchJoin`, rồi distribute lại release PRD `1es2opf1r66fo` vào group này. Verify group PRD có `testerCount=29`, `releaseCount=1`.
- Correction: Android PRD Firebase config and PRD API Firebase secret were still using `itec-denwa-vti-dev`, causing potential FCM sender mismatch for production login/push. Production Firebase project in registry is `p-call-70ece`, Android app `jp.co.itec.denwa`, app id `1:913584308098:android:c4b8fee95dccc28ab9d99b`. Updated `app/src/release/google-services.json` and `registry/keystore/projects/itec-denwa/android/firebase/production-google-services.json` from Firebase production API. Updated AWS secret `/denwa/prd/all` key `firebase-credentials-json` to production service account `firebase-adminsdk-fbsvc@p-call-70ece.iam.gserviceaccount.com`, then forced new ECS deployment for `denwa-backend-prd-service`; deployment completed. Rebuilt/redeployed Android PRD release to Firebase project `p-call-70ece`, release `3halbncmvhba0`, and copied 29 testers from dev `staging-testers` into production project group `production-early-access-testers`.
- Follow-up deploy: `app/src/release/google-services.json` was verified byte-for-byte equal to registry `android/firebase/production-google-services.json` and uploaded Release again to Firebase project `p-call-70ece`, app `jp.co.itec.denwa`, release `36kis8l7er2n0`. Local gotchas: Gradle/Kotlin fails under Java 25 (`IllegalArgumentException: 25.0.1`), so use JDK 21; build logic expects secret filenames `env_production.secrets.json` / `env_development.secrets.json`, while registry stores `production.secrets.json` / `development.secrets.json`, so use a temporary env directory with symlinks when building directly from registry.
- OTP follow-up: PRD DB `denwa_prd` had no OTP rows for `96tx1mrt2@mozmail.com` / SIP `11800`, and PRD CloudWatch logs after 10:20 JST had no `verify-otp`, `send-otp`, `resend-otp`, or email-match events for that user. STG DB `denwa_stg` had OTP rows for the same active user: reset-password OTP at 11:48 JST and login OTP at 11:50 JST, both `is_used=true`; STG CloudWatch showed email sends to the same address around 11:47-11:50 JST. This indicates the observed OTP activity was still hitting STG, not PRD. `last_login_time` remains null because `updateUserForLoginSuccess` does not update that column.
- Android cleanup follow-up: build type `dev` was removed again; Android now exposes only `debug` and `release`. `debug` keeps package suffix `.dev` (`jp.co.itec.denwa.dev`) so it can install alongside release, but uses `env_debug.json` with PRD API/socket. `app/src/debug/google-services.json` uses VTI Firebase dev app `.dev`; `app/src/release/google-services.json` uses production Firebase. `appDistributionDebug.sh` replaces `appDistributionDevelop.sh` and uploads `assembleDebug` to `staging-testers`.
