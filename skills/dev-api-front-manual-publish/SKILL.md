---
name: dev-api-front-manual-publish
description: Manually build, push, deploy, and verify itec-denwa API and Front DEV infra when GitLab CI/CD is pending, failed because runner devops is unavailable, or the user asks to publish local/manual instead of CI. Use for denwa-api, denwa-front, API-only, Front-only, or combined DEV ECS/ECR publish workflows.
---

# DEV API/Front Manual Publish

## Overview

Use this project-store skill to publish `denwa-api` and/or `denwa-front` to DEV infrastructure without relying on GitLab CI. It mirrors the DEV CI build/deploy convention, but runs locally from a clean `origin/dev` snapshot, pushes images to ECR, updates ECS services, waits for rollout, and performs smoke checks. It can also verify the currently running DEV services after an interrupted or long-running publish attempt.

## Fixed DEV Targets

- API source: `sources/denwa-api`.
- Front source: `sources/denwa-front`.
- Git ref: `origin/dev` unless a task requires a specific ref.
- AWS account: `668426476432`.
- AWS region: `ap-northeast-1`.
- ECS cluster: `denwa-dev-cluster`.
- API service: `denwa-backend-task-service-4mh4rz2a`.
- Front service: `denwa-frontend-service`.
- API ECR repo/tag format: `itec-denwa-backend:<TAG_VERSION>-<pipeline_iid>`.
- Front ECR repo/tag format: `itec-denwa-frontend:<TAG_VERSION>-<pipeline_iid>` and `itec-denwa-frontend:<TAG_VERSION>-<pipeline_iid>-<short_sha>`.
- Front DEV API build arg: `VITE_API_BASE_URL=https://api-dev.apl.purattocall.com`.

## Required Context

- Read root `AGENTS.md`, `sources/AGENTS.md`, and this skill before using the workflow.
- Use `skills/knowledge-code/source-code-intel/` rules before operating on source under `sources/`.
- Use `skills/project-ops/aws-ops-check/` for AWS authentication and verification context.
- Treat project-local AWS credentials and GitLab tokens as secrets. Do not print secret values.
- Use local snapshots under `scratch/`; do not switch the user's working branches just to deploy.

## Quick Command

Run from repo root after merging/fetching the target `dev` revision:

```bash
rtk bash project-store/skills/dev-api-front-manual-publish/scripts/manual_publish_dev.sh --component api
rtk bash project-store/skills/dev-api-front-manual-publish/scripts/manual_publish_dev.sh --component front
rtk bash project-store/skills/dev-api-front-manual-publish/scripts/manual_publish_dev.sh --component all
```

Pass `--api-pipeline-iid` or `--front-pipeline-iid` only when the GitLab API cannot discover the pending pipeline for the exact commit.

## Quick Verify

Use verify-only mode when a previous publish command was interrupted, looked stuck, or completed without a readable final summary:

```bash
rtk bash project-store/skills/dev-api-front-manual-publish/scripts/manual_publish_dev.sh --component api --verify-only
rtk bash project-store/skills/dev-api-front-manual-publish/scripts/manual_publish_dev.sh --component front --verify-only
rtk bash project-store/skills/dev-api-front-manual-publish/scripts/manual_publish_dev.sh --component all --verify-only
```

`--verify-only` must not build, push, register, or update ECS. It only reads AWS state, checks the live task image digest against ECR, and runs smoke checks unless `--skip-smoke` is passed.

## Anti-Hang Operating Rules

- Do not wait on GitLab CI when jobs are pending/created with `runner=None`; use the pipeline IID for image tagging and continue manual publish.
- Do not trust a long-running terminal as deployment evidence. Verify directly with ECS/ECR/smoke using `--verify-only` before rerunning build or deploy.
- Keep ECS rollout waits bounded. Use `--ecs-timeout` and `--ecs-poll-interval` when a service needs a different wait window.
- If ECS wait times out or fails, inspect the printed recent ECS service events before attempting another update.
- Always finish with the script summary: selected component, image tag, ECS task definition, rollout state, running count, digest match, smoke result, and GitLab runner status when available.

## Workflow

1. Confirm the target MR is merged or the intended `origin/dev` commit is known.
2. Fetch the newest remote `dev` for the selected repo(s) with `--no-tags` into `refs/remotes/origin/dev`. Do not build from stale local tracking refs.
3. Ensure CodeGraph for the selected source repo(s).
4. Check GitLab pipeline status for the exact commit. If CI is pending/stuck due runner, continue manual publish; do not block on CI completion.
5. Run `scripts/manual_publish_dev.sh` with the selected component.
6. Verify the script reports:
   - build/type-check success,
   - GitLab pipeline/job status and runner assignment when available,
   - ECR pushed tag and digest,
   - ECS task definition revision,
   - rollout `COMPLETED`, running `1/1`,
   - running task digest matching ECR,
   - DEV smoke test success.
7. If the terminal is interrupted or the command appears to run too long, run the same component with `--verify-only` and report direct ECS/ECR/smoke state.
8. Record merge/deploy evidence in `project-store/memory/` and sync Qdrant when the run creates useful historical context.

## Script Behavior

`scripts/manual_publish_dev.sh`:

- loads AWS credentials from `project-store/config/keystore.local/` when environment credentials are absent;
- reads GitLab credentials through `git credential fill`;
- resolves the selected ref to an exact commit;
- fetches `origin/dev` explicitly with `--no-tags` before resolving the default `origin/dev` ref;
- discovers the GitLab pipeline IID for that commit/ref, unless explicitly provided;
- reports GitLab pipeline/job status and runner assignment when the pipeline can be found;
- creates a clean archive snapshot under `scratch/manual-publish-dev-*`;
- builds API with Maven and skipped tests, matching CI;
- runs Front `npm ci` and `npm run type-check` in a Node 18 container before Docker build;
- builds Linux AMD64 Docker images and pushes CI-compatible ECR tags;
- registers a new task definition from the current live ECS service task definition;
- updates ECS with rolling deployment and does not stop running tasks manually;
- verifies ECR/running task digest match;
- runs API and/or Front DEV smoke checks;
- supports `--verify-only` for direct post-run verification without build/push/deploy.

## Troubleshooting

- If GitLab pipeline discovery fails, read the pipeline URL/API and pass the IID explicitly.
- If a pipeline stays pending/created with `runner=None`, treat CI as unavailable and proceed with manual publish.
- If a publish attempt looks stuck or the terminal output is lost, run `--verify-only` before rerunning deployment.
- If API build fails under a newer local Java, set `DENWA_API_JAVA_HOME` to a JDK 21 home.
- If Front type-check fails, fix source and push to `dev` before publishing so Git and infra remain aligned.
- If AWS CLI or `jq` output is malformed, use raw `aws`/`jq` in scripts instead of output-summarizing wrappers.
- If ECS rollout fails, inspect recent service events and do not force stop tasks unless explicitly requested.

## Resources

- `scripts/manual_publish_dev.sh`: deterministic local DEV publish workflow for API, Front, or both.
