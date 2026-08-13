---
title: Japanese tech report spoken meeting flow
project: itec-denwa
type: decision
status: archived
source:
  - Codex session on 2026-07-01
  - skills/japanese-tech-report/SKILL.md
  - skills/japanese-tech-report/references/report-patterns.md
tags:
  - japanese-tech-report
  - spoken-japanese
  - meeting-flow
  - customer-report
scope: historical
captured_at: 2026-07-01
validity: historical_context
promote_to_knowledge: false
---

# Japanese tech report spoken meeting flow

User finalized a single default spoken meeting flow for `skills/japanese-tech-report/`:

```text
開始挨拶
本日の共有目的
先に結論
本日のポイント
現状
確認済みの事実
原因／見立て
影響範囲
リリース判定への影響
対応方針
次のアクション
確認依頼
相手の反応待ち
確認後の進め方
終了挨拶
想定QA
```

The skill should keep one canonical spoken meeting sample only. Avoid multiple competing formal templates for default spoken customer/onsite output. For Japanese meeting output, keep common IT vocabulary but use spoken grammar and short sentence flow.

Environment wording for Japanese customer-facing output should use `ステージング環境` and `本番環境`, not raw `STG`, `PRD`, or `production`.

Follow-up rule from the same 2026-07-01 session:

- When the user asks for Japanese customer meeting/report practice, output the main spoken report first.
- Then add `Q&A Luyện Trả Lời KH`.
- Each Q&A should include a Vietnamese `Tư duy:` line before the Japanese `Q:` / `A:`.
- The Q&A should train smooth customer pushback handling: conclusion first, scope separation, fact vs. assumption, controlled risk, next action, soft deferral, and soft refusal without over-committing.
- Useful soft deferral / non-commitment phrases include `こちらで一度持ち帰って確認します`, `こちらの確認事項として持ち帰らせてください`, `確認できたら、結果を共有します`, `今この場で断定するのは少し難しいです`, and `一度整理させてください`.
