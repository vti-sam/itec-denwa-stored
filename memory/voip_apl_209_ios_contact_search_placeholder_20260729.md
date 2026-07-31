---
title: VOIP_APL-209 iOS contact search placeholder fix
project: itec-denwa
type: lesson
status: archived
source:
  - Backlog VOIP_APL-209
  - Backlog ITEC_DENWA_APP-265
  - sources/denwa-ios/Denwa/Denwa/Modules/Contacts/Contacts/Controller/ContactsViewController.xib
tags:
  - VOIP_APL-209
  - ITEC_DENWA_APP-265
  - iOS
  - contacts
  - placeholder
scope: historical
captured_at: 2026-07-29
validity: historical_context
promote_to_knowledge: false
---

## Outcome

Đã sửa placeholder tìm kiếm danh bạ trên iOS từ `名前または番号で検索` thành
`名前または内線番号で検索`. Phạm vi chỉ gồm iOS XIB; logic tìm kiếm và Android
không thay đổi.

## Evidence

- Ticket nội bộ `ITEC_DENWA_APP-265` có 7 comment và 2 attachment. Comment
  `784568320` cùng ảnh QA xác nhận Android đã đúng, còn iOS vẫn hiển thị chuỗi
  cũ trước khi sửa.
- Ticket khách hàng `VOIP_APL-209` yêu cầu placeholder trên cả Android và iOS
  là `名前または内線番号で検索`.
- Source thay đổi tại
  `sources/denwa-ios/Denwa/Denwa/Modules/Contacts/Contacts/Controller/ContactsViewController.xib`.
  Sau sửa, chuỗi mới xuất hiện đúng một lần và chuỗi cũ không còn trong file.
- `xmllint --noout` pass cho XIB và `git diff --check` pass.
- Build `DevRelease` cho generic iOS Simulator với
  `CODE_SIGNING_ALLOWED=NO` hoàn tất thành công.

## Unresolved

- Chưa thực hiện retest trực tiếp trên thiết bị hoặc bản build DEV sau thay đổi.
- Chưa cập nhật trạng thái hay comment trên Backlog trong task này.

## Retrieval keys

- `VOIP_APL-209`
- `ITEC_DENWA_APP-265`
- `ContactsViewController.xib`
- `名前または番号で検索`
- `名前または内線番号で検索`
- iOS contact search placeholder
