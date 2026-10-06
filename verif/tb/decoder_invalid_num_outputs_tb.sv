`timescale 1ns / 1ps

/// Negative elaboration fixture for NUM_OUTPUTS=0.
module decoder_invalid_num_outputs_tb;
    logic i_enable;
    logic i_select;
    logic [1:0] o_decoded;
    logic o_select_valid;

    decoder #(.NUM_OUTPUTS(0)) dut (.*);
endmodule
