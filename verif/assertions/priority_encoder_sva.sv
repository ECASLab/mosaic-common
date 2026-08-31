module priority_encoder_sva #(
    parameter int unsigned WIDTH = 4,
    parameter bit LSB_HIGH_PRIORITY = 1'b1,
    parameter int unsigned INDEX_WIDTH = (WIDTH > 1) ? $clog2(WIDTH) : 1
) (
    input logic [      WIDTH-1:0] i_request,
    input logic                   o_valid,
    input logic [INDEX_WIDTH-1:0] o_index,
    input logic [      WIDTH-1:0] o_onehot,
    input logic                   o_multiple
);
    always_comb begin
        request_known : assert (!$isunknown(i_request));
        valid_matches_requests : assert (o_valid == (|i_request));
        selection_is_onehot_or_zero : assert ($onehot0(o_onehot));
        selection_is_requested : assert ((o_onehot & ~i_request) == '0);
        multiple_matches_population : assert (o_multiple == ($countones(i_request) > 1));

        no_request_covered : cover (!o_valid);
        valid_request_covered : cover (o_valid);
        single_request_covered : cover ($onehot(i_request));
        lowest_request_selected_covered : cover (o_valid && o_onehot[0]);
        highest_request_selected_covered : cover (o_valid && o_onehot[WIDTH-1]);

        if (o_valid) begin
            valid_selection_is_onehot : assert ($onehot(o_onehot));
            index_matches_onehot : assert (o_onehot[o_index]);
            index_selects_request : assert (i_request[o_index]);
        end else begin
            no_request_onehot_is_zero : assert (o_onehot == '0);
            no_request_index_is_zero : assert (o_index == '0);
        end

        for (int unsigned position = 0; position < WIDTH; position++) begin
            if (o_onehot[position]) begin
                if (LSB_HIGH_PRIORITY) begin
                    higher_lsb_requests_absent :
                    assert ((i_request & ((WIDTH'(1'b1) << position) - 1'b1)) == '0);
                end else begin
                    higher_msb_requests_absent : assert ((i_request >> (position + 1)) == '0);
                end
            end
        end
    end

    if (WIDTH > 1) begin : gen_contention_coverage
        always_comb begin
            multiple_requests_covered : cover (o_multiple);
        end
    end
endmodule
