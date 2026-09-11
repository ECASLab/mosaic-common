#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"

report_dir="${REPORT_DIR}/four_state_check"
work_dir="${WORK_DIR}/four_state_check"
rm -rf "${report_dir}" "${work_dir}"
mkdir -p "${report_dir}" "${work_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"

"${IVERILOG_CMD:-iverilog}" -g2012 -s level_shifter_four_state_tb \
    -o "${work_dir}/level_shifter_four_state.vvp" \
    rtl/level_shifter.sv verif/tb/four_state/level_shifter_four_state_tb.sv \
    > "${report_dir}/compile.log" 2>&1
"${VVP_CMD:-vvp}" "${work_dir}/level_shifter_four_state.vvp" \
    > "${report_dir}/run.log" 2>&1

grep -q "PASS: level shifter preserves X and Z values" "${report_dir}/run.log"
printf 'PASS\n' > "${report_dir}/status.txt"
cat "${report_dir}/run.log"
