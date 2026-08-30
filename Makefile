SHELL := /usr/bin/env bash

MODULE ?= dff
TARGET ?= open-source

export MODULE_ROOT := $(CURDIR)
export FLOW_ROOT ?= $(abspath $(MODULE_ROOT)/mosaic-flow)

include config/design.mk
include $(FLOW_ROOT)/config/tools.mk
include $(FLOW_ROOT)/mk/module.mk

.PHONY: all-modules assertion-coverage constraint-check fault-injection four-state-check openroad-container release-manifest

## all-modules Run TARGET for every registered module in parallel
all-modules:
	+@python3 -c 'import json; print("\n".join(item["name"] for item in json.load(open(".github/modules.json"))["include"]))' | \
		xargs --no-run-if-empty --replace={} --max-procs="$${JOBS:-0}" \
		$(MAKE) --no-print-directory -f "$(firstword $(MAKEFILE_LIST))" MODULE={} "$(TARGET)"

## assertion-coverage Prove that every required assertion antecedent is exercised
assertion-coverage:
	@if [[ -n "$(ASSERTION_COVERAGE_SCRIPT)" ]]; then \
		"$(ASSERTION_COVERAGE_SCRIPT)"; \
	else \
		echo "No assertion-coverage campaign is configured for MODULE=$(MODULE)"; \
	fi

## constraint-check Validate synchronous and asynchronous SDC intent
constraint-check:
	@if [[ -n "$(CONSTRAINT_CHECK_SCRIPT)" ]]; then \
		"$(CONSTRAINT_CHECK_SCRIPT)"; \
	else \
		echo "No additional constraint-intent check is configured for MODULE=$(MODULE)"; \
	fi

## fault-injection Prove that the verification environment detects known mutations
fault-injection:
	@if [[ -n "$(FAULT_INJECTION_SCRIPT)" ]]; then \
		"$(FAULT_INJECTION_SCRIPT)"; \
	else \
		echo "No fault-injection campaign is configured for MODULE=$(MODULE)"; \
	fi

## four-state-check Demonstrate detection of unknown control inputs
four-state-check:
	@if [[ -n "$(FOUR_STATE_CHECK_SCRIPT)" ]]; then \
		"$(FOUR_STATE_CHECK_SCRIPT)"; \
	else \
		echo "No four-state input check is configured for MODULE=$(MODULE)"; \
	fi

## openroad-container Run the pinned ORFS image and validate physical evidence
openroad-container:
	@if [[ -n "$(OPENROAD_CONTAINER_SCRIPT)" ]]; then \
		"$(OPENROAD_CONTAINER_SCRIPT)"; \
	else \
		echo "No containerized OpenROAD flow is configured for MODULE=$(MODULE)"; \
	fi

## release-manifest Validate and index the module's release evidence
release-manifest:
	@"$(RELEASE_MANIFEST_SCRIPT)"
