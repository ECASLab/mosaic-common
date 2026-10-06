#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"

report_dir="${REPORT_DIR}/fault_injection"
work_dir="${WORK_DIR}/fault_injection"
rm -rf "${report_dir}" "${work_dir}"
mkdir -p "${report_dir}" "${work_dir}"
printf 'FAIL\n' > "${report_dir}/status.txt"

fault_names=(bypass incorrect_clamp reversed_control constant_zero)
fault_defines=(ISOLATION_CELL_FAULT_BYPASS ISOLATION_CELL_FAULT_CLAMP ISOLATION_CELL_FAULT_CONTROL ISOLATION_CELL_FAULT_CONSTANT)
for index in 0 1 2 3; do
    name="${fault_names[${index}]}"
    mkdir -p "${report_dir}/${name}" "${work_dir}/${name}"
    "${VERILATOR_CMD:-verilator}" --binary --timing --assert -Wall -Wno-DECLFILENAME \
        -Wno-UNUSEDSIGNAL -Wno-UNUSEDPARAM \
        -D"${fault_defines[${index}]}" \
        verif/tb/fault_injection/isolation_cell_mutant.sv \
        verif/tb/isolation_cell_checker.sv verif/tb/isolation_cell_tb.sv \
        verif/assertions/isolation_cell_sva.sv verif/assertions/isolation_cell_bind.sv \
        --top-module isolation_cell_tb --Mdir "${work_dir}/${name}/obj_dir" \
        > "${report_dir}/${name}/compile.log" 2>&1
    set +e
    "${work_dir}/${name}/obj_dir/Visolation_cell_tb" > "${report_dir}/${name}/run.log" 2>&1
    result=$?
    set -e
    if ((result == 0)); then
        echo "Fault ${name} escaped simulation" >&2
        exit 1
    fi
    printf 'PASS\n' > "${report_dir}/${name}/status.txt"
done

invalid_parameters=(WIDTH CLAMP)
for parameter in "${invalid_parameters[@]}"; do
    name="invalid_${parameter,,}"
    mkdir -p "${report_dir}/${name}" "${work_dir}/${name}"
    "${IVERILOG_CMD:-iverilog}" -g2012 -s isolation_cell_invalid_parameter_tb \
        -D"ISOLATION_CELL_INVALID_${parameter}" -o "${work_dir}/${name}/test.vvp" \
        rtl/isolation_cell.sv verif/tb/fault_injection/isolation_cell_invalid_parameter_tb.sv \
        > "${report_dir}/${name}/compile.log" 2>&1
    set +e
    "${VVP_CMD:-vvp}" "${work_dir}/${name}/test.vvp" > "${report_dir}/${name}/run.log" 2>&1
    result=$?
    set -e
    if ((result == 0)) || ! grep -Fq "FATAL" "${report_dir}/${name}/run.log"; then
        echo "Invalid ${parameter,,} parameter was not rejected" >&2
        exit 1
    fi
    printf 'PASS\n' > "${report_dir}/${name}/status.txt"
done

mkdir -p "${report_dir}/rtl_netlist_mismatch"
set +e
"${EQY_CMD:-eqy}" -f -d "${work_dir}/rtl_netlist_mismatch" \
    verif/formal/fault_injection/isolation_cell_bad_netlist.eqy \
    > "${report_dir}/rtl_netlist_mismatch/run.log" 2>&1
result=$?
set -e
if ((result == 0)); then
    echo "Incorrect isolation-cell candidate netlist escaped EQY" >&2
    exit 1
fi
printf 'PASS\n' > "${report_dir}/rtl_netlist_mismatch/status.txt"
printf 'PASS\n' > "${report_dir}/status.txt"
echo "All isolation-cell negative tests detected their assigned defect"
