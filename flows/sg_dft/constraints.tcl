# DFT is disabled for this primitive release and remains an integration concern.
# Qualify these commands against the selected SpyGlass DFT release if enabled.
#
# clock -name i_clk -period 10 [get_ports i_clk]
# reset -name i_rstb -value 0 [get_ports i_rstb]
#
# Scan insertion is external to this functional primitive. The flow must verify
# that i_enable does not block scan replacement and that i_rstb is controllable in
# test mode. No internal clock or direct scan port is permitted in mosaic_dff.
