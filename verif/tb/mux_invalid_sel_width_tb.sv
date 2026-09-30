`timescale 1ns / 1ps

/// Negative elaboration fixture for an overridden, inconsistent select width.
module mux_invalid_sel_width_tb;
    logic [3:0][7:0] i_data;
    logic [2:0] i_select;
    logic [7:0] o_data;
    logic o_select_valid;

    mux #(
        .NUM_INPUTS(4),
        .DATA_WIDTH(8),
        .SEL_WIDTH (3)
    ) dut (
        .*
    );
endmodule
