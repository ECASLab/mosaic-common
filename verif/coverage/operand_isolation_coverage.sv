/// Functional coverage for the operand-isolation combinational contract.
module operand_isolation_coverage #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0
) (
    input logic [WIDTH-1:0] i_data,
    input logic             i_isolate,
    input logic [WIDTH-1:0] o_data
);

    always_comb begin
        transparent_mode : cover (!i_isolate && o_data == i_data);
        isolation_mode : cover (i_isolate && o_data == CLAMP_VALUE);
        transparent_zero : cover (!i_isolate && i_data == '0 && o_data == '0);
        transparent_ones : cover (!i_isolate && i_data == '1 && o_data == '1);
        isolated_input_differs :
        cover (i_isolate && i_data != CLAMP_VALUE && o_data == CLAMP_VALUE);
        isolated_input_matches :
        cover (i_isolate && i_data == CLAMP_VALUE && o_data == CLAMP_VALUE);
    end

endmodule
