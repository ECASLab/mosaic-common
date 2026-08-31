// Verification-only candidate netlist that omits the architectural lane mask.
// EQY must reject it when compared with the production RTL.
module lane_mask #(
    parameter LANES = 4
) (
    input  wire             i_operation_valid,
    input  wire [LANES-1:0] i_lane_valid,
    input  wire [LANES-1:0] i_lane_mask,
    input  wire [LANES-1:0] i_lane_predicate,
    output wire [LANES-1:0] o_lane_active,
    output wire [LANES-1:0] o_lane_isolate,
    output wire [LANES-1:0] o_lane_write_mask
);
    wire [LANES-1:0] unused_lane_mask = i_lane_mask;
    assign o_lane_active = {LANES{i_operation_valid}} & i_lane_valid & i_lane_predicate;
    assign o_lane_isolate = ~o_lane_active;
    assign o_lane_write_mask = o_lane_active;
endmodule
