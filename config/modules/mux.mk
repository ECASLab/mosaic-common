# Mux tops and design-owned flow inputs.
export DESIGN_TOP := mux
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
    rtl/mux.sv \
    verif/properties/mux_predicates.svh \
    verif/assertions/mux_sva.sv \
    verif/assertions/mux_bind.sv \
    verif/coverage/mux_coverage.sv \
    verif/coverage/mux_transition_coverage.sv \
    verif/coverage/mux_coverage_bind.sv \
    verif/formal/mux_formal.sv \
    verif/mutations/mux_invalid_valid_mutant.sv \
    verif/tb/mux_test_case.sv \
    verif/tb/mux_tb.sv \
    verif/tb/mux_four_state_tb.sv \
    verif/tb/mux_invalid_num_inputs_tb.sv \
    verif/tb/mux_invalid_data_width_tb.sv \
    verif/tb/mux_invalid_sel_width_tb.sv \
    verif/tb/mux_invalid_default_value_tb.sv
export FORMAL_CONFIG := $(call resolve_flow_config,symbiyosys,formal.sby)
export FORMAL_COVER_CONFIG := $(MODULE_ROOT)/flows/symbiyosys/mux.cover.sby
export EQUIVALENCE_CONFIG := $(call resolve_flow_config,eqy,equivalence.eqy)
export COVERAGE_QUALIFICATION_POLICY := $(MODULE_ROOT)/config/coverage-policies/mux.json
export COVERAGE_QUALIFICATION_SOURCE := verilator_sim
export SIM_COVERAGE := enabled
export QUALIFICATION_CAMPAIGN_MANIFEST := $(MODULE_ROOT)/config/qualification-campaigns/mux.json
export STATIC_INTENT_CONFIG := $(MODULE_ROOT)/config/static-intent/mux.json
export OPENROAD_CONFIG := $(call resolve_flow_config,openroad,config.mk)
export SYNTHESIS_CONSTRAINT_FILE := $(call resolve_flow_config,synthesis,timing.sdc)
export ASYNC_SYNTHESIS_CONSTRAINT_FILE :=
export OPENROAD_CONSTRAINT_FILE := $(MODULE_ROOT)/flows/openroad/mux.timing.sdc
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
