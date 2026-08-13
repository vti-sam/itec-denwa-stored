---
title: Backlog VOIP_APL-197 to VOIP_APL-204 mobile issues
project: itec-denwa
type: decision
status: archived
source:
  - Codex session creating customer Backlog issues on 2026-07-13
tags:
  - backlog
  - android
  - ios
  - customer
scope: historical
captured_at: 2026-07-13
validity: historical_context
promote_to_knowledge: false
---

Created eight Japanese customer Backlog issues in project `VOIP_APL` and assigned all of them to `VTI サム`.

- `VOIP_APL-197`: neutral default icon, type `要望`, priority `低`
- `VOIP_APL-198`: network error after device unlock, type `バグ`, priority `中`
- `VOIP_APL-199`: missing logo on first iOS launch, type `バグ`, priority `中`
- `VOIP_APL-200`: missing contacts-screen indicator on iOS, type `バグ`, priority `低`
- `VOIP_APL-201`: error saving an automatic call-forwarding contact, type `バグ`, priority `高`
- `VOIP_APL-202`: Android settings screen becomes unresponsive after closing password change with the device Back button, type `バグ`, priority `中`
- `VOIP_APL-203`: outgoing call error on Android 11, type `バグ`, priority `高`
- `VOIP_APL-204`: shortened and accelerated voicemail playback from Android 13, type `バグ`, priority `高`

All issues were read back after creation. Summary, description, type, priority, assignee, and Japanese text were correct.

## Đồng bộ sang Backlog VTI

Ngày 2026-07-13, tám ticket phía KH đã được đồng bộ sang dự án nội bộ `ITEC_DENWA_APP` và assign cho `VTI_SAM`:

- `VOIP_APL-197` → `ITEC_DENWA_APP-252`
- `VOIP_APL-198` → `ITEC_DENWA_APP-253`
- `VOIP_APL-199` → `ITEC_DENWA_APP-254`
- `VOIP_APL-200` → `ITEC_DENWA_APP-255`
- `VOIP_APL-201` → `ITEC_DENWA_APP-256`
- `VOIP_APL-202` → `ITEC_DENWA_APP-257`
- `VOIP_APL-203` → `ITEC_DENWA_APP-258`
- `VOIP_APL-204` → `ITEC_DENWA_APP-259`

Không đồng bộ `VOIP_APL-205` về SIP Phone vì phía VTI đã có ticket tương ứng.

`ITEC_DENWA_APP-256` ghi nhận kết luận mới nhất: KH đã chốt vô hiệu hóa chức năng tự động chuyển tiếp cuộc gọi. Phạm vi đối ứng nội bộ là loại bỏ màn hình và điểm truy cập liên quan trên Android/iOS, thay vì tiếp tục sửa luồng lưu cũ.

Ngày 2026-07-17, đã kiểm tra và chuẩn hóa liên kết giữa hai Backlog:

- Title của `ITEC_DENWA_APP-252` đến `ITEC_DENWA_APP-259` giữ mã ticket KH theo format `[KH: VOIP_APL-xxx]`.
- Description của từng task VTI đã được bổ sung URL trực tiếp tới ticket KH tương ứng `VOIP_APL-197` đến `VOIP_APL-204` trong mục `Nguồn`.
- Đã read-back đủ tám task sau khi cập nhật; title, URL và nội dung UTF-8 đều đúng.
- Đã tạo milestone nội bộ `PRD-BUG-07/2026` không có ngày bắt đầu/kết thúc và gắn vào đủ tám task VTI.
- Đã verify bằng bộ lọc milestone; kết quả chỉ gồm `ITEC_DENWA_APP-252` đến `ITEC_DENWA_APP-259`.
