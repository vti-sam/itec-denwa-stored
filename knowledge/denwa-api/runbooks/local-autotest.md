---
title: Runbook chạy autotest local cho denwa-api
project: denwa-api
type: runbook
status: confirmed
source:
  - User request 2026-06-20
  - Local verification commit 48bdeb50 on sources/denwa-api dev
tags:
  - denwa-api
  - autotest
  - api-it
  - testcontainers
  - local-dev
---

# Runbook chạy autotest local cho denwa-api

## Mục đích

Chạy bộ API integration test local trước khi deploy hoặc trước khi đánh giá bug UAT web. Bộ test hiện tại không hit môi trường DEV thật; test tự dựng DB và stub các dependency ngoài.

## Phạm vi test

- `VoipWebApiRegressionIT`: 104 case web gốc được map sang API/integration regression test.
- `AuthApiIT` và `AuthIpWhitelistDeniedIT`: 6 case auth/IP whitelist.
- Expected result hiện tại: `110 tests`, `0 failures`, `0 errors`.

## Yêu cầu local

- JDK 21 có trong `/usr/libexec/java_home -v 21`.
- Docker CLI và Colima đã cài trên máy.
- Colima chạy bằng QEMU hoặc Docker socket tương đương:

```bash
colima start --vm-type qemu
```

## Cách chạy nhanh

Từ workspace root:

```bash
./project-store/artifacts/scripts/run_denwa_api_it_local.sh
```

Script sẽ tự:

- Chuyển vào `sources/denwa-api`.
- Set `DOCKER_HOST=unix://$HOME/.colima/default/docker.sock` nếu chưa có.
- Set `TESTCONTAINERS_RYUK_DISABLED=true`.
- Set `JAVA_HOME` bằng `/usr/libexec/java_home -v 21`.
- Chạy `./mvnw -Papi-it verify`.

## Cách chạy thủ công

```bash
cd /Users/vti-sam/pm-control/itec-denwa/sources/denwa-api

DOCKER_HOST=unix://$HOME/.colima/default/docker.sock \
TESTCONTAINERS_RYUK_DISABLED=true \
JAVA_HOME=$(/usr/libexec/java_home -v 21) \
./mvnw -Papi-it verify
```

## Test harness hoạt động thế nào

- Testcontainers dùng Postgres local container.
- DB được reset bằng SQL fixture trước mỗi test.
- MVE được stub bằng HTTP server nội bộ trong test JVM.
- S3 được stub trong `ApiTestConfig`, không gọi AWS thật.
- Mail sender được stub/capture, không gửi mail thật.

## Lưu ý quan trọng

- Đây là local integration test, không phải post-deploy test trên DEV.
- Không cần seed dữ liệu lên DEV thật.
- Không cần deploy trước khi chạy.
- Nếu muốn chạy test trực tiếp lên DEV thật, cần một suite riêng có data sandbox/cleanup rõ ràng.

## Lỗi thường gặp

### Docker socket không kết nối được

Kiểm tra Colima:

```bash
colima status
docker --host unix://$HOME/.colima/default/docker.sock ps
```

Nếu chưa chạy:

```bash
colima start --vm-type qemu
```

### Ryuk timeout

Trên setup Colima/QEMU hiện tại, dùng:

```bash
TESTCONTAINERS_RYUK_DISABLED=true
```

Script đã set sẵn biến này.

### Sai Java version

Kiểm tra:

```bash
/usr/libexec/java_home -v 21
```

Nếu chưa có JDK 21 thì cần cài JDK 21 trước khi chạy.
