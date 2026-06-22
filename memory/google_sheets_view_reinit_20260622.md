---
title: Google Sheets management view reinitialization
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-06-22 Google Sheets view reinit
  - skills/management-sync/scripts/init_project_sheets.py
tags:
  - google-sheets
  - management-sync
  - init-sheets
  - wbs
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

Reinitialized the management Google Sheets view after the visible sheet layout diverged from `skills/management-sync`.

Workflow used:

- Fetch all management tables first so Project summary and Gantt use current YAML snapshots.
- Run `skills/management-sync/scripts/init_project_sheets.py` directly for full view rebuild.
- Run `skills/management-sync/scripts/clear_filters.py` after init.
- Run `skills/management-sync/scripts/update_today_line.py` after filters are cleared.
- Fetch all management tables again and dry-run all tables to confirm `No changes`.

Gotcha: `manage.py init-sheets --dry-run` does not forward `--dry-run` as expected through the wrapper argument parser. Use the direct script for dry-run/options, or verify wrapper behavior before relying on it.

Verification from 2026-06-22:

- Init formatted Project, WBS, Risks, Decisions, Stakeholders and Communications sheets.
- Clear filters removed Basic Filter from 7 sheets, including legacy `WBS_JP / WBS_日本語`.
- Today line updated for `WBS / WBS` and `WBS_JP / WBS_日本語`.
- Data dry-run for WBS, Risks, Decisions, Stakeholders and Communications returned `No changes`.

Correction from later verification on 2026-06-22:

- Re-running `init_project_sheets.py` is not enough when the user expects the view to match the actual `smj-ks-pos` Google Sheet style. The config and script can be identical while the live view still differs.
- Use `skills/management-sync/scripts/clone_sheet_style.py` to clone actual style from `smj-ks-pos` to `itec-denwa` without overwriting management record values.
- WBS style clone must also copy Gantt timeline header view values for rows 2-4; otherwise conditional formats can use the SMJ timeline start date while the visible day header still shows the old ITEC timeline.
- Do not run the legacy `update_today_line.py` after cloning WBS style from SMJ unless it has been updated to understand the cloned timeline. The old implementation calculates the ITEC data-derived timeline and can place the red today border on the wrong column.
- Verified after clone: `WBS / WBS` matched SMJ at `rows=200`, `cols=104`, `frozenRows=4`, `filter=no`, `merges=3168`, `conditionalFormats=26`, and `R4C50=05/18`. Management data dry-runs still returned `No changes`.

Follow-up fix from 2026-06-22:

- The fast default workflow is now `manage.py init-sheets` -> `clear-filters` -> `today-line`. This keeps style generation deterministic and lets WBS/Gantt use project data dynamically.
- `manage.py` now forwards utility options correctly, so `manage.py init-sheets --dry-run` works.
- `update_today_line.py` now reads the visible Gantt date headers directly from Google Sheets and only moves the red today border; it no longer rebuilds the timeline from YAML or clears all Gantt left borders.
- `clone_sheet_style.py` remains a fallback/bootstrap tool for reconciling with an actual reference spreadsheet. It should not be used for every normal view refresh because it is much slower and can hit Google Sheets write quota.

Gantt formula/style correction from 2026-06-22:

- WBS Gantt must be dynamic from min/max WBS dates, not static-cloned from SMJ. It must not pad to the start/end of week; for the current WBS, the visible timeline spans 2026-05-26 through 2026-07-03, so months 2026-05 and 2026-07 remain only because records currently touch those months.
- Row 2 is merged month headers; row 4 stores real date values but displays only `dd` to keep daily columns compact.
- Daily Gantt columns are 18 px. Body cells use formula overlap logic based on start date and end date/deadline, similar to the reference workbook formula, and return symbols (`■`, `◇`, `◆`) instead of painting bars only by background.
- Conditional format uses the status palette as main symbol color and a lightened version as the bar background. Gantt body borders are white.
- `init_project_sheets.py` unmerges old ranges before shrinking the grid; otherwise a prior static/clone timeline with more columns can fail with an out-of-grid `unmergeCells` error.

Status/Gantt color correction from 2026-06-22:

- `project-data.yaml` is ignored local config, so status display palette changes must live in tracked script logic if they need to survive normal repo merges.
- `init_project_sheets.py` now overrides known status display colors with a stronger palette, sets contrast text color for status cells, and uses a less aggressive lightening ratio for Gantt backgrounds. Read-back verified `Completed` as main `#16A34A` with white status text, and Gantt body uses the same main color for symbols with a stronger light background.
