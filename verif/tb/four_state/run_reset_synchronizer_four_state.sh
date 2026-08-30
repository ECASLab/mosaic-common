#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"

report_dir="${REPORT_DIR}/four_state_check"
work_dir="${WORK_DIR}/four_state_check"
iverilog_cmd="${IVERILOG_CMD:-iverilog}"
vvp_cmd="${VVP_CMD:-vvp}"
sources=(
    rtl/reset_synchronizer.sv
    verif/tb/four_state/reset_synchronizer_four_state_tb.sv
)

rm -rf "${report_dir}" "${work_dir}"
mkdir -p "${report_dir}" "${work_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"

"${iverilog_cmd}" -g2012 -s reset_synchronizer_four_state_tb \
    -o "${work_dir}/unknown_check.vvp" "${sources[@]}" \
    > "${report_dir}/compile.log" 2>&1

set +e
"${vvp_cmd}" "${work_dir}/unknown_check.vvp" \
    > "${report_dir}/detection.log" 2>&1
detection_result=$?
set -e
if ((detection_result == 0)); then
    echo "Unknown reset input escaped the four-state monitor" >&2
    exit 1
fi
if ! grep -Fq "UNKNOWN_RESET_DETECTED" "${report_dir}/detection.log"; then
    echo "Four-state simulation failed for an unexpected reason" >&2
    cat "${report_dir}/detection.log" >&2
    exit 1
fi

"${iverilog_cmd}" -g2012 -s reset_synchronizer_four_state_tb \
    -DRESET_SYNCHRONIZER_DISABLE_UNKNOWN_CHECK \
    -o "${work_dir}/disabled_check.vvp" "${sources[@]}" \
    > "${report_dir}/disabled-compile.log" 2>&1
"${vvp_cmd}" "${work_dir}/disabled_check.vvp" \
    > "${report_dir}/disabled-run.log" 2>&1
if ! grep -Fq "UNKNOWN_RESET_ESCAPED" "${report_dir}/disabled-run.log"; then
    echo "Disabled-monitor control did not reach the expected escape marker" >&2
    exit 1
fi

printf 'PASS\n' > "${report_dir}/status.txt"
echo "Four-state simulation detected the unknown reset input"
