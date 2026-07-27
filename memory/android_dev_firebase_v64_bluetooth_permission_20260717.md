---
title: Android DEV Firebase v64 Bluetooth Android 11 fix
project: itec-denwa
type: lesson
status: archived
source:
  - Codex session Android 11 outgoing call Bluetooth permission fix and Firebase DEV release
tags:
  - android
  - android-11
  - bluetooth
  - firebase-app-distribution
  - deployment
scope: historical
captured_at: 2026-07-17
validity: historical_context
promote_to_knowledge: false
---

Ngày 2026-07-17, bản Android DEV v64 được build và upload lên Firebase App Distribution để sửa lỗi gọi đi trên Android 11: phía gọi hiện lỗi trước khi mở màn hình cuộc gọi trong khi phía nhận vẫn đổ chuông.

- Source: `sources/denwa-android`, nhánh `prd`, commit nền `bcd2519fc30195e2173e72bd3dfa6fd4321dedc5`.
- Thay đổi: thêm `android.permission.BLUETOOTH` với `android:maxSdkVersion="30"`; giữ `android.permission.BLUETOOTH_CONNECT` cho Android 12 trở lên.
- Version code: `64`.
- Version hiển thị: `1.0.2.dev_b(0064)_bcd2519`.
- Variant/package: `debug`, `jp.co.itec.denwa.dev`.
- Firebase project/group: `itec-denwa-vti-dev`, `staging-testers`.
- Firebase release id: `6edat8aakun2g`.
- Firebase Console: `https://console.firebase.google.com/project/itec-denwa-vti-dev/appdistribution/app/android:jp.co.itec.denwa.dev/releases/6edat8aakun2g?utm_source=gradle`.
- Tester link: `https://appdistribution.firebase.google.com/testerapps/1:16254034261:android:03f0360f1c351309b58fdc/releases/6edat8aakun2g?utm_source=gradle`.

Verification:

- `:app:assembleDebug` thành công.
- APK xác nhận package `jp.co.itec.denwa.dev`, version code `64`, version name `1.0.2.dev_b(0064)_bcd2519`.
- Manifest trong APK có `android.permission.BLUETOOTH` với `maxSdkVersion=30` và `android.permission.BLUETOOTH_CONNECT`.
- `:app:appDistributionUploadDebug` thành công; Gradle kết thúc với `BUILD SUCCESSFUL`.
- Source Android đã được push lên `origin/prd`: commit avatar `b816bc7`, sau đó commit quyền Bluetooth và version 64 `77a4206`.

Gotcha vận hành:

- Repo Android có sẵn thay đổi local ở ảnh placeholder. Bản Firebase được build trong worktree sạch riêng để không đóng gói thay đổi ngoài scope.
- Worktree riêng cần liên kết `local.properties` từ checkout chính để tìm Android SDK; credential Firebase vẫn đọc từ đường dẫn local của checkout chính và không được sao chép vào worktree.
