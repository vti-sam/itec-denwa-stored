# Verified Case Contract

## Evidence gate

Verified case là knowledge đã được kiểm chứng, không phải bản ghi rating.
Feedback, conversation history và LLM output chỉ giúp phát hiện candidate.
Mỗi case phải có ít nhất một source trực tiếp của project: source-of-truth,
source code/test, issue/WBS, quyết định khách hàng hoặc deliverable truy ngược
được.

Thứ tự ưu tiên khi evidence xung đột:

1. source-of-truth hoặc hành vi source/test hiện tại;
2. verified case còn hiệu lực;
3. historical memory;
4. raw feedback hoặc conversation.

Không xác định được source có thẩm quyền thì case là `unknown` và không lưu.

## Frontmatter

```yaml
---
title: <Tiêu đề tự đủ nghĩa>
project: <project_id từ config/project.yaml>
type: analysis
status: active
source:
  - <project evidence trực tiếp>
  - "feedback: <mô tả tín hiệu, nếu cần>"
tags:
  - verified-case
  - <domain hoặc intent>
scope: durable
updated_at: <YYYY-MM-DD>
case_id: <ascii-kebab-case>
verified_at: <YYYY-MM-DD>
---
```

`feedback:` và `conversation:` được phép giữ provenance nhưng không được là
source duy nhất. Không thêm enum mới vào field schema chung.

## Section bắt buộc

- `# <title>`
- `## Câu hỏi thực tế`
- `## Intent và phạm vi`
- `## Entity và identifier`
- `## Kết luận đã xác minh`
- `## Evidence`
- `## Cách trả lời phù hợp`
- `## Không được kết luận`
- `## Điều kiện áp dụng`

Mỗi section phải có nội dung và không quá 1.200 ký tự; mục tiêu dưới 1.000 ký
tự. Một case chỉ chứa một kết luận nghiệp vụ chính.

## Quy tắc retrieval

- Đặt câu hỏi tự nhiên của User trong `Câu hỏi thực tế`.
- Dùng canonical name/ID từ evidence và ghi rõ điều kiện áp dụng.
- Không sao chép conversation dài, lưu chain-of-thought, keyword stuffing hoặc
  prompt hoàn chỉnh.
- Không để `TODO`, placeholder hoặc câu hỏi mở trong case đã xác minh.

File chỉ hợp lệ tại
`project-store/knowledge/verified-cases/<case_id>.md`. Candidate chưa xác minh
chỉ giữ tạm trong `scratch/` nếu cần và không sync vào FalkorDB.
