# Portable structural and behavioral checks qualify this implementation slice.
FLOW_verible_lint := enabled
FLOW_verible_format := enabled
FLOW_slang_elaboration := enabled
FLOW_verilator_lint := enabled
FLOW_yosys_synthesis := enabled
FLOW_symbiyosys_formal := enabled
FLOW_eqy_equivalence := enabled
FLOW_verilator_sim := enabled

# Licensed and technology-specific flows are approved integration-level skips
# for this portable release. Yosys remains the required synthesis gate.
FLOW_openroad := disabled
FLOW_vcs_sim := disabled
FLOW_vc_lint := disabled
# A qualified CDC/RDC engine is mandatory at the first level containing the
# source, synchronizer, destination domain, and consumers. No licensed engine is
# required for this isolated portable leaf release.
FLOW_vc_cdc := disabled
FLOW_sg_cdc := disabled
# DFT controllability is qualified with the complete MOSAIC/SoC test network.
FLOW_sg_dft := disabled
# VC LP becomes mandatory only for switchable or multi-voltage integration.
FLOW_vc_lp := disabled
FLOW_synopsys_synthesis := disabled
FLOW_synopsys_primetime := disabled
FLOW_synopsys_primepower := disabled

FLOW_DEPENDENCIES_eqy_equivalence := yosys_synthesis
FLOW_DEPENDENCIES_synopsys_primetime :=
FLOW_DEPENDENCIES_synopsys_primepower :=
