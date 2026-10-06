// Interface properties for the combinational lane-mask contract.
module lane_mask_sva #(
    parameter int unsigned LANES = 4
) (
    input logic             i_operation_valid,
    input logic [LANES-1:0] i_lane_valid,
    input logic [LANES-1:0] i_lane_mask,
    input logic [LANES-1:0] i_lane_predicate,
    input logic [LANES-1:0] o_lane_active,
    input logic [LANES-1:0] o_lane_isolate,
    input logic [LANES-1:0] o_lane_write_mask
);
    always_comb begin
        active_matches_controls :
        assert (o_lane_active == ({LANES{i_operation_valid}} & i_lane_valid & i_lane_mask & i_lane_predicate));
        isolation_complements_activity : assert (o_lane_isolate == ~o_lane_active);
        write_mask_matches_activity : assert (o_lane_write_mask == o_lane_active);
        operation_valid_known : assert (!$isunknown(i_operation_valid));
        if (i_operation_valid) begin
            active_controls_known :
            assert (!$isunknown({i_lane_valid, i_lane_mask, i_lane_predicate}));
        end

        operation_disabled_covered : cover (!i_operation_valid);
        all_lanes_active_covered : cover (&o_lane_active);
        lane_valid_suppression_covered : cover (i_operation_valid && !(&i_lane_valid));
        architectural_mask_suppression_covered : cover (i_operation_valid && !(&i_lane_mask));
        predicate_suppression_covered : cover (i_operation_valid && !(&i_lane_predicate));
    end
endmodule
