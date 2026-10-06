/// Covers isolation state for representative downstream datapath classes.
module operand_isolation_integration_coverage #(
    parameter int unsigned USE_CASE = 0
) (
    input logic i_sample,
    input logic i_isolate,
    input logic i_input_changes
);

    if (USE_CASE == 0) begin : g_arithmetic
        always @(posedge i_sample) begin
            arithmetic_active : cover (!i_isolate);
            arithmetic_isolated : cover (i_isolate && i_input_changes);
        end
    end else if (USE_CASE == 1) begin : g_vector
        always @(posedge i_sample) begin
            vector_active : cover (!i_isolate);
            vector_isolated : cover (i_isolate && i_input_changes);
        end
    end else begin : g_address_generation
        always @(posedge i_sample) begin
            address_generation_active : cover (!i_isolate);
            address_generation_isolated : cover (i_isolate && i_input_changes);
        end
    end

endmodule
