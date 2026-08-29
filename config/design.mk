# Select one lightweight module profile while keeping source trees at repo root.
MODULE_DESIGN_CONFIG := $(MODULE_ROOT)/config/modules/$(MODULE).mk

# Prefer module-specific flow collateral and fall back to the repository-wide
# default. Example: counter.formal.sby takes precedence over formal.sby.
resolve_flow_config = $(or $(wildcard $(MODULE_ROOT)/flows/$(1)/$(DESIGN_TOP).$(2)),$(MODULE_ROOT)/flows/$(1)/$(2))

# Apply the same module-first convention to source file lists. Example:
# counter.rtl.f takes precedence over the generic rtl.f.
resolve_filelist = $(or $(wildcard $(MODULE_ROOT)/filelists/$(DESIGN_TOP).$(1)),$(MODULE_ROOT)/filelists/$(1))

# Keep module-specific indentation reproducible while the shared Verible adapter
# checks every SystemVerilog source in the repository.
export VERIBLE_FORMAT_CMD := $(MODULE_ROOT)/scripts/verible-format

ifeq ($(wildcard $(MODULE_DESIGN_CONFIG)),)
$(error Unknown MODULE '$(MODULE)'; expected $(MODULE_DESIGN_CONFIG))
endif

# The selected profile owns tops, file lists, tool inputs, and output locations.
include $(MODULE_DESIGN_CONFIG)
