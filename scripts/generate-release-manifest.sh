#!/usr/bin/env bash
set -euo pipefail

: "${MODULE:?MODULE must be set}"
: "${MODULE_ROOT:?MODULE_ROOT must be set}"
: "${FLOW_ROOT:?FLOW_ROOT must be set}"
: "${REPORT_DIR:?REPORT_DIR must be set}"
: "${MOSAIC_FLOW_IDS:?MOSAIC_FLOW_IDS must be set}"

manifest_dir="${REPORT_DIR}/release_manifest"
manifest="${manifest_dir}/manifest.txt"
mkdir -p "${manifest_dir}"

resolve_revision() {
  local supplied_revision="$1"
  local repository="$2"
  local label="$3"

  if [[ "${supplied_revision}" =~ ^[0-9a-f]{40}$ ]]; then
    printf '%s' "${supplied_revision}"
    return
  fi

  if git -C "${repository}" rev-parse HEAD >/dev/null 2>&1; then
    git -C "${repository}" rev-parse HEAD
    return
  fi

  echo "${label} revision is unavailable; provide it explicitly" >&2
  exit 1
}

module_revision="$(resolve_revision "${MODULE_REVISION:-}" "${MODULE_ROOT}" module)"
methodology_revision="$(resolve_revision "${METHODOLOGY_REVISION:-}" "${FLOW_ROOT}" methodology)"
generated_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

if git -C "${MODULE_ROOT}" status --porcelain --untracked-files=no >/dev/null 2>&1; then
  source_tree_dirty="$(git -C "${MODULE_ROOT}" status --porcelain --untracked-files=no | grep -q . && echo true || echo false)"
else
  source_tree_dirty=unknown
fi

single_line_version() {
  local command_name="$1"
  local version_flag="--version"

  if ! command -v "${command_name}" >/dev/null 2>&1; then
    printf 'UNAVAILABLE'
    return
  fi

  if [[ "${command_name}" == "iverilog" ]]; then
    version_flag="-V"
  fi

  "${command_name}" "${version_flag}" 2>&1 | head -n 1 | tr '\t' ' '
}

record_file() {
  local path="$1"
  local relative_path

  if [[ ! -f "${path}" ]]; then
    echo "Required release input is missing: ${path}" >&2
    exit 1
  fi

  relative_path="${path#"${MODULE_ROOT}"/}"
  printf 'file.%s.sha256=%s\n' \
    "${relative_path}" "$(sha256sum "${path}" | awk '{print $1}')"
}

{
  echo "schema=mosaic-release-evidence-v1"
  echo "module=${MODULE}"
  echo "module_revision=${module_revision}"
  echo "methodology_revision=${methodology_revision}"
  echo "generated_at=${generated_at}"
  echo "technology=technology-independent"
  echo "configuration=config/modules/${MODULE}.mk"
  echo "flow_policy=config/modules/${MODULE}-flows.mk"
  echo "source_tree_dirty=${source_tree_dirty}"
  echo "tool.verible=$(single_line_version verible-verilog-lint)"
  echo "tool.slang=$(single_line_version slang)"
  echo "tool.verilator=$(single_line_version verilator)"
  echo "tool.yosys=$(single_line_version yosys)"
  echo "tool.symbiyosys=$(single_line_version sby)"
  echo "tool.eqy=$(single_line_version eqy)"
  echo "tool.iverilog=$(single_line_version iverilog)"

  record_file "${MODULE_ROOT}/config/modules/${MODULE}.mk"
  record_file "${MODULE_ROOT}/config/modules/${MODULE}-flows.mk"
  record_file "${SYNTHESIS_CONSTRAINT_FILE}"
  if [[ -n "${ASYNC_SYNTHESIS_CONSTRAINT_FILE:-}" ]]; then
    record_file "${ASYNC_SYNTHESIS_CONSTRAINT_FILE}"
  fi
  if [[ -n "${OPENROAD_CONFIG:-}" ]]; then
    record_file "${OPENROAD_CONFIG}"
  fi
  if [[ -n "${CDC_CONFIG:-}" ]]; then
    record_file "${CDC_CONFIG}"
  fi
  if [[ -n "${DFT_CONFIG:-}" ]]; then
    record_file "${DFT_CONFIG}"
  fi
  if [[ -n "${UPF_CONFIG:-}" ]]; then
    record_file "${UPF_CONFIG}"
  fi

  for flow in ${MOSAIC_FLOW_IDS}; do
    state_variable="FLOW_${flow}"
    state="${!state_variable:-disabled}"
    status_file="${REPORT_DIR}/${flow}/status.txt"

    if [[ "${state}" == "disabled" ]]; then
      echo "flow.${flow}=SKIP"
      continue
    fi

    if [[ ! -f "${status_file}" ]]; then
      echo "Required evidence is missing for enabled flow ${flow}: ${status_file}" >&2
      exit 1
    fi

    status="$(tr -d '[:space:]' < "${status_file}")"
    if [[ "${status}" != "PASS" ]]; then
      echo "Enabled flow ${flow} has release status ${status}, expected PASS" >&2
      exit 1
    fi
    echo "flow.${flow}=PASS"
  done

  for gate in ${RELEASE_EVIDENCE_GATES:-}; do
    status_file="${REPORT_DIR}/${gate}/status.txt"
    if [[ ! -f "${status_file}" ]]; then
      echo "Required evidence is missing for module gate ${gate}: ${status_file}" >&2
      exit 1
    fi

    status="$(tr -d '[:space:]' < "${status_file}")"
    if [[ "${status}" != "PASS" ]]; then
      echo "Module gate ${gate} has release status ${status}, expected PASS" >&2
      exit 1
    fi
    echo "gate.${gate}=PASS"
  done
} > "${manifest}"

printf 'PASS\n' > "${manifest_dir}/status.txt"
echo "Release evidence manifest written to ${manifest}"
