---
title: iOS VOIP_APL-211 DEV TestFlight 1.0.5 build 43
project: itec-denwa
type: gotcha
status: archived
source:
  - https://itechh.backlog.jp/view/VOIP_APL-211
  - https://vti-corp.backlog.com/view/ITEC_DENWA_APP-266
  - sources/denwa-ios/Denwa/Denwa/Config/Service/ApiManage.swift
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.5-b43-20260724-161207-archive.log
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.5-b43-20260724-161207-export-upload.log
tags:
  - VOIP_APL-211
  - ITEC_DENWA_APP-266
  - ios
  - testflight
  - devrelease
  - build-43
scope: historical
captured_at: 2026-07-24
validity: historical_context
promote_to_knowledge: false
---

Đã sửa luồng forced logout trên iOS để `ApiManage.moveToLogin()` gọi `ACCallManager.resetConfiguration()` và `LocalResourceRepository.clearAllData()` trước khi chuyển sang màn hình đăng nhập. Fix nằm ở commit `3a08e5d03273920010e7f7b4c856462ae6aec3ce`.

Version release cuối là `1.0.5 (43)` tại commit `db74e739a33439a1a5abd2c3a8ca8489a79cc759`; cả app `Denwa` và `MVWebRTCNotificationServiceExtension` dùng cùng version/build. Hai commit đã push lên nhánh `prd`.

Archive `DevRelease` xác nhận bundle id `jp.co.itec.denwa.product`, API DEV `https://api-dev.apl.purattocall.com` và Firebase project DEV. App Store Connect trả về `Upload succeeded`, `Uploaded package is processing` và `EXPORT SUCCEEDED` lúc 16:15 JST.

Lần upload đầu với `1.0.4 (43)` bị từ chối vì version train `1.0.4` đã đóng sau khi phiên bản này được duyệt. Đã tăng marketing version lên `1.0.5` và upload lại thành công. Cảnh báo thiếu dSYM của các framework MVWebRTC/WebRTC đóng gói sẵn vẫn là cảnh báo không chặn upload.
