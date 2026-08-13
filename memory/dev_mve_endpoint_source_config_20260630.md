---
title: DEV MVE endpoint source config aligned to demo MVE
project: itec-denwa
type: lesson
status: archived
source:
  - sources/denwa-api/src/main/resources/config/application-dev.properties
  - sources/denwa-api/src/main/resources/config/application-dev-cloud.properties
  - project-store/skills/mve-users-sync/scripts/fetch_mve_users.py
tags:
  - mve
  - dev
  - source-config
  - denwa-api
scope: historical
captured_at: 2026-06-30
validity: historical_context
promote_to_knowledge: false
---

# DEV MVE endpoint source config aligned to demo MVE

DEV DB `master_schema.system_settings` was verified through the project-local MVE users skill as pointing to `c2.cd-demo-mve.com`.

The source profiles `application-dev.properties` and `application-dev-cloud.properties` previously pointed `mve.file.ini` and `mve.ini.incremental` to production MVE `app-mve.purattocall.com`. Both DEV source profiles were aligned to `https://c2.cd-demo-mve.com/api/v1/files/ini` and `https://c2.cd-demo-mve.com/api/v1/files/ini/incremental`.

STG/PRD profiles intentionally remain on `app-mve.purattocall.com`; test profile remains on the local stub.
