#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC2153
: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
# shellcheck disable=SC2153
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"

report_dir="${REPORT_DIR}/fault_injection"
work_dir="${WORK_DIR}/fault_injection"
verilator_cmd="${VERILATOR_CMD:-verilator}"
eqy_cmd="${EQY_CMD:-eqy}"

rm -rf "${report_dir}" "${work_dir}"
mkdir -p "${report_dir}" "${work_dir}"
printf 'FAIL\n' >"${report_dir}/status.txt"

declare -A fault_names=(
  [1]="combinational_clock_gating"
  [2]="missing_test_override"
  [3]="inverted_functional_enable"
  [4]="high_phase_enable_capture"
)

for mode in {1..4}; do
  fault_name="${fault_names[${mode}]}"
  fault_work_dir="${work_dir}/${fault_name}"
  fault_report_dir="${report_dir}/${fault_name}"
  mkdir -p "${fault_work_dir}" "${fault_report_dir}"

  if ! "${verilator_cmd}" --binary --timing --assert -Wall \
    -Wno-BLKSEQ -Wno-SYNCASYNCNET -Wno-DECLFILENAME \
    -DCLOCK_GATE_FAULT_MODE="${mode}" \
    verif/tb/fault_injection/clock_gate_mutant.sv \
    verif/tb/clock_gate_tb.sv verif/assertions/clock_gate_sva.sv \
    verif/assertions/clock_gate_bind.sv \
    --top-module clock_gate_tb --Mdir "${fault_work_dir}/obj_dir" \
    >"${fault_report_dir}/compile.log" 2>&1; then
    cat "${fault_report_dir}/compile.log" >&2
    echo "Failed to compile fault ${fault_name}" >&2
    exit 1
  fi

  set +e
  "${fault_work_dir}/obj_dir/Vclock_gate_tb" >"${fault_report_dir}/run.log" 2>&1
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
  verif/formal/fault_injection/clock_gate_bad_netlist.eqy \
  >"${eqy_report_dir}/run.log" 2>&1
result=$?
set -e

if ((result == 0)); then
  echo "Incorrect clock-gate candidate netlist escaped EQY" >&2
  exit 1
fi
if ! grep -Eq 'Successfully proved designs inequivalent|Failed to prove equivalence' \
  "${eqy_report_dir}/run.log"; then
  echo "EQY failed without reporting the expected clock-gate inequivalence" >&2
  exit 1
fi

printf 'PASS\n' >"${eqy_report_dir}/status.txt"
printf 'PASS\n' >"${report_dir}/status.txt"
echo "All clock-gate fault-injection tests detected their assigned mutation"
