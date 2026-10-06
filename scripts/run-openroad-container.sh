#!/usr/bin/env bash
set -euo pipefail

# Run the official ORFS image so physical evidence does not depend on a host
# OpenROAD installation. The digest keeps CI and local runs on the same tools.
: "${MODULE_ROOT:?MODULE_ROOT must identify the repository root}"
: "${REPORT_DIR:?REPORT_DIR must identify the module report directory}"
: "${WORK_DIR:?WORK_DIR must identify the module work directory}"
: "${OPENROAD_CONFIG:?OPENROAD_CONFIG must select the ORFS design configuration}"
: "${SYNTHESIS_CONSTRAINT_FILE:?SYNTHESIS_CONSTRAINT_FILE must select the SDC}"

image="${OPENROAD_ORFS_IMAGE:-openroad/orfs@sha256:d995618be9f2bcdfa5538b885123463070dfbf178bea1818716d4652fe0fa380}"
platform="${OPENROAD_PLATFORM:-nangate45}"
variant="${OPENROAD_FLOW_VARIANT:-clock_gate_release}"
flow_report_dir="${REPORT_DIR}/openroad"
flow_work_dir="${WORK_DIR}/openroad"
orfs_report_dir="${flow_work_dir}/reports/${platform}/${DESIGN_TOP}/${variant}"
orfs_result_dir="${flow_work_dir}/results/${platform}/${DESIGN_TOP}/${variant}"

command -v docker >/dev/null 2>&1 || {
  echo "Docker is required for the pinned OpenROAD flow" >&2
  exit 2
}

mkdir -p "${flow_report_dir}" \
  "${flow_work_dir}/results" "${flow_work_dir}/reports" \
  "${flow_work_dir}/logs" "${flow_work_dir}/objects"
printf 'FAIL\n' >"${flow_report_dir}/status.txt"

if ! docker run --rm --user "$(id -u):$(id -g)" \
  --volume "${MODULE_ROOT}:/workspace" \
  --volume "${flow_work_dir}/results:/OpenROAD-flow-scripts/flow/results" \
  --volume "${flow_work_dir}/reports:/OpenROAD-flow-scripts/flow/reports" \
  --volume "${flow_work_dir}/logs:/OpenROAD-flow-scripts/flow/logs" \
  --volume "${flow_work_dir}/objects:/OpenROAD-flow-scripts/flow/objects" \
  --entrypoint bash "${image}" -lc \
  "source /OpenROAD-flow-scripts/env.sh >/dev/null && \
   make -C /OpenROAD-flow-scripts/flow \
     DESIGN_CONFIG=/workspace/${OPENROAD_CONFIG#"${MODULE_ROOT}/"} \
     REPO_ROOT=/workspace \
     SYNTHESIS_CONSTRAINT_FILE=/workspace/${SYNTHESIS_CONSTRAINT_FILE#"${MODULE_ROOT}/"} \
     OPENROAD_PLATFORM=${platform} FLOW_VARIANT=${variant}" \
  2>&1 | tee "${flow_report_dir}/run.log"; then
  echo "OpenROAD-flow-scripts failed" >&2
  exit 1
fi

for artifact in 6_final.def 6_final.gds 6_final.odb 6_final.sdc 6_final.v; do
  if [[ ! -s "${orfs_result_dir}/${artifact}" ]]; then
    echo "Missing final OpenROAD artifact: ${artifact}" >&2
    exit 1
  fi
done

finish_report="${orfs_report_dir}/6_finish.rpt"
route_log="${flow_work_dir}/logs/${platform}/${DESIGN_TOP}/${variant}/5_2_route.log"
for expected in \
  'setup violation count 0' \
  'hold violation count 0' \
  'max slew violation count 0' \
  'max fanout violation count 0' \
  'max cap violation count 0'; do
  grep -Fq "${expected}" "${finish_report}" || {
    echo "Missing clean final metric: ${expected}" >&2
    exit 1
  }
done
grep -Fq 'Number of violations = 0' "${route_log}" || {
  echo "Detailed routing did not report zero violations" >&2
  exit 1
}

{
  echo "image=${image}"
  echo "platform=${platform}"
  echo "variant=${variant}"
  echo "design_config=${OPENROAD_CONFIG#"${MODULE_ROOT}/"}"
  echo "constraint=${SYNTHESIS_CONSTRAINT_FILE#"${MODULE_ROOT}/"}"
  sha256sum "${orfs_result_dir}/6_final.def" "${orfs_result_dir}/6_final.gds"
} >"${flow_report_dir}/evidence.txt"

printf 'PASS\n' >"${flow_report_dir}/status.txt"
echo "Pinned OpenROAD physical flow passed for ${DESIGN_TOP} on ${platform}"
