---
title: STG MVE endpoint aligned with production
project: itec-denwa
type: lesson
status: archived
source:
- memory/stg_mve_endpoint_alignment_20260619.md
tags:
- stg
- database
- mve
- sip
- android
- ios
scope: historical
captured_at: '2026-06-19'
validity: historical_context
promote_to_knowledge: false
---

Updated the single active row in `denwa_stg.master_schema.system_settings` to align STG mobile clients with the production MVE:

- Before: IP `15.168.65.231`, domain `c2.cd-demo-mve.com`.
- After: IP `13.112.245.12`, domain `app-mve.purattocall.com`.
- Kept UDP port `5071` and TLS port `10183` unchanged.
- Incremented `version_no` from `17` to `18`.
- Independent read-back confirmed the committed STG values.
- DNS verification confirmed `app-mve.purattocall.com` resolves to `13.112.245.12`.

PRD already had the target IP/domain and was not modified. Android/iOS obtain both `ipAddress` and `domain` from the backend system-settings response; clients may need to log in again or re-run initialization to refresh locally cached call credentials.
