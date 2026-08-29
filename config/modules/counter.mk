# Counter tops and design-owned flow inputs.
export DESIGN_TOP := counter
export TB_TOP := $(DESIGN_TOP)_tb
export FORMAL_TOP := $(DESIGN_TOP)_formal
export DUT_INSTANCE := $(TB_TOP)/checker_async_sat/dut

export RTL_FILELIST := $(call resolve_filelist,rtl.f)
export TB_FILELIST := $(call resolve_filelist,tb.f)
export FORMAL_FILELIST := $(call resolve_filelist,formal.f)
export VERILATOR_WAIVER_FILE := $(MODULE_ROOT)/flows/verilator_lint/waivers.vlt
export VERIBLE_WAIVER_FILE := $(MODULE_ROOT)/flows/verible/waivers.txt
export VERIBLE_RULES_FILE := $(MODULE_ROOT)/flows/verible/rules
export FORMAL_CONFIG := $(call resolve_flow_config,symbiyosys,formal.sby)
export EQUIVALENCE_CONFIG := $(call resolve_flow_config,eqy,equivalence.eqy)
export OPENROAD_CONFIG := $(call resolve_flow_config,openroad,config.mk)
export SYNTHESIS_CONSTRAINT_FILE := $(call resolve_flow_config,synthesis,timing.sdc)
export ASYNC_SYNTHESIS_CONSTRAINT_FILE := $(call resolve_flow_config,synthesis,timing_async.sdc)
export OPENROAD_CONSTRAINT_FILE := $(SYNTHESIS_CONSTRAINT_FILE)
export CDC_CONFIG := $(call resolve_flow_config,cdc,constraints.tcl)
export DFT_CONFIG := $(call resolve_flow_config,sg_dft,constraints.tcl)
export UPF_CONFIG := $(call resolve_flow_config,vc_lp,power.upf)
export CONSTRAINT_DIR := $(MODULE_ROOT)/flows/synthesis

# Constraint intent, assertion coverage, and fault injection are required
# release evidence for the counter.
export ASSERTION_COVERAGE_SCRIPT := $(MODULE_ROOT)/verif/tb/assertion_coverage/run_assertion_coverage.sh
export ASSERTION_COVERPOINT_REQUIREMENTS := reset_covered=8 clear_covered=8 clear_priority_covered=8 load_covered=8 load_priority_covered=8 increment_covered=8 decrement_covered=8 hold_covered=8 overflow_covered=8 underflow_covered=8
export ASSERTION_COVERAGE_EXCLUDED_RTL_LINES := 35 57 64 89 96
export FORMAL_COVERAGE_CONFIG := $(MODULE_ROOT)/flows/symbiyosys/counter.cover.sby
export CONSTRAINT_CHECK_SCRIPT := $(MODULE_ROOT)/verif/static/run_constraint_check.sh
export FAULT_INJECTION_SCRIPT := $(MODULE_ROOT)/verif/tb/fault_injection/run_counter_fault_injection.sh
export RELEASE_MANIFEST_SCRIPT := $(MODULE_ROOT)/scripts/generate-release-manifest.sh
export RELEASE_EVIDENCE_GATES := constraint_check assertion_coverage fault_injection

export REPORT_DIR := $(MODULE_ROOT)/reports/$(MODULE)
export WORK_DIR := $(MODULE_ROOT)/work/$(MODULE)
export OPENROAD_PLATFORM ?= nangate45

export TECH_SETUP_TCL ?=
export TARGET_LIBRARY ?=
export LINK_LIBRARY ?=
export OPERATING_CONDITION ?=
export ACTIVITY_FILE ?=$(WORK_DIR)/vcs_sim/$(DESIGN_TOP).saif
