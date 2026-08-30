# Clock-gate CDC intent. Qualify these commands against the selected VC CDC or
# SpyGlass CDC release before enabling the commercial adapter.
create_clock -name source_clk -period 10 [get_ports i_clk]
create_generated_clock -name gated_clk -source [get_ports i_clk] [get_ports o_gclk]

# i_enable must be synchronous to source_clk or satisfy an approved clock-gating
# control protocol. i_test_enable is a DFT control and must remain stable across
# scan clock activity. Neither input is a generic asynchronous CDC synchronizer.
