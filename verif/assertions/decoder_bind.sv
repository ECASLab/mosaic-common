`timescale 1ns / 1ps

/// Stable boundary used to bind checks to every decoder instance.
module decoder_bind #(
    parameter int unsigned NUM_OUTPUTS  = 4,
    parameter int unsigned SELECT_WIDTH = (NUM_OUTPUTS > 1) ? $clog2(NUM_OUTPUTS) : 1
) (
    input logic                    i_enable,
    input logic [SELECT_WIDTH-1:0] i_select,
    input logic [ NUM_OUTPUTS-1:0] o_decoded,
    input logic                    o_select_valid
);

    decoder_sva #(
        .NUM_OUTPUTS (NUM_OUTPUTS),
        .SELECT_WIDTH(SELECT_WIDTH)
    ) i_decoder_sva (
        .*
    );

endmodule

`ifndef MOSAIC_FORMAL
bind decoder decoder_bind #(
    .NUM_OUTPUTS (NUM_OUTPUTS),
    .SELECT_WIDTH(SELECT_WIDTH)
) i_decoder_bind (.*);
`endif
