# Combinational mux timing intent.
set_input_transition 0.1 [all_inputs]
set_load 0.01 [all_outputs]
set_max_delay 5.0 -from [all_inputs] -to [all_outputs]
set_max_delay 4.0 -from [get_ports i_select*] -to [all_outputs]
set_max_delay 5.0 -from [get_ports i_data*] -to [get_ports o_data*]
