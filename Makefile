SHELL := /usr/bin/env bash

MODULE ?= dff
TARGET ?= open-source

export MODULE_ROOT := $(CURDIR)
export FLOW_ROOT ?= $(abspath $(MODULE_ROOT)/mosaic-flow)

include config/design.mk
include $(FLOW_ROOT)/config/tools.mk
include $(FLOW_ROOT)/mk/module.mk

.PHONY: all-modules

## all-modules Run TARGET for every registered module in parallel
all-modules:
	+@python3 -c 'import json; print("\n".join(item["name"] for item in json.load(open(".github/modules.json"))["include"]))' | \
		xargs --no-run-if-empty --replace={} --max-procs="$${JOBS:-0}" \
		$(MAKE) --no-print-directory -f "$(firstword $(MAKEFILE_LIST))" MODULE={} "$(TARGET)"
