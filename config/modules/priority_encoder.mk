# Priority-encoder tops and design-owned flow inputs.
export DESIGN_TOP := priority_encoder
export TB_TOP := $(DESIGN_TOP)_tb
export FORMAL_TOP := $(DESIGN_TOP)_formal
export DUT_INSTANCE := $(TB_TOP)/lsb_4/dut

export FLOW_CONFIG_ROOT := $(MODULE_ROOT)/flows
export RTL_FILELIST := $(call resolve_filelist,rtl.f)
export TB_FILELIST := $(call resolve_filelist,tb.f)
export FORMAL_FILELIST := $(call resolve_filelist,formal.f)
export VERILATOR_WAIVER_FILE := $(FLOW_CONFIG_ROOT)/verilator_lint/waivers.vlt
export VERIBLE_WAIVER_FILE := $(FLOW_CONFIG_ROOT)/verible/waivers.txt
export VERIBLE_RULES_FILE := $(FLOW_CONFIG_ROOT)/verible/rules
export FORMAL_CONFIG := $(call resolve_flow_config,symbiyosys,formal.sby)
export EQUIVALENCE_CONFIG := $(call resolve_flow_config,eqy,equivalence.eqy)
export OPENROAD_CONFIG := $(call resolve_flow_config,openroad,config.mk)
export SYNTHESIS_CONSTRAINT_FILE := $(call resolve_flow_config,synthesis,timing.sdc)
export ASYNC_SYNTHESIS_CONSTRAINT_FILE :=
export OPENROAD_CONSTRAINT_FILE := $(SYNTHESIS_CONSTRAINT_FILE)
export CDC_CONFIG := $(call resolve_flow_config,cdc,constraints.tcl)
export DFT_CONFIG := $(call resolve_flow_config,sg_dft,constraints.tcl)
export UPF_CONFIG := $(call resolve_flow_config,vc_lp,power.upf)
export CONSTRAINT_DIR := $(FLOW_CONFIG_ROOT)/synthesis
export ASSERTION_COVERAGE_SCRIPT := $(MODULE_ROOT)/verif/tb/assertion_coverage/run_assertion_coverage.sh
export ASSERTION_COVERPOINT_REQUIREMENTS := no_request_covered=16 valid_request_covered=16 single_request_covered=16 lowest_request_selected_covered=16 highest_request_selected_covered=16 multiple_requests_covered=14
# Verilator merges all parameter elaborations into one LCOV source record. Port
# toggles that are constant at WIDTH=1 and inactive static-priority alternatives
# are therefore structurally unreachable. Both alternatives remain required by
# named coverpoints, simulation, and formal proof.
export ASSERTION_COVERAGE_EXCLUDED_RTL_LINES := 10 11 13 17 18 20 21 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51
export FORMAL_COVERAGE_CONFIG :=
export CONSTRAINT_CHECK_SCRIPT := $(MODULE_ROOT)/verif/static/run_priority_encoder_constraint_check.sh
export FAULT_INJECTION_SCRIPT :=
export FOUR_STATE_CHECK_SCRIPT :=
export RELEASE_MANIFEST_SCRIPT := $(MODULE_ROOT)/scripts/generate-release-manifest.sh
export RELEASE_EVIDENCE_GATES := constraint_check assertion_coverage
export REPORT_DIR := $(MODULE_ROOT)/reports/$(MODULE)
export WORK_DIR := $(MODULE_ROOT)/work/$(MODULE)
export OPENROAD_PLATFORM ?= nangate45
export TECH_SETUP_TCL ?=
export TARGET_LIBRARY ?=
export LINK_LIBRARY ?=
export OPERATING_CONDITION ?=
export ACTIVITY_FILE ?=$(WORK_DIR)/vcs_sim/$(DESIGN_TOP).saif
