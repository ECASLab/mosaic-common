#!/usr/bin/env bash
set -euo pipefail

# These paths are supplied by the selected module profile through GNU Make.
# shellcheck disable=SC2153
: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
# shellcheck disable=SC2153
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"
# shellcheck disable=SC2153
: "${DESIGN_TOP:?DESIGN_TOP must identify the selected module}"
# shellcheck disable=SC2153
: "${ASSERTION_COVERPOINT_REQUIREMENTS:?ASSERTION_COVERPOINT_REQUIREMENTS must define required coverpoint hits}"

report_dir="${REPORT_DIR}/assertion_coverage"
work_dir="${WORK_DIR}/assertion_coverage"
verilator_cmd="${VERILATOR_CMD:-verilator}"
coverage_cmd="${VERILATOR_COVERAGE_CMD:-verilator_coverage}"

rm -rf "${report_dir}" "${work_dir}"
mkdir -p "${report_dir}" "${work_dir}/obj_dir"
printf 'FAIL\n' > "${report_dir}/status.txt"

if ! "${verilator_cmd}" --binary --timing --assert --coverage -Wall \
  -Wno-BLKSEQ -Wno-SYNCASYNCNET -f "${TB_FILELIST}" \
  --top-module "${TB_TOP}" --Mdir "${work_dir}/obj_dir" \
  >"${report_dir}/compile.log" 2>&1; then
  cat "${report_dir}/compile.log" >&2
  exit 1
fi

(
  cd "${work_dir}"
  ./obj_dir/"V${TB_TOP}" >"${report_dir}/run.log" 2>&1
)

coverage_data="${work_dir}/coverage.dat"
if [[ ! -s "${coverage_data}" ]]; then
  echo "Verilator did not produce assertion coverage data" >&2
  exit 1
fi

"${coverage_cmd}" --write-info "${report_dir}/coverage.info" "${coverage_data}" \
  >"${report_dir}/coverage.log" 2>&1

declare -A required_coverpoints=()
for requirement in ${ASSERTION_COVERPOINT_REQUIREMENTS}; do
  coverpoint="${requirement%%=*}"
  expected_count="${requirement#*=}"
  if [[ -z "${coverpoint}" || ! "${expected_count}" =~ ^[1-9][0-9]*$ ]]; then
    echo "Invalid assertion coverage requirement: ${requirement}" >&2
    exit 2
  fi
  required_coverpoints["${coverpoint}"]="${expected_count}"
done

for coverpoint in "${!required_coverpoints[@]}"; do
  expected_count="${required_coverpoints[${coverpoint}]}"
  emitted_count="$(grep -Ec "^BRDA:[0-9]+,[0-9]+,${coverpoint}," \
    "${report_dir}/coverage.info")"
  hit_count="$(grep -Ec "^BRDA:[0-9]+,[0-9]+,${coverpoint},[1-9][0-9]*$" \
    "${report_dir}/coverage.info")"
  if [[ "${emitted_count}" != "${expected_count}" || "${hit_count}" != "${expected_count}" ]]; then
    echo "Coverpoint ${coverpoint}: expected ${expected_count} positive instance hits, got ${hit_count}/${emitted_count}" >&2
    exit 1
  fi
done

# Release RTL must reach every executable line and both directions of every
# toggle represented in the LCOV BRDA records. Verification-source metrics are
# retained for diagnosis but are not release thresholds.
# Verilator emits BRDA records for both runtime branches and toggle coverage.
# Module profiles may exclude narrowly reviewed source lines for structurally
# unreachable elaboration-time alternatives or four-state-only behavior.
if ! awk -v rtl_source="rtl/${DESIGN_TOP}.sv" \
  -v excluded_lines="${ASSERTION_COVERAGE_EXCLUDED_RTL_LINES:-}" '
  BEGIN {
    split(excluded_lines, line_list, " ");
    for (line_index in line_list) excluded[line_list[line_index]] = 1;
  }
  /^SF:/ { in_rtl = ($0 == "SF:" rtl_source); next }
  in_rtl && /^DA:/ {
    split(substr($0, 4), fields, ",");
    if (fields[1] in excluded) next;
    line_total++;
    if (fields[2] > 0) line_hit++;
  }
  in_rtl && /^BRDA:/ {
    split(substr($0, 6), fields, ",");
    if (fields[1] in excluded) next;
    toggle_total++;
    if (fields[4] != "-" && fields[4] > 0) toggle_hit++;
  }
  END {
    printf "RTL executable lines: %d/%d\nRTL toggles: %d/%d\n",
      line_hit, line_total, toggle_hit, toggle_total;
    exit !(line_total > 0 && line_hit == line_total &&
      toggle_total > 0 && toggle_hit == toggle_total);
  }
' "${report_dir}/coverage.info" >"${report_dir}/summary.txt"; then
  cat "${report_dir}/summary.txt" >&2
  echo "RTL line or toggle coverage is incomplete" >&2
  exit 1
fi

if [[ -n "${FORMAL_COVERAGE_CONFIG:-}" ]]; then
  if ! "${SBY_CMD:-sby}" -f \
    -d "${work_dir}/formal_cover" \
    "${FORMAL_COVERAGE_CONFIG}" \
    >"${report_dir}/formal-cover.log" 2>&1; then
    cat "${report_dir}/formal-cover.log" >&2
    exit 1
  fi
fi

printf 'PASS\n' > "${report_dir}/status.txt"
echo "All required ${DESIGN_TOP} assertion antecedents were exercised"
