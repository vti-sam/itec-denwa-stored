---
title: DOCX builder Office PDF font mapping gotcha
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-02
  - skills/docx-builder/scripts/build_docx.py
tags:
  - docx-builder
  - office-pdf
  - font-mapping
scope: historical
captured_at: 2026-07-02
validity: historical_context
promote_to_knowledge: false
---

When exporting Vietnamese/Japanese mixed DOCX files to PDF through Microsoft Word,
do not map a Japanese-only template font to `ascii`/`hAnsi`. Word can render the
DOCX acceptably but split Vietnamese accent glyphs in the PDF.

The stable mapping used by `skills/docx-builder` is:

- `ascii`/`hAnsi`/`cs`: Arial
- `eastAsia`: Meiryo UI
- code runs: Consolas

For final QA, export with Microsoft Word/Office and inspect the rendered PNG
pages, especially body pages containing Vietnamese headings such as `Muc dich`
or `Pham vi`.
