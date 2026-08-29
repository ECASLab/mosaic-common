# Keep flow policy separate from design identity so each module can approve its
# own required and optional checks.
MODULE_FLOW_CONFIG := $(MODULE_ROOT)/config/modules/$(MODULE)-flows.mk

ifeq ($(wildcard $(MODULE_FLOW_CONFIG)),)
$(error Missing flow policy for MODULE '$(MODULE)': $(MODULE_FLOW_CONFIG))
endif

# mosaic-flow loads this file after shared defaults, so module values override
# the methodology defaults deliberately.
include $(MODULE_FLOW_CONFIG)
