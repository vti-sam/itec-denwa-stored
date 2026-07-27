---
name: verified-case-learning
description: Phân tích feedback hoặc conversation do User chỉ định, đối chiếu với evidence của project và chỉ lưu case đã xác minh vào knowledge để FalkorDB retrieval dùng ở các phiên sau. Dùng khi User yêu cầu học từ feedback, gom case đúng/sai, tạo verified case, hoặc cập nhật một verified case hiện có; không dùng để tự động quét history, chạy scheduler hay coi cảm nhận User là bằng chứng nghiệp vụ duy nhất.
---

# Verified Case Learning

## Mục tiêu

Biến tín hiệu từ feedback thành một knowledge case nhỏ, có evidence truy ngược
được và an toàn để retrieval đưa vào prompt ở phiên sau. Skill không fine-tune
model, không tạo graph/index mới và không tự gọi LLM; việc phân tích do model
trong conversation hiện tại thực hiện.

## Rule bắt buộc

1. Đọc root `AGENTS.md`, `project-store/AGENTS.md` và
   `references/verified-case-contract.md` trước khi phân tích hoặc ghi file.
2. Chỉ phân tích conversation, feedback hoặc history mà User đã đặt trong
   scope. Không tự quét các phiên không liên quan.
3. Tách feedback thành preference về cách trả lời và factual/business claim.
4. Feedback là tín hiệu tạo candidate, không tự chứng minh candidate đúng.
   Factual/business claim phải có project evidence trực tiếp.
5. Chỉ case `confirmed` được ghi vào
   `project-store/knowledge/verified-cases/`. Case `unknown` hoặc `refuted`
   không được ghi vào knowledge.
6. Không tạo scheduler, taxonomy, dependency, graph hoặc storage workflow mới.

## Workflow

### 1. Khoanh candidate

- Ghi câu hỏi thực tế, câu trả lời bị đánh giá và lựa chọn feedback.
- Chuẩn hóa intent, entity, action, identifier và phạm vi áp dụng.
- Một file chỉ chứa một kết luận chính; dùng `case_id` ASCII kebab-case ổn định.

### 2. Kiểm chứng

- Với tài liệu/tri thức, dùng
  `skills/knowledge-code/knowledge-memory-sync/` để query và đọc evidence.
- Với hành vi source code, dùng `skills/knowledge-code/source-code-intel/` và
  verify bằng source/test phù hợp.
- Với source-of-truth online, dùng skill owner của backend và read-back khi có
  write; skill này không tự mở rộng quyền cập nhật backend.
- Đánh giá evidence theo intent, entity, action, identifier và thời điểm.
- Nếu evidence mâu thuẫn hoặc thiếu trực tiếp, kết luận `unknown`/`refuted` và
  dừng trước khi ghi knowledge.

### 3. Soạn case

- Dùng `templates/verified-case.md`.
- Giữ schema knowledge hiện có: `type: analysis`, `status: active`,
  `scope: durable`, tag `verified-case`.
- `source` phải có ít nhất một evidence trực tiếp ngoài feedback, conversation
  history hoặc LLM output.
- Viết tự đủ nghĩa, ngắn, retrieval-friendly và dùng canonical identifier.
  Không lặp keyword để ép ranking.
- `Cách trả lời phù hợp` là answer pattern, không phải response dài cố định và
  không được thêm claim chưa có evidence.

### 4. Validate và lưu

1. Chỉ tạo/sửa file đích sau khi candidate đã `confirmed`.
2. Chạy validator:

   `rtk uv run project-store/skills/verified-case-learning/scripts/validate_verified_case.py project-store/knowledge/verified-cases/<case_id>.md`

3. Chạy knowledge lint:

   `rtk uv run skills/knowledge-code/knowledge-memory-sync/scripts/lint_knowledge.py`

4. Sync FalkorDB rồi chạy `doctor`.
5. Query read-back bằng câu hỏi gốc và ít nhất một cách diễn đạt tương đương.
   Không chỉnh keyword chỉ để làm đẹp ranking.

## Cập nhật case hiện có

- Giữ `case_id`; cập nhật `updated_at`, `verified_at` và evidence.
- Nếu source hiện tại bác bỏ case, chuyển case cũ thành `superseded` hoặc
  `archived`, rồi tạo/tham chiếu nội dung thay thế đã verify.
- Nếu chỉ có feedback mới nhưng chưa có evidence mới, không thay đổi kết luận
  nghiệp vụ đã lưu.

## Kết quả bàn giao

Báo candidate được lưu hoặc bị loại, evidence, file đã đổi và kết quả
validator/lint/sync/query. Không tạo memory chỉ để ghi lịch sử phát triển skill.
