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
export CDC_CONFIG := $(call resolve_flow_config,cdc,constraints.tcl)
export DFT_CONFIG := $(call resolve_flow_config,sg_dft,constraints.tcl)
export UPF_CONFIG := $(call resolve_flow_config,vc_lp,power.upf)
export CONSTRAINT_DIR := $(MODULE_ROOT)/flows/synthesis

# Advanced release campaigns will be enabled as their counter-specific
# implementations are qualified. Base lint, simulation, synthesis, formal, and
# equivalence remain mandatory through the flow policy.
export ASSERTION_COVERAGE_SCRIPT :=
export CONSTRAINT_CHECK_SCRIPT :=
export FAULT_INJECTION_SCRIPT :=
export RELEASE_MANIFEST_SCRIPT := $(MODULE_ROOT)/scripts/generate-release-manifest.sh
export RELEASE_EVIDENCE_GATES :=

export REPORT_DIR := $(MODULE_ROOT)/reports/$(MODULE)
export WORK_DIR := $(MODULE_ROOT)/work/$(MODULE)
export OPENROAD_PLATFORM ?= nangate45

export TECH_SETUP_TCL ?=
export TARGET_LIBRARY ?=
export LINK_LIBRARY ?=
export OPERATING_CONDITION ?=
export ACTIVITY_FILE ?=$(WORK_DIR)/vcs_sim/$(DESIGN_TOP).saif
