# AGENTS.md

File này kế thừa root `AGENTS.md` và chỉ bổ sung boundary cho toàn bộ
`project-store/`. Không tạo `AGENTS.md` trong folder con; thêm rule đặc thù vào
đúng section tại đây. Global gate ở root về approval, secret, destructive
action, online write và packaging luôn còn hiệu lực.

Link nội bộ dùng path từ workspace root với prefix `project-store/`.

## Stored project invariants

- `project-store/` là nested Git repo chứa snapshot portable riêng của project.
  Chỉ `config/`, `knowledge/`, `memory/`, `artifacts/`, `management/`, `skills/`
  được dùng làm top-level data folder.
- User sở hữu thao tác clone/pull. Bootstrap chỉ kiểm tra và dùng nested repo
  hiện có; không tự fetch, reset, stage, commit hoặc push.
- Không lưu application source, tracked secret, cache/index, build output hoặc
  draft dùng một lần trong `project-store/`.

| Loại dữ liệu | Source-of-truth hoặc đích hợp lệ |
|---|---|
| Project ID, resource binding, backend và endpoint không bí mật | `config/project.yaml` |
| Credential, token, key material | Environment hoặc local ignored config |
| WBS, risks, decisions, stakeholders, communications | Google Sheets; `management/` chỉ là YAML sync/export |
| Tri thức bền đã verify | `knowledge/` |
| Historical project outcome có anchor | `memory/` |
| Raw customer file và artifact portable | `artifacts/` |
| Workflow deterministic riêng của project | `skills/` |
| Application source | `sources/<project>/` ngoài nested repo |
| Draft/candidate/cache/index/output tạm | Workspace-root `scratch/` hoặc ignored path trong bundle do owner skill quy định; không track trong snapshot |

## `config/`

- `config/project.yaml` là source-of-truth portable duy nhất cho project ID,
  resource binding và backend dùng chung. File này được phép chứa resource
  ID/URL, base URL hoặc endpoint không bí mật cần để resolve đúng project.
- Credential và secret thật chỉ nằm trong environment,
  `config/secrets.local.yaml` hoặc `config/keystore.local/`; các path local phải
  bị nested Git ignore.
- `knowledge_memory.graph` phải ổn định và chỉ gồm chữ, số, dấu gạch dưới.
  Không lưu cache/index FalkorDB trong `config/`.
- Khi đổi project ID, endpoint hoặc binding, chạy bootstrap dry-run và smoke
  test read-only của workflow liên quan trước mọi online write.

## `management/`

- Google Sheets là source-of-truth. YAML trong `management/` chỉ là
  export/cache/sync metadata do `skills/project-ops/management-sync/` tạo và
  đọc; không dùng connector Google Sheets thay owner workflow này.
- Mọi mutation phải dùng owner skill và completion contract của skill:
  `fetch latest → sửa stable id → dry-run/approval → apply → read-back`. Không
  sửa YAML ad hoc hoặc định danh bằng row number/row order.
- Duplicate `id` phải dừng; thiếu `id` chỉ được tạo khi request cho phép record
  mới.
- Record bị loại khỏi YAML/source plan sẽ bị xóa khỏi Google Sheets theo stable
  `id` trong dry-run đã duyệt; không tự chuyển record đó thành trạng thái hoặc
  type archived.
- `deadline` là hạn kế hoạch; `end_date` chỉ ghi khi item đã hoàn thành có căn
  cứ.
- `WBS_JP / WBS_日本語` là legacy generated view, không phải source mặc định.
- Chỉ ghi `Decisions / 決定事項` (`DECISIONS.yaml`) khi task thực sự tạo/thay
  đổi quyết định vận hành hoặc audit outcome riêng của project và write đó nằm
  trong scope đã duyệt. Liên kết WBS, knowledge, memory và verification phù
  hợp; không tạo decision store song song.
- Sau mọi online write, read-back hoặc sync/fetch đúng table và stable `id` để
  kiểm tra dữ liệu cùng encoding UTF-8. Nếu khác dry-run plan, dừng và báo
  chênh lệch; không retry toàn batch mù quáng.

## `knowledge/`

- `knowledge/` là source-of-truth nội bộ cho tri thức bền, reusable và có
  evidence. FalkorDB chỉ là index có thể rebuild.
- Không lưu raw customer file, draft, credential, application source hoặc dữ
  liệu chưa verify. Không tự tạo taxonomy, metadata enum hay trạng thái hiện tại
  nếu chưa có source/evidence và scope đã thống nhất.
- Frontmatter bắt buộc có `title`, `project: <project_id>`, non-empty `source`
  và `tags`, `scope: durable`, `updated_at: <YYYY-MM-DD>`. `type` chỉ nhận
  `requirement | decision | gotcha | runbook | architecture | glossary |
  analysis`; `status` chỉ nhận `active | superseded | archived`.

- `active` được dùng làm căn cứ hiện tại; `superseded` phải có nội dung thay
  thế; `archived` chỉ giữ để truy vết.
- Khi promote từ memory, thêm path memory vào `source` và giữ evidence chain.

### Verified cases

- Mọi create/update dưới `knowledge/verified-cases/` hoặc có tag
  `verified-case` phải dùng và pass completion contract của
  `project-store/skills/verified-case-learning/SKILL.md`.
- Chỉ lưu case có evidence trực tiếp. User feedback, conversation history hoặc
  LLM output không được làm nguồn xác nhận nghiệp vụ duy nhất; candidate chưa
  đủ evidence chỉ nằm trong `scratch/`, không ghi vào knowledge.

## `memory/`

- `memory/` chỉ lưu historical context có relevance trực tiếp với project,
  không phải active source-of-truth hay changelog chung.
- Trước khi ghi phải có ít nhất một project anchor kiểm chứng được:
  application source path, issue/WBS, deliverable/artifact, quyết định khách
  hàng hoặc trạng thái vận hành của project.
- Thay đổi skill/tool/rule chung, benchmark, evaluator hay log verify không tạo
  project outcome thì không được ghi memory. Nội dung bền phải promote sang
  `knowledge/` với evidence chain.
- Trước khi tạo file mới, tìm theo anchor, identifier và chủ đề để update memory
  hiện có khi cùng outcome; không tách file chỉ vì task kéo dài nhiều lượt.
- Body phải tách `Outcome`, `Evidence`, `Unresolved` và `Retrieval keys`.
  `Evidence` chỉ ghi source trực tiếp hoặc kết quả đã read-back; User correction
  là trigger kiểm tra lại, không tự trở thành fact nghiệp vụ. Mâu thuẫn quan
  trọng chưa giải quyết phải dùng `status: stale` và nêu điều kiện verify lại.
- Không dump transcript, secret hoặc token. Chỉ giữ context, identifier,
  environment và source path cần để truy vết đúng entity.
- Frontmatter bắt buộc có `title`, `project: <project_id>`, non-empty `source`
  và `tags`, `scope: historical`, `captured_at: <YYYY-MM-DD>`,
  `validity: historical_context`, `promote_to_knowledge: false`. `type` chỉ
  nhận `requirement | decision | gotcha | runbook | architecture | lesson`;
  `status` chỉ nhận `archived | stale`.
- `source` phải có ít nhất một project anchor; Codex session/task log chỉ là
  evidence bổ sung. `archived` còn hữu ích để truy vết; `stale` phải verify lại
  trước khi dùng.
- Retrieval, capture, sync/read-back và closeout tuân theo root `AGENTS.md` và
  `skills/knowledge-code/knowledge-memory-sync/SKILL.md`.

## `artifacts/`

- `artifacts/` lưu raw customer file và artifact portable không thuộc workflow
  Google Sheets management. Ghi source/mục đích dùng lại trong tên, metadata
  hoặc companion document; khi đổi tên/di chuyển phải cập nhật internal link.
- Intermediate/review artifact dùng workspace-root `scratch/` hoặc `draft/`,
  `output/` bên trong bundle khi owner skill quy định; phải giữ untracked/ignored
  nếu chưa được duyệt. Artifact chính đã được chấp nhận phải promote vào bundle
  parent.
- `artifacts/reports/` chỉ chứa category folder dạng ASCII kebab-case; report
  bundle không đặt trực tiếp dưới `reports/`.
- Bundle dùng `<document_id>_<document_title>/`; file chính dùng
  `<document_id>_<document_title>_<document_kind>`. Title/kind dùng tiếng Nhật
  khi có tên tài liệu tiếng Nhật chính thức.
- Document code dùng `<doc_type>-<domain>-<seq2>` hoặc
  `<doc_type>-<phase>-<domain>-<seq2>`; `seq2` có hai chữ số.
- Code chuẩn: `ARCH` = structure design, `REL` = release plan/checklist,
  `SEC` = security report, `TC` = test case. Phase test chuẩn là `UT`, `IT`,
  `ST`, `UAT`; trong test case, `IT` luôn là integration test.
- Các bản xuất cùng nội dung giữ cùng basename và chỉ khác extension.
  Deliverable `.drawio`, `.svg`, `.png`, `.xlsx`, `.md` đặt tại bundle parent.

## `skills/`

- `skills/` chỉ chứa skill portable đặc định cho project hiện tại. Mỗi skill
  phải có `SKILL.md`; script phải deterministic, không tự gọi LLM và không
  hardcode secret.
- Script resolve binding không bí mật từ `config/project.yaml`; credential chỉ
  được đọc từ environment hoặc local ignored config.
- Không lưu application source, generated output, cache/index hoặc task history
  trong skill. Durable knowledge đặt trong `knowledge/`; candidate/draft đặt
  trong `scratch/`.
- Mỗi skill phải có validator hoặc verification command tương xứng với artifact
  nó tạo và phải chạy verify trước khi coi workflow hoàn tất.

## Verification và hoàn tất

- Knowledge/memory và management phải pass completion contract của owner skill.
- Artifact: chạy validator/render/link check do owner workflow quy định; mọi
  packaging hoặc distributable vẫn chịu approval gate ở root.
- Sau mọi thay đổi, kiểm tra `rtk git status --short` và
  `rtk git -C project-store status --short`; không stage/commit/push nếu User
  chưa yêu cầu.
