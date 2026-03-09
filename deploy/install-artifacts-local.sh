#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ARTIFACTS_FILE="${ARTIFACTS_FILE:-${SCRIPT_DIR}/artifacts.csv}"
SKIP_EXISTING="${SKIP_EXISTING:-false}"
M2_REPO="${M2_REPO:-${HOME}/.m2/repository}"

if ! command -v mvn >/dev/null 2>&1; then
  echo "ERROR: Maven (mvn) is not available in PATH." >&2
  exit 1
fi

if [[ ! -f "${ARTIFACTS_FILE}" ]]; then
  echo "ERROR: Artifacts file not found: ${ARTIFACTS_FILE}" >&2
  exit 1
fi

echo "Using artifacts file: ${ARTIFACTS_FILE}"
echo "Local Maven repository: ${M2_REPO}"

install_count=0
skip_count=0

while IFS=',' read -r raw_path raw_group_id raw_artifact_id raw_version raw_packaging; do
  path="${raw_path//[$'\t\r\n ']/}"

  if [[ -z "${path}" ]] || [[ "${path}" == \#* ]]; then
    continue
  fi

  group_id="${raw_group_id//[$'\t\r\n ']/}"
  artifact_id="${raw_artifact_id//[$'\t\r\n ']/}"
  version="${raw_version//[$'\t\r\n ']/}"
  packaging="${raw_packaging//[$'\t\r\n ']/}"

  if [[ -z "${group_id}" || -z "${artifact_id}" || -z "${version}" || -z "${packaging}" ]]; then
    echo "ERROR: Invalid CSV row (missing required values): ${raw_path},${raw_group_id},${raw_artifact_id},${raw_version},${raw_packaging}" >&2
    exit 1
  fi

  file_path="${REPO_ROOT}/${path}"

  if [[ ! -f "${file_path}" ]]; then
    echo "ERROR: Artifact file does not exist: ${file_path}" >&2
    exit 1
  fi

  group_path="${group_id//./\/}"
  local_target="${M2_REPO}/${group_path}/${artifact_id}/${version}/${artifact_id}-${version}.${packaging}"

  if [[ "${SKIP_EXISTING}" == "true" ]] && [[ -f "${local_target}" ]]; then
    echo "Skipping existing local artifact: ${group_id}:${artifact_id}:${version}"
    skip_count=$((skip_count + 1))
    continue
  fi

  echo "Installing ${group_id}:${artifact_id}:${version} from ${path}"

  install_log="$(mktemp)"
  if ! mvn --batch-mode install:install-file \
    -DgroupId="${group_id}" \
    -DartifactId="${artifact_id}" \
    -Dversion="${version}" \
    -Dpackaging="${packaging}" \
    -Dfile="${file_path}" \
    -DlocalRepositoryPath="${M2_REPO}" \
    >"${install_log}" 2>&1; then
    cat "${install_log}" >&2
    rm -f "${install_log}"
    exit 1
  fi

  rm -f "${install_log}"
  install_count=$((install_count + 1))
done < "${ARTIFACTS_FILE}"

echo "Local installation complete. installed=${install_count}, skipped=${skip_count}"
