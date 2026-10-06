# Glitch-free clock-gate tops and design-owned flow inputs.
export DESIGN_TOP := clock_gate
export TB_TOP := $(DESIGN_TOP)_tb
export FORMAL_TOP := $(DESIGN_TOP)_formal
export DUT_INSTANCE := $(TB_TOP)/dut

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
export ASYNC_SYNTHESIS_CONSTRAINT_FILE :=
export OPENROAD_CONSTRAINT_FILE := $(SYNTHESIS_CONSTRAINT_FILE)
export CDC_CONFIG := $(call resolve_flow_config,cdc,constraints.tcl)
export DFT_CONFIG := $(call resolve_flow_config,sg_dft,constraints.tcl)
export UPF_CONFIG := $(call resolve_flow_config,vc_lp,power.upf)
export CONSTRAINT_DIR := $(MODULE_ROOT)/flows/synthesis
export ASSERTION_COVERAGE_SCRIPT := $(MODULE_ROOT)/verif/tb/assertion_coverage/run_assertion_coverage.sh
export ASSERTION_COVERPOINT_REQUIREMENTS := functional_enable_covered=1 test_enable_covered=1 both_enables_covered=1 disabled_covered=1
export ASSERTION_COVERAGE_EXCLUDED_RTL_LINES :=
export FORMAL_COVERAGE_CONFIG :=
export CONSTRAINT_CHECK_SCRIPT := $(MODULE_ROOT)/verif/static/run_clock_gate_constraint_check.sh
export FAULT_INJECTION_SCRIPT := $(MODULE_ROOT)/verif/tb/fault_injection/run_clock_gate_fault_injection.sh
export OPENROAD_CONTAINER_SCRIPT := $(MODULE_ROOT)/scripts/run-openroad-container.sh
export RELEASE_MANIFEST_SCRIPT := $(MODULE_ROOT)/scripts/generate-release-manifest.sh
export RELEASE_EVIDENCE_GATES := constraint_check assertion_coverage fault_injection

export REPORT_DIR := $(MODULE_ROOT)/reports/$(MODULE)
export WORK_DIR := $(MODULE_ROOT)/work/$(MODULE)
export OPENROAD_PLATFORM ?= nangate45
export OPENROAD_FLOW_VARIANT ?= clock_gate_release

export TECH_SETUP_TCL ?=
export TARGET_LIBRARY ?=
export LINK_LIBRARY ?=
export OPERATING_CONDITION ?=
export ACTIVITY_FILE ?=$(WORK_DIR)/vcs_sim/$(DESIGN_TOP).saif
