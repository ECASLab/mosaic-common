# Baseline 100 MHz synthesis budget for technology qualification.
create_clock -name i_clk -period 10.000 [get_ports i_clk]
set_clock_uncertainty 0.100 [get_clocks i_clk]
set_input_delay 0.500 -clock i_clk [remove_from_collection [all_inputs] [get_ports {i_clk i_rstb}]]
set_output_delay 0.500 -clock i_clk [all_outputs]
# This exception models asynchronous reset assertion. Review and replace it when
# synthesizing the default synchronous-reset parameter profile.
set_false_path -from [get_ports i_rstb]
