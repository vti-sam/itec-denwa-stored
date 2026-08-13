# AGENTS.md

File này kế thừa root `AGENTS.md` và chỉ bổ sung boundary cho toàn bộ
`project-store/`. Không tạo `AGENTS.md` trong folder con; boundary đặc thù phải
được bổ sung tại đúng section này. Approval, secret, destructive action, online
write và packaging gate của root luôn còn hiệu lực.

Link nội bộ dùng path từ workspace root với prefix `project-store/`.

## Stored project

- `project-store/` là nested Git repo chứa snapshot portable riêng của project.
- Chỉ `config/`, `knowledge/`, `memory/`, `artifacts/`, `management/` và
  `skills/` là top-level data folder được phép.
- Application source nằm ngoài nested repo dưới `sources/<project>/`. Cache,
  index, build output, secret tracked và draft một lần không được lưu trong
  snapshot; dùng `scratch/` hoặc ignored path do owner skill quy định.
- Bootstrap bình thường chỉ kiểm tra repo stored hiện có; không tự fetch, pull,
  reset, stage, commit hoặc push. Flow `--init-stored` chỉ khởi tạo local từ rule
  mẫu, không tạo remote/commit/push. Clone/pull phải là action cụ thể đã được
  User duyệt.
- Sau thay đổi, kiểm tra status của cả root repo và nested repo. Không stage,
  commit hoặc push nếu User chưa yêu cầu.

## Source-of-truth map

| Dữ liệu | Source-of-truth hoặc đích hợp lệ |
|---|---|
| Project ID, resource binding, backend và endpoint không bí mật | `config/project.yaml` |
| Credential, token và key material | Environment hoặc local ignored config |
| WBS, risks, decisions, stakeholders, communications | `management/*.md`; Google Sheets chỉ là projection |
| Tri thức bền đã verify | `knowledge/` |
| Historical project outcome có anchor | `memory/` |
| Raw customer file và artifact portable | `artifacts/` |
| Workflow deterministic riêng của project | `skills/` |
| Draft, candidate, cache, index và output tạm | Workspace `scratch/` hoặc ignored path do owner skill quy định |

## config/

- `config/project.yaml` là source-of-truth portable duy nhất cho project ID,
  resource binding và backend dùng chung. Không đưa secret thật vào file này.
- `config/management.override.yaml` chỉ tồn tại khi owner workflow có một
  khác biệt đã được xác định; không dùng nó để nhân bản template chung.
- Secret thật chỉ nằm trong environment, `config/secrets.local.yaml` hoặc
  `config/keystore.local/`; các path local phải bị nested Git ignore.
- `knowledge_memory.graph` phải ổn định và chỉ gồm chữ, số, dấu gạch dưới.
  Không lưu cache hoặc index trong `config/`.
- Binding source-intelligence nếu có phải lấy từ `config/project.yaml` và
  route qua owner skill; rule này không tự tạo index.
- Khi đổi project ID, endpoint hoặc binding, chạy bootstrap dry-run và smoke
  test read-only của workflow liên quan trước online write.

## management/

- Markdown trong `management/` là source-of-truth duy nhất. Google Sheets chỉ
  là projection có thể xoá và dựng lại từ Markdown; `.sync-state.json` chỉ là
  metadata disposable, còn YAML cũ không còn là nguồn dữ liệu.
- Mọi mutation dùng completion contract của owner skill:
  `validate MD → plan → approval → publish/rebuild → read-back`.
  Không định danh record bằng row number hoặc row order.
- Google Sheets chỉ phản ánh ngược vào Markdown khi chạy trực tiếp lệnh
  `management-google-sheets import`; lệnh này tạo candidate trước, chỉ
  `--apply` mới cập nhật Markdown chính, và không tự publish lại. Schema và
  authoring gate thuộc `management-authoring`.
- Duplicate stable `id` phải dừng; record mới chỉ được tạo khi request cho phép.
- Chỉ xóa record khi dry-run của owner workflow đánh dấu xóa từ authoritative
  snapshot đã được duyệt; thiếu record trong partial cache không tự là lệnh xóa.
- `deadline` là hạn kế hoạch; `end_date` chỉ ghi khi item hoàn thành có căn cứ.
- Tên cột và nội dung Markdown thuộc `management-authoring`; dropdown và
  generated view của WBS thuộc `management-google-sheets`; không tạo biến thể
  riêng trong rule này.
- Chỉ ghi Decisions khi task thực sự tạo hoặc thay đổi quyết định vận hành;
  không tạo decision store song song.
- Sau mọi online write, read-back đúng table và stable `id`, kiểm tra encoding
  UTF-8 và dừng nếu kết quả khác dry-run.

## knowledge/

- `knowledge/` là source-of-truth cho tri thức bền, reusable và có evidence;
  backend/index chỉ là dữ liệu có thể rebuild.
- Không lưu raw customer file, draft, credential, application source hoặc dữ
  liệu chưa verify. Taxonomy, metadata và status phải có source/evidence.
- Frontmatter, schema và lint dùng owner skill
  `skills/knowledge-code/knowledge-memory-sync/`.
- Verified case phải dùng `project-store/skills/verified-case-learning/` và
  chỉ lưu evidence trực tiếp; candidate chưa đủ evidence để ở `scratch/`.

## memory/

- `memory/` chỉ lưu historical context có relevance trực tiếp với project,
  không phải active source-of-truth hoặc changelog của rule/skill/tool chung.
- Trước khi ghi phải có project anchor kiểm chứng được; trước file mới phải tìm
  memory cùng anchor/identifier để update đúng outcome.
- Body phải tách đúng bốn mục `Outcome`, `Evidence`, `Unresolved` và
  `Retrieval keys`. Evidence chỉ dùng source trực tiếp hoặc read-back; phần
  chưa đủ căn cứ nằm ở `Unresolved`.
- Không dump transcript, secret hoặc token. Frontmatter, capture, sync và
  retrieval tuân theo owner skill và root memory gate.

## artifacts/

- `artifacts/` lưu raw customer file và artifact portable ngoài workflow
  Google Sheets. Source/mục đích tái sử dụng phải được ghi trong metadata hoặc
  companion document; đổi tên/di chuyển phải cập nhật internal link.
- Draft/review/intermediate để trong `scratch/` hoặc output path do owner skill
  quy định; artifact chính chỉ promote sau acceptance theo workflow.
- Naming, document ID, code, vocabulary, bundle layout và renderer thuộc
  skill tài liệu tương ứng; không copy danh sách convention vào rule này.

## skills/

- `skills/` chỉ chứa workflow portable đặc định cho project. Mỗi skill có
  `SKILL.md`; script phải deterministic, không tự gọi LLM và không hardcode
  secret.
- Script đọc binding không bí mật từ `config/project.yaml`; credential chỉ
  đọc từ environment hoặc local ignored config.
- Không lưu source, generated output, cache/index hoặc task history trong skill.
  Durable knowledge ở `knowledge/`, candidate/draft ở `scratch/`.
- Mỗi skill phải có validator hoặc verification command tương xứng với artifact
  nó tạo.

## Verification và hoàn tất

- Knowledge/memory, management và artifact phải pass completion contract của
  owner skill; verify ở phạm vi hẹp nhất chứng minh được thay đổi.
- Sau mỗi write, kiểm tra diff và status của root cùng nested `project-store/`.
- Closeout phải báo memory `created`, `updated` hoặc `not applicable`; không
  kết luận hoàn tất khi write/read-back bắt buộc còn thiếu.
