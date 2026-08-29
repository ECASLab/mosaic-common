#!/usr/bin/env bash
set -euo pipefail

# These paths are supplied by the selected module profile through GNU Make.
# shellcheck disable=SC2153
: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
# shellcheck disable=SC2153
: "${SYNTHESIS_CONSTRAINT_FILE:?SYNTHESIS_CONSTRAINT_FILE must select the default SDC}"
# shellcheck disable=SC2153
: "${ASYNC_SYNTHESIS_CONSTRAINT_FILE:?ASYNC_SYNTHESIS_CONSTRAINT_FILE must select the asynchronous SDC}"

report_dir="${REPORT_DIR}/constraint_check"
mkdir -p "${report_dir}"
printf 'FAIL\n' >"${report_dir}/status.txt"

if [[ "${SYNTHESIS_CONSTRAINT_FILE}" != "${CONSTRAINT_DIR}/timing.sdc" ]]; then
  echo "The default synthesis flow must select the synchronous timing.sdc profile" >&2
  exit 1
fi

"${TCLSH_CMD:-tclsh}" verif/static/check_constraints.tcl \
  "${SYNTHESIS_CONSTRAINT_FILE}" \
  "${ASYNC_SYNTHESIS_CONSTRAINT_FILE}" \
  "${FLOW_CONFIG_ROOT}/openroad/timing.sdc" \
  >"${report_dir}/check.log" 2>&1

printf 'PASS\n' >"${report_dir}/status.txt"
cat "${report_dir}/check.log"
