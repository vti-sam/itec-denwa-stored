---
title: ITEC management Markdown SOT and VTI-style Sheets projection
project: itec-denwa
type: decision
status: archived
source:
  - project-store/management/DECISIONS.md
  - skills/project-ops/management-authoring/SKILL.md
  - skills/project-ops/management-authoring/scripts/management_authoring_gate.py
  - skills/project-ops/management-google-sheets/SKILL.md
  - skills/project-ops/management-google-sheets/scripts/management_sheets_sync.py
  - skills/project-ops/management-google-sheets/scripts/management_projection_helpers.py
  - skills/project-ops/management-google-sheets/resources/project-data.template.yaml
  - skills/project-ops/management-authoring/resources/management.schema.yaml
  - scratch/management-style-preview/design-tokens.md
  - skills/project-ops/management-authoring/scripts/test_management_authoring_gate.py
  - scratch/management-audit/projection-20260802-233829.json
tags:
  - management-authoring
  - management-google-sheets
  - markdown-sot
  - google-sheets-projection
  - itec-denwa
scope: historical
captured_at: 2026-08-02
validity: historical_context
promote_to_knowledge: false
---

## Outcome

ITEC management data is stored in five canonical Markdown tables under `project-store/management/`: WBS, risks, decisions, stakeholders and communications. Schema v3 uses one common `notes` field displayed as `備考`; language-specific `notes_vi` fields were removed and project prose was normalized to concise Japanese while preserving stable IDs, URLs and technical literals. The current project set contains 37 WBS records, 4 risks, 1 confirmed project decision, 7 stakeholders and 1 communication rule. Tooling or data-transfer workflow is not recorded as a project decision; the authoring gate rejects such rows. Google Sheets is a generated projection with a metadata-only `WBS / WBS` tab, a separate formula-driven `WBS Graph / WBSグラフ` tab and a derived Project summary. The reverse direction is explicit only: `management-google-sheets import` creates a candidate, and `--apply` is required before canonical Markdown changes.

The workflow is split into `management-authoring` (Markdown/schema/terminology/gate) and `management-google-sheets` (projection/layout/API/audit). Key left fields are frozen at merged-field boundaries: WBS A:M, Graph A:K, Risks A:G, Decisions A:J, Stakeholders A:E and Communications A:F. Reader-facing tables follow the Basic Design convention: the first column is `No.` with circled row markers (`①、②、…`), stable machine keys remain hidden for explicit import/read-back, and empty or context-duplicate fields are omitted from the visible view (for example `区分=Stakeholder` and `種別=Communication Rule`). Vertical body merges are explicit per-table field/group policy and only apply to adjacent non-empty rows in the same group; incidental repeats such as `status` or `owner` are not merged, and row order is never used as identity.

On 2026-08-02, the projection style was rebuilt through the maintained shadow/read-back/swap path. All seven tabs now use the VTI-inspired title/header palette (`#1B3A5C`, `#2E5E8E`, `#E8EDF2`, `#F5F7FA`) with Meiryo UI and a fixed 40px base grid. The first tab title is `【プロジェクト管理サマリー】`. Normal table widths are WBS 52, Risks 46, Decisions 52, Stakeholders 44 and Communications 44 base cells; IDs/dates use 3 cells, compact fields use 2, and narrative fields use explicit wider spans. Every visible body cell is horizontally merged to the exact span of its header, including empty values; vertical merges remain limited to the configured contiguous groups (WBS external IDs/same-group content and Stakeholders organization). Hidden metadata does not create body merge regions. The graph is only 1-cell `No.`, 8-cell `作業項目` and a 46-day timeline (57 columns total); labels, dates and bars are formulas referencing the WBS tab, not copied WBS metadata. Graph dates render as day numbers, timeline rows stay CLIP/fixed-height, and graph bars use a light Google-style blue fill. Master values display Japanese labels with reversible canonical-code mapping and dropdown validation. The renderer is named `management_sheets_sync.py`; reverse import remains explicit.

Project body merges are horizontal-only; the audit now rejects any body-row vertical merge in `Project / プロジェクト`, including `期限未設定` blocks. WBS Graph body rows are also horizontal-only and are validated against the 8-cell `作業項目` header span. Borders are scoped to populated table ranges; Project uses independent per-block borders, blank separators/tail rows remain borderless, and all managed tabs hide default gridlines.

## Evidence

- `rebuild --apply --confirm-rebuild` created correctly sized shadow tabs (WBS metadata 52 columns; Risks 46; Decisions 52; Stakeholders 44; Communications 44; WBS graph 57; Project 16), wrote rectangular values and formulas before formatting, passed shadow read-back, swapped seven canonical tabs, and removed the old/legacy tabs.
- The final plan reported 37 WBS updates, 4 risk updates, 1 decision update plus 1 tooling-decision deletion, 7 stakeholder updates and 1 communication update; direct Sheet read-back returned 37, 4, 1, 7 and 1 records respectively.
- The final audit reported seven tabs, zero legacy tabs, zero protected ranges, zero filters, zero charts and zero named ranges, with `merge_validation=PASS` (`scratch/management-audit/projection-20260802-233829.json`). It reported merge counts of 533 WBS, 51 WBS graph, 65 Risks, 29 Decisions, 70 Stakeholders, 20 Communications and 123 Project; direct metadata read-back confirmed 37 horizontal WBS Graph body merges and zero graph body vertical merges, 121 horizontal Project body merges and zero Project body vertical merges, all visible body spans matching their headers, four WBS body vertical groups, one Stakeholders organization group, no body vertical merges in the other normal tables, hidden machine-key columns, the expected tab order, `hideGridlines=true` on managed tabs, and no effective borders on Project separator/tail rows or normal-table reserved tails.
- Direct Sheets read-back confirmed graph formulas reference `WBS / WBS` after the shadow swap, body rows contain only ID/title formulas and timeline formulas, date headers render as ISO dates, every physical column reports pixel size `40`, and no graph `#REF!` values remain.
- `validate` passed all Markdown hashes, and a direct `import --table risks` produced a candidate identical to canonical `RISKS.md` without changing the source.
- Style/API read-back after the rebuild confirmed the title, section and header palette and `Meiryo UI` on WBS and Project; normal tabs use the pastel master colors and the graph has one local timeline-bar conditional rule.
- Local verification passed the management Markdown/parser tests, the management authoring scope-guard tests, 41 projection tests, typed-action validation, rule/knowledge lint and workspace verification. Visual QA artifacts remain under `scratch/management-audit/`.

## Unresolved

- Shadow swapping changes Google Sheet `sheetId/gid` values. The audit found no named ranges, protected ranges or charts, but external links or consumers outside this spreadsheet must be checked if they rely on old gids.
- Older archived memory entries still describe the pre-migration YAML workflow; they are historical context and are not active instructions.
- `scratch/management-style-preview/preview.svg` and its rendered PNG are disposable visual references; regenerate them when the style profile changes rather than treating them as source data.

## Retrieval keys

- `management_markdown_sot_migration_20260802`
- `ITEC management VTI style projection`
- `Markdown SOT`
- `itec-denwa management-google-sheets`
- `Google Sheets projection explicit import`
