# Exploratory physical setup for the portable model. This configuration does
# not qualify mapping to an ASIC integrated clock-gating cell.
export DESIGN_NAME = clock_gate
export PLATFORM = $(OPENROAD_PLATFORM)
export VERILOG_FILES = $(REPO_ROOT)/rtl/clock_gate.sv
export SDC_FILE = $(SYNTHESIS_CONSTRAINT_FILE)

# The design is smaller than the default Nangate45 PDN strap pitch. Keep a
# fixed minimum outline so floorplanning and PDN generation remain repeatable.
export DIE_AREA = 0 0 60 60
export CORE_AREA = 5 5 55 55

# The block has one source-clock sink and no internal gated-clock sinks. CTS is
# retained, while its post-CTS repair pass is unnecessary for this leaf cell.
export SKIP_CTS_REPAIR_TIMING = 1
