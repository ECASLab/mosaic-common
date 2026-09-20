# Exploratory physical setup for the representative WIDTH=2 write gate.
export DESIGN_NAME = write_gate
export PLATFORM = $(OPENROAD_PLATFORM)
export VERILOG_FILES = $(REPO_ROOT)/rtl/write_gate.sv
export VERILOG_TOP_PARAMS = WIDTH 2
export SDC_FILE = $(SYNTHESIS_CONSTRAINT_FILE)

# The leaf is smaller than the default Nangate45 PDN strap pitch.
export DIE_AREA = 0 0 60 60
export CORE_AREA = 5 5 55 55
export SKIP_CTS_REPAIR_TIMING = 1
