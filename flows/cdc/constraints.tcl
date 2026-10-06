# CDC is disabled for the DFF release. Retain this integration intent for a
# consuming design that elects to run CDC analysis.
# MOSAIC DFF has one functional clock domain. This intent must be translated to
# the exact command dialect of the qualified VC CDC or SpyGlass CDC release.
#
# clock -name i_clk -period 10 [get_ports i_clk]
# reset -name i_rstb -value 0 [get_ports i_rstb]
#
# i_d and i_enable are required to be synchronous to i_clk. dff is not a
# synchronizer and must not receive a blanket synchronizer waiver.
