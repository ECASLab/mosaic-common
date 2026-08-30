#!/usr/bin/env bash
set -euo pipefail

: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${SYNTHESIS_CONSTRAINT_FILE:?SYNTHESIS_CONSTRAINT_FILE must select the reset synchronizer SDC}"

report_dir="${REPORT_DIR}/constraint_check"
report="${report_dir}/checks.log"
expected_sdc="${MODULE_ROOT}/flows/synthesis/reset_synchronizer.timing.sdc"
mkdir -p "${report_dir}"
printf 'FAIL\n' >"${report_dir}/status.txt"
: >"${report}"

if [[ "${SYNTHESIS_CONSTRAINT_FILE}" != "${expected_sdc}" ]]; then
    echo "Unexpected reset-synchronizer SDC selection" >&2
    exit 1
fi

require_pattern() {
    local description="$1"
    local pattern="$2"
    grep -Eq "${pattern}" "${expected_sdc}" || {
        echo "Missing ${description}" >&2
        exit 1
    }
    echo "PASS: ${description}" >>"${report}"
}

require_pattern "10 ns destination clock" \
    'create_clock .*destination_clk .*period 10(\.0+)? .*get_ports i_clk'
require_pattern "destination-clock uncertainty" \
    'set_clock_uncertainty 0\.1(0*)? \[get_clocks destination_clk\]'
require_pattern "synchronized reset output delay" \
    'set_output_delay 0\.5(0*)? .*destination_clk .*get_ports o_rstb'

if grep -Eq 'set_false_path.*sync_stages|set_clock_groups|set_input_delay.*i_async_rstb' "${expected_sdc}"; then
    echo "SDC suppresses required synchronizer or asynchronous-reset analysis" >&2
    exit 1
fi

echo "PASS: no blanket stage exception or synchronous raw-reset delay" >>"${report}"
printf 'PASS\n' >"${report_dir}/status.txt"
echo "Reset-synchronizer constraint intent passed"
