---
title: VOIP_APL-192/193 SV9300 transfer history
project: itec-denwa
type: gotcha
status: archived
source:
- memory/voip_apl_192_193_sv9300_transfer_history.md
tags:
- backlog
- sv9300
- transfer
- android
- ios
scope: historical
captured_at: '2026-06-21'
validity: historical_context
promote_to_knowledge: false
---

# VOIP_APL-192/193 SV9300 transfer history

VOIP_APL-192 is an iOS attended-transfer case where app-to-app call transfer to an SV9300 fixed phone succeeds, but the SV9300 side cannot hear audio from the app. This matches the earlier VOIP_APL-122 history from 2026-02 to 2026-03: transfer became possible after MVE/SV9300 settings were changed, but one-way audio remained until M800/SBC settings were adjusted. The 2026-03-09 VOIP_APL-122 comment says M800 setting changes improved the one-way-audio symptom for iOS.

VOIP_APL-193 is an Android attended-transfer case where transfer to SV9300 fails and the call returns to the original app-to-app call while SV9300 keeps hold music. The 2026-06-19 Android syslog shows the normal consultation call to `11112001`, but MVE outbound manipulation changes destination username `11112001` to `12001`. During transfer, the propagated `Refer-To` becomes `sip:12001@210.171.4.212...` and the replacement INVITE to SV9300 fails with `500 Server Internal Error` / `GWAPP_NO_ROUTE_TO_DESTINATION`. This aligns with VOIP_APL-191's warning that 5-digit numbers cannot be routed unless MVE can distinguish app vs SIP phone tenant.

For customer-facing wording, separate the two causes:
- iOS: likely recurrence of the known MVE/M800/SV9300 media-path one-way-audio issue; app only calls the SDK transfer function and does not control low-level REFER/ReINVITE/media handling.
- Android: current log evidence points to routing failure after number manipulation to a 5-digit destination in the transfer/Replaces flow; confirm whether app/SDK sends the full `11112001` before MVE rewrites it, then coordinate MVE/SV9300 numbering rules.
