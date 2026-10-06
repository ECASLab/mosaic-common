module lane_mask_formal_checker #(
    parameter int unsigned LANES = 4
);
    (* anyconst *)logic             i_operation_valid;
    (* anyconst *)logic [LANES-1:0] i_lane_valid;
    (* anyconst *)logic [LANES-1:0] i_lane_mask;
    (* anyconst *)logic [LANES-1:0] i_lane_predicate;
    logic [LANES-1:0] o_lane_active;
    logic [LANES-1:0] o_lane_isolate;
    logic [LANES-1:0] o_lane_write_mask;

    lane_mask #(.LANES(LANES)) dut (.*);

    always_comb begin
        assert (o_lane_active == ({LANES{i_operation_valid}} & i_lane_valid & i_lane_mask & i_lane_predicate));
        assert (o_lane_isolate == ~o_lane_active);
        assert (o_lane_write_mask == o_lane_active);
        if (!i_operation_valid) begin
            assert (o_lane_active == '0);
            assert (o_lane_isolate == '1);
        end
    end
endmodule

module lane_mask_formal;
    lane_mask_formal_checker #(.LANES(1)) check_lanes_1 ();
    lane_mask_formal_checker #(.LANES(2)) check_lanes_2 ();
    lane_mask_formal_checker #(.LANES(4)) check_lanes_4 ();
    lane_mask_formal_checker #(.LANES(8)) check_lanes_8 ();
    lane_mask_formal_checker #(.LANES(16)) check_lanes_16 ();
endmodule
