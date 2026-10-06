/// Covers destination type, suppression reason, and protocol decision together.
module write_gate_integration_coverage #(
    parameter int unsigned WIDTH = 1,
    parameter bit DESTINATION_IS_MEMORY = 1'b0
) (
    input logic i_sample,
    input logic i_transaction_accepted,
    input logic i_redundant_value_reason,
    input logic [WIDTH-1:0] i_write_enable,
    input logic [WIDTH-1:0] i_suppress,
    input logic [WIDTH-1:0] o_write_enable,
    input logic [WIDTH-1:0] o_write_suppressed
);

    always @(posedge i_sample) begin
        protocol_idle_no_decision : cover (!i_transaction_accepted && i_write_enable == '0);
        protocol_accepted_permit : cover (i_transaction_accepted && o_write_enable != '0);
        protocol_accepted_suppress : cover (i_transaction_accepted && o_write_suppressed != '0);
    end

    if (DESTINATION_IS_MEMORY) begin : g_memory_destination
        always @(posedge i_sample) begin
            memory_redundant_suppression :
            cover (i_redundant_value_reason && (i_write_enable & i_suppress) != '0);
        end
    end else begin : g_register_destination
        always @(posedge i_sample) begin
            register_redundant_suppression :
            cover (i_redundant_value_reason && (i_write_enable & i_suppress) != '0);
        end
    end

endmodule
