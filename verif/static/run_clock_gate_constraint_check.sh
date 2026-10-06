#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC2153
: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
# shellcheck disable=SC2153
: "${SYNTHESIS_CONSTRAINT_FILE:?SYNTHESIS_CONSTRAINT_FILE must select the clock-gate SDC}"
# shellcheck disable=SC2153
: "${OPENROAD_CONSTRAINT_FILE:?OPENROAD_CONSTRAINT_FILE must select the OpenROAD SDC}"

report_dir="${REPORT_DIR}/constraint_check"
report="${report_dir}/checks.log"
mkdir -p "${report_dir}"
printf 'FAIL\n' >"${report_dir}/status.txt"
: >"${report}"

expected_sdc="${MODULE_ROOT}/flows/synthesis/clock_gate.timing.sdc"
for selected_sdc in "${SYNTHESIS_CONSTRAINT_FILE}" "${OPENROAD_CONSTRAINT_FILE}"; do
  if [[ "${selected_sdc}" != "${expected_sdc}" ]]; then
    echo "Unexpected clock-gate SDC selection: ${selected_sdc}" >&2
    exit 1
  fi
done

require_pattern() {
  local description="$1"
  local pattern="$2"
  if ! grep -Eq "${pattern}" "${expected_sdc}"; then
    echo "Missing ${description}" >&2
    exit 1
  fi
  echo "PASS: ${description}" >>"${report}"
}

require_pattern "10 ns source clock" \
  'create_clock .*source_clk .*period 10(\.0+)? .*get_ports i_clk'
require_pattern "generated gated clock" \
  'create_generated_clock .*gated_clk .*source \[get_ports i_clk\] .*combinational .*get_ports o_gclk'
require_pattern "source-clock uncertainty" \
  'set_clock_uncertainty 0\.1(0*)? \[get_clocks source_clk\]'
require_pattern "functional and test enable input delays" \
  'set_input_delay 0\.5(0*)? .*source_clk .*get_ports \{i_enable i_test_enable\}'

if grep -Eq 'set_false_path|set_clock_groups|set_output_delay.*o_gclk' "${expected_sdc}"; then
  echo "Clock-gate SDC contains a forbidden exception or output-delay model" >&2
  exit 1
fi

echo "PASS: no false paths, asynchronous clock groups, or data output delay on o_gclk" >>"${report}"
printf 'PASS\n' >"${report_dir}/status.txt"
echo "Clock-gate generated-clock constraint intent passed"
