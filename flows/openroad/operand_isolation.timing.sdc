# Match the synthesis assumptions for exploratory physical runs.
set_input_transition 0.100 [all_inputs]
set_load 0.010 [all_outputs]

set_max_delay 10.000 -from [all_inputs] -to [all_outputs]
set_max_delay 10.000 \
    -from [get_ports i_data*] \
    -to [get_ports o_data*]
set_max_delay 10.000 \
    -from [get_ports i_isolate] \
    -to [get_ports o_data*]
