`timescale 1ns / 1ps

/// Stable boundary used to bind functional coverage to every mux instance.
module mux_coverage_bind #(
    parameter int unsigned NUM_INPUTS = 2,
    parameter int unsigned DATA_WIDTH = 32,
    parameter logic [DATA_WIDTH-1:0] DEFAULT_VALUE = '0,
    parameter int unsigned SEL_WIDTH = (NUM_INPUTS > 1) ? $clog2(NUM_INPUTS) : 1
) (
    input logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] i_data,
    input logic [ SEL_WIDTH-1:0]                 i_select,
    input logic [DATA_WIDTH-1:0]                 o_data,
    input logic                                  o_select_valid
);

    mux_coverage #(
        .NUM_INPUTS   (NUM_INPUTS),
        .DATA_WIDTH   (DATA_WIDTH),
        .DEFAULT_VALUE(DEFAULT_VALUE),
        .SEL_WIDTH    (SEL_WIDTH)
    ) i_mux_coverage (
        .*
    );

endmodule

`ifndef MOSAIC_FORMAL
bind mux mux_coverage_bind #(
    .NUM_INPUTS   (NUM_INPUTS),
    .DATA_WIDTH   (DATA_WIDTH),
    .DEFAULT_VALUE(DEFAULT_VALUE),
    .SEL_WIDTH    (SEL_WIDTH)
) i_mux_coverage_bind (.*);
`endif
