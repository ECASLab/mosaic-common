#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"

report_dir="${REPORT_DIR}/four_state_check"
work_dir="${WORK_DIR}/four_state_check"
rm -rf "${report_dir}" "${work_dir}"
mkdir -p "${report_dir}" "${work_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"

for control in RESET ENABLE SAVE RESTORE; do
    "${IVERILOG_CMD:-iverilog}" -g2012 -D"UNKNOWN_${control}" \
        -s retention_register_four_state_tb \
        -o "${work_dir}/${control}.vvp" rtl/retention_register.sv \
        verif/tb/four_state/retention_register_four_state_tb.sv \
        > "${report_dir}/${control}.compile.log" 2>&1
    set +e
    "${VVP_CMD:-vvp}" "${work_dir}/${control}.vvp" \
        > "${report_dir}/${control}.run.log" 2>&1
    result=$?
    set -e
    if ((result == 0)) || ! grep -Fq UNKNOWN_CONTROL_DETECTED \
        "${report_dir}/${control}.run.log"; then
        echo "Unknown ${control} was not detected" >&2
        exit 1
    fi
done

printf 'PASS\n' > "${report_dir}/status.txt"
echo "All retention-register unknown controls were detected"
