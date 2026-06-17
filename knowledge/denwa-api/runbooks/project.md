---
title: Dự án API Backend (denwa-api project scope & stack)
project: itec-denwa
type: runbook
status: confirmed
source:
  - sources/denwa-api/pom.xml
  - sources/denwa-api/README.md
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/DenwaApiApplication.java
  - sources/denwa-api/src/main/resources/application.properties
tags:
  - api
  - backend
  - java
  - spring-boot
---

# Dự án API Backend (denwa-api project)

## Phạm vi (Scope)

- Mã nguồn của API Backend nằm dưới thư mục: `/Users/vti-sam/itec-denwa/sources/denwa-api`.
- Tài liệu README phần lớn vẫn là mẫu mặc định của GitLab, do đó hãy dựa vào cấu trúc mã nguồn và tệp cấu hình Maven để xem các thông tin kỹ thuật chi tiết.

## Công nghệ sử dụng (Stack)

- Java 17.
- Spring Boot 3.4.3.
- Spring Web, Spring Security.
- MyBatis.
- PostgreSQL, Redis.
- Firebase Admin.
- AWS S3/SQS.
- Maven wrapper (`mvnw`).

## Cấu trúc thư mục (Structure)

- Mã nguồn Java nằm dưới thư mục `src/main/java/jp/co/itec/denwa`.
- Các file XML của MyBatis nằm dưới thư mục `src/main/resources/jp/co/itec/denwa/mapper`.
- Các file cấu hình môi trường nằm dưới thư mục `src/main/resources/config`.
- Điểm khởi chạy chính (Main entrypoint): `jp.co.itec.denwa.DenwaApiApplication`.

## Quy ước (Conventions)

- Giữ nguyên tiền tố gói (package prefix) `jp.co.itec.denwa`.
- Lớp lưu trữ dữ liệu (persistence) thường đi đôi giữa interface mapper và file cấu hình XML chứa mã SQL tương ứng.
- Lombok được hỗ trợ và sử dụng trong dự án.
- Ưu tiên sử dụng các mô hình controller/service/mapper hiện có.
- Đảm bảo các thay đổi được kiểm soát trong phạm vi hẹp; tránh refactor trên phạm vi quá rộng.

## Các lệnh thường dùng (Commands)

- Kiểm tra trạng thái git: `rtk git status --short`
- Tìm kiếm văn bản: `rtk rg "pattern" src/main/java src/main/resources`
- Chạy kiểm thử: `rtk ./mvnw test`
- Đóng gói ứng dụng bỏ qua kiểm thử: `rtk ./mvnw -DskipTests package`
- Chạy ứng dụng cục bộ nếu môi trường đã cấu hình: `rtk ./mvnw spring-boot:run`
