create_clock -name source_clk -period 10.0 [get_ports i_clk]
create_generated_clock -name gated_clk -source [get_ports i_clk] -combinational [get_ports o_gclk]
set_clock_uncertainty 0.1 [get_clocks source_clk]
set_input_delay 0.5 -clock source_clk [get_ports {i_enable i_test_enable}]
