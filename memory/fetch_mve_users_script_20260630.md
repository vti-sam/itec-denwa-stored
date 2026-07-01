---
title: Add fetch_mve_users.py script to fetch MVE SBC users
project: itec-denwa
type: runbook
status: archived
source:
  - Conversation ID: 9b027e71-35ff-40d7-92cc-8830ee5155f2
  - project-store/artifacts/scripts/fetch_mve_users.py
tags:
  - mve
  - sbc
  - fetch-script
  - sip-users
scope: historical
captured_at: 2026-06-30
validity: historical_context
promote_to_knowledge: false
---

# Add fetch_mve_users.py script to fetch MVE SBC users

## Context & Objective
The MVE (Mobile Virtual Extension) server for Purattocall configuration runs on `13.112.245.12` (resolved from `app-mve.purattocall.com`). Staging application requires retrieving the SBC configuration file (`.ini` format) from MVE endpoint `https://app-mve.purattocall.com/api/v1/files/ini` using HTTP Basic Authentication configured in `infra/staging/application.properties`.

This memory documents the script added to retrieve and parse the SIP users table (`SBCUserInfoTable`) from the MVE configuration.

## Implementation Detail
We created the [fetch_mve_users.py](file:///Users/vti-sam/pm-control/itec-denwa/project-store/artifacts/scripts/fetch_mve_users.py) script which:
1. Dynamically loads credentials from [application.properties](file:///Users/vti-sam/pm-control/itec-denwa/registry/keystore/projects/itec-denwa/infra/staging/application.properties) (`mve.file.ini`, `mve.username`, `mve.password`).
2. Pulls the `.ini` config from the server.
3. Parses and outputs the parsed SIP users.

## How to use
```bash
python project-store/artifacts/scripts/fetch_mve_users.py [--output output.json|output.csv] [--config config_path]
```
