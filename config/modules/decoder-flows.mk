# Required portable checks for the technology-independent decoder leaf.
FLOW_verible_lint := enabled
FLOW_verible_format := enabled
FLOW_slang_elaboration := enabled
FLOW_verilator_lint := enabled
FLOW_yosys_synthesis := enabled
FLOW_symbiyosys_formal := enabled
FLOW_eqy_equivalence := enabled
FLOW_verilator_sim := enabled
FLOW_coverage_qualification := enabled
FLOW_negative_qualification := enabled
FLOW_four_state_qualification := enabled
FLOW_static_intent := enabled

# Clock-domain, scan, power-domain, mapped timing, power, and placement context
# belong to the first consuming block that uses the decoded controls.
FLOW_openroad := disabled
FLOW_vcs_sim := disabled
FLOW_pyuvm_open_source := disabled
FLOW_pyuvm_commercial := disabled
FLOW_vc_lint := disabled
FLOW_vc_cdc := disabled
FLOW_sg_cdc := disabled
FLOW_sg_dft := disabled
FLOW_vc_lp := disabled
FLOW_synopsys_synthesis := disabled
FLOW_synopsys_primetime := disabled
FLOW_synopsys_primepower := disabled

FLOW_DEPENDENCIES_eqy_equivalence := yosys_synthesis
FLOW_DEPENDENCIES_coverage_qualification := verilator_sim
FLOW_DEPENDENCIES_negative_qualification :=
FLOW_DEPENDENCIES_four_state_qualification :=
FLOW_DEPENDENCIES_static_intent :=
FLOW_DEPENDENCIES_synopsys_primetime :=
FLOW_DEPENDENCIES_synopsys_primepower :=
