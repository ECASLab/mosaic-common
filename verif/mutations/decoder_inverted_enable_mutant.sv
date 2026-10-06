`timescale 1ns / 1ps

/// Deliberately faulty decoder used only to qualify the regression.
module decoder #(
    parameter int unsigned NUM_OUTPUTS  = 4,
    parameter int unsigned SELECT_WIDTH = (NUM_OUTPUTS > 1) ? $clog2(NUM_OUTPUTS) : 1
) (
    input  logic                    i_enable,
    input  logic [SELECT_WIDTH-1:0] i_select,
    output logic [ NUM_OUTPUTS-1:0] o_decoded,
    output logic                    o_select_valid
);

    always_comb begin
        o_decoded = '0;
        o_select_valid = 1'b0;
        if (!i_enable && ({1'b0, i_select} < (SELECT_WIDTH + 1)'(NUM_OUTPUTS))) begin
            o_decoded[i_select] = 1'b1;
            o_select_valid = 1'b1;
        end
    end

endmodule
