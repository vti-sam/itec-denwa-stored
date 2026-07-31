---
title: Tạo ticket nội bộ cho lỗi notification Message Android VOIP_APL-215
project: itec-denwa
type: requirement
status: archived
source:
  - https://itechh.backlog.jp/view/VOIP_APL-215
  - https://vti-corp.backlog.com/view/ITEC_DENWA_APP-270
tags:
  - VOIP_APL-215
  - ITEC_DENWA_APP-270
  - Android
  - Message
  - notification
scope: historical
captured_at: 2026-07-30
validity: historical_context
promote_to_knowledge: false
---

## Outcome

Đã tạo ticket nội bộ `ITEC_DENWA_APP-270` từ yêu cầu khách hàng
`VOIP_APL-215` để xử lý lỗi Android không nhận notification Message khi người
nhận đang mở đúng cuộc trò chuyện với người gửi rồi đưa ứng dụng xuống
background hoặc tắt màn hình.

Ticket nội bộ dùng summary
`VOIP_APL-215: [Android] Không nhận thông báo Message khi màn hình chat ở background/sleep`,
loại `Bug`, priority `中`, milestone `PRD-BUG-07/2026`, category `BUG` và
assignee `VTI_SAM`.

## Evidence

- Full issue reader xác nhận `VOIP_APL-215` có hai comment chỉ chứa change log,
  không có attachment, shared file, ảnh inline hoặc evidence URL bổ sung.
- Ticket nguồn ghi nhận lỗi trên Android `1.0.4_b (0065)` với người gửi
  `11111001` và người nhận `11111002`.
- Read-back `ITEC_DENWA_APP-270` xác nhận summary, description tiếng Việt,
  issue type, priority, milestone, category và assignee đúng payload; không có
  mojibake.
- Description nội bộ giữ các trường hợp đối chứng: lỗi không xảy ra khi ứng
  dụng đã bị task kill hoặc khi người nhận đang mở cuộc trò chuyện với người
  khác.

## Unresolved

- Chưa có evidence phân tích nguyên nhân, sửa source, test hoặc deploy.

## Retrieval keys

- `VOIP_APL-215`
- `ITEC_DENWA_APP-270`
- `Android Message notification background sleep`
- `11111001 11111002`
