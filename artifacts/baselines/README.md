# Management Baselines

Thư mục này lưu lịch sử thay đổi theo phase hoặc mốc quản lý lớn. Không dùng làm trạng thái hiện tại và không dùng để ghi daily log.

Trạng thái hiện tại nằm trong các YAML IN HOA ngay dưới `management/`, ví dụ `WBS.yaml`, `RISKS.yaml`, `DECISIONS.yaml`.

## Khi nào tạo baseline

- Kết thúc một phase hoặc sprint dài khoảng 1-2 tuần.
- Có thay đổi scope/stakeholder lớn.
- Có task mới đổ về làm thay đổi kế hoạch quản lý hiện tại.
- Cần chốt trạng thái trước khi chuyển sang phase tiếp theo.

## Quy ước đặt tên

```text
YYYY-MM-DD_<phase-name>.md
```

Ví dụ:

```text
2026-05-31_phase1-design-baseline.md
2026-06-15_phase2-implementation-update.md
```

## Template

```markdown
# Baseline: <phase name>

## Thời điểm

- Ngày chốt:
- Phase:
- Người/nhóm liên quan:

## Trạng thái chốt

- Scope đã hoàn thành:
- Scope còn lại:
- Task mới phát sinh:
- Stakeholder thay đổi:
- Risk/issue chính:

## Delta so với baseline trước

- Scope:
- Schedule:
- Cost/resource:
- Quality/acceptance:

## Next phase plan

- Mục tiêu:
- Deliverable:
- Open items cần xử lý:
- Điều kiện cần confirm:
```
