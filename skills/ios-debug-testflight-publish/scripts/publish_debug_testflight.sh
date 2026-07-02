#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: publish_debug_testflight.sh [options]

Fetch the itec-denwa iOS prd branch, build DevRelease, and upload to TestFlight.

Options:
  --marketing-version VERSION     Set MARKETING_VERSION. Defaults to current project value,
                                  but 1.0.0 is upgraded to 1.0.1 because the 1.0.0
                                  App Store Connect train is closed.
  --build-number NUMBER           Set CURRENT_PROJECT_VERSION. Defaults to next local build
                                  with a minimum of 27 because 1.0.1 build 26 was uploaded.
  --skip-pull                     Use the current local iOS checkout without git pull.
  --archive-only                  Archive only; skip App Store Connect/TestFlight upload.
  --allow-dirty-version-file      Continue when the only dirty file is
                                  Denwa/Denwa.xcodeproj/project.pbxproj.
  -h, --help                      Show this help.

Environment:
  ITEC_DENWA_WORKSPACE_ROOT       Override workspace root.
  DENWA_IOS_TEAM_ID               Override App Store Connect team id. Default: 84S993H7LR.
USAGE
}

marketing_version=""
build_number=""
skip_pull=0
archive_only=0
allow_dirty_version_file=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --marketing-version)
      marketing_version="${2:-}"
      if [[ -z "$marketing_version" ]]; then
        echo "ERROR: --marketing-version requires a value." >&2
        exit 2
      fi
      shift 2
      ;;
    --build-number)
      build_number="${2:-}"
      if [[ -z "$build_number" ]]; then
        echo "ERROR: --build-number requires a value." >&2
        exit 2
      fi
      shift 2
      ;;
    --skip-pull)
      skip_pull=1
      shift
      ;;
    --archive-only)
      archive_only=1
      shift
      ;;
    --allow-dirty-version-file)
      allow_dirty_version_file=1
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

require_cmd() {
  local name="$1"
  if ! command -v "$name" >/dev/null 2>&1; then
    echo "ERROR: Required command not found: ${name}" >&2
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

ios_dir="${workspace_root}/sources/denwa-ios"
ios_app_dir="${ios_dir}/Denwa"
workspace_path="${ios_app_dir}/Denwa.xcworkspace"
project_path="${ios_app_dir}/Denwa.xcodeproj"
project_file="${project_path}/project.pbxproj"
project_file_rel="Denwa/Denwa.xcodeproj/project.pbxproj"
codegraph_script="${workspace_root}/skills/codegraph-local/scripts/codegraph_project.py"
scratch_dir="${workspace_root}/scratch/ios-testflight"
team_id="${DENWA_IOS_TEAM_ID:-84S993H7LR}"
known_min_build=27

require_dir "$workspace_root" "workspace root"
require_file "${workspace_root}/AGENTS.md" "root AGENTS.md"
require_dir "$ios_dir" "iOS source directory"
require_dir "$ios_app_dir" "iOS app directory"
require_dir "$workspace_path" "iOS workspace"
require_dir "$project_path" "Xcode project"
require_file "$project_file" "Xcode project file"
require_file "$codegraph_script" "CodeGraph script"
require_file "${ios_app_dir}/Podfile" "Podfile"
require_cmd rtk
require_cmd ruby
require_cmd pod
require_cmd xcodebuild

for helper_dir in \
  "/Library/Developer/CommandLineTools/usr/libexec/git-core" \
  "/Applications/Xcode.app/Contents/Developer/usr/libexec/git-core"; do
  if [[ -d "$helper_dir" ]]; then
    export PATH="${helper_dir}:${PATH}"
  fi
done

dirty_is_only_version_file() {
  local status="$1"
  local line
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    case "$line" in
      " M ${project_file_rel}"|"M  ${project_file_rel}"|"MM ${project_file_rel}")
        ;;
      *)
        return 1
        ;;
    esac
  done <<< "$status"
  return 0
}

require_clean_or_allowed() {
  local status
  status="$(rtk git -C "$ios_dir" status --porcelain)"
  if [[ -z "$status" ]]; then
    return 0
  fi
  if [[ "$allow_dirty_version_file" -eq 1 ]] && dirty_is_only_version_file "$status"; then
    echo "Continuing with existing ${project_file_rel} changes because --allow-dirty-version-file was set." >&2
    return 0
  fi
  echo "ERROR: iOS worktree has uncommitted changes. Resolve before publishing:" >&2
  rtk git -C "$ios_dir" status --short >&2
  exit 1
}

read_project_setting() {
  local key="$1"
  rtk ruby - "$project_path" "$key" <<'RUBY'
require "xcodeproj"

project_path, key = ARGV
project = Xcodeproj::Project.open(project_path)
target = project.targets.find { |candidate| candidate.name == "Denwa" }
abort "Missing target Denwa" unless target
config = target.build_configurations.find { |candidate| candidate.name == "DevRelease" }
abort "Missing DevRelease configuration on target Denwa" unless config
value = config.build_settings[key]
abort "Missing build setting #{key}" if value.nil? || value.to_s.empty?
puts value
RUBY
}

set_project_versions() {
  local next_marketing_version="$1"
  local next_build_number="$2"
  rtk ruby - "$project_path" "$next_marketing_version" "$next_build_number" <<'RUBY'
require "xcodeproj"

project_path, marketing_version, build_number = ARGV
project = Xcodeproj::Project.open(project_path)
target_names = ["Denwa", "MVWebRTCNotificationServiceExtension"]

target_names.each do |target_name|
  target = project.targets.find { |candidate| candidate.name == target_name }
  abort "Missing target #{target_name}" unless target
  target.build_configurations.each do |config|
    config.build_settings["MARKETING_VERSION"] = marketing_version
    config.build_settings["CURRENT_PROJECT_VERSION"] = build_number
  end
end

project.save
RUBY
}

branch="$(rtk git -C "$ios_dir" branch --show-current)"
if [[ "$branch" != "prd" ]]; then
  echo "ERROR: iOS repo must be on branch prd, current branch is: ${branch}" >&2
  exit 1
fi

require_clean_or_allowed

echo "Workspace: ${workspace_root}"
echo "iOS repo: ${ios_dir}"
echo "Branch: ${branch}"

run rtk python "$codegraph_script" ensure "$ios_dir"

if [[ "$skip_pull" -eq 0 ]]; then
  run rtk git -C "$ios_dir" pull --ff-only
  run rtk python "$codegraph_script" ensure "$ios_dir"
else
  echo "Skipping git pull by request."
fi

require_clean_or_allowed

current_marketing_version="$(read_project_setting MARKETING_VERSION)"
current_build_number="$(read_project_setting CURRENT_PROJECT_VERSION)"

if [[ -z "$marketing_version" ]]; then
  if [[ "$current_marketing_version" == "1.0.0" ]]; then
    marketing_version="1.0.1"
  else
    marketing_version="$current_marketing_version"
  fi
fi

if [[ "$marketing_version" == "1.0.0" ]]; then
  echo "ERROR: iOS 1.0.0 is closed for new App Store Connect/TestFlight builds. Use 1.0.1 or newer." >&2
  exit 1
fi

if [[ ! "$current_build_number" =~ ^[0-9]+$ ]]; then
  echo "ERROR: Current build number is not numeric: ${current_build_number}" >&2
  exit 1
fi

if [[ -z "$build_number" ]]; then
  build_number="$((current_build_number + 1))"
  if (( build_number < known_min_build )); then
    build_number="$known_min_build"
  fi
fi

if [[ ! "$build_number" =~ ^[0-9]+$ ]]; then
  echo "ERROR: Build number must be numeric: ${build_number}" >&2
  exit 1
fi

if (( build_number < known_min_build )); then
  echo "ERROR: Build number ${build_number} is below known uploaded floor ${known_min_build}. Use ${known_min_build} or newer." >&2
  exit 1
fi

mkdir -p "$scratch_dir"
timestamp="$(date +%Y%m%d-%H%M%S)"
safe_marketing_version="${marketing_version//[^A-Za-z0-9._-]/_}"
artifact_prefix="Denwa-prd-devrelease-v${safe_marketing_version}-b${build_number}-${timestamp}"
archive_path="${scratch_dir}/${artifact_prefix}.xcarchive"
export_path="${scratch_dir}/${artifact_prefix}-export"
archive_log="${scratch_dir}/${artifact_prefix}-archive.log"
export_log="${scratch_dir}/${artifact_prefix}-export-upload.log"
export_options="${scratch_dir}/ExportOptions-devrelease-testflight.plist"
commit="$(rtk git -C "$ios_dir" rev-parse --short HEAD)"

cat > "$export_options" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>destination</key>
	<string>upload</string>
	<key>manageAppVersionAndBuildNumber</key>
	<false/>
	<key>method</key>
	<string>app-store-connect</string>
	<key>signingStyle</key>
	<string>automatic</string>
	<key>teamID</key>
	<string>${team_id}</string>
	<key>testFlightInternalTestingOnly</key>
	<true/>
	<key>uploadSymbols</key>
	<true/>
</dict>
</plist>
PLIST

echo "Current project version/build: ${current_marketing_version} (${current_build_number})"
echo "Release version/build: ${marketing_version} (${build_number})"
echo "Commit: ${commit}"
echo "Archive: ${archive_path}"
echo "Archive log: ${archive_log}"
echo "Export/upload log: ${export_log}"

(
  cd "$ios_app_dir"
  run rtk pod install
)

set_project_versions "$marketing_version" "$build_number"

(
  cd "$ios_app_dir"
  set -o pipefail
  echo "+ rtk xcodebuild -workspace ${workspace_path} -scheme DevRelease -configuration DevRelease -sdk iphoneos -destination generic/platform=iOS -archivePath ${archive_path} -allowProvisioningUpdates clean archive" >&2
  rtk xcodebuild \
    -workspace "$workspace_path" \
    -scheme DevRelease \
    -configuration DevRelease \
    -sdk iphoneos \
    -destination "generic/platform=iOS" \
    -archivePath "$archive_path" \
    -allowProvisioningUpdates \
    clean archive 2>&1 | tee "$archive_log"
)

if [[ "$archive_only" -eq 1 ]]; then
  echo "Archive-only run finished."
  echo "Archive: ${archive_path}"
  exit 0
fi

(
  set -o pipefail
  echo "+ rtk xcodebuild -exportArchive -archivePath ${archive_path} -exportPath ${export_path} -exportOptionsPlist ${export_options} -allowProvisioningUpdates" >&2
  rtk xcodebuild \
    -exportArchive \
    -archivePath "$archive_path" \
    -exportPath "$export_path" \
    -exportOptionsPlist "$export_options" \
    -allowProvisioningUpdates 2>&1 | tee "$export_log"
)

echo "Upload summary:"
if rtk rg -q "Upload succeeded" "$export_log"; then
  echo "- Upload succeeded: yes"
else
  echo "- Upload succeeded: not found in log"
fi
if rtk rg -q "EXPORT SUCCEEDED" "$export_log"; then
  echo "- Export succeeded: yes"
else
  echo "- Export succeeded: not found in log"
fi
if rtk rg -q "Uploaded package is processing" "$export_log"; then
  echo "- App Store Connect processing: yes"
fi
if rtk rg -q "dSYM|DWARF" "$export_log"; then
  echo "- dSYM warnings: check log; known prebuilt MVWebRTC/WebRTC dSYM warnings may be non-blocking"
fi

echo "Version/build: ${marketing_version} (${build_number})"
echo "Commit: ${commit}"
echo "Archive: ${archive_path}"
echo "Export/upload log: ${export_log}"
