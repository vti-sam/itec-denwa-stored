---
title: DOCX builder Office PDF export behavior
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-02
  - skills/docx-builder/scripts/export_pdf_office.py
tags:
  - docx-builder
  - office-export
  - pdf
scope: historical
captured_at: 2026-07-02
validity: historical_context
promote_to_knowledge: false
---

`skills/docx-builder/scripts/export_pdf_office.py` was added to export `.docx` to PDF through Microsoft Word/Office instead of the headless render pipeline. Windows uses Word COM through a temporary UTF-8 PowerShell script, which is the preferred path for final PDF export.

On the local macOS environment, Microsoft Word was installed, but the first AppleScript export attempt timed out because Word showed a `Grant File Access` prompt for the output folder. Saving to Word's container avoided that prompt, but then macOS showed a privacy prompt asking whether `Codex` may access data from other apps when Python tried to copy the PDF out of Word's container.

The macOS path was changed to export the Word PDF into the system temp directory instead. If macOS still shows the `Codex would like to access data from other apps` prompt, the user must approve it before Office render QA can run. The script has an explicit timeout and must report a clear error instead of hanging or silently falling back to LibreOffice/headless rendering.

For final deliverables, use Office export when it succeeds. Use the headless renderer only for preview/QA PNGs or when the user explicitly accepts a non-Office PDF.
