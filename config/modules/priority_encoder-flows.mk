FLOW_verible_lint := enabled
FLOW_verible_format := enabled
FLOW_slang_elaboration := enabled
FLOW_verilator_lint := enabled
FLOW_yosys_synthesis := enabled
FLOW_symbiyosys_formal := enabled
FLOW_eqy_equivalence := enabled
FLOW_verilator_sim := enabled
# Technology, clock-domain, scan, and power-domain signoff require the complete
# consuming integration and are approved policy skips for this combinational leaf.
FLOW_openroad := disabled
FLOW_vcs_sim := disabled
FLOW_vc_lint := disabled
FLOW_vc_cdc := disabled
FLOW_sg_cdc := disabled
FLOW_sg_dft := disabled
FLOW_vc_lp := disabled
FLOW_synopsys_synthesis := disabled
FLOW_synopsys_primetime := disabled
FLOW_synopsys_primepower := disabled
FLOW_DEPENDENCIES_eqy_equivalence := yosys_synthesis
FLOW_DEPENDENCIES_synopsys_primetime :=
FLOW_DEPENDENCIES_synopsys_primepower :=
