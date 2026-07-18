# AGENTS.md

- `config/` là source-of-truth cho cấu hình riêng của project hiện tại.

## Boundaries

- `project.yaml` chỉ chứa cấu hình portable không bí mật, service binding và đường dẫn tới local keystore.
- Secret local chỉ được đặt trong `secrets.local.yaml` hoặc `keystore.local/`; cả hai bắt buộc bị ignore khỏi nested Git repo.
- Không commit API key, token, password, private key, signing key hoặc service-account credential trong subtree này.
- Khi đổi resource hoặc binding, chạy bootstrap dry-run và smoke test read-only của skill liên quan.

## Git Workflow

- Không stage/commit/push nếu User chưa yêu cầu.
