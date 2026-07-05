---
title: DEV voicemail voiceFileUrl null do thieu quyen S3 PutObject
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-03 voice mail missed call DEV voiceFileUrl null investigation
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/service/call/CallService.java
  - sources/denwa-api/src/main/java/jp/co/itec/denwa/aws/S3Utils.java
  - CloudWatch log group /ecs/denwa-backend-task
tags:
  - denwa-api
  - dev
  - voicemail
  - voiceFileUrl
  - s3
  - ecs
scope: historical
captured_at: 2026-07-03
validity: historical_context
promote_to_knowledge: false
---

Ngay 2026-07-03, khi dieu tra loi voice mail cuoc goi nho tren DEV tra `voiceFileUrl=null`, runtime evidence cho thay nguyen nhan la ECS task role DEV khong co quyen `s3:PutObject` vao bucket `denwa-s3-dev-2025`.

Flow source:

- `CallService.addVoiceMessage()` upload file len S3 bang key `<tenantId>/<originalFilename>`, sau do goi `s3Utils.getUrlFromBucketS3(key)` va update `calls.voice_file_url`.
- `S3Utils.uploadFileToBucketS3()` catch all exception va chi log error, khong throw.
- Neu upload fail, `getUrlFromBucketS3()` goi `headObject`; object khong ton tai thi tra `null`, dan toi response va DB `voice_file_url` bi null.

Bang chung runtime:

- DEV backend ECS: cluster `denwa-dev-cluster`, service `denwa-backend-task-service-4mh4rz2a`, task definition `denwa-backend-task:269`, image `itec-denwa-backend:1.1.1-482`, profile `dev-cloud`.
- PRD backend ECS: cluster `denwa-prd-cluster`, service `denwa-backend-prd-service`, task definition `denwa-backend-prd:24`, image `itec-denwa-backend:1.1.1-481`, profile `pro`.
- DB DEV `112_schema`: trong 14 ngay gan nhat co cac row non-deleted duoc update sau create nhung `voice_file_url` van null; latest candidate luc `2026-07-03 08:06:33.737392`.
- DB PRD `111_schema`: co row voicemail non-null gan nhat luc `2026-07-03 08:22:22.676332`.
- S3 DEV bucket `denwa-s3-dev-2025` chi co object cu dang anh duoi prefix `111/` va `112/`; khong co recording moi ngay 2026-07-03.
- S3 PRD bucket `denwa-s3-prd-2026` co nhieu file `recording_*.m4a` moi ngay 2026-07-03.
- CloudWatch DEV luc `2026-07-03T08:06:10.674Z` va `2026-07-03T08:06:33.690Z` log `uploadFileToBucketS3 error`: assumed role `denwa-dev-ecs-task-role` is not authorized to perform `s3:PutObject` on `arn:aws:s3:::denwa-s3-dev-2025/112/...m4a` because no identity-based policy allows the action.

IAM/S3 config tai thoi diem kiem tra:

- ECS task role `denwa-dev-ecs-task-role` chi attach `AmazonS3ReadOnlyAccess` cho S3, khong co `s3:PutObject`.
- DEV bucket policy chi allow `s3:GetObject` tren `arn:aws:s3:::denwa-s3-dev-2025/*`.
- PRD bucket policy allow `s3:*` tren `arn:aws:s3:::denwa-s3-prd-2026/*`, nen PRD van upload duoc du task role chi read-only.

Huong xu ly lan sau: cap quyen write toi bucket DEV cho ECS task role hoac chinh bucket policy DEV cho dung scope can thiet, toi thieu `s3:PutObject` va `s3:GetObject`/`s3:ListBucket`/`s3:HeadObject` neu can verify object. Sau do test lai `/voice-message` va kiem tra S3 object + `calls.voice_file_url` read-back.

## Fix applied 2026-07-03

Da them inline IAM policy `denwa-dev-s3-voice-message-write` vao role `denwa-dev-ecs-task-role`.

Policy scope:

- Action: `s3:PutObject`
- Resource: `arn:aws:s3:::denwa-s3-dev-2025/*`

Verify sau khi ghi:

- Read-back role `denwa-dev-ecs-task-role` thay inline policy moi voi statement `AllowDevVoiceMessageUpload`.
- IAM simulation cho `arn:aws:s3:::denwa-s3-dev-2025/112/test-voice-message-fix.m4a` tra `allowed` cho `s3:PutObject`.
- `s3:GetObject` van `allowed` nho managed policy `AmazonS3ReadOnlyAccess` da co san tren role.
- ECS DEV backend service `denwa-backend-task-service-4mh4rz2a` van steady voi task definition `denwa-backend-task:269`, running `1/1`.

Chua co test app moi sau fix trong session nay. Can tao/nhan mot missed-call voicemail tren DEV va read-back S3 object + DB `calls.voice_file_url` de xac nhan end-to-end.
