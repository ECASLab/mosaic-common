#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${SYNTHESIS_CONSTRAINT_FILE:?SYNTHESIS_CONSTRAINT_FILE must identify the SDC}"
: "${UPF_CONFIG:?UPF_CONFIG must identify the UPF}"

report_dir="${REPORT_DIR}/constraint_check"
rm -rf "${report_dir}"
mkdir -p "${report_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"

"${TCLSH_CMD:-tclsh}" verif/static/check_isolation_cell_constraints.tcl \
    "${SYNTHESIS_CONSTRAINT_FILE}" | tee "${report_dir}/timing.log"
"${TCLSH_CMD:-tclsh}" verif/static/check_isolation_cell_power_intent.tcl \
    "${UPF_CONFIG}" | tee "${report_dir}/power-intent.log"

printf 'PASS\n' > "${report_dir}/status.txt"
