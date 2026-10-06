# Reset synchronizer tops and design-owned flow inputs.
export DESIGN_TOP := reset_synchronizer
export TB_TOP := $(DESIGN_TOP)_tb
export FORMAL_TOP := $(DESIGN_TOP)_formal
export DUT_INSTANCE := $(TB_TOP)/checker_stages_2/dut

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
export ASSERTION_COVERPOINT_REQUIREMENTS := reset_asserted_covered=3 release_progress_covered=3 release_complete_covered=3 reassert_during_release_covered=3
export ASSERTION_COVERAGE_EXCLUDED_RTL_LINES :=
export FORMAL_COVERAGE_CONFIG :=
export CONSTRAINT_CHECK_SCRIPT := $(MODULE_ROOT)/verif/static/run_reset_synchronizer_constraint_check.sh
export FAULT_INJECTION_SCRIPT := $(MODULE_ROOT)/verif/tb/fault_injection/run_reset_synchronizer_fault_injection.sh
export FOUR_STATE_CHECK_SCRIPT := $(MODULE_ROOT)/verif/tb/four_state/run_reset_synchronizer_four_state.sh
export RELEASE_MANIFEST_SCRIPT := $(MODULE_ROOT)/scripts/generate-release-manifest.sh
export RELEASE_EVIDENCE_GATES := constraint_check assertion_coverage fault_injection four_state_check

export REPORT_DIR := $(MODULE_ROOT)/reports/$(MODULE)
export WORK_DIR := $(MODULE_ROOT)/work/$(MODULE)
export OPENROAD_PLATFORM ?= nangate45

export TECH_SETUP_TCL ?=
export TARGET_LIBRARY ?=
export LINK_LIBRARY ?=
export OPERATING_CONDITION ?=
export ACTIVITY_FILE ?=$(WORK_DIR)/vcs_sim/$(DESIGN_TOP).saif
