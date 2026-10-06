# Baseline exploratory setup retained for optional physical experiments.
# OpenROAD is disabled in the reviewed DFF release policy.
export DESIGN_NAME = dff
export PLATFORM = $(OPENROAD_PLATFORM)
export VERILOG_FILES = $(REPO_ROOT)/rtl/dff.sv
export SDC_FILE = $(REPO_ROOT)/flows/openroad/timing.sdc

# Conservative defaults for this small sequential primitive; they are not
# technology-qualified signoff targets.
export CORE_UTILIZATION = 35
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2
