---
title: VOIP_APL-211 deleted iOS user keeps SIP session
project: itec-denwa
type: gotcha
status: archived
source:
  - https://itechh.backlog.jp/view/VOIP_APL-211
  - https://vti-corp.backlog.com/view/ITEC_DENWA_APP-266
  - sources/denwa-ios/Denwa/Denwa/Config/Service/ApiManage.swift
  - sources/denwa-ios/Denwa/Denwa/ClientModel/ACCallManager.swift
tags:
  - VOIP_APL-211
  - ITEC_DENWA_APP-266
  - iOS
  - SIP
  - logout
scope: historical
captured_at: 2026-07-24
validity: historical_context
promote_to_knowledge: false
---

Ticket KH `VOIP_APL-211` ghi nhận user đã bị xóa vẫn nhận và trả lời được cuộc gọi trên iOS. Luồng unauthorized hiện chỉ chuyển root view về màn hình đăng nhập, trong khi logout thủ công gọi `resetConfiguration()` để disconnect SIP.

Đã tạo ticket nội bộ `ITEC_DENWA_APP-266`, loại `Bug`, priority `中`, assign `VTI_SAM`. Summary là `VOIP_APL-211: [iOS] User đã bị xóa vẫn có thể nhận và nghe cuộc gọi`.

Phạm vi ticket yêu cầu forced logout phải hủy SIP registration và xóa call session trước khi mở màn hình đăng nhập. Android foreground đã có luồng `LogOutUseCase` gọi `callManager.logOut()` và được đưa vào regression test, không nằm trong phạm vi fix chính.
