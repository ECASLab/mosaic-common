`timescale 1ns / 1ps

/// Negative elaboration fixture for NUM_INPUTS=0.
module mux_invalid_num_inputs_tb;
    logic [1:0][7:0] i_data;
    logic i_select;
    logic [7:0] o_data;
    logic o_select_valid;

    mux #(
        .NUM_INPUTS(0),
        .DATA_WIDTH(8)
    ) dut (
        .*
    );
endmodule
