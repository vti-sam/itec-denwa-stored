#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: publish_debug_dev_firebase.sh [--skip-pull]

Build and upload the itec-denwa Android debug APK to DEV Firebase App Distribution.

Options:
  --skip-pull   Use the current local Android checkout without git pull.
  -h, --help    Show this help.

Environment:
  ITEC_DENWA_WORKSPACE_ROOT  Override workspace root.
  DENWA_ANDROID_JAVA_HOME    Override JDK 21 path.
USAGE
}

skip_pull=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-pull)
      skip_pull=1
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

require_file() {
  local path="$1"
  local label="$2"
  if [[ ! -f "$path" ]]; then
    echo "ERROR: Missing ${label}: ${path}" >&2
    exit 1
  fi
}

require_dir() {
  local path="$1"
  local label="$2"
  if [[ ! -d "$path" ]]; then
    echo "ERROR: Missing ${label}: ${path}" >&2
    exit 1
  fi
}

run() {
  echo "+ $*" >&2
  "$@"
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace_root="${ITEC_DENWA_WORKSPACE_ROOT:-}"
if [[ -z "$workspace_root" ]]; then
  workspace_root="$(cd "${script_dir}/../../../.." && pwd)"
fi

android_dir="${workspace_root}/sources/denwa-android"
codegraph_script="${workspace_root}/skills/codegraph-local/scripts/codegraph_project.py"
distribution_key="${android_dir}/env/distribution/itec-denwa-distribution-dev-key.json"

require_dir "$workspace_root" "workspace root"
require_file "${workspace_root}/AGENTS.md" "root AGENTS.md"
require_dir "$android_dir" "Android source directory"
require_file "$codegraph_script" "CodeGraph script"
require_file "${android_dir}/appDistributionDebug.sh" "Android App Distribution script"
require_file "$distribution_key" "DEV Firebase Distribution service account"

if ! command -v rtk >/dev/null 2>&1; then
  echo "ERROR: rtk is required in this workspace." >&2
  exit 1
fi

for helper_dir in \
  "/Library/Developer/CommandLineTools/usr/libexec/git-core" \
  "/Applications/Xcode.app/Contents/Developer/usr/libexec/git-core"; do
  if [[ -d "$helper_dir" ]]; then
    export PATH="${helper_dir}:${PATH}"
  fi
done

java_home="${DENWA_ANDROID_JAVA_HOME:-}"
if [[ -z "$java_home" && -d "/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home" ]]; then
  java_home="/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home"
fi
if [[ -z "$java_home" && -x "/usr/libexec/java_home" ]]; then
  java_home="$(/usr/libexec/java_home -v 21 2>/dev/null || true)"
fi
if [[ -z "$java_home" || ! -d "$java_home" ]]; then
  echo "ERROR: JDK 21 was not found. Set DENWA_ANDROID_JAVA_HOME to a JDK 21 home." >&2
  exit 1
fi

branch="$(rtk git -C "$android_dir" branch --show-current)"
if [[ "$branch" != "prd" ]]; then
  echo "ERROR: Android repo must be on branch prd, current branch is: ${branch}" >&2
  exit 1
fi

status_before="$(rtk git -C "$android_dir" status --porcelain)"
if [[ -n "$status_before" ]]; then
  echo "ERROR: Android worktree has uncommitted changes. Resolve before publishing:" >&2
  rtk git -C "$android_dir" status --short >&2
  exit 1
fi

echo "Workspace: ${workspace_root}"
echo "Android repo: ${android_dir}"
echo "Branch: ${branch}"
echo "JAVA_HOME: ${java_home}"

run rtk python "$codegraph_script" ensure "$android_dir"

if [[ "$skip_pull" -eq 0 ]]; then
  run rtk git -C "$android_dir" fetch --no-tags origin prd:refs/remotes/origin/prd
  remote_prd_sha="$(rtk git -C "$android_dir" rev-parse refs/remotes/origin/prd)"
  echo "Remote prd after fetch: ${remote_prd_sha}"
  run rtk git -C "$android_dir" merge --ff-only refs/remotes/origin/prd
  run rtk python "$codegraph_script" ensure "$android_dir"
else
  echo "Skipping git pull by request."
fi

status_after="$(rtk git -C "$android_dir" status --porcelain)"
if [[ -n "$status_after" ]]; then
  echo "ERROR: Android worktree is not clean after pull:" >&2
  rtk git -C "$android_dir" status --short >&2
  exit 1
fi

echo "Latest commit:"
rtk git -C "$android_dir" log -1 --oneline --decorate

(
  cd "$android_dir"
  export JAVA_HOME="$java_home"
  export ITEC_PROJECT_DIR="$android_dir"
  run rtk bash appDistributionDebug.sh
)
