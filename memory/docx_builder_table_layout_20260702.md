---
title: DOCX builder table and code block layout gotcha
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-02
  - skills/docx-builder/scripts/build_docx.py
tags:
  - docx-builder
  - table-layout
  - render-docx
scope: historical
captured_at: 2026-07-02
validity: historical_context
promote_to_knowledge: false
---

When rendering official DOCX from Markdown with `skills/docx-builder`, the template body style does not start at the raw page content edge. `FXSS7` combines `w:left` and `w:leftChars`, so table/code blocks that use `tblInd=0` or only a small indent look visually misaligned against normal body text.

The stable fix applied on 2026-07-02 was to make boxed blocks use the visual body axis and to stop dividing table columns by raw text length. The renderer now gives minimum width to date, range, numeric identifier, and IPGroup columns, and uses compact font/padding for tables with four or more columns.

For similar future complaints about Word table alignment, first inspect rendered page PNGs, not only the DOCX XML. A width that looks correct in XML can still render poorly because Word applies template style indentation and cell wrapping rules.
