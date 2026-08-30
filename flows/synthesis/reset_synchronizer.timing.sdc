create_clock -name destination_clk -period 10.0 [get_ports i_clk]
set_clock_uncertainty 0.1 [get_clocks destination_clk]

# The raw reset is intentionally asynchronous. Do not false-path stage-to-stage
# data arcs or suppress recovery/removal analysis on the synchronization chain.
set_output_delay 0.5 -clock destination_clk [get_ports o_rstb]
