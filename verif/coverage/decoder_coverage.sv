`timescale 1ns / 1ps

/// Functional coverage for the decoder's combinational contract.
module decoder_coverage #(
    parameter int unsigned NUM_OUTPUTS  = 4,
    parameter int unsigned SELECT_WIDTH = (NUM_OUTPUTS > 1) ? $clog2(NUM_OUTPUTS) : 1
) (
    input logic                    i_enable,
    input logic [SELECT_WIDTH-1:0] i_select,
    input logic [ NUM_OUTPUTS-1:0] o_decoded,
    input logic                    o_select_valid
);

    always_comb begin
        disabled_operation : cover (!i_enable && (o_decoded == '0) && !o_select_valid);
        enabled_legal :
        cover (i_enable && ({1'b0, i_select} < (SELECT_WIDTH + 1)'(NUM_OUTPUTS)) && o_select_valid);
        first_selection : cover (i_enable && (i_select == '0) && o_decoded[0]);
        last_selection :
        cover (i_enable && (i_select == SELECT_WIDTH'(NUM_OUTPUTS - 1)) &&
               o_decoded[NUM_OUTPUTS-1]);
        any_output_selected : cover (o_select_valid && (|o_decoded));
    end

    if ((64'(1) << SELECT_WIDTH) > longint'(NUM_OUTPUTS)) begin : g_invalid_encoding
        always_comb begin
            invalid_selection :
            cover (i_enable && ({1'b0, i_select} >= (SELECT_WIDTH + 1)'(NUM_OUTPUTS)) &&
                   (o_decoded == '0) && !o_select_valid);
        end
    end

endmodule
