// Attach the same parameter-matched contract to every dff instance.
bind dff dff_sva #(
    .WIDTH      (WIDTH),
    .RESET_VALUE(RESET_VALUE),
    .ASYNC_RESET(ASYNC_RESET),
    .HAS_ENABLE (HAS_ENABLE)
) i_dff_sva (.*);
