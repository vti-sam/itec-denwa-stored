---
title: DOCX builder body indent axis gotcha
project: itec-denwa
type: gotcha
status: archived
source:
  - project-store/artifacts/sip-phone-requirement-20260609/rendered-office/page-7.png
  - skills/docx-builder/scripts/build_docx.py
tags:
  - docx-builder
  - office-render
  - indent
scope: historical
captured_at: 2026-07-02
validity: historical_context
promote_to_knowledge: false
---

# DOCX builder body indent axis gotcha

When the builder uses the project template body style (`FXSS7`), Word can inherit a deeper left indent than expected. This makes body paragraphs and numbered lists start too far to the right compared with the header/heading axis.

The fix is to set an explicit body axis in `build_docx.py`:

- `BODY_LEFT_DXA = 210`
- `BLOCK_INDENT_DXA = BODY_LEFT_DXA`
- `BLOCK_WIDTH_DXA = CONTENT_WIDTH_DXA - BLOCK_INDENT_DXA`

Use that body axis for `body_para`, `bullet`, `numbered`, table `tblInd`, and code-block table `tblInd`. Verify with Office-rendered PNG pages, because non-Office renderers can show different margins from Microsoft Word.
