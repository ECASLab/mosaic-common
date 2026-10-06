`timescale 1ns / 1ps

/// Deliberately faulty mux used only to qualify the regression.
module mux #(
    parameter int unsigned NUM_INPUTS = 2,
    parameter int unsigned DATA_WIDTH = 32,
    parameter logic [DATA_WIDTH-1:0] DEFAULT_VALUE = '0,
    parameter int unsigned SEL_WIDTH = (NUM_INPUTS > 1) ? $clog2(NUM_INPUTS) : 1
) (
    input  logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] i_data,
    input  logic [ SEL_WIDTH-1:0]                 i_select,
    output logic [DATA_WIDTH-1:0]                 o_data,
    output logic                                  o_select_valid
);

    always_comb begin
        o_data = DEFAULT_VALUE;
        o_select_valid = 1'b0;
        if ({1'b0, i_select} < (SEL_WIDTH + 1)'(NUM_INPUTS)) begin
            o_data = i_data[i_select];
            o_select_valid = 1'b0;
        end
    end

endmodule
