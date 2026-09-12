SHELL := /usr/bin/env bash

export MODULE_ROOT := $(CURDIR)
export FLOW_ROOT ?= $(abspath $(MODULE_ROOT)/mosaic-flow)

# Compatibility aliases preserve the existing module configuration syntax while
# delegating resolution to the shared project API below.
resolve_filelist = $(call mosaic_resolve_filelist,$(1))
resolve_flow_config = $(call mosaic_resolve_flow_config,$(1),$(2))

include $(FLOW_ROOT)/mk/project.mk
