# Portable checks form the required DFF acceptance gate.
FLOW_verible_lint := enabled
FLOW_verible_format := enabled
FLOW_slang_elaboration := enabled
FLOW_verilator_lint := enabled
FLOW_yosys_synthesis := enabled
FLOW_symbiyosys_formal := enabled
FLOW_eqy_equivalence := enabled
FLOW_verilator_sim := enabled

# Physical implementation is outside the reusable RTL release scope.
FLOW_openroad := disabled

# Commercial simulation is optional for this technology-independent primitive.
# Verilator provides the required functional simulation evidence.
FLOW_vcs_sim := disabled

# Integration-level static checks are approved skips for this single-clock,
# technology-independent primitive. Open-source lint remains mandatory above.
FLOW_vc_lint := disabled
FLOW_vc_cdc := disabled
FLOW_sg_cdc := disabled
FLOW_sg_dft := disabled
FLOW_vc_lp := disabled
FLOW_synopsys_synthesis := disabled

# Commercial synthesis, timing, and power signoff belong to the integrating
# design for this technology-independent primitive. Yosys synthesis remains a
# required part of the portable acceptance gate.
FLOW_synopsys_primetime := disabled
FLOW_synopsys_primepower := disabled

# EQY consumes the Yosys netlist. Disabled flows have empty dependencies so an
# explicit invocation records SKIP without launching prerequisite tools.
FLOW_DEPENDENCIES_eqy_equivalence := yosys_synthesis
FLOW_DEPENDENCIES_synopsys_primetime :=
FLOW_DEPENDENCIES_synopsys_primepower :=
