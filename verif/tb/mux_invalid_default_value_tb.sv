`timescale 1ns / 1ps

/// Negative elaboration fixture for an unknown DEFAULT_VALUE bit.
module mux_invalid_default_value_tb;
    logic [2:0][3:0] i_data;
    logic [1:0] i_select;
    logic [3:0] o_data;
    logic o_select_valid;

    mux #(
        .NUM_INPUTS   (3),
        .DATA_WIDTH   (4),
        .DEFAULT_VALUE(4'b0x01)
    ) dut (
        .*
    );
endmodule
