---
title: Phát hành mobile production 1.0.2 ngày 2026-07-13
project: itec-denwa
type: runbook
status: archived
source:
  - Codex session 2026-07-13
  - sources/denwa-ios
  - sources/denwa-android
tags:
  - ios
  - android
  - app-store-connect
  - google-play
  - production
  - release-1.0.2
scope: historical
captured_at: 2026-07-13
validity: historical_context
promote_to_knowledge: false
---

Đã chốt thay đổi, nâng phiên bản, commit và push nhánh `prd` cho hai ứng dụng.

## iOS

- Build 28 bị đánh dấu chỉ dành cho TestFlight nội bộ do `testFlightInternalTestingOnly = true` trong ExportOptions, nên không thể chọn để gửi App Review.
- Đã nâng phiên bản/build lên `1.0.2 (29)` cho app và extension.
- Commit: `c4820e30eba7c9671e88b64ec101841bcfa5c2b3` (`chore(ios): bump build number to 29`).
- Tag: `denwa-v1.0.2-build29(Release)`.
- Archive: `scratch/ios-product-testflight/Denwa-prd-release-v1.0.2-b29-20260713.xcarchive`.
- ExportOptions của lần upload build 29 đặt `testFlightInternalTestingOnly = false`; build đã upload và được App Store Connect xử lý thành công.
- Đã khai báo build không triển khai các thuật toán mã hoá được liệt kê, gắn build 29 vào phiên bản 1.0.2 và giữ release note `軽微な修正を行いました。`.
- Giữ chế độ phát hành thủ công và phát hành bản cập nhật ngay cho toàn bộ người dùng sau khi chủ động release.
- Đã gửi App Review thành công; trạng thái cuối ngày 2026-07-13 là `Waiting for Review`, submission ID `30b402e7-e1a6-40a4-b574-b98e33121de9`.
- Có cảnh báo thiếu dSYM cho các framework WebRTC dựng sẵn; cảnh báo này không chặn upload hoặc gửi duyệt.

## Android

- Phiên bản: `1.0.2`, version code `63`.
- Commit: `859c9e68ec7168d8b9dcf3d9fe2d6fd504520114`.
- Tag: `release_r00063_v1.0.2`.
- AAB: `sources/denwa-android/app/build/outputs/bundle/release/itec-denwa_release_1.0.2_b(0063)_859c9e6.aab`.
- SHA256: `ede5caaefe91322719482acee087a7bb8bd9d06f40530c98fc0eaae871bcd0e6`.
- Release production đã gửi Google Play review với rollout 100% và release note `軽微な修正を行いました。`.
- Trạng thái cuối: thay đổi đang được xem xét; managed publishing đang bật nên sau khi Google duyệt vẫn cần thao tác publish thủ công.
- Cảnh báo thiếu native debug symbols không chặn gửi review.
