# Decoder tops and design-owned flow inputs.
export DESIGN_TOP := decoder
export TB_TOP := $(DESIGN_TOP)_tb
export FORMAL_TOP := $(DESIGN_TOP)_formal
export DUT_INSTANCE := $(TB_TOP)/u_unit/dut

export FLOW_CONFIG_ROOT := $(MODULE_ROOT)/flows
export RTL_FILELIST := $(call resolve_filelist,rtl.f)
export TB_FILELIST := $(call resolve_filelist,tb.f)
export FORMAL_FILELIST := $(call resolve_filelist,formal.f)
export PROPERTY_FILELIST := $(call resolve_filelist,properties.f)
export ASSERTION_FILELIST := $(call resolve_filelist,assertions.f)
export COVERAGE_FILELIST := $(call resolve_filelist,coverage.f)
export VERILATOR_WAIVER_FILE := $(FLOW_CONFIG_ROOT)/verilator_lint/waivers.vlt
export VERIBLE_WAIVER_FILE := $(FLOW_CONFIG_ROOT)/verible/waivers.txt
export VERIBLE_RULES_FILE := $(FLOW_CONFIG_ROOT)/verible/rules
export VERIBLE_FORMAT_ARGS := --indentation_spaces=4
export VERIBLE_FORMAT_PATHS := \
    rtl/decoder.sv \
    verif/properties/decoder_predicates.svh \
    verif/assertions/decoder_sva.sv \
    verif/assertions/decoder_bind.sv \
    verif/coverage/decoder_coverage.sv \
    verif/coverage/decoder_transition_coverage.sv \
    verif/coverage/decoder_coverage_bind.sv \
    verif/formal/decoder_formal.sv \
    verif/mutations/decoder_inverted_enable_mutant.sv \
    verif/tb/decoder_test_case.sv \
    verif/tb/decoder_tb.sv \
    verif/tb/decoder_four_state_tb.sv \
    verif/tb/decoder_invalid_num_outputs_tb.sv \
    verif/tb/decoder_invalid_select_width_tb.sv
export FORMAL_CONFIG := $(call resolve_flow_config,symbiyosys,formal.sby)
export FORMAL_COVER_CONFIG := $(MODULE_ROOT)/flows/symbiyosys/decoder.cover.sby
export EQUIVALENCE_CONFIG := $(call resolve_flow_config,eqy,equivalence.eqy)
export COVERAGE_QUALIFICATION_POLICY := $(MODULE_ROOT)/config/coverage-policies/decoder.json
export COVERAGE_QUALIFICATION_SOURCE := verilator_sim
export SIM_COVERAGE := enabled
export QUALIFICATION_CAMPAIGN_MANIFEST := $(MODULE_ROOT)/config/qualification-campaigns/decoder.json
export STATIC_INTENT_CONFIG := $(MODULE_ROOT)/config/static-intent/decoder.json
export OPENROAD_CONFIG := $(call resolve_flow_config,openroad,config.mk)
export SYNTHESIS_CONSTRAINT_FILE := $(call resolve_flow_config,synthesis,timing.sdc)
export ASYNC_SYNTHESIS_CONSTRAINT_FILE :=
export OPENROAD_CONSTRAINT_FILE := $(MODULE_ROOT)/flows/openroad/decoder.timing.sdc
export CDC_CONFIG := $(call resolve_flow_config,cdc,constraints.tcl)
export DFT_CONFIG := $(call resolve_flow_config,sg_dft,constraints.tcl)
export UPF_CONFIG := $(call resolve_flow_config,vc_lp,power.upf)
export CONSTRAINT_DIR := $(FLOW_CONFIG_ROOT)/synthesis

export REPORT_DIR := $(MODULE_ROOT)/reports/$(MODULE)
export WORK_DIR := $(MODULE_ROOT)/work/$(MODULE)
export OPENROAD_PLATFORM ?= nangate45
export TECH_SETUP_TCL ?=
export TARGET_LIBRARY ?=
export LINK_LIBRARY ?=
export OPERATING_CONDITION ?=
export ACTIVITY_FILE ?=$(WORK_DIR)/vcs_sim/$(DESIGN_TOP).saif
