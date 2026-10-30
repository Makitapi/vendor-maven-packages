#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "${TEST_DIR}"' EXIT

mkdir -p "${TEST_DIR}/bin"
export PATH="${TEST_DIR}/bin:${PATH}"
export ARTIFACTS_FILE="${TEST_DIR}/artifacts.csv"
export CURL_CALLS="${TEST_DIR}/curl-calls"
export MVN_CALLS="${TEST_DIR}/mvn-calls"
export REPOSITORY_URL="https://maven.pkg.github.com/Makitapi/vendor-maven-packages/"
export REPOSITORY_ID=github-vendor
export GITHUB_ACTOR=test-user
export GITHUB_TOKEN=test-token

cat > "${TEST_DIR}/bin/curl" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" >> "${CURL_CALLS}"
printf '%s' "${CURL_STATUS}"
exit "${CURL_EXIT}"
EOF

cat > "${TEST_DIR}/bin/mvn" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" >> "${MVN_CALLS}"
printf '%s\n' "${MVN_OUTPUT}"
exit "${MVN_EXIT}"
EOF
chmod +x "${TEST_DIR}/bin/curl" "${TEST_DIR}/bin/mvn"

run_case() {
  local name="$1" expected_exit="$2" expected_deploy="$3" expected_output="$4" packaging="${5:-jar}"
  local actual_exit=0
  printf 'impinj/ltkjava-12.4.0.0.jar,com.makitapi.vendor,impinj-ltkjava,12.4.0.0,%s\n' "${packaging}" > "${ARTIFACTS_FILE}"
  : > "${CURL_CALLS}"
  : > "${MVN_CALLS}"

  bash "${SCRIPT_DIR}/deploy-artifacts.sh" > "${TEST_DIR}/output" 2>&1 || actual_exit=$?
  if [[ "${actual_exit}" != "${expected_exit}" ]] || ! grep -Fq "${expected_output}" "${TEST_DIR}/output"; then
    printf 'FAIL: %s (exit %s, expected %s)\n' "${name}" "${actual_exit}" "${expected_exit}" >&2
    cat "${TEST_DIR}/output" >&2
    exit 1
  fi

  if [[ "${expected_deploy}" == true ]]; then
    test -s "${MVN_CALLS}"
  else
    test ! -s "${MVN_CALLS}"
  fi

  if [[ "${SKIP_EXISTING}" == true ]]; then
    grep -Fxq -- '--head' "${CURL_CALLS}"
    grep -Fxq -- 'test-user:test-token' "${CURL_CALLS}"
    grep -Fxq "${REPOSITORY_URL}com/makitapi/vendor/impinj-ltkjava/12.4.0.0/impinj-ltkjava-12.4.0.0.${packaging}" "${CURL_CALLS}"
  else
    test ! -s "${CURL_CALLS}"
  fi
  printf 'PASS: %s\n' "${name}"
}

export SKIP_EXISTING=true CURL_STATUS=200 CURL_EXIT=0 MVN_EXIT=0 MVN_OUTPUT=''
run_case 'Existing JAR is skipped' 0 false 'deployed=0, skipped=1'
run_case 'AAR uses the packaging extension' 0 false 'deployed=0, skipped=1' aar

export CURL_STATUS=404
run_case 'Missing artifact is deployed' 0 true 'deployed=1, skipped=0'

export MVN_EXIT=1
export MVN_OUTPUT='[ERROR] Failed to deploy artifacts: HTTP Status: 409 -> [Help 1]'
run_case 'HTTP Status conflict is skipped' 0 true 'deployed=0, skipped=1'
export MVN_OUTPUT='[ERROR] Failed to deploy artifacts: Conflict (409)'
run_case 'Legacy conflict is skipped' 0 true 'deployed=0, skipped=1'
export MVN_OUTPUT='[ERROR] Failed to deploy artifacts: status code: 409, reason phrase: Conflict'
run_case 'Status code conflict is skipped' 0 true 'deployed=0, skipped=1'
export MVN_OUTPUT='[ERROR] Failed to deploy artifacts: HTTP Status: 401'
run_case 'Deployment authentication failure remains fatal' 1 true 'HTTP Status: 401'
export MVN_OUTPUT='[ERROR] Failed to deploy artifacts: HTTP Status: 500'
run_case 'Deployment server failure remains fatal' 1 true 'HTTP Status: 500'

export CURL_STATUS=401
run_case 'Preflight authentication failure remains fatal' 1 false 'Artifact check returned HTTP 401'
export CURL_STATUS=403
run_case 'Preflight authorization failure remains fatal' 1 false 'Artifact check returned HTTP 403'
export CURL_STATUS=500
run_case 'Preflight server failure remains fatal' 1 false 'Artifact check returned HTTP 500'
export CURL_STATUS=000 CURL_EXIT=7
run_case 'Preflight network failure remains fatal' 1 false 'Could not check artifact'

export SKIP_EXISTING=false MVN_OUTPUT='[ERROR] Failed to deploy artifacts: HTTP Status: 409'
run_case 'Conflicts remain fatal when skipping is disabled' 1 true 'HTTP Status: 409'
export MVN_EXIT=0 MVN_OUTPUT=''
run_case 'Skipping disabled bypasses preflight' 0 true 'deployed=1, skipped=0'
