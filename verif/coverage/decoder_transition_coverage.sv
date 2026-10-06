`timescale 1ns / 1ps

/// Sampled transition coverage driven by the self-checking decoder test.
module decoder_transition_coverage #(
    parameter int unsigned NUM_OUTPUTS  = 4,
    parameter int unsigned SELECT_WIDTH = (NUM_OUTPUTS > 1) ? $clog2(NUM_OUTPUTS) : 1
) (
    input logic                    i_sample,
    input logic                    i_enable,
    input logic [SELECT_WIDTH-1:0] i_select
);

    logic previous_sample_valid;
    logic previous_enable;
    logic [SELECT_WIDTH-1:0] previous_select;

    function automatic logic selection_legal(input logic [SELECT_WIDTH-1:0] select);
        selection_legal = {1'b0, select} < (SELECT_WIDTH + 1)'(NUM_OUTPUTS);
    endfunction

    initial begin
        previous_sample_valid = 1'b0;
        previous_enable = 1'b0;
        previous_select = '0;
    end

    always @(posedge i_sample) begin
        if (previous_sample_valid) begin
            enable_asserted : cover (!previous_enable && i_enable);
            enable_deasserted : cover (previous_enable && !i_enable);
            legal_selection_changed :
            cover (previous_enable && selection_legal(
                previous_select
            ) && i_enable && selection_legal(
                i_select
            ) && (previous_select != i_select));
        end

        previous_sample_valid <= 1'b1;
        previous_enable <= i_enable;
        previous_select <= i_select;
    end

    if ((64'(1) << SELECT_WIDTH) > longint'(NUM_OUTPUTS)) begin : g_invalid_transitions
        always @(posedge i_sample) begin
            if (previous_sample_valid) begin
                legal_to_invalid :
                cover (previous_enable && selection_legal(
                    previous_select
                ) && i_enable && !selection_legal(
                    i_select
                ));
                invalid_to_legal :
                cover (previous_enable && !selection_legal(
                    previous_select
                ) && i_enable && selection_legal(
                    i_select
                ));
            end
        end
    end

endmodule
