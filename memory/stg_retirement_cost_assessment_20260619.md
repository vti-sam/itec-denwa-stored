---
title: STG retirement cost assessment
project: itec-denwa
type: lesson
status: archived
source:
- memory/stg_retirement_cost_assessment_20260619.md
tags:
- aws
- staging
- cost
- retirement
scope: historical
captured_at: '2026-06-19'
validity: historical_context
promote_to_knowledge: false
---

Read-only AWS verification for STG retirement:

- `denwa-stg-cluster` has two active EC2-launch-type services, each desired/running count `1`.
- STG uses a dedicated running `t3.large` ECS container instance (`i-0808233d16b49c7fe`) with a 50 GB gp2 EBS volume.
- There is no separate live STG RDS instance. The STG backend task points to the PRD RDS endpoint but uses database name `denwa_stg`.
- Backend and frontend ALBs are shared with DEV/PRD; removing only STG target groups/listener rules will not remove the ALB fixed cost.
- The STG S3 bucket contains approximately 114 MB across 603 objects, so its storage cost is negligible relative to the dedicated EC2 instance.
- Primary savings from retirement come from the dedicated STG EC2 instance; secondary savings come from EBS and logs. ECS cluster metadata itself has no meaningful standing cost.
- Safer retirement sequence: scale STG services to zero, disable STG routing, retain backup/config briefly, then terminate the dedicated EC2 instance and remove residual STG-only resources after validation.

AWS Price List API values retrieved on 2026-06-19 for Asia Pacific (Tokyo), Linux On-Demand:

- EC2 `t3.large`: USD 0.1088/hour, approximately USD 79.42 per 730-hour month.
- EBS gp2: USD 0.12/GB-month; the 50 GB STG volume is approximately USD 6.00/month.
- Fixed direct STG compute/storage estimate: approximately USD 85.42/month or USD 1,025/year, excluding tax, data transfer, CloudWatch usage and discounts/commitments.
- S3 holds only about 114 MB, so its monthly storage charge is below one cent at normal S3 Standard rates.
