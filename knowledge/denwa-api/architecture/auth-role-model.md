---
title: Mô hình role và lưu trữ account của Denwa
project: itec-denwa
type: architecture
status: confirmed
verified_at: 2026-06-19
stale_after: 2026-09-19
source:
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/constant/enums/TypeRole.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/constant/enums/TypeAccount.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/config/SecurityConfig.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/service/auth/AuthService.java
  - sources/denwa-api/src/main/resources/jp/co/itec/denwa/mapper/accountmapping/AccountMappingMapper.xml
  - sources/denwa-front/src/constants/constant.ts
  - sources/denwa-front/src/router/index.ts
  - sources/denwa-front/src/components/common/Sidebar.vue
  - Live DEV/PRD read-only DB verification on 2026-06-19
tags:
  - authentication
  - authorization
  - role
  - account-mapping
  - mve-admin
  - database
---

# Mô hình role và account

Hệ thống có tổng cộng bốn role. Web quản trị sử dụng ba role; mobile app sử dụng một role.

| Giá trị | Enum | Tên Nhật | Client | Quyền chính |
|---:|---|---|---|---|
| `0` | `SYSTEM_ADMIN` | システム管理者 | Web | Quản trị hệ thống và tenant |
| `1` | `TENANT_ADMIN` | テナント管理者 | Web | Quản trị user trong một tenant |
| `2` | `USER` | ユーザー | Mobile app | Người dùng ứng dụng |
| `3` | `MVE_ADMIN` | MVE管理者 / 岡田電機管理者 | Web | Màn hình 岡田電機管理 và API MVE |

Frontend chỉ khai báo ba role Web: `SYSTEM_ADMIN`, `TENANT_ADMIN` và `MVE_ADMIN`. Route `/admin/maintenance` yêu cầu `MVE_ADMIN` và được hiển thị với nhãn `岡田電機管理`.

## Vị trí lưu account

| Role | Bảng | Giá trị `role` |
|---|---|---:|
| System admin | `master_schema.admin` | `0` |
| Tenant admin | `<tenant_id>_schema.admin` | `1` |
| Mobile user | `<tenant_id>_schema.users` | `2` |
| MVE admin | `master_schema.admin` | `3` |

System admin và MVE admin đều là master admin về mặt lưu trữ. Quyền thực tế được phân biệt bằng cột `role` và authority trong JWT/Spring Security.

## Phân biệt `role` và `account_type`

`role` và `account_type` là hai khái niệm khác nhau:

- `role` xác định quyền nghiệp vụ: `0`, `1`, `2`, `3` theo bảng role ở trên.
- `account_type` trong `master_schema.account_mapping` chỉ phân biệt loại bản ghi đăng nhập:
  - `0`: admin.
  - `1`: user.

Không được suy luận `account_type=1` là `role=1`.

| Loại account | `tenant_id` trong mapping | `account_type` |
|---|---|---:|
| System admin | `master` | `0` |
| MVE admin | `master` | `0` |
| Tenant admin | ID tenant tương ứng | `0` |
| Mobile user | ID tenant tương ứng | `1` |

## Trường hợp 岡田電機管理者

`岡田電機管理者` tương ứng với `MVE_ADMIN`, vì vậy account Web phải được lưu trong `master_schema.admin` với `role=3` và mapping `master / account_type=0`.

Cùng một email có thể đồng thời tồn tại trong hai context độc lập:

- Web MVE admin: `master_schema.admin`, `role=3`.
- Mobile user của tenant: `<tenant_id>_schema.users`, `role=2`.

Nếu mobile user đã tồn tại nhưng thiếu MVE admin, không chuyển bản ghi user từ role `2` sang role `3`. Phải giữ user hiện tại và tạo thêm master admin role `3` cùng mapping master tương ứng.

Tại thời điểm verify ngày 2026-06-19, cả DEV và PRD đều có đúng hai context active cho account Okada: master MVE admin role `3` và tenant user role `2`.

## Authorization và IP whitelist

- `/mve-admin/**` yêu cầu authority `MVE_ADMIN`.
- Các API system admin yêu cầu authority `SYSTEM_ADMIN`.
- Các API tenant admin yêu cầu authority `TENANT_ADMIN`.
- Các API mobile user yêu cầu authority `USER`.

Khi account thuộc master:

- Role `0` được kiểm tra bằng `ip.whitelist.system.admin`.
- Role `3` được kiểm tra bằng `ip.whitelist.mve.admin`.

Whitelist là cấu hình global theo role, không phải quan hệ IP–account trong database. Thay đổi whitelist cần cập nhật cấu hình ứng dụng và deploy backend; chỉ sửa DB không làm whitelist có hiệu lực.

## Quy tắc vận hành

- Mật khẩu phải được lưu bằng BCrypt qua `PasswordEncoder`; không lưu plaintext trong source, knowledge, log hoặc script.
- Khi tạo master admin, phải tạo cả bản ghi `master_schema.admin` và mapping `master / account_type=0`.
- Kiểm tra explicit account active trước khi insert/update vì `admin_name` không có unique constraint trong schema đã verify.
- Script dữ liệu phải idempotent và verify lại role, mapping cùng BCrypt trước khi commit.
- Khi tài liệu đã quá `stale_after`, kiểm tra lại enum source và DB metadata trước khi dùng làm căn cứ thay đổi production.
