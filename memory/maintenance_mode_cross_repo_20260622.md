---
title: Maintenance mode cross-repo implementation context
project: itec-denwa
type: decision
status: archived
source:
  - Codex session 2026-06-22 maintenance mode implementation
tags:
  - maintenance
  - denwa-api
  - denwa-front
  - denwa-android
  - denwa-ios
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

Implemented maintenance mode handling across `sources/denwa-api`, `sources/denwa-front`, `sources/denwa-android`, and `sources/denwa-ios`.

Backend direction:
- Add public `GET /maintain/status`, returning `data.maintaining`.
- During system maintenance, `JwtFilter` blocks non-allowlisted API requests with HTTP 403 and message key `MSG_ERR_00074`.
- Keep health/status/MVE maintenance stop and admin login/OTP/refresh/login-with-role paths available.

Client direction:
- FE handles global 403 `MSG_ERR_00074`, suppresses normal toast, and shows a persistent maintenance dialog.
- Android handles `MSG_ERR_00074` in base repository response handling, stores global `MaintenanceMode`, renders `MaintenanceDialog` in main/auth/call roots, and checks `/maintain/status` before post-login initialization and foreground SIP reconnect.
- iOS handles `MSG_ERR_00074` in `ApiManage`, shows a blocking `UIAlertController`, and rechecks `/maintain/status` when OK is tapped.

Verification notes from this session:
- FE `npm run type-check` passed.
- FE `npm run build` failed before app compile because `vite-plugin-vue-devtools` called `localStorage.getItem` while loading Vite config in Node.
- iOS `xcodebuild -workspace Denwa/Denwa.xcworkspace -scheme Denwa -configuration Debug -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' build CODE_SIGNING_ALLOWED=NO` passed.
- Android Gradle failed before project compilation because local Java version `25.0.1` cannot be parsed by the Kotlin/Gradle toolchain.
- API Maven compile failed with broad pre-existing Lombok/generated accessor errors across many classes.
