`timescale 1ns / 1ps

// Verification-only lane-mask mutants selected by LANE_MASK_FAULT_MODE.
`ifndef LANE_MASK_FAULT_MODE
`define LANE_MASK_FAULT_MODE 0
`endif

module lane_mask #(
    parameter int unsigned LANES = 4
) (
    input  logic             i_operation_valid,
    input  logic [LANES-1:0] i_lane_valid,
    input  logic [LANES-1:0] i_lane_mask,
    input  logic [LANES-1:0] i_lane_predicate,
    output logic [LANES-1:0] o_lane_active,
    output logic [LANES-1:0] o_lane_isolate,
    output logic [LANES-1:0] o_lane_write_mask
);
    localparam int unsigned FaultMode = `LANE_MASK_FAULT_MODE;

    always_comb begin
        case (FaultMode)
            1: o_lane_active = i_lane_valid & i_lane_mask & i_lane_predicate;
            2: o_lane_active = {LANES{i_operation_valid}} & i_lane_mask & i_lane_predicate;
            3: o_lane_active = {LANES{i_operation_valid}} & i_lane_valid & i_lane_predicate;
            4: o_lane_active = {LANES{i_operation_valid}} & i_lane_valid & i_lane_mask;
            default:
            o_lane_active = {LANES{i_operation_valid}} & i_lane_valid &
                                     i_lane_mask & i_lane_predicate;
        endcase

        o_lane_isolate = (FaultMode == 5) ? o_lane_active : ~o_lane_active;
        o_lane_write_mask = (FaultMode == 6) ? ~o_lane_active : o_lane_active;
    end
endmodule

`undef LANE_MASK_FAULT_MODE
