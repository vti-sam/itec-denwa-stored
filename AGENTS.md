# AGENTS.md

File này là rule duy nhất cho toàn bộ `project-store/`. Không tạo `AGENTS.md`
trong folder con; boundary đặc thù phải được bổ sung thành section tại đây để
agent chỉ cần nạp một nguồn rule cho stored project.

## Commands

- Kiểm tra repo stored: `rtk git -C project-store status --short`.
- Tìm path/link trong snapshot: `rtk rg "<keyword_or_path>" project-store`.
- Lint rule: `rtk uv run skills/knowledge-code/knowledge-memory-sync/scripts/lint_rules.py`.
- Lint knowledge/memory: `rtk uv run skills/knowledge-code/knowledge-memory-sync/scripts/lint_knowledge.py`.
- Sync FalkorDB sau khi sửa knowledge/memory: `rtk uv run skills/knowledge-code/knowledge-memory-sync/scripts/sync_falkor.py`.
- Kiểm tra index sau sync: `rtk uv run skills/knowledge-code/knowledge-memory-sync/scripts/sync_falkor.py doctor`.

## Stored Project

- `project-store/` là nested Git repo chứa snapshot portable riêng của project.
- Chỉ các folder `config/`, `knowledge/`, `memory/`, `artifacts/`,
  `management/`, `skills/` được dùng làm top-level data folder.
- Không lưu application source, secret tracked, cache/index, build output hoặc
  draft tạm. Source đặt trong `sources/`; draft và candidate chưa verify đặt
  trong `scratch/` hoặc runtime `DATA_DIR`.
- Link nội bộ dùng path từ workspace root với prefix `project-store/`.
- User clone/pull repo stored; bootstrap chỉ kiểm tra và dùng repo hiện có,
  không fetch hoặc reset nested repo.
- Không stage, commit hoặc push nếu User chưa yêu cầu. Sau khi sửa phải kiểm
  tra Git status của cả root repo và `project-store/`.

## `config/`

- `config/project.yaml` là source-of-truth portable duy nhất cho project ID,
  resource binding và backend dùng chung.
- Chỉ lưu config endpoint-neutral, không bí mật. Secret thật chỉ nằm trong biến
  môi trường, `config/secrets.local.yaml` hoặc `config/keystore.local/`; các
  path local này phải bị nested Git ignore.
- `knowledge_memory.graph` phải ổn định và chỉ gồm chữ, số, dấu gạch dưới.
- Không lưu cache/index FalkorDB trong `config/`.
- Khi đổi project ID hoặc binding, chạy bootstrap dry-run và smoke test read-only
  của workflow liên quan trước khi dùng thao tác online.

## `management/`

- Google Sheets là source-of-truth; YAML trong `management/` chỉ là
  export/cache/sync metadata do `skills/project-ops/management-sync/` tạo hoặc
  đọc.
- Không viết tài liệu tự do hoặc artifact không thuộc workflow management vào
  folder này. Artifact portable đặt trong `artifacts/`; tri thức tổng hợp đặt
  trong `knowledge/`; draft đặt trong `scratch/`.
- Không sửa YAML management trực tiếp trừ khi User yêu cầu rõ. Cập nhật bằng
  workflow quản trị theo stable `id`, không dùng row number hoặc row order.
- Trước khi cập nhật WBS, fetch bản mới nhất từ Google Sheets. Nếu duplicate
  `id` thì dừng; nếu thiếu `id` thì chỉ tạo khi request cho phép tạo mới.
- Record archived phải được xóa khỏi source-of-truth theo stable `id`;
  `deadline` là hạn kế hoạch, `end_date` chỉ ghi khi item đã hoàn thành có căn
  cứ.
- WBS chính dùng tiếng Nhật cho `作業項目`; `作業項目 (VN)` / `title_vi` là
  memo nội bộ được dịch một lần khi tạo. Không tự overwrite bản tiếng Việt theo
  thay đổi tiếng Nhật nếu User chưa yêu cầu.
- Dropdown `担当` lấy từ `Stakeholders / 関係者` field `name` (`氏名`), không
  hardcode owner hoặc email. Không hardcode dropdown cho `種別` hay `区分` nếu
  User chưa yêu cầu.
- `WBS_JP / WBS_日本語` là legacy generated view, không phải source mặc định.
- Audit trail của quyết định vận hành hoặc task lớn phải ghi vào
  `Decisions / 決定事項` (`DECISIONS.yaml`) với liên kết WBS, knowledge, memory
  và verification phù hợp; không tạo decision store song song.
- Sau mọi write online, read-back hoặc sync/fetch lại để kiểm tra kết quả và
  encoding UTF-8.

## `knowledge/`

- `knowledge/` là source-of-truth nội bộ cho tri thức bền, reusable và có
  evidence. FalkorDB chỉ là index có thể rebuild.
- Không lưu raw customer file, draft, credential, application source hoặc dữ
  liệu chưa verify. Raw artifact đặt trong `artifacts/`; historical context đặt
  trong `memory/`.
- Không tự tạo taxonomy, metadata enum hoặc trạng thái hiện tại nếu chưa có
  source/evidence và chưa thống nhất scope.
- Markdown knowledge phải bắt đầu bằng frontmatter:

```yaml
---
title: <Human readable title>
project: <project_id>
type: requirement | decision | gotcha | runbook | architecture | glossary | analysis
status: active | superseded | archived
source:
  - <source path, ticket, meeting, or evidence>
tags:
  - <keyword>
scope: durable
updated_at: <YYYY-MM-DD>
---
```

- `active` được dùng làm căn cứ hiện tại; `superseded` đã có nội dung thay thế;
  `archived` chỉ giữ để truy vết.
- Khi promote từ memory, thêm path memory vào `source`.
- Sau khi sửa, chạy knowledge lint, Falkor sync, doctor và query read-back phù
  hợp với nội dung đã thay đổi.

### Verified cases

- Mọi tạo/sửa file dưới `knowledge/verified-cases/` hoặc có tag
  `verified-case` bắt buộc dùng
  `project-store/skills/verified-case-learning/SKILL.md`.
- Chỉ lưu case có evidence trực tiếp. User feedback, conversation history hoặc
  LLM output không được làm nguồn xác nhận nghiệp vụ duy nhất.
- Candidate `unknown`, `rejected` hoặc chưa đủ evidence chỉ được giữ trong
  `scratch/`; không ghi vào knowledge.
- Verified case dùng `type: analysis`, tag `verified-case`; case còn hiệu lực
  dùng `status: active`, case đã có nội dung thay thế hoặc chỉ giữ audit dùng
  `superseded`/`archived`. File phải pass validator của skill trước knowledge
  lint/sync.

## `memory/`

- `memory/` chỉ lưu historical context có relevance trực tiếp với project,
  không phải active source-of-truth.
- Trước khi ghi phải có ít nhất một project anchor kiểm chứng được: application
  source path, issue/WBS, deliverable/artifact, quyết định khách hàng hoặc
  trạng thái vận hành của project.
- Không dùng memory làm changelog cho skill/tool/rule chung, benchmark,
  evaluator hoặc log verify không tạo project outcome.
- Nội dung bền phải promote sang `knowledge/` với evidence chain.
- Trước khi tạo file mới, tìm theo project anchor, identifier và chủ đề để
  update memory hiện có khi cùng một outcome; không tách nhiều file chỉ vì task
  kéo dài qua nhiều lượt.
- Body memory phải tách rõ `Outcome`, `Evidence`, `Unresolved` và
  `Retrieval keys`. `Evidence` chỉ ghi kết quả đã read-back hoặc source trực
  tiếp; correction của User là trigger để kiểm tra lại, không tự trở thành fact
  nghiệp vụ duy nhất. Nếu còn mâu thuẫn quan trọng chưa giải quyết, dùng
  `status: stale` và nêu điều kiện cần verify lại.
- Không dump transcript, secret hoặc token. Chỉ tổng hợp context cần truy vết
  và giữ các identifier, environment, source path đủ để task sau tìm lại đúng
  entity.
- Markdown memory phải bắt đầu bằng frontmatter:

```yaml
---
title: <Human readable title>
project: <project_id>
type: requirement | decision | gotcha | runbook | architecture | lesson
status: archived | stale
source:
  - <Codex session, task log, or evidence path>
tags:
  - <keyword>
scope: historical
captured_at: <YYYY-MM-DD>
validity: historical_context
promote_to_knowledge: false
---
```

- `archived` còn hữu ích để truy vết; `stale` phải verify lại trước khi dùng.

## `artifacts/`

- `artifacts/` lưu artifact portable không thuộc workflow Google Sheets
  management. Nếu artifact có nguồn hoặc mục đích dùng lại, ghi source trong
  tên, metadata hoặc companion document.
- Khi di chuyển/đổi tên artifact, cập nhật internal link liên quan.
- `artifacts/reports/` chỉ chứa category folder dạng ASCII kebab-case; không
  đặt report bundle trực tiếp dưới `reports/`.
- Report bundle dùng `<document_id>_<document_title>/`; file chính dùng
  `<document_id>_<document_title>_<document_kind>`. Tên title/kind dùng tiếng
  Nhật khi có tên tài liệu tiếng Nhật chính thức.
- Document code đặt loại tài liệu trước domain: `<doc_type>-<domain>-<seq2>`
  hoặc `<doc_type>-<phase>-<domain>-<seq2>`. `seq2` có hai chữ số.
- Code chuẩn: `ARCH` = structure design, `REL` = release plan/checklist,
  `SEC` = security report, `TC` = test case. Phase test chuẩn: `UT`, `IT`,
  `ST`, `UAT`; trong test case, `IT` luôn là integration test.
- Các bản xuất cùng nội dung giữ cùng basename và chỉ khác extension.
- Deliverable `.drawio`, `.svg`, `.png`, `.xlsx`, `.md` đặt tại bundle parent;
  `output/` chỉ dùng cho intermediate/review artifact.
- Tài liệu chính thức gửi khách hàng phải là tiếng Nhật tự nhiên và không chứa
  note nội bộ, TODO hoặc nội dung chưa chốt.

## `skills/`

- `skills/` chỉ chứa skill portable đặc định cho project hiện tại. Mỗi skill
  phải có `SKILL.md`; chỉ thêm `agents/`, `scripts/`, `references/`,
  `resources/`, `templates/` khi phục vụ trực tiếp workflow.
- Script trong project-specific skill phải deterministic; không tự gọi LLM.
  Model reasoning được thực hiện bởi conversation/agent đang dùng skill.
- Script đọc config/credential từ `config/project.yaml`, biến môi trường hoặc
  local ignored config; không hardcode secret.
- Không lưu application source, generated output, cache/index hoặc task history
  trong skill. Durable knowledge đặt trong `knowledge/`; candidate/draft đặt
  trong `scratch/`.
- Skill phải có validator hoặc verification command tương xứng với artifact nó
  tạo; luôn chạy verify trước khi coi workflow hoàn tất.
