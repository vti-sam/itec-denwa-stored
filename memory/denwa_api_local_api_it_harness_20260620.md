---
title: denwa-api local API integration harness
project: itec-denwa
type: runbook
status: archived
source:
- memory/denwa_api_local_api_it_harness_20260620.md
tags:
- denwa-api
- testcontainers
- docker
- api-test
- ip-whitelist
scope: historical
captured_at: '2026-06-20'
validity: historical_context
promote_to_knowledge: false
---

`sources/denwa-api` branch `dev` has commit `a05abaf7` (`test: add API integration harness`) pushed to `origin/dev`.

Later expansion commit `48bdeb50` (`test: expand UAT API integration coverage`) added a dynamic suite now named `VoipWebApiRegressionIT`, covering all 104 web cases as API/integration checks. The suite uses a shared local Testcontainers Postgres container, SQL reset per test, an in-process MVE HTTP stub, and an S3 test stub. Verified command:

```bash
DOCKER_HOST=unix://$HOME/.colima/default/docker.sock \
TESTCONTAINERS_RYUK_DISABLED=true \
JAVA_HOME=$(/usr/libexec/java_home -v 21) \
./mvnw -Papi-it verify
```

Latest verification passed 110 tests total: 104 UAT dynamic cases plus 6 existing integration tests.

Product fixes found by the expanded UAT harness:
- `/tenant/delete` returned null/500; controller now returns a normal `BaseResponse`.
- Tenant delete mapper now cleans related tenant master rows and drops `<tenant_id>_schema`.
- Reset password OTP validation now treats missing OTP records as invalid OTP instead of NPE/500.
- User activation mail now returns 400 when no selected user is eligible, avoiding a silent success/no-op.

Local Docker setup uses Homebrew Docker CLI, Docker Compose plugin, and Colima QEMU. Verified versions: Docker client `29.6.0`, Docker server `29.5.2`, Compose `5.1.4`. Testcontainers needs the Colima socket explicitly:

```bash
DOCKER_HOST=unix://$HOME/.colima/default/docker.sock \
TESTCONTAINERS_RYUK_DISABLED=true \
JAVA_HOME=$(/usr/libexec/java_home -v 21) \
./mvnw -Papi-it verify
```

`TESTCONTAINERS_RYUK_DISABLED=true` is needed on this Colima/QEMU setup because Ryuk times out before logging its startup marker. The verified `api-it` run passed 6 integration tests covering system-admin login, multi-role login/selection, tenant pre-token issuance, and IP whitelist denial.

UAT web testcase artifacts are in `project-store/artifacts/reports/testcase/VoIPWebテストケース/TEST-UAT-01_VoIPWebテストケース.md` and `project-store/artifacts/reports/testcase/VoIPWebAPI自動化判定/TEST-AUTO-01_VoIPWebAPI自動化判定.md`; they were not committed with the source repo because they belong to the root project-store/artifacts workspace.

Operator runbook for repeat local execution is now stored at `project-store/knowledge/denwa-api/runbooks/local-autotest.md`. Convenience script is `project-store/artifacts/scripts/run_denwa_api_it_local.sh`; verified on 2026-06-20 after changing it to call `bash ./mvnw -Papi-it verify` because `sources/denwa-api/mvnw` is not executable in this checkout. Latest script run passed `110 tests, 0 failures, 0 errors, 0 skipped`.

API IT testcase spec for the 104 converted web cases is stored at `project-store/artifacts/reports/testcase/VoIPWebAPI結合テスト/TEST-IT-02_VoIPWebAPI結合テストカバレッジ.md`. It maps each original `Role + TC ID` to the current `VoipWebApiRegressionIT` method, converted API assertion, and coverage gap (`equivalent`, `api-equivalent`, `negative-equivalent`, `smoke`, or `partial`).

2026-06-20 update: `VoipWebApiRegressionIT` was expanded again locally and full `./mvnw -Papi-it verify` passed `110 tests, 0 failures, 0 errors, 0 skipped`. The run now covers tenant create success, tenant admin mail send/resend, CSV success upload with MS932/CRLF test data, CSV error-file name assertions, password/OTP lock flows, DB read-back assertions, maintenance import block/recovery, and MVE export content assertions. The test harness now stubs `jp.holiday.csv.url` in `ApiIntegrationTestSupport`; without this, tenant create/mail flows can hit `HolidayJpUtility` and return 500. Production mapper fix: `AdminMapper.xml#getListTAdminNotSendMailByAdmin` needs `resultType="jp.co.itec.denwa.model.entity.admin.Admin"` so tenant-admin mail update receives `adminUuid` and does not return 0/500. For fixture tenant `111`, CSV valid rows must use a real email (`csv-user-<sip>@example.test`) because SIP-only behavior is tied to tenant names ending `_SIPP`, and fixture `Test Tenant` is a normal tenant.
