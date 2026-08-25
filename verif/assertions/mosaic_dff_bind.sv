// Attach the same parameter-matched contract to every mosaic_dff instance.
bind mosaic_dff mosaic_dff_sva #(
    .WIDTH      (WIDTH),
    .RESET_VALUE(RESET_VALUE),
    .ASYNC_RESET(ASYNC_RESET),
    .HAS_ENABLE (HAS_ENABLE)
) i_mosaic_dff_sva (.*);
