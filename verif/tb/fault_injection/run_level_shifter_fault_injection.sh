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
    [1]="inverted_output"
    [2]="constant_zero_output"
    [3]="reversed_bit_order"
    [4]="corrupted_bit_zero"
)

for mode in {1..4}; do
    fault_name="${fault_names[${mode}]}"
    fault_work_dir="${work_dir}/${fault_name}"
    fault_report_dir="${report_dir}/${fault_name}"
    mkdir -p "${fault_work_dir}" "${fault_report_dir}"

    "${verilator_cmd}" --binary --timing --assert -Wall \
        -Wno-DECLFILENAME -DLEVEL_SHIFTER_FAULT_MODE="${mode}" \
        verif/tb/fault_injection/level_shifter_mutant.sv \
        verif/tb/level_shifter_checker.sv verif/tb/level_shifter_tb.sv \
        verif/assertions/level_shifter_sva.sv verif/assertions/level_shifter_bind.sv \
        --top-module level_shifter_tb --Mdir "${fault_work_dir}/obj_dir" \
        > "${fault_report_dir}/compile.log" 2>&1

    set +e
    "${fault_work_dir}/obj_dir/Vlevel_shifter_tb" > "${fault_report_dir}/run.log" 2>&1
    result=$?
    set -e
    if ((result == 0)); then
        echo "Fault ${fault_name} escaped simulation" >&2
        exit 1
    fi
    printf 'PASS\n' > "${fault_report_dir}/status.txt"
done

for top in level_shifter_invalid_width_tb level_shifter_invalid_direction_tb; do
    invalid_work_dir="${work_dir}/${top}"
    invalid_report_dir="${report_dir}/${top}"
    mkdir -p "${invalid_work_dir}" "${invalid_report_dir}"

    "${verilator_cmd}" --binary --timing -Wall -Wno-DECLFILENAME \
        -Wno-LITENDIAN -Wno-UNDRIVEN -Wno-UNUSEDSIGNAL \
        rtl/level_shifter.sv verif/tb/fault_injection/level_shifter_invalid_parameter_tb.sv \
        --top-module "${top}" --Mdir "${invalid_work_dir}/obj_dir" \
        > "${invalid_report_dir}/compile.log" 2>&1

    set +e
    "${invalid_work_dir}/obj_dir/V${top}" > "${invalid_report_dir}/run.log" 2>&1
    result=$?
    set -e
    if ((result == 0)); then
        echo "Illegal configuration ${top} escaped elaboration-time validation" >&2
        exit 1
    fi
    printf 'PASS\n' > "${invalid_report_dir}/status.txt"
done

eqy_report_dir="${report_dir}/rtl_netlist_mismatch"
eqy_work_dir="${work_dir}/rtl_netlist_mismatch"
mkdir -p "${eqy_report_dir}"

set +e
"${eqy_cmd}" -f -d "${eqy_work_dir}" \
    verif/formal/fault_injection/level_shifter_bad_netlist.eqy \
    > "${eqy_report_dir}/run.log" 2>&1
result=$?
set -e
if ((result == 0)); then
    echo "Incorrect level-shifter candidate netlist escaped EQY" >&2
    exit 1
fi
if ! grep -Eq 'Successfully proved designs inequivalent|Failed to prove equivalence' \
    "${eqy_report_dir}/run.log"; then
    echo "EQY failed without reporting the expected level-shifter inequivalence" >&2
    exit 1
fi

printf 'PASS\n' > "${eqy_report_dir}/status.txt"
printf 'PASS\n' > "${report_dir}/status.txt"
echo "All level-shifter negative tests detected their assigned defect"
