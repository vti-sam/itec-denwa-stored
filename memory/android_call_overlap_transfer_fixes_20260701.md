---
title: Android call overlap, voice-message, and transfer history fixes
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex task 2026-07-01 Android call bugs
tags:
  - android
  - call-flow
  - missed-call
  - transfer
  - voice-message
scope: historical
captured_at: '2026-07-01'
validity: historical_context
promote_to_knowledge: false
---

# Android call overlap, voice-message, and transfer history fixes

Fixed Android call-flow bugs around overlapping incoming calls, voice-message recording, and attended-transfer call history.

Important implementation notes:
- While the outgoing voice-message recording window is active, incoming calls should be deferred, not converted into immediate local missed-call notifications. If a MISSED_CALL push arrives while that deferred incoming SIP session is still live, consume it without cancelling the live incoming session.
- For an auto-rejected duplicate incoming call during another incoming/ringing session, suppress local/server missed-call notification while another session is still live. This avoids tapping the missed-call push and replacing the incoming UI with the call-handler screen.
- MainActivity notification routing must send an active Ringing/Connecting non-outgoing session back to IncomingCallActivity, not CallHandlerActivity.
- Transfer history split should prefer the cached transfer peer/transferContact over SDK remoteNumber, because remoteNumber can still be the old peer during replace stabilization. If transfer replacement connects and no pending log exists, open a new accepted pending log for local user to the replacement peer so A/C history is captured.

Verification gotcha:
- Gradle/Kotlin in this Android project fails under Java 25 with `IllegalArgumentException: 25.0.1` before build scripts compile. Use JDK 21, e.g. `JAVA_HOME=/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home`.
