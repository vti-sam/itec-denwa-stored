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
  - missing-tenant
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

Deployment evidence: commit `6ddf9342` was pushed to `origin/dev`. GitLab built ECR image `itec-denwa-backend:1.1.1-458` and registered ECS task definition `denwa-backend-task:252`. DEV service `denwa-backend-task-service-4mh4rz2a` reached `PRIMARY:COMPLETED` on task definition `252` with one running task. Pulling image `1.1.1-458` from ECR and running it locally confirmed `User=appuser` and successful writes to `/var/denwa/csv/result` and `/var/denwa/company-logo`.

Follow-up on the same day: after adding diagnostic logs in `UserService.createCsvFileError()` via commit `577115bc` and deploying image `itec-denwa-backend:1.1.1-459` / ECS task definition `denwa-backend-task:253`, direct DEV API calls with tenant `503` still returned HTTP 500 but did not hit the CSV error-file logging. Querying DEV DB showed tenant `503` and schema `503_schema` do not exist. The code path throws `Error500Exception` in `UserService.getCsvUserListAndCheck()` when `tenantService.getTenantInfo(tenantId)` is empty, before CSV validation runs.

Control test against existing DEV tenant `500` with the same files returned expected HTTP 400 and an error CSV filename for both `user_chuakytudacbiet.csv` and `user_ko phai Katakana.csv`. This separates the runtime directory issue from the DEV test-data issue: invalid CSV handling works for an existing tenant after the directory fix, but missing tenant IDs are still surfaced as 500 and should be changed to a 400 tenant-not-found validation error if that behavior is in scope.

The missing-tenant behavior was fixed in commit `c3e3eee1`: `UserService.getCsvUserListAndCheck()` now throws `Error400Exception` with `MSG_ERR_00015` when the requested tenant does not exist. Integration test `UserCsvMissingTenantIT` locks the HTTP 400 response and message key. Local regression tests `UserCsvMissingTenantIT`, `ExternalUserCsvUploadDataIT`, and `UserCsvErrorFileWriterIT` passed with JDK 21.

GitLab pipeline `708030` deployed ECR image `itec-denwa-backend:1.1.1-460` and ECS task definition `denwa-backend-task:254`. The build job initially stalled while installing OpenJDK and was canceled/retried as job `1195943`; both the retried build and deploy job completed successfully. The ECS service required a direct update to task definition `254` because the deploy script stopped the running task before changing the service revision, causing ECS to restart revision `253`.

Final direct DEV API verification with nonexistent tenant `503`:

- `user_chuakytudacbiet.csv`: HTTP 400, code `400`, key `MSG_ERR_00015`.
- `user_ko phai Katakana.csv`: HTTP 400, code `400`, key `MSG_ERR_00015`.
