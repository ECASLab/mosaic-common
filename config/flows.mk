# Keep flow policy separate from design identity so each module can approve its
# own required and optional checks.
# This legacy fallback is reached only by selection-free administrative targets.
# Selected modules use config/modules/<name>-flows.mk through project.mk.
ifneq ($(strip $(MODULE)),)
MODULE_FLOW_CONFIG := $(MODULE_ROOT)/config/modules/$(MODULE)-flows.mk

ifeq ($(wildcard $(MODULE_FLOW_CONFIG)),)
$(error Missing flow policy for MODULE '$(MODULE)': $(MODULE_FLOW_CONFIG))
endif

include $(MODULE_FLOW_CONFIG)
endif
