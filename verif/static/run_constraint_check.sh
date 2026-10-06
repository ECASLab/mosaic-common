#!/usr/bin/env bash
set -euo pipefail

# These paths are supplied by the selected module profile through GNU Make.
# shellcheck disable=SC2153
: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
# shellcheck disable=SC2153
: "${SYNTHESIS_CONSTRAINT_FILE:?SYNTHESIS_CONSTRAINT_FILE must select the default SDC}"
# shellcheck disable=SC2153
: "${ASYNC_SYNTHESIS_CONSTRAINT_FILE:?ASYNC_SYNTHESIS_CONSTRAINT_FILE must select the asynchronous SDC}"
# shellcheck disable=SC2153
: "${OPENROAD_CONSTRAINT_FILE:?OPENROAD_CONSTRAINT_FILE must select the SDC consumed by OpenROAD}"
# shellcheck disable=SC2153
: "${DESIGN_TOP:?DESIGN_TOP must identify the selected module}"

report_dir="${REPORT_DIR}/constraint_check"
mkdir -p "${report_dir}"
printf 'FAIL\n' >"${report_dir}/status.txt"

expected_default="${CONSTRAINT_DIR}/${DESIGN_TOP}.timing.sdc"
if [[ ! -f "${expected_default}" ]]; then
  expected_default="${CONSTRAINT_DIR}/timing.sdc"
fi

expected_async="${CONSTRAINT_DIR}/${DESIGN_TOP}.timing_async.sdc"
if [[ ! -f "${expected_async}" ]]; then
  expected_async="${CONSTRAINT_DIR}/timing_async.sdc"
fi

if [[ "${SYNTHESIS_CONSTRAINT_FILE}" != "${expected_default}" ]]; then
  echo "The synthesis flow selected an unexpected synchronous SDC" >&2
  exit 1
fi

if [[ "${ASYNC_SYNTHESIS_CONSTRAINT_FILE}" != "${expected_async}" ]]; then
  echo "The synthesis flow selected an unexpected asynchronous SDC" >&2
  exit 1
fi

"${TCLSH_CMD:-tclsh}" verif/static/check_constraints.tcl \
  "${SYNTHESIS_CONSTRAINT_FILE}" \
  "${ASYNC_SYNTHESIS_CONSTRAINT_FILE}" \
  "${OPENROAD_CONSTRAINT_FILE}" \
  "${DESIGN_TOP}" \
  >"${report_dir}/check.log" 2>&1

printf 'PASS\n' >"${report_dir}/status.txt"
cat "${report_dir}/check.log"
