#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"

report_dir="${REPORT_DIR}/four_state_check"
work_dir="${WORK_DIR}/four_state_check"
iverilog_cmd="${IVERILOG_CMD:-iverilog}"
vvp_cmd="${VVP_CMD:-vvp}"
sources=(rtl/lane_mask.sv verif/tb/four_state/lane_mask_four_state_tb.sv)
scenarios=(GLOBAL VALID MASK PREDICATE)

rm -rf "${report_dir}" "${work_dir}"
mkdir -p "${report_dir}" "${work_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"

for scenario in "${scenarios[@]}"; do
    name="${scenario,,}"
    "${iverilog_cmd}" -g2012 -s lane_mask_four_state_tb \
        -D"LANE_MASK_UNKNOWN_${scenario}" -o "${work_dir}/${name}.vvp" \
        "${sources[@]}" > "${report_dir}/${name}-compile.log" 2>&1
    set +e
    "${vvp_cmd}" "${work_dir}/${name}.vvp" > "${report_dir}/${name}-run.log" 2>&1
    result=$?
    set -e
    if ((result == 0)) || ! grep -Fq "UNKNOWN_CONTROL_DETECTED" \
        "${report_dir}/${name}-run.log"; then
        echo "Unknown ${name} control was not detected as expected" >&2
        exit 1
    fi
done

"${iverilog_cmd}" -g2012 -s lane_mask_four_state_tb \
    -DLANE_MASK_UNKNOWN_GLOBAL -DLANE_MASK_DISABLE_UNKNOWN_CHECK \
    -o "${work_dir}/disabled.vvp" "${sources[@]}" \
    > "${report_dir}/disabled-compile.log" 2>&1
"${vvp_cmd}" "${work_dir}/disabled.vvp" > "${report_dir}/disabled-run.log" 2>&1
grep -Fq "UNKNOWN_CONTROL_ESCAPED" "${report_dir}/disabled-run.log"

printf 'PASS\n' > "${report_dir}/status.txt"
echo "Four-state simulation detected every illegal lane-mask control class"
