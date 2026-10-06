# Translate this intent to the qualified VC CDC or SpyGlass CDC command dialect.
# i_async_rstb is asynchronous to i_clk and is permitted to release only through
# the ASYNC_REG-marked synchronization chain. Intermediate stages may not fan out.
#
# clock -name i_clk -period 10 [get_ports i_clk]
# reset -name i_async_rstb -value 0 [get_ports i_async_rstb]
# synchronize -type reset -from i_async_rstb -to o_rstb
