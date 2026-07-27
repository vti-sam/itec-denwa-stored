---
title: iOS concurrent JWT refresh race fix
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-16
  - applog_1.0.3_A7DFE1CE-4CBC-4658-8821-7A250CEEFA10_20260716153055.txt
  - sources/denwa-ios/Denwa/Denwa/Config/Service/ApiManage.swift
tags:
  - ios
  - jwt
  - refresh-token
  - concurrency
scope: historical
captured_at: 2026-07-16
validity: historical_context
promote_to_knowledge: false
---

# Hiện tượng

- Build DEV `1.0.3 (37)` hiện dialog `JWTトークンの有効期限が切れました` dù API refresh-token trả `ES200`.
- Log lúc 14:59:30 và 15:30:45 cho thấy `/calls/list` và `/conversations` cùng trả `ACCESS_TOKEN_EXPIRED`.
- Chỉ `/calls/list` được retry sau refresh; `/conversations` đẩy message lỗi lên UI.

# Nguyên nhân

- `ApiManage` kiểm tra access token tại thời điểm xử lý response.
- Request đầu tiên reset access token trước khi refresh, khiến request hết hạn thứ hai thấy token đã mất và không tham gia refresh.
- Việc dùng một `task` dùng chung và cancel trong response handler có thể cancel nhầm request song song.
- Commit `e564818` làm race này lộ ra thành dialog khi thêm nhánh propagate lỗi cho request không có access token; thiết kế refresh không đồng bộ đã tồn tại trước đó.

# Cách sửa local

- Ghi nhận trạng thái authenticated khi request được tạo.
- Dùng lock và callback queue để chỉ chạy một refresh-token tại một thời điểm.
- Tất cả request hết hạn đồng thời chờ một refresh rồi retry với token mới.
- Không reset access token trước refresh; xoá riêng Authorization khỏi request refresh-token và chỉ reset access token khi refresh thất bại.
- Giới hạn auth retry một lần để tránh vòng lặp vô hạn.
- Không cancel `ApiManage.task` trong handler 401 vì task response hiện tại đã hoàn thành và biến dùng chung có thể đang trỏ tới request khác.

# Verify

- `git diff --check`: pass.
- `xcodebuild` scheme/configuration `DevRelease`, generic iOS device, `CODE_SIGNING_ALLOWED=NO`: exit code 0.
- Warning compiler còn lại thuộc dependency hoặc source cũ, không phát sinh từ `ApiManage.swift`.
- Chưa commit, push hoặc upload TestFlight bản có fix.
