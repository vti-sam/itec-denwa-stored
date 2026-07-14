---
title: Backlog VOIP_APL-205 SIP Phone IPGroup SIPP suffix
project: itec-denwa
type: decision
status: archived
source:
  - Codex session creating customer Backlog issue on 2026-07-13
tags:
  - backlog
  - sip-phone
  - ipgroup
  - sipp
scope: historical
captured_at: 2026-07-13
validity: historical_context
promote_to_knowledge: false
---

Created customer Backlog task `VOIP_APL-205`, priority `高`, assigned to `VTI サム`.

The task requires API-generated SIP Phone IPGroup names for `phoneType=4` to use `IPG_{tenantName}_SIPP` without duplicating the suffix. The same rule applies to immediate MVE registration, batch registration, and account export.

The customer-facing description explicitly separates provisioning from live calling: foreground mobile calls go directly from the SDK to MVE, and Web/API does not participate in call setup. The issue contains a Mermaid sequence for registration and MVE synchronization only, with no source file or class names.

Formatting follow-up: project `VOIP_APL` uses Backlog notation rather than Markdown. The description was updated to use `*` headings, `{code}` blocks, and `-` lists. The Mermaid source was rendered to `voip-apl-205-sip-phone-mve-flow.png`, attached to the issue, and displayed inline with `#image(voip-apl-205-sip-phone-mve-flow.png)`. Browser verification confirmed that headings, code blocks, the inline diagram, and completion-condition bullets render correctly.

Customer clarification was reflected afterward: the explicit trigger is extension range `51001`–`99899`, which API treats as `phoneType=4`, rather than `phoneType=4` being the only customer-facing condition. The description and diagram were updated to `voip-apl-205-sip-phone-mve-flow-v2.png`; the original attachment was removed. API read-back and browser verification confirmed that only the v2 attachment remains and is displayed inline.
