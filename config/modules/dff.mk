# DFF tops used by synthesis, simulation, and formal verification.
export DESIGN_TOP := dff
export TB_TOP := $(DESIGN_TOP)_tb
export FORMAL_TOP := $(DESIGN_TOP)_formal
export DUT_INSTANCE := $(TB_TOP)/checker_async_scalar/dut

# Tool adapters consume design-owned inputs through these canonical paths.
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
export ASYNC_SYNTHESIS_CONSTRAINT_FILE := $(call resolve_flow_config,synthesis,timing_async.sdc)
export OPENROAD_CONSTRAINT_FILE := $(FLOW_CONFIG_ROOT)/openroad/timing.sdc
export CDC_CONFIG := $(call resolve_flow_config,cdc,constraints.tcl)
export DFT_CONFIG := $(call resolve_flow_config,sg_dft,constraints.tcl)
export UPF_CONFIG := $(call resolve_flow_config,vc_lp,power.upf)
export CONSTRAINT_DIR := $(FLOW_CONFIG_ROOT)/synthesis
export ASSERTION_COVERAGE_SCRIPT := $(MODULE_ROOT)/verif/tb/assertion_coverage/run_assertion_coverage.sh
export ASSERTION_COVERPOINT_REQUIREMENTS := reset_covered=7 reset_priority_covered=7 enabled_capture_covered=5 hold_covered=5 always_capture_covered=2 async_reset_covered=3
export ASSERTION_COVERAGE_EXCLUDED_RTL_LINES :=
export FORMAL_COVERAGE_CONFIG :=
export CONSTRAINT_CHECK_SCRIPT := $(MODULE_ROOT)/verif/static/run_constraint_check.sh
export FAULT_INJECTION_SCRIPT := $(MODULE_ROOT)/verif/tb/fault_injection/run_fault_injection.sh
export RELEASE_MANIFEST_SCRIPT := $(MODULE_ROOT)/scripts/generate-release-manifest.sh
export RELEASE_EVIDENCE_GATES := constraint_check assertion_coverage fault_injection

# Per-module roots prevent concurrent jobs from overwriting one another.
export REPORT_DIR := $(MODULE_ROOT)/reports/$(MODULE)
export WORK_DIR := $(MODULE_ROOT)/work/$(MODULE)
export OPENROAD_PLATFORM ?= nangate45

# Technology and activity inputs are site-owned and must remain untracked.
export TECH_SETUP_TCL ?=
export TARGET_LIBRARY ?=
export LINK_LIBRARY ?=
export OPERATING_CONDITION ?=
export ACTIVITY_FILE ?=$(WORK_DIR)/vcs_sim/$(DESIGN_TOP).saif
