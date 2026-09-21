`timescale 1ns / 1ps

/// Negative elaboration fixture for an overridden, inconsistent select width.
module decoder_invalid_select_width_tb;
    logic i_enable;
    logic [2:0] i_select;
    logic [3:0] o_decoded;
    logic o_select_valid;

    decoder #(
        .NUM_OUTPUTS (4),
        .SELECT_WIDTH(3)
    ) dut (
        .*
    );
endmodule
