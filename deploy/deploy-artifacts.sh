#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ARTIFACTS_FILE="${ARTIFACTS_FILE:-${SCRIPT_DIR}/artifacts.csv}"
REPOSITORY_ID="${REPOSITORY_ID:-github-vendor}"
REPOSITORY_URL="${REPOSITORY_URL:-https://maven.pkg.github.com/Makitapi/vendor-maven-packages}"
SKIP_EXISTING="${SKIP_EXISTING:-false}"

if ! command -v mvn >/dev/null 2>&1; then
  echo "ERROR: Maven (mvn) is not available in PATH." >&2
  exit 1
fi

if [[ ! -f "${ARTIFACTS_FILE}" ]]; then
  echo "ERROR: Artifacts file not found: ${ARTIFACTS_FILE}" >&2
  exit 1
fi

echo "Using artifacts file: ${ARTIFACTS_FILE}"
echo "Repository ID: ${REPOSITORY_ID}"
echo "Repository URL: ${REPOSITORY_URL}"

deploy_count=0
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

  file_path="${REPO_ROOT}/${path}"

  if [[ ! -f "${file_path}" ]]; then
    echo "ERROR: Artifact file does not exist: ${file_path}" >&2
    exit 1
  fi

  if [[ "${SKIP_EXISTING}" == "true" ]]; then
    if curl --silent --fail --location \
      -u "${GITHUB_ACTOR:-}:${GITHUB_TOKEN:-}" \
      "${REPOSITORY_URL}/${group_id//./\/}/${artifact_id}/${version}/" \
      >/dev/null 2>&1; then
      echo "Skipping existing artifact: ${group_id}:${artifact_id}:${version}"
      skip_count=$((skip_count + 1))
      continue
    fi
  fi

  echo "Deploying ${group_id}:${artifact_id}:${version} from ${path}"

  deploy_log="$(mktemp)"
  if ! mvn --batch-mode deploy:deploy-file \
    -DgroupId="${group_id}" \
    -DartifactId="${artifact_id}" \
    -Dversion="${version}" \
    -Dpackaging="${packaging}" \
    -Dfile="${file_path}" \
    -DrepositoryId="${REPOSITORY_ID}" \
    -Durl="${REPOSITORY_URL}" \
    >"${deploy_log}" 2>&1; then
    if [[ "${SKIP_EXISTING}" == "true" ]] && grep -q "Conflict (409)" "${deploy_log}"; then
      echo "Skipping existing artifact after deploy conflict: ${group_id}:${artifact_id}:${version}"
      skip_count=$((skip_count + 1))
      rm -f "${deploy_log}"
      continue
    fi

    cat "${deploy_log}" >&2
    rm -f "${deploy_log}"
    exit 1
  fi

  rm -f "${deploy_log}"
  deploy_count=$((deploy_count + 1))
done < "${ARTIFACTS_FILE}"

echo "Deployment complete. deployed=${deploy_count}, skipped=${skip_count}"
