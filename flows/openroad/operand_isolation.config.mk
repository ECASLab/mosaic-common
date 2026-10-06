# Exploratory physical setup for a representative WIDTH=16 pattern clamp.
export DESIGN_NAME = operand_isolation
export PLATFORM = $(OPENROAD_PLATFORM)
export VERILOG_FILES = $(REPO_ROOT)/rtl/operand_isolation.sv
export VERILOG_TOP_PARAMS = WIDTH 16 CLAMP_VALUE 16'ha55a
export SDC_FILE = $(OPENROAD_CONSTRAINT_FILE)

# The leaf is smaller than the default Nangate45 PDN strap pitch.
export DIE_AREA = 0 0 60 60
export CORE_AREA = 5 5 55 55
export SKIP_CTS_REPAIR_TIMING = 1
