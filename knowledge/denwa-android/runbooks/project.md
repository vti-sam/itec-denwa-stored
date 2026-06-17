---
title: Dự án Android (denwa-android project scope & build)
project: itec-denwa
type: runbook
status: confirmed
source:
  - sources/denwa-android/README.md
  - sources/denwa-android/settings.gradle.kts
  - sources/denwa-android/build.gradle.kts
  - sources/denwa-android/app/build.gradle.kts
tags:
  - android
  - build
  - env
---

# Dự án Android (denwa-android project)

## Phạm vi (Scope)

- Thư mục mã nguồn của ứng dụng Android: `/Users/vti-sam/itec-denwa/sources/denwa-android`.
- Các file riêng tư (private) của Android nằm dưới đường dẫn `/Users/vti-sam/itec-denwa/sources/android-private-files` hoặc được đưa vào thư mục `env/` của Android tùy thuộc vào cấu trúc checkout hiện tại.
- Tuyệt đối không sao chép khóa riêng tư/nội dung bảo mật dạng thô vào bộ nhớ (memory).

## Build/Môi trường (Build/env)

- Build production yêu cầu các file `denwa_production.jks` và `keystore.json` nằm dưới thư mục `env/`.
- Khóa phân phối Firebase (Firebase distribution keys) được đặt dưới thư mục `env/distribution/`.
- Tài liệu README hướng dẫn cấu hình biến `ITEC_PROJECT_DIR=your_root_project_dir` cho các script phân phối.
- Các script phân phối bao gồm: `appDistributionDevelop.sh`, `appDistributionStagingInternal.sh`, `appDistributionStaging.sh`, `appDistributionProductionEarlyAccess.sh`.
- Trên máy này, Gradle/Kotlin gặp sự cố khi chạy dưới Java 25; vui lòng sử dụng Java 21, ví dụ: `JAVA_HOME=/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home`.

## Cấu trúc thư mục môi trường riêng tư (Private env layout)

- Các file dự kiến bao gồm:
  - `env/keystore.json`
  - `env/vti_developer.jks`
  - `env/vti_staging.jks`
  - `env/denwa_production.jks`
  - `env/distribution/itec-denwa-distribution-key.json`
  - `env/distribution/itec-denwa-distribution-dev-key.json`
- Plugin ký ứng dụng (Signing plugin) đọc cấu hình ký từ `${rootProject.projectDir}/env/keystore.json` và các file JKS từ thư mục `${rootProject.projectDir}/env/`.
- Kiểu build Release (Release build type) sử dụng tên cấu hình ký là `production`.

## Xác minh (Verification)

- Các lệnh kiểm tra phạm vi hẹp thường dùng:
  - `rtk env JAVA_HOME=/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home ./gradlew :app:compileDebugKotlin`
  - `rtk env JAVA_HOME=/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home ./gradlew :app:compileStagingKotlin`
  - Các lệnh kiểm tra riêng cho Manifest đối với thay đổi về sao lưu (backup): `:app:processDebugManifest`, `:app:processStagingManifest`.
