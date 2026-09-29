`timescale 1ns / 1ps

/// Sampled transition coverage driven by the self-checking mux test.
module mux_transition_coverage #(
    parameter int unsigned NUM_INPUTS = 2,
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned SEL_WIDTH  = (NUM_INPUTS > 1) ? $clog2(NUM_INPUTS) : 1
) (
    input logic                                  i_sample,
    input logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] i_data,
    input logic [ SEL_WIDTH-1:0]                 i_select,
    input logic [DATA_WIDTH-1:0]                 o_data,
    input logic                                  o_select_valid
);

    localparam int unsigned NumEncodings = 1 << SEL_WIDTH;
    localparam int unsigned NumLegalTransitions = NUM_INPUTS * NUM_INPUTS;

    logic previous_sample_valid;
    logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] previous_data;
    logic [SEL_WIDTH-1:0] previous_select;
    logic [DATA_WIDTH-1:0] previous_output;
    logic previous_select_valid;
    logic [NumEncodings-1:0] observed_encodings;
    logic [NumEncodings-1:0] encodings_with_current;
    logic [NumLegalTransitions-1:0] observed_legal_transitions;
    logic [NumLegalTransitions-1:0] legal_transitions_with_current;

    function automatic logic selection_legal(input logic [SEL_WIDTH-1:0] select);
        selection_legal = {1'b0, select} < (SEL_WIDTH + 1)'(NUM_INPUTS);
    endfunction

    initial begin
        previous_sample_valid = 1'b0;
        previous_data = '0;
        previous_select = '0;
        previous_output = '0;
        previous_select_valid = 1'b0;
        observed_encodings = '0;
        observed_legal_transitions = '0;
    end

    always_comb begin
        encodings_with_current = observed_encodings;
        encodings_with_current[i_select] = 1'b1;

        legal_transitions_with_current = observed_legal_transitions;
        if (previous_sample_valid && previous_select_valid && o_select_valid) begin
            legal_transitions_with_current[
                (int'(previous_select) * NUM_INPUTS) + int'(i_select)
            ] = 1'b1;
        end
    end

    always @(posedge i_sample) begin
        all_selection_encodings : cover (&encodings_with_current);
        all_legal_selection_pairs : cover (&legal_transitions_with_current);

        if (previous_sample_valid) begin
            legal_selection_changed :
            cover (previous_select_valid && o_select_valid && (previous_select != i_select));
            selected_input_changed :
            cover (previous_select_valid && o_select_valid &&
                   (previous_select == i_select) &&
                   (previous_data[i_select] != i_data[i_select]) &&
                   (previous_output != o_data));
            unselected_input_changed :
            cover (previous_select_valid && o_select_valid &&
                   (previous_select == i_select) &&
                   (previous_data[i_select] == i_data[i_select]) &&
                   (previous_data != i_data) && (previous_output == o_data));
        end

        previous_sample_valid <= 1'b1;
        previous_data <= i_data;
        previous_select <= i_select;
        previous_output <= o_data;
        previous_select_valid <= o_select_valid;
        observed_encodings <= encodings_with_current;
        observed_legal_transitions <= legal_transitions_with_current;
    end

    if ((64'(1) << SEL_WIDTH) > longint'(NUM_INPUTS)) begin : g_invalid_transitions
        always @(posedge i_sample) begin
            if (previous_sample_valid) begin
                legal_to_invalid :
                cover (previous_select_valid && !o_select_valid && !selection_legal(i_select));
                invalid_to_legal :
                cover (!previous_select_valid && !selection_legal(
                    previous_select
                ) && o_select_valid);
            end
        end
    end

endmodule
