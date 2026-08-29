#!/usr/bin/env bash
set -euo pipefail

# These paths are supplied by the selected module profile through GNU Make.
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
printf 'FAIL\n' > "${report_dir}/status.txt"

declare -A fault_names=(
  [1]="incorrect_reset_value"
  [2]="capture_while_disabled"
  [3]="failure_to_capture_while_enabled"
  [4]="enable_used_in_always_capture_profile"
)

for mode in 1 2 3 4; do
  fault_name="${fault_names[${mode}]}"
  fault_work_dir="${work_dir}/${fault_name}"
  fault_report_dir="${report_dir}/${fault_name}"
  mkdir -p "${fault_work_dir}" "${fault_report_dir}"

  if ! "${verilator_cmd}" --binary --timing --assert -Wall \
    -Wno-BLKSEQ -Wno-SYNCASYNCNET -Wno-DECLFILENAME \
    -DDFF_FAULT_MODE="${mode}" \
    verif/tb/fault_injection/dff_mutant.sv \
    verif/tb/dff_checker.sv verif/tb/dff_tb.sv \
    verif/assertions/dff_sva.sv verif/assertions/dff_bind.sv \
    --top-module dff_tb --Mdir "${fault_work_dir}/obj_dir" \
    >"${fault_report_dir}/compile.log" 2>&1; then
    cat "${fault_report_dir}/compile.log" >&2
    echo "Failed to compile fault ${fault_name}" >&2
    exit 1
  fi

  set +e
  "${fault_work_dir}/obj_dir/Vdff_tb" \
    >"${fault_report_dir}/run.log" 2>&1
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
  verif/formal/fault_injection/dff_bad_netlist.eqy \
  >"${eqy_report_dir}/run.log" 2>&1
result=$?
set -e

if ((result == 0)); then
  echo "Incorrect candidate netlist escaped EQY" >&2
  exit 1
fi
if ! grep -Eq 'Successfully proved designs inequivalent|Failed to prove equivalence' \
  "${eqy_report_dir}/run.log"; then
  echo "EQY failed without reporting the expected inequivalence" >&2
  exit 1
fi
printf 'PASS\n' > "${eqy_report_dir}/status.txt"
printf 'PASS\n' > "${report_dir}/status.txt"
echo "All DFF fault-injection tests detected their assigned mutation"
