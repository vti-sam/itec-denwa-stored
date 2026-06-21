---
title: Bootstrap sources AGENTS git push blocked
project: itec-denwa
type: gotcha
status: archived
source:
- memory/bootstrap_sources_agents_git_push_blocked.md
tags:
- bootstrap
- git
- sources
scope: historical
captured_at: '2026-06-17'
validity: historical_context
promote_to_knowledge: false
---

Created commit `2a9a608` on `main` to track `sources/AGENTS.md` and update `.gitignore` so source checkout folders remain ignored. Push to `origin/main` failed because the workspace has no GitHub HTTPS credential, `gh` is unavailable, and SSH authentication to GitHub returns `Permission denied (publickey)`.
