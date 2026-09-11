create_clock -name i_clk -period 10.0 [get_ports i_clk]
set_input_delay 1.0 -clock i_clk [remove_from_collection [all_inputs] [get_ports i_clk]]
set_output_delay 1.0 -clock i_clk [all_outputs]
