# Default synchronous-reset 100 MHz counter budget.
create_clock -name i_clk -period 10.000 [get_ports i_clk]
set_clock_uncertainty 0.100 [get_clocks i_clk]
set_input_delay 0.500 -clock i_clk [remove_from_collection [all_inputs] [get_ports i_clk]]
set_output_delay 0.500 -clock i_clk [all_outputs]
