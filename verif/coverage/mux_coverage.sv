`timescale 1ns / 1ps

/// Functional coverage for the mux's combinational contract.
module mux_coverage #(
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

    always_comb begin
        legal_selection :
        cover (({1'b0, i_select} < (SEL_WIDTH + 1)'(NUM_INPUTS)) && o_select_valid);
        first_selection : cover ((i_select == '0) && o_select_valid && (o_data == i_data[0]));
        last_selection :
        cover ((i_select == SEL_WIDTH'(NUM_INPUTS - 1)) && o_select_valid &&
               (o_data == i_data[NUM_INPUTS-1]));
        selected_zero : cover (o_select_valid && (i_data[i_select] == '0) && (o_data == '0));
        selected_all_ones : cover (o_select_valid && (i_data[i_select] == '1) && (o_data == '1));
    end

    if (NUM_INPUTS > 1) begin : g_distinct_inputs
        always_comb begin
            distinct_input_values : cover (o_select_valid && (i_data[0] != i_data[NUM_INPUTS-1]));
        end
    end

    if ((64'(1) << SEL_WIDTH) > longint'(NUM_INPUTS)) begin : g_invalid_encoding
        always_comb begin
            invalid_selection :
            cover (({1'b0, i_select} >= (SEL_WIDTH + 1)'(NUM_INPUTS)) &&
                   (o_data == DEFAULT_VALUE) && !o_select_valid);
        end
    end

endmodule
