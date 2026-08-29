SHELL := /usr/bin/env bash

MODULE ?= dff
TARGET ?= open-source

export MODULE_ROOT := $(CURDIR)
export FLOW_ROOT ?= $(abspath $(MODULE_ROOT)/mosaic-flow)

include config/design.mk
include $(FLOW_ROOT)/config/tools.mk
include $(FLOW_ROOT)/mk/module.mk

.PHONY: all-modules assertion-coverage constraint-check fault-injection release-manifest

## all-modules Run TARGET for every registered module in parallel
all-modules:
	+@python3 -c 'import json; print("\n".join(item["name"] for item in json.load(open(".github/modules.json"))["include"]))' | \
		xargs --no-run-if-empty --replace={} --max-procs="$${JOBS:-0}" \
		$(MAKE) --no-print-directory -f "$(firstword $(MAKEFILE_LIST))" MODULE={} "$(TARGET)"

## assertion-coverage Prove that every required assertion antecedent is exercised
assertion-coverage:
	@"$(ASSERTION_COVERAGE_SCRIPT)"

## constraint-check Validate synchronous and asynchronous SDC intent
constraint-check:
	@"$(CONSTRAINT_CHECK_SCRIPT)"

## fault-injection Prove that the verification environment detects known mutations
fault-injection:
	@"$(FAULT_INJECTION_SCRIPT)"

## release-manifest Validate and index the module's release evidence
release-manifest:
	@"$(RELEASE_MANIFEST_SCRIPT)"
