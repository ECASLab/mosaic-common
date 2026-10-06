/// Samples isolation transitions and concurrent operand activity.
module operand_isolation_transition_coverage #(
    parameter int unsigned WIDTH = 32
) (
    input logic             i_sample,
    input logic [WIDTH-1:0] i_data,
    input logic             i_isolate
);

    logic previous_valid;
    logic previous_isolate;
    logic [WIDTH-1:0] previous_data;

    initial begin
        previous_valid = 1'b0;
        previous_isolate = 1'b0;
        previous_data = '0;
    end

    always @(posedge i_sample) begin
        if (previous_valid) begin
            isolation_assert_data_stable :
            cover (!previous_isolate && i_isolate && previous_data == i_data);
            isolation_assert_data_changes :
            cover (!previous_isolate && i_isolate && previous_data != i_data);
            isolation_deassert_data_stable :
            cover (previous_isolate && !i_isolate && previous_data == i_data);
            isolation_deassert_data_changes :
            cover (previous_isolate && !i_isolate && previous_data != i_data);
            isolated_input_changes :
            cover (previous_isolate && i_isolate && previous_data != i_data);
            transparent_input_changes :
            cover (!previous_isolate && !i_isolate && previous_data != i_data);
            back_to_back_isolation : cover (previous_isolate && i_isolate);
        end
        previous_isolate = i_isolate;
        previous_data = i_data;
        previous_valid = 1'b1;
    end

endmodule
