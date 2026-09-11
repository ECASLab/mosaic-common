module level_shifter_sva #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned DIRECTION = 0
) (
    input wire [WIDTH-1:0] i_data,
    input wire [WIDTH-1:0] o_data
);
    always_comb begin
        direction_is_legal : assert (DIRECTION <= 1);
        data_is_preserved : assert (o_data == i_data);
        all_zero_covered : cover (i_data == '0);
        all_one_covered : cover (i_data == '1);
    end

    if (WIDTH > 1) begin : gen_mixed_coverage
        always_comb begin
            mixed_data_covered : cover ((|i_data) && !(&i_data));
        end
    end
endmodule
