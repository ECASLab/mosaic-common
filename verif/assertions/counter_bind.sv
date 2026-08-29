// Attach a parameter-matched contract to every counter instance.
bind counter counter_sva #(
    .WIDTH(WIDTH),
    .RESET_VALUE(RESET_VALUE),
    .ASYNC_RESET(ASYNC_RESET),
    .SATURATE(SATURATE)
) i_counter_sva (.*);
