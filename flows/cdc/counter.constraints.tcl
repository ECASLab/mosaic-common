# The counter has one functional clock and does not implement synchronization.
create_clock -name i_clk -period 10 [get_ports i_clk]
