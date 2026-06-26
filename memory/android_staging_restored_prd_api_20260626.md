---
title: Android staging build restored with production API
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session on 2026-06-26
tags:
  - android
  - staging
  - firebase-distribution
  - production-api
scope: historical
captured_at: 2026-06-26
validity: historical_context
promote_to_knowledge: false
---

Android staging was restored after the previous STG removal. The restored staging build type uses package `jp.co.itec.denwa.stg` and Firebase VTI dev app id `1:16254034261:android:75a5e055aa933144b58fdc`, but its public endpoints were intentionally pointed to production:

- `APPLICATION_ENDPOINT=https://api.apl.purattocall.com`
- `SOCKET_ENDPOINT=https://api.apl.purattocall.com`

`env_staging.json` keeps app name `ぷらっとCALL (S)`.

Build logic was updated so staging can load registry-backed secrets/signing:

- secret dir supports registry names such as `production.secrets.json`
- staging resolves production secret first because it calls production API
- signing config supports both `keystore.json` and `signing-config.json`
- JKS fallback names support registry files `developer.jks`, `staging.jks`, and `production.jks`

Verification:

```sh
JAVA_HOME=$(/usr/libexec/java_home -v 21) \
DENWA_ANDROID_ENV_SECRET_DIR=/Users/vti-sam/pm-control/itec-denwa/registry/keystore/projects/itec-denwa/android/env \
DENWA_ANDROID_KEYSTORE_DIR=/Users/vti-sam/pm-control/itec-denwa/registry/keystore/projects/itec-denwa/android/signing \
./gradlew :app:assembleStaging --stacktrace
```

The build passed and generated `app/build/outputs/apk/staging/itec-denwa_staging_1.0.0.stg_b(0055)_22394a0.apk`.
