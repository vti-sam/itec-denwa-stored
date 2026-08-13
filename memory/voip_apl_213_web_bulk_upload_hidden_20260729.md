---
title: VOIP_APL-213 chốt ẩn upload hàng loạt khi tenant đang sử dụng
project: itec-denwa
type: decision
status: archived
source:
  - https://itechh.backlog.jp/view/VOIP_APL-213
  - https://vti-corp.backlog.com/view/ITEC_DENWA_APP-269
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/controller/tenant/TenantController.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/controller/user/UserController.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/service/user/UserService.java
  - sources/denwa-front/src/views/tenant-management/TenantDetails.vue
tags:
  - VOIP_APL-213
  - ITEC_DENWA_APP-269
  - Web
  - tenant
  - bulk-upload
scope: historical
captured_at: 2026-07-29
validity: historical_context
promote_to_knowledge: false
---

## Outcome

Khách hàng và VTI đã chốt phương án 1 cho `VOIP_APL-213`: trên màn hình
chi tiết tenant của System Admin, khi tenant ở trạng thái “Đang sử dụng” thì
không hiển thị nút upload user hàng loạt.

Đã tạo task nội bộ `ITEC_DENWA_APP-269` với summary
`VOIP_APL-213: [Web] Ẩn nút upload user hàng loạt khi tenant đang sử dụng`,
loại `Task`, priority `中`, milestone `PRD-BUG-07/2026`, category `BUG`,
assignee `VTI_SAM`, start date và deadline `2026-07-29`.

Phạm vi không bao gồm bổ sung xử lý gọi MVE API. Luồng upload user khi tenant
ở trạng thái “Chờ đăng ký” phải được giữ nguyên.

Ngày 2026-07-29, description của `ITEC_DENWA_APP-269` được cập nhật để xác
nhận phạm vi sửa chỉ áp dụng cho màn hình System Admin. Luồng thêm user của
Tenant Admin đang đồng bộ MVE bình thường, không nằm trong phạm vi thay đổi và
phải tiếp tục hoạt động như hiện tại.

## Evidence

- Ticket khách hàng `VOIP_APL-213` mô tả hiện tượng user được thêm trên Web
  nhưng số không được thêm trên MVE khi System Admin upload cho tenant đang
  “Đang sử dụng”, đồng thời đề xuất ưu tiên phương án không cho phép thao tác.
- Read-back `ITEC_DENWA_APP-269` xác nhận đúng summary có tag `[Web]`, nội
  dung phương án 1, metadata đã duyệt và tiếng Việt UTF-8 không bị mojibake.
- Link ticket nguồn được ghi trực tiếp trong description của ticket nội bộ.
- Source hiện tại xác nhận System Admin gọi `processInsertUser(..., false)`
  nên chỉ lưu DB và không phát event đồng bộ MVE ngay, trong khi Tenant Admin
  gọi cùng service với `true` nên phát event đồng bộ MVE sau transaction.
- Read-back sau cập nhật xác nhận description ghi rõ chỉ sửa System Admin,
  không thay đổi luồng Tenant Admin.

## Unresolved

- Chưa có evidence triển khai source code, test hoặc deploy; memory này chỉ
  xác nhận quyết định phạm vi và việc tạo ticket nội bộ.

## Retrieval keys

- `VOIP_APL-213`
- `ITEC_DENWA_APP-269`
- `tenant Đang sử dụng`
- `ẩn nút upload user hàng loạt`
- `Web bulk upload MVE`
