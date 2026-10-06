#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${SYNTHESIS_CONSTRAINT_FILE:?SYNTHESIS_CONSTRAINT_FILE must select the SDC}"
: "${OPENROAD_CONSTRAINT_FILE:?OPENROAD_CONSTRAINT_FILE must select the OpenROAD SDC}"
: "${UPF_CONFIG:?UPF_CONFIG must select the portable UPF}"

report_dir="${REPORT_DIR}/constraint_check"
mkdir -p "${report_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"

if [[ "${SYNTHESIS_CONSTRAINT_FILE}" != "${CONSTRAINT_DIR}/level_shifter.timing.sdc" ]]; then
    echo "The synthesis flow selected an unexpected level-shifter SDC" >&2
    exit 1
fi
if [[ "${OPENROAD_CONSTRAINT_FILE}" != "${SYNTHESIS_CONSTRAINT_FILE}" ]]; then
    echo "Synthesis and OpenROAD must consume the same portable SDC" >&2
    exit 1
fi

"${TCLSH_CMD:-tclsh}" verif/static/check_level_shifter_constraints.tcl \
    "${SYNTHESIS_CONSTRAINT_FILE}" > "${report_dir}/check.log" 2>&1
"${TCLSH_CMD:-tclsh}" verif/static/check_level_shifter_power_intent.tcl \
    "${UPF_CONFIG}" > "${report_dir}/power-intent.log" 2>&1

printf 'PASS\n' > "${report_dir}/status.txt"
cat "${report_dir}/check.log"
cat "${report_dir}/power-intent.log"
