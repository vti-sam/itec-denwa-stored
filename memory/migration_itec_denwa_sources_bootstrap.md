---
title: ITEC Denwa sources bootstrap migration
project: itec-denwa
type: lesson
status: archived
source:
- memory/migration_itec_denwa_sources_bootstrap.md
tags:
- migration
- bootstrap
- sources
- management
scope: historical
captured_at: '2026-06-17'
validity: historical_context
promote_to_knowledge: false
---

Migrated the new `itec-denwa` workspace by running `scripts/bootstrap_project.py --project itec-denwa --fetch-management`, copying source project folders from `/Users/vti-sam/pm-control/itec-denwa_bk/sources` into local `sources/`, and moving the root `sources/google-services.json` from the backup into `registry/keystore/projects/itec-denwa/android/firebase/production-google-services.json`. The copied source project folders `denwa-android`, `denwa-api`, `denwa-front`, and `denwa-ios` matched the backup by rsync checksum dry-run. Management YAML was fetched from Google Sheets and pushed to Drive snapshot for the `management` folder.
