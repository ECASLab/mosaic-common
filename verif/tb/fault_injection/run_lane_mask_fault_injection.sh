#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"

report_dir="${REPORT_DIR}/fault_injection"
work_dir="${WORK_DIR}/fault_injection"
verilator_cmd="${VERILATOR_CMD:-verilator}"
eqy_cmd="${EQY_CMD:-eqy}"

rm -rf "${report_dir}" "${work_dir}"
mkdir -p "${report_dir}" "${work_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"

declare -A fault_names=(
    [1]="missing_operation_valid"
    [2]="missing_lane_valid"
    [3]="missing_architectural_mask"
    [4]="missing_predicate"
    [5]="incorrect_isolation_polarity"
    [6]="incorrect_write_mask_polarity"
)

for mode in {1..6}; do
    fault_name="${fault_names[${mode}]}"
    fault_work_dir="${work_dir}/${fault_name}"
    fault_report_dir="${report_dir}/${fault_name}"
    mkdir -p "${fault_work_dir}" "${fault_report_dir}"

    "${verilator_cmd}" --binary --timing --assert -Wall \
        -Wno-DECLFILENAME -DLANE_MASK_FAULT_MODE="${mode}" \
        verif/tb/fault_injection/lane_mask_mutant.sv \
        verif/tb/lane_mask_checker.sv verif/tb/lane_mask_tb.sv \
        verif/assertions/lane_mask_sva.sv verif/assertions/lane_mask_bind.sv \
        --top-module lane_mask_tb --Mdir "${fault_work_dir}/obj_dir" \
        > "${fault_report_dir}/compile.log" 2>&1

    set +e
    "${fault_work_dir}/obj_dir/Vlane_mask_tb" > "${fault_report_dir}/run.log" 2>&1
    result=$?
    set -e
    if ((result == 0)); then
        echo "Fault ${fault_name} escaped simulation" >&2
        exit 1
    fi
    printf 'PASS\n' > "${fault_report_dir}/status.txt"
done

eqy_report_dir="${report_dir}/rtl_netlist_mismatch"
eqy_work_dir="${work_dir}/rtl_netlist_mismatch"
mkdir -p "${eqy_report_dir}"

set +e
"${eqy_cmd}" -f -d "${eqy_work_dir}" \
    verif/formal/fault_injection/lane_mask_bad_netlist.eqy \
    > "${eqy_report_dir}/run.log" 2>&1
result=$?
set -e
if ((result == 0)); then
    echo "Incorrect lane-mask candidate netlist escaped EQY" >&2
    exit 1
fi
if ! grep -Eq 'Successfully proved designs inequivalent|Failed to prove equivalence' \
    "${eqy_report_dir}/run.log"; then
    echo "EQY failed without reporting the expected lane-mask inequivalence" >&2
    exit 1
fi

printf 'PASS\n' > "${eqy_report_dir}/status.txt"
printf 'PASS\n' > "${report_dir}/status.txt"
echo "All lane-mask fault-injection tests detected their assigned mutation"
