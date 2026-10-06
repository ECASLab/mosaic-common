`timescale 1ns / 1ps

/// Negative elaboration fixture for DATA_WIDTH=0.
module mux_invalid_data_width_tb;
    logic [1:0] i_data;
    logic i_select;
    logic [1:0] o_data;
    logic o_select_valid;

    mux #(
        .NUM_INPUTS(2),
        .DATA_WIDTH(0)
    ) dut (
        .*
    );
endmodule
