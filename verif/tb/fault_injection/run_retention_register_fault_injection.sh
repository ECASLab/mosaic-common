#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"

report_dir="${REPORT_DIR}/fault_injection"
work_dir="${WORK_DIR}/fault_injection"
rm -rf "${report_dir}" "${work_dir}"
mkdir -p "${report_dir}" "${work_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"

"${IVERILOG_CMD:-iverilog}" -g2012 -s retention_register_negative_tb \
    -o "${work_dir}/illegal.vvp" rtl/retention_register.sv \
    verif/tb/fault_injection/retention_register_negative_tb.sv \
    > "${report_dir}/compile.log" 2>&1
set +e
"${VVP_CMD:-vvp}" "${work_dir}/illegal.vvp" > "${report_dir}/run.log" 2>&1
result=$?
set -e
if ((result == 0)) || ! grep -Fq 'ILLEGAL_CONTROL_DETECTED' "${report_dir}/run.log"; then
    echo "Illegal simultaneous save and restore escaped verification" >&2
    exit 1
fi

printf 'PASS\n' > "${report_dir}/status.txt"
echo "Retention-register verification detected the illegal control mutation"
