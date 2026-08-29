# Select one lightweight module profile while keeping source trees at repo root.
MODULE_DESIGN_CONFIG := $(MODULE_ROOT)/config/modules/$(MODULE).mk

ifeq ($(wildcard $(MODULE_DESIGN_CONFIG)),)
$(error Unknown MODULE '$(MODULE)'; expected $(MODULE_DESIGN_CONFIG))
endif

# The selected profile owns tops, file lists, tool inputs, and output locations.
include $(MODULE_DESIGN_CONFIG)
