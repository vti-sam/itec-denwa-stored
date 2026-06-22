---
title: DEV upload user CSV 500 do runtime directory permission
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-06-22 API direct test and ECS/ECR inspection
  - sources/denwa-api/Dockerfile
  - sources/denwa-api/src/main/resources/config/application-dev-cloud.properties
tags:
  - denwa-api
  - upload-user-csv
  - ecs
  - dockerfile
  - runtime-directory
scope: historical
captured_at: 2026-06-22
validity: historical_context
promote_to_knowledge: false
---

# DEV upload user CSV 500 do runtime directory permission

Direct DEV API upload for invalid CSV files `user_chuakytudacbiet.csv` and `user_ko phai Katakana.csv` returned HTTP 500, while local backend tests returned HTTP 400 with an error CSV file.

ECS DEV backend was running `denwa-backend-task:251`, image `itec-denwa-backend:1.1.1-456`, profile `dev-cloud`, with no volume or mount point for `/var/denwa`. The live image config had `User=appuser`. Pulling the same ECR image and running `mkdir -p /var/denwa/csv/result` as the container user failed with `Permission denied`.

The code writes validation error CSV files under `csv.result.dir=/var/denwa/csv/result`. When an invalid upload needs an error file, the app can fail before returning the expected 400 response if the runtime directory is not writable.

Fix applied in `sources/denwa-api/Dockerfile`: create `/var/denwa/csv/result` and `/var/denwa/company-logo`, then `chown -R appuser:root /var/denwa` before switching to `USER appuser`. Local Docker build verified that `appuser` can touch files in both directories.
