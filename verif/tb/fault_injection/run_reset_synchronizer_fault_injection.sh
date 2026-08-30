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
printf 'FAIL\n' >"${report_dir}/status.txt"

declare -A fault_names=(
    [1]="synchronous_only_assertion"
    [2]="premature_output_release"
    [3]="skipped_release_stages"
    [4]="incomplete_asynchronous_clear"
)

for mode in {1..4}; do
    fault_name="${fault_names[${mode}]}"
    fault_work_dir="${work_dir}/${fault_name}"
    fault_report_dir="${report_dir}/${fault_name}"
    mkdir -p "${fault_work_dir}" "${fault_report_dir}"

    if ! "${verilator_cmd}" --binary --timing --assert -Wall \
        -Wno-BLKSEQ -Wno-SYNCASYNCNET -Wno-DECLFILENAME \
        -DRESET_SYNCHRONIZER_FAULT_MODE="${mode}" \
        verif/tb/fault_injection/reset_synchronizer_mutant.sv \
        verif/tb/reset_synchronizer_checker.sv \
        verif/tb/reset_synchronizer_tb.sv \
        verif/assertions/reset_synchronizer_sva.sv \
        verif/assertions/reset_synchronizer_bind.sv \
        --top-module reset_synchronizer_tb --Mdir "${fault_work_dir}/obj_dir" \
        >"${fault_report_dir}/compile.log" 2>&1; then
        cat "${fault_report_dir}/compile.log" >&2
        exit 1
    fi

    set +e
    "${fault_work_dir}/obj_dir/Vreset_synchronizer_tb" >"${fault_report_dir}/run.log" 2>&1
    result=$?
    set -e
    if ((result == 0)); then
        echo "Fault ${fault_name} escaped simulation" >&2
        exit 1
    fi
    printf 'PASS\n' >"${fault_report_dir}/status.txt"
done

eqy_report_dir="${report_dir}/rtl_netlist_mismatch"
eqy_work_dir="${work_dir}/rtl_netlist_mismatch"
mkdir -p "${eqy_report_dir}"
set +e
"${eqy_cmd}" -f -d "${eqy_work_dir}" \
    verif/formal/fault_injection/reset_synchronizer_bad_netlist.eqy \
    >"${eqy_report_dir}/run.log" 2>&1
result=$?
set -e
if ((result == 0)); then
    echo "Incorrect reset-synchronizer netlist escaped EQY" >&2
    exit 1
fi
if ! grep -Eq 'Successfully proved designs inequivalent|Failed to prove equivalence' \
    "${eqy_report_dir}/run.log"; then
    echo "EQY did not report the expected reset-synchronizer inequivalence" >&2
    exit 1
fi

printf 'PASS\n' >"${eqy_report_dir}/status.txt"
printf 'PASS\n' >"${report_dir}/status.txt"
echo "All reset-synchronizer fault-injection tests detected their mutation"
