# Technology-independent interface assumptions for the combinational leaf.
set_input_transition 0.100 [all_inputs]
set_load 0.010 [all_outputs]

# Preserve a complete interface budget for portable static-intent validation.
set_max_delay 10.000 -from [all_inputs] -to [all_outputs]

# Keep each architecturally relevant control path visible in timing reports.
set_max_delay 10.000 \
    -from [get_ports i_write_enable*] \
    -to [get_ports o_write_enable*]
set_max_delay 10.000 \
    -from [get_ports i_suppress*] \
    -to [get_ports o_write_enable*]
set_max_delay 10.000 \
    -from [get_ports {i_write_enable* i_suppress*}] \
    -to [get_ports o_write_suppressed*]
