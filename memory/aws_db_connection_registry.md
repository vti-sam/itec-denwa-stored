---
title: AWS DB connection registry
project: itec-denwa
type: architecture
status: archived
source:
- memory/aws_db_connection_registry.md
tags:
- aws
- rds
- registry
- bastion
scope: historical
captured_at: '2026-06-18'
validity: historical_context
promote_to_knowledge: false
---

Full PostgreSQL connection details for dev and prd are stored locally at `registry/keystore/projects/itec-denwa/infra/shared/database-connections.yaml` with file mode `600`.

- Dev currently uses Secrets Manager secret `/denwa/stg/all`; `/denwa/dev/all` does not exist.
- PRD uses Secrets Manager secret `/denwa/prd/all`.
- The bastion public IP is dynamic because the instance has no Elastic IP. Re-check EC2 and update the registry after stop/start operations.
- Passwords were verified against the `db-password` field in each AWS secret on 2026-06-18.
