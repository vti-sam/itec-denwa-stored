#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: manual_publish_dev.sh --component api|front|all [options]

Manually build, push, deploy, and verify itec-denwa DEV API/Front when GitLab CI is unavailable.

Options:
  --component api|front|all       Component(s) to publish.
  --api-ref REF                   Git ref for denwa-api. Default: origin/dev.
  --front-ref REF                 Git ref for denwa-front. Default: origin/dev.
  --api-pipeline-iid IID          Override API GitLab pipeline IID for image tag.
  --front-pipeline-iid IID        Override Front GitLab pipeline IID for image tag.
  --verify-only                   Verify current live ECS/ECR/smoke state without build/push/deploy.
  --ecs-timeout SECONDS           Max seconds to wait for each ECS rollout. Default: 900.
  --ecs-poll-interval SECONDS     Poll interval while waiting for ECS. Default: 30.
  --skip-smoke                    Skip HTTP smoke checks.
  -h, --help                      Show this help.

Environment:
  ITEC_DENWA_WORKSPACE_ROOT       Override workspace root.
  DENWA_API_JAVA_HOME             Override JDK home for API Maven build.
USAGE
}

component=""
api_ref="origin/dev"
front_ref="origin/dev"
api_pipeline_iid=""
front_pipeline_iid=""
verify_only=0
ecs_timeout=900
ecs_poll_interval=30
skip_smoke=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --component)
      component="${2:-}"
      shift 2
      ;;
    --api-ref)
      api_ref="${2:-}"
      shift 2
      ;;
    --front-ref)
      front_ref="${2:-}"
      shift 2
      ;;
    --api-pipeline-iid)
      api_pipeline_iid="${2:-}"
      shift 2
      ;;
    --front-pipeline-iid)
      front_pipeline_iid="${2:-}"
      shift 2
      ;;
    --verify-only)
      verify_only=1
      shift
      ;;
    --ecs-timeout)
      ecs_timeout="${2:-}"
      shift 2
      ;;
    --ecs-poll-interval)
      ecs_poll_interval="${2:-}"
      shift 2
      ;;
    --skip-smoke)
      skip_smoke=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$component" in
  api|front|all) ;;
  "")
    echo "ERROR: --component is required." >&2
    usage >&2
    exit 2
    ;;
  *)
    echo "ERROR: --component must be api, front, or all." >&2
    exit 2
    ;;
esac

case "$ecs_timeout" in
  ""|*[!0-9]*)
    echo "ERROR: --ecs-timeout must be a positive integer." >&2
    exit 2
    ;;
esac
case "$ecs_poll_interval" in
  ""|*[!0-9]*)
    echo "ERROR: --ecs-poll-interval must be a positive integer." >&2
    exit 2
    ;;
esac
if (( ecs_timeout < 1 || ecs_poll_interval < 1 )); then
  echo "ERROR: ECS timeout and poll interval must be positive." >&2
  exit 2
fi

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: Required command not found: $1" >&2
    exit 1
  fi
}

timestamp() {
  date '+%Y-%m-%dT%H:%M:%S%z'
}

run() {
  echo "+ [$(timestamp)] $*" >&2
  "$@"
}

record_summary() {
  local line="$*"
  echo "SUMMARY ${line}" >&2
  if [[ -n "${summary_log:-}" ]]; then
    printf '%s\n' "$line" >> "$summary_log"
  fi
}

print_summary() {
  echo "MANUAL_PUBLISH_SUMMARY_BEGIN"
  if [[ -s "${summary_log:-}" ]]; then
    cat "$summary_log"
  fi
  echo "MANUAL_PUBLISH_SUMMARY_END"
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace_root="${ITEC_DENWA_WORKSPACE_ROOT:-}"
if [[ -z "$workspace_root" ]]; then
  workspace_root="$(cd "${script_dir}/../../../.." && pwd)"
fi

api_src="${workspace_root}/sources/denwa-api"
front_src="${workspace_root}/sources/denwa-front"
registry_aws_csv="${workspace_root}/registry/keystore/projects/itec-denwa/infra/shared/aws-access-keys.csv"
codegraph_script="${workspace_root}/skills/codegraph-local/scripts/codegraph_project.py"

require_cmd rtk
require_cmd git
require_cmd aws
require_cmd jq
require_cmd docker
require_cmd curl

[[ -d "$api_src" ]] || { echo "ERROR: Missing API source: $api_src" >&2; exit 1; }
[[ -d "$front_src" ]] || { echo "ERROR: Missing Front source: $front_src" >&2; exit 1; }
[[ -f "$registry_aws_csv" ]] || { echo "ERROR: Missing AWS registry credential CSV." >&2; exit 1; }

git_helper_dir="/Library/Developer/CommandLineTools/usr/libexec/git-core"
if [[ -d "$git_helper_dir" ]]; then
  export PATH="${git_helper_dir}:${PATH}"
fi

if [[ -z "${AWS_ACCESS_KEY_ID:-}" || -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
  eval "$(
    rtk python - "$registry_aws_csv" <<'PY'
import csv
import shlex
import sys
from pathlib import Path

path = Path(sys.argv[1])
with path.open(encoding="utf-8-sig", newline="") as file:
    row = next(csv.DictReader(file))
access = row.get("Access key ID") or row.get("aws_access_key_id") or row.get("AWS_ACCESS_KEY_ID")
secret = row.get("Secret access key") or row.get("aws_secret_access_key") or row.get("AWS_SECRET_ACCESS_KEY")
if not access or not secret:
    raise SystemExit("Missing AWS credentials in registry CSV")
for key, value in {
    "AWS_ACCESS_KEY_ID": access,
    "AWS_SECRET_ACCESS_KEY": secret,
    "AWS_DEFAULT_REGION": "ap-northeast-1",
}.items():
    print(f"export {key}={shlex.quote(value)}")
PY
  )"
fi
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-ap-northeast-1}"

account_id="668426476432"
region="ap-northeast-1"
ecr_uri="${account_id}.dkr.ecr.${region}.amazonaws.com"
cluster="denwa-dev-cluster"
api_service="denwa-backend-task-service-4mh4rz2a"
front_service="denwa-frontend-service"
front_api_base_url="https://api-dev.apl.purattocall.com"

needs_api=0
needs_front=0
if [[ "$component" == "api" || "$component" == "all" ]]; then
  needs_api=1
fi
if [[ "$component" == "front" || "$component" == "all" ]]; then
  needs_front=1
fi

resolve_ref() {
  local repo="$1"
  local ref="$2"
  rtk git -C "$repo" rev-parse "$ref"
}

pipeline_iid_for() {
  local project_path="$1"
  local sha="$2"
  local ref_name="$3"
  rtk python - "$project_path" "$sha" "$ref_name" <<'PY'
import json
import os
import subprocess
import sys
import time
import urllib.parse
import urllib.request

project_path, sha, ref_name = sys.argv[1:4]
host = "git.vti.com.vn"
creds = subprocess.run(
    ["git", "credential", "fill"],
    input=f"protocol=https\nhost={host}\n\n",
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    env=os.environ.copy(),
)
values = {}
for line in creds.stdout.splitlines():
    if "=" in line:
        key, value = line.split("=", 1)
        values[key] = value
token = values.get("password")
if creds.returncode != 0 or not token:
    raise SystemExit("GitLab credential is unavailable")
headers = {"PRIVATE-TOKEN": token}
base = f"https://{host}/api/v4"
project = urllib.parse.quote(project_path, safe="")
for _ in range(10):
    qs = urllib.parse.urlencode({"sha": sha, "ref": ref_name})
    req = urllib.request.Request(f"{base}/projects/{project}/pipelines?{qs}", headers=headers)
    with urllib.request.urlopen(req, timeout=30) as response:
        pipelines = json.load(response)
    if pipelines:
        pipeline = pipelines[0]
        print(
            "GITLAB_PIPELINE "
            f"project={project_path} iid={pipeline.get('iid')} id={pipeline.get('id')} "
            f"status={pipeline.get('status')} ref={pipeline.get('ref')} sha={pipeline.get('sha')}",
            file=sys.stderr,
        )
        try:
            jobs_req = urllib.request.Request(
                f"{base}/projects/{project}/pipelines/{pipeline['id']}/jobs",
                headers=headers,
            )
            with urllib.request.urlopen(jobs_req, timeout=30) as jobs_response:
                jobs = json.load(jobs_response)
            for job in jobs:
                runner = job.get("runner") or {}
                runner_name = runner.get("description") or "None"
                print(
                    "GITLAB_JOB "
                    f"name={job.get('name')} stage={job.get('stage')} "
                    f"status={job.get('status')} runner={runner_name}",
                    file=sys.stderr,
                )
        except Exception as exc:
            print(f"WARN: Could not read GitLab pipeline jobs: {exc}", file=sys.stderr)
        print(pipeline["iid"])
        raise SystemExit(0)
    time.sleep(3)
raise SystemExit(f"No GitLab pipeline found for {project_path} {ref_name} {sha}")
PY
}

print_service_events() {
  local service="$1"
  echo "Recent ECS events for ${service}:" >&2
  aws ecs describe-services \
    --cluster "$cluster" \
    --services "$service" \
    --region "$region" \
    --query 'services[0].events[0:5].[createdAt,message]' \
    --output text >&2 || true
}

describe_service_summary() {
  local label="$1"
  local service="$2"
  local json task_def rollout running desired pending
  json="$(aws ecs describe-services --cluster "$cluster" --services "$service" --region "$region" --output json)"
  task_def="$(jq -r '.services[0].taskDefinition' <<<"$json")"
  rollout="$(jq -r '.services[0].deployments[] | select(.status=="PRIMARY") | .rolloutState // ""' <<<"$json")"
  running="$(jq -r '.services[0].runningCount' <<<"$json")"
  desired="$(jq -r '.services[0].desiredCount' <<<"$json")"
  pending="$(jq -r '.services[0].pendingCount' <<<"$json")"
  echo "ECS_STATUS label=${label} service=${service} rollout=${rollout} running=${running}/${desired} pending=${pending} taskDefinition=${task_def}"
  record_summary "${label}_ecs service=${service} rollout=${rollout} running=${running}/${desired} pending=${pending} taskDefinition=${task_def}"
}

wait_service() {
  local service="$1"
  local timeout="${2:-$ecs_timeout}"
  local interval="${3:-$ecs_poll_interval}"
  local elapsed=0
  while true; do
    local json
    json="$(aws ecs describe-services --cluster "$cluster" --services "$service" --region "$region" --output json)"
    local rollout running desired pending task_def
    rollout="$(jq -r '.services[0].deployments[] | select(.status=="PRIMARY") | .rolloutState // ""' <<<"$json")"
    running="$(jq -r '.services[0].runningCount' <<<"$json")"
    desired="$(jq -r '.services[0].desiredCount' <<<"$json")"
    pending="$(jq -r '.services[0].pendingCount' <<<"$json")"
    task_def="$(jq -r '.services[0].taskDefinition' <<<"$json")"
    echo "ECS ${service}: rollout=${rollout} running=${running}/${desired} pending=${pending} elapsed=${elapsed}s timeout=${timeout}s taskDefinition=${task_def}"
    if [[ "$rollout" == "FAILED" ]]; then
      print_service_events "$service"
      return 1
    fi
    if [[ "$rollout" == "COMPLETED" && "$running" == "$desired" && "$pending" == "0" ]]; then
      record_summary "ecs service=${service} rollout=${rollout} running=${running}/${desired} pending=${pending} taskDefinition=${task_def}"
      return 0
    fi
    if (( elapsed >= timeout )); then
      break
    fi
    local sleep_for="$interval"
    if (( elapsed + sleep_for > timeout )); then
      sleep_for=$((timeout - elapsed))
    fi
    if (( sleep_for < 1 )); then
      sleep_for=1
    fi
    sleep "$sleep_for"
    elapsed=$((elapsed + sleep_for))
  done
  echo "ERROR: Timed out waiting for ECS service: $service" >&2
  print_service_events "$service"
  return 1
}

register_and_update_api() {
  local image="$1"
  aws ecs describe-services --cluster "$cluster" --services "$api_service" --region "$region" --query 'services[0].taskDefinition' --output text > api-current-task-def.txt
  aws ecs describe-task-definition --task-definition "$(cat api-current-task-def.txt)" --region "$region" --output json > api-task-current.json
  jq --arg IMAGE "$image" '
    .taskDefinition
    | del(.taskDefinitionArn, .revision, .status, .requiresAttributes, .registeredAt, .registeredBy, .compatibilities)
    | .containerDefinitions[0].image = $IMAGE
    | def set_env($name; $value):
        .containerDefinitions[0].environment = ((.containerDefinitions[0].environment // []) | map(select(.name != $name)) + [{"name": $name, "value": $value}]);
      set_env("SPRING_PROFILES_ACTIVE"; "dev-cloud")
  ' api-task-current.json > api-task-new.json
  jq empty api-task-new.json
  local task_def_arn
  task_def_arn="$(aws ecs register-task-definition --cli-input-json file://api-task-new.json --region "$region" --query 'taskDefinition.taskDefinitionArn' --output text)"
  echo "API_TASK_DEF_ARN=${task_def_arn}"
  record_summary "api_task_definition=${task_def_arn}"
  aws ecs update-service --cluster "$cluster" --service "$api_service" --task-definition "$task_def_arn" --force-new-deployment --region "$region" --output json >/dev/null
}

register_and_update_front() {
  local image="$1"
  aws ecs describe-services --cluster "$cluster" --services "$front_service" --region "$region" --query 'services[0].taskDefinition' --output text > front-current-task-def.txt
  aws ecs describe-task-definition --task-definition "$(cat front-current-task-def.txt)" --region "$region" --output json > front-task-current.json
  jq --arg IMAGE "$image" --arg API_BASE_URL "$front_api_base_url" '
    .taskDefinition
    | del(.taskDefinitionArn, .revision, .status, .requiresAttributes, .registeredAt, .registeredBy, .compatibilities)
    | .containerDefinitions[0].image = $IMAGE
    | .cpu |= (. // "0")
    | .memory |= (. // "1024")
    | .family = "denwa-frontend"
    | def set_env($name; $value):
        .containerDefinitions[0].environment = ((.containerDefinitions[0].environment // []) | map(select(.name != $name)) + [{"name": $name, "value": $value}]);
      set_env("VITE_API_BASE_URL"; $API_BASE_URL)
  ' front-task-current.json > front-task-new.json
  jq empty front-task-new.json
  local task_def_arn
  task_def_arn="$(aws ecs register-task-definition --cli-input-json file://front-task-new.json --region "$region" --query 'taskDefinition.taskDefinitionArn' --output text)"
  echo "FRONT_TASK_DEF_ARN=${task_def_arn}"
  record_summary "front_task_definition=${task_def_arn}"
  aws ecs update-service --cluster "$cluster" --service "$front_service" --task-definition "$task_def_arn" --force-new-deployment --enable-execute-command --region "$region" --output json >/dev/null
}

verify_digest() {
  local label="$1"
  local service="$2"
  local json
  json="$(rtk python - "$cluster" "$service" "$region" <<'PY'
import json
import os
import subprocess
import sys

cluster, service, region = sys.argv[1:4]

def aws(args):
    proc = subprocess.run(["aws", *args, "--region", region, "--output", "json"], env=os.environ, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    return json.loads(proc.stdout)

svc = aws(["ecs", "describe-services", "--cluster", cluster, "--services", service])["services"][0]
task_def = aws(["ecs", "describe-task-definition", "--task-definition", svc["taskDefinition"]])["taskDefinition"]
image = task_def["containerDefinitions"][0]["image"]
repo = image.split("/")[1].split(":")[0]
tag = image.rsplit(":", 1)[1]
ecr = aws(["ecr", "describe-images", "--repository-name", repo, "--image-ids", f"imageTag={tag}"])["imageDetails"][0]
task_arns = aws(["ecs", "list-tasks", "--cluster", cluster, "--service-name", service, "--desired-status", "RUNNING"])["taskArns"]
tasks = aws(["ecs", "describe-tasks", "--cluster", cluster, "--tasks", *task_arns])["tasks"] if task_arns else []
running = []
for task in tasks:
    for container in task.get("containers", []):
        running.append({
            "task": task["taskArn"].rsplit("/", 1)[-1],
            "image": container.get("image"),
            "imageDigest": container.get("imageDigest"),
            "lastStatus": container.get("lastStatus"),
        })
digest = ecr.get("imageDigest")
print(json.dumps({
    "service": service,
    "taskDefinition": svc["taskDefinition"],
    "image": image,
    "ecrDigest": digest,
    "ecrTags": ecr.get("imageTags"),
    "running": running,
    "digestMatch": bool(running) and all(item.get("imageDigest") == digest for item in running),
    "runningCount": svc.get("runningCount"),
    "desiredCount": svc.get("desiredCount"),
    "rollout": next((item.get("rolloutState") for item in svc.get("deployments", []) if item.get("status") == "PRIMARY"), None),
}, ensure_ascii=False))
PY
)"
  echo "${label}_VERIFY=${json}"
  local task_def image ecr_digest digest_match rollout running_count desired_count
  task_def="$(jq -r '.taskDefinition' <<<"$json")"
  image="$(jq -r '.image' <<<"$json")"
  ecr_digest="$(jq -r '.ecrDigest' <<<"$json")"
  digest_match="$(jq -r '.digestMatch' <<<"$json")"
  rollout="$(jq -r '.rollout' <<<"$json")"
  running_count="$(jq -r '.runningCount' <<<"$json")"
  desired_count="$(jq -r '.desiredCount' <<<"$json")"
  record_summary "${label}_verify image=${image} taskDefinition=${task_def} ecrDigest=${ecr_digest} digestMatch=${digest_match} rollout=${rollout} running=${running_count}/${desired_count}"
  if [[ "$(jq -r '.digestMatch' <<<"$json")" != "true" ]]; then
    echo "ERROR: ${label} running task digest does not match ECR." >&2
    return 1
  fi
}

smoke_http() {
  local label="$1"
  local url="$2"
  local accept_regex="$3"
  local body_file="/tmp/denwa-${label}-smoke-body"
  local code
  code="$(curl -k -sS -o "$body_file" -w '%{http_code}' "$url" || true)"
  echo "SMOKE ${label} code=${code} url=${url}"
  record_summary "smoke label=${label} code=${code} url=${url}"
  if [[ ! "$code" =~ $accept_regex ]]; then
    echo "ERROR: Smoke check failed for ${label}: HTTP ${code} ${url}" >&2
    return 1
  fi
}

smoke_api() {
  smoke_http api_swagger "https://api-dev.apl.purattocall.com/swagger-ui/index.html" '^200$'
  smoke_http api_docs "https://api-dev.apl.purattocall.com/v3/api-docs" '^200$'
  smoke_http api_root "https://api-dev.apl.purattocall.com/" '^(200|401)$'
  smoke_http api_health "https://api-dev.apl.purattocall.com/actuator/health" '^(200|401)$'
}

smoke_front() {
  local front="https://dev.apl.purattocall.com"
  curl -k -fsSI "${front}/admin/login" | awk 'BEGIN{IGNORECASE=1} /^HTTP\// || /^cache-control:/ || /^content-security-policy:/ {print}'
  curl -k -fsS "${front}/index.html" -o /tmp/denwa-front-index.html
  local asset
  asset="$(sed -n 's/.*src="\([^"]*\/assets\/[^"]*\.js\)".*/\1/p' /tmp/denwa-front-index.html | head -n 1)"
  test -n "$asset"
  echo "FRONT_ASSET ${asset}"
  curl -k -fsSI "${front}${asset}" | awk 'BEGIN{IGNORECASE=1} /^HTTP\// || /^cache-control:/ {print}'
  curl -k -fsS "${front}${asset}" -o /tmp/denwa-front-app.js
  grep -q "api-dev.apl.purattocall.com" /tmp/denwa-front-app.js
  echo "FRONT_BUNDLE_API_HOST ok"
  record_summary "front_smoke url=${front}/admin/login asset=${asset} apiHost=ok"
}

stamp="$(date +%Y%m%d-%H%M%S)"
work_dir="${workspace_root}/scratch/manual-publish-dev-${stamp}"
mkdir -p "$work_dir"
summary_log="${work_dir}/summary.txt"
: > "$summary_log"
echo "Snapshot root: ${work_dir}"
record_summary "component=${component} verifyOnly=${verify_only} workDir=${work_dir}"
record_summary "ecsTimeout=${ecs_timeout} ecsPollInterval=${ecs_poll_interval}"

run aws sts get-caller-identity --region "$region" --query 'Account' --output text

if [[ "$verify_only" -eq 1 ]]; then
  if [[ "$needs_api" -eq 1 ]]; then
    describe_service_summary api "$api_service"
    verify_digest api "$api_service"
  fi
  if [[ "$needs_front" -eq 1 ]]; then
    describe_service_summary front "$front_service"
    verify_digest front "$front_service"
  fi
  if [[ "$skip_smoke" -eq 0 ]]; then
    if [[ "$needs_api" -eq 1 ]]; then
      smoke_api
    fi
    if [[ "$needs_front" -eq 1 ]]; then
      smoke_front
    fi
  fi
  print_summary
  echo "Manual DEV verify completed."
  exit 0
fi

run aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$ecr_uri" >/dev/null

if [[ "$needs_api" -eq 1 ]]; then
  run rtk git -C "$api_src" fetch --no-tags origin dev:refs/remotes/origin/dev
  api_remote_dev_sha="$(rtk git -C "$api_src" rev-parse refs/remotes/origin/dev)"
  echo "API remote dev after fetch: ${api_remote_dev_sha}"
  record_summary "api_remote_dev=${api_remote_dev_sha}"
  run rtk python "$codegraph_script" ensure "$api_src"
fi
if [[ "$needs_front" -eq 1 ]]; then
  run rtk git -C "$front_src" fetch --no-tags origin dev:refs/remotes/origin/dev
  front_remote_dev_sha="$(rtk git -C "$front_src" rev-parse refs/remotes/origin/dev)"
  echo "Front remote dev after fetch: ${front_remote_dev_sha}"
  record_summary "front_remote_dev=${front_remote_dev_sha}"
  run rtk python "$codegraph_script" ensure "$front_src"
fi

if [[ "$needs_api" -eq 1 ]]; then
  api_sha="$(resolve_ref "$api_src" "$api_ref")"
  api_short="${api_sha:0:7}"
  if [[ -z "$api_pipeline_iid" ]]; then
    api_pipeline_iid="$(pipeline_iid_for "itec_denwa_app/denwa-api" "$api_sha" "dev")"
  else
    pipeline_iid_for "itec_denwa_app/denwa-api" "$api_sha" "dev" >/dev/null || true
  fi
  record_summary "api_commit=${api_sha} api_pipeline_iid=${api_pipeline_iid}"
  api_work="${work_dir}/denwa-api"
  mkdir -p "$api_work"
  run rtk git -C "$api_src" archive --format=tar "$api_sha" | tar -xf - -C "$api_work"
  (
    cd "$api_work"
    set -a
    # shellcheck disable=SC1091
    source .env.version
    set +a
    api_tag="${TAG_VERSION}-${api_pipeline_iid}"
    api_image="${ecr_uri}/itec-denwa-backend:${api_tag}"
    java_home="${DENWA_API_JAVA_HOME:-}"
    if [[ -z "$java_home" && -d "/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home" ]]; then
      java_home="/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home"
    fi
    if [[ -n "$java_home" ]]; then
      export JAVA_HOME="$java_home"
    fi
    run rtk bash ./mvnw clean package -Dmaven.test.skip=true
    run docker build --platform linux/amd64 -t "itec-denwa-backend:${api_sha}" .
    run docker tag "itec-denwa-backend:${api_sha}" "$api_image"
    run docker push "$api_image"
    echo "API_COMMIT=${api_sha}"
    echo "API_SHORT=${api_short}"
    echo "API_IMAGE=${api_image}"
    record_summary "api_image=${api_image} api_short=${api_short}"
    register_and_update_api "$api_image"
  )
fi

if [[ "$needs_front" -eq 1 ]]; then
  front_sha="$(resolve_ref "$front_src" "$front_ref")"
  front_short="${front_sha:0:7}"
  if [[ -z "$front_pipeline_iid" ]]; then
    front_pipeline_iid="$(pipeline_iid_for "itec_denwa_app/denwa-front" "$front_sha" "dev")"
  else
    pipeline_iid_for "itec_denwa_app/denwa-front" "$front_sha" "dev" >/dev/null || true
  fi
  record_summary "front_commit=${front_sha} front_pipeline_iid=${front_pipeline_iid}"
  front_work="${work_dir}/denwa-front"
  mkdir -p "$front_work"
  run rtk git -C "$front_src" archive --format=tar "$front_sha" | tar -xf - -C "$front_work"
  (
    cd "$front_work"
    set -a
    # shellcheck disable=SC1091
    source .env.version
    set +a
    front_tag="${TAG_VERSION}-${front_pipeline_iid}"
    front_image="${ecr_uri}/itec-denwa-frontend:${front_tag}"
    run docker run --rm -v "$PWD":/app -w /app node:18-alpine sh -lc "npm ci --cache .npm --prefer-offline --legacy-peer-deps --no-audit --no-fund && npm run type-check"
    run docker build --platform linux/amd64 --build-arg "VITE_API_BASE_URL=${front_api_base_url}" -t "itec-denwa-frontend:${front_sha}" .
    run docker tag "itec-denwa-frontend:${front_sha}" "$front_image"
    run docker tag "itec-denwa-frontend:${front_sha}" "${front_image}-${front_short}"
    run docker push "$front_image"
    run docker push "${front_image}-${front_short}"
    echo "FRONT_COMMIT=${front_sha}"
    echo "FRONT_SHORT=${front_short}"
    echo "FRONT_IMAGE=${front_image}"
    echo "FRONT_IMAGE_SHORT=${front_image}-${front_short}"
    record_summary "front_image=${front_image} front_short=${front_short}"
    register_and_update_front "$front_image"
  )
fi

if [[ "$needs_api" -eq 1 ]]; then
  wait_service "$api_service" "$ecs_timeout" "$ecs_poll_interval"
  verify_digest api "$api_service"
fi
if [[ "$needs_front" -eq 1 ]]; then
  wait_service "$front_service" "$ecs_timeout" "$ecs_poll_interval"
  verify_digest front "$front_service"
fi

if [[ "$skip_smoke" -eq 0 ]]; then
  if [[ "$needs_api" -eq 1 ]]; then
    smoke_api
  fi
  if [[ "$needs_front" -eq 1 ]]; then
    smoke_front
  fi
fi

print_summary
echo "Manual DEV publish completed."
