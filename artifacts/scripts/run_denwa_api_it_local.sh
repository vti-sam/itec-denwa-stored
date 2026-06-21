#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
SOURCE_DIR="${WORKSPACE_ROOT}/sources/denwa-api"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Cannot find denwa-api source directory: ${SOURCE_DIR}" >&2
  exit 1
fi

if [[ -z "${DOCKER_HOST:-}" ]]; then
  export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
fi

export TESTCONTAINERS_RYUK_DISABLED="${TESTCONTAINERS_RYUK_DISABLED:-true}"

if [[ -z "${JAVA_HOME:-}" ]]; then
  if [[ -x /usr/libexec/java_home ]]; then
    export JAVA_HOME="$(/usr/libexec/java_home -v 21)"
  else
    echo "JAVA_HOME is not set and /usr/libexec/java_home is unavailable." >&2
    exit 1
  fi
fi

if ! docker --host "${DOCKER_HOST}" ps >/dev/null 2>&1; then
  if command -v colima >/dev/null 2>&1; then
    echo "Docker is not reachable via ${DOCKER_HOST}; starting Colima..."
    colima start --vm-type qemu
  else
    echo "Docker is not reachable via ${DOCKER_HOST}, and colima is not installed." >&2
    exit 1
  fi
fi

cd "${SOURCE_DIR}"

echo "Running denwa-api local API integration tests..."
echo "SOURCE_DIR=${SOURCE_DIR}"
echo "DOCKER_HOST=${DOCKER_HOST}"
echo "TESTCONTAINERS_RYUK_DISABLED=${TESTCONTAINERS_RYUK_DISABLED}"
echo "JAVA_HOME=${JAVA_HOME}"

bash ./mvnw -Papi-it verify
