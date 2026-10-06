#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${SYNTHESIS_CONSTRAINT_FILE:?SYNTHESIS_CONSTRAINT_FILE is required}"
: "${ASYNC_SYNTHESIS_CONSTRAINT_FILE:?ASYNC_SYNTHESIS_CONSTRAINT_FILE is required}"
: "${OPENROAD_CONSTRAINT_FILE:?OPENROAD_CONSTRAINT_FILE is required}"
: "${UPF_CONFIG:?UPF_CONFIG is required}"

report_dir="${REPORT_DIR}/constraint_check"
mkdir -p "${report_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"
"${TCLSH_CMD:-tclsh}" verif/static/check_retention_register_constraints.tcl \
    "${SYNTHESIS_CONSTRAINT_FILE}" "${ASYNC_SYNTHESIS_CONSTRAINT_FILE}" \
    "${OPENROAD_CONSTRAINT_FILE}" "${UPF_CONFIG}" > "${report_dir}/check.log" 2>&1
printf 'PASS\n' > "${report_dir}/status.txt"
cat "${report_dir}/check.log"
