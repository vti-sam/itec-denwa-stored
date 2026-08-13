---
title: ITEC_DENWA_APP-264 iOS permissions DEV TestFlight 1.0.5 build 46
project: itec-denwa
type: gotcha
status: stale
source:
  - https://vti-corp.backlog.com/view/ITEC_DENWA_APP-264
  - https://itechh.backlog.jp/view/VOIP_APL-210
  - sources/denwa-ios/Denwa/Denwa/Config/Helpers/PermissionManager.swift
  - sources/denwa-ios/Denwa/Denwa/Modules/Main/MainViewController.swift
  - sources/denwa-ios commit 8de5d651182def96abe018c5f78a18bcd5c5a889
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.5-b46-20260730-135901-archive.log
  - scratch/ios-testflight/Denwa-prd-devrelease-v1.0.5-b46-20260730-135901-export-upload.log
tags:
  - ITEC_DENWA_APP-264
  - VOIP_APL-210
  - ios
  - permissions
  - callkit
  - testflight
  - devrelease
  - build-46
scope: historical
captured_at: 2026-07-30
validity: historical_context
promote_to_knowledge: false
---

## Outcome

Lỗi iOS khi nhận cuộc gọi trong lúc màn hình khóa và quyền microphone/camera
chưa từng được hỏi xuất phát từ nhánh background coi trạng thái chưa xác định
như quyền bị từ chối, sau đó reject SIP session ngay.

Fix tại commit `8de5d651182def96abe018c5f78a18bcd5c5a889` chủ động yêu cầu các quyền cuộc
gọi còn chưa xác định khi màn hình chính xuất hiện hoặc ứng dụng trở lại active.
Quyền đã bị từ chối không bị hỏi lặp lại.

Bản DEV TestFlight `1.0.5 (46)` chứa fix đã được upload thành công và đang được
App Store Connect xử lý.

## Evidence

- Source branch `prd` sạch và đồng bộ `origin/prd` tại commit `8de5d65` trước
  khi archive.
- Archive dùng scheme/configuration `DevRelease`, bundle id
  `jp.co.itec.denwa.product`, version/build `1.0.5 (46)`.
- Notification extension dùng cùng version/build `1.0.5 (46)`.
- Archive read-back xác nhận `ROOT_URL=https://api-dev.apl.purattocall.com`,
  `GOOGLE_PLIST_FILE_NAME=GooglePlistDevelopment` và Firebase project
  `itec-denwa-vti-dev`.
- App Store Connect trả về `Upload succeeded`, `Uploaded package is processing`
  và `EXPORT SUCCEEDED` lúc 14:02 JST ngày 2026-07-30.
- Cảnh báo thiếu dSYM của các framework MVWebRTC/WebRTC đóng gói sẵn không chặn
  upload.

## Unresolved

- Chưa hoàn tất kiểm tra bằng iPhone thật cho audio/video incoming khi màn hình
  khóa. Cần xác nhận thứ tự popup notification, microphone và camera; sau đó
  kiểm tra CallKit không tự ngắt và media hoạt động hai chiều.
- File `sources/denwa-ios/Denwa/Denwa.xcodeproj/project.pbxproj` đang giữ thay
  đổi local tăng build từ `45` lên `46`; chưa commit hoặc push theo phạm vi đã
  duyệt.
- Memory giữ trạng thái `stale` cho đến khi có kết quả test thiết bị.

## Retrieval keys

- ITEC_DENWA_APP-264
- VOIP_APL-210
- iOS microphone camera undetermined permission
- CallKit locked screen incoming call
- DevRelease 1.0.5 build 46
- commit 8de5d65
