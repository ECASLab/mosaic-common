`timescale 1ns / 1ps

// Demonstrate detection of every control class that is illegal when unknown.
module lane_mask_four_state_tb;
    localparam int unsigned LANES = 4;

    logic             i_operation_valid;
    logic [LANES-1:0] i_lane_valid;
    logic [LANES-1:0] i_lane_mask;
    logic [LANES-1:0] i_lane_predicate;
    logic [LANES-1:0] o_lane_active;
    logic [LANES-1:0] o_lane_isolate;
    logic [LANES-1:0] o_lane_write_mask;

    lane_mask #(.LANES(LANES)) dut (.*);

`ifndef LANE_MASK_DISABLE_UNKNOWN_CHECK
    always @(*) begin
        #1ps;
        if ($isunknown(i_operation_valid)) begin
            $fatal(1, "UNKNOWN_CONTROL_DETECTED: i_operation_valid");
        end
        if (i_operation_valid && $isunknown({i_lane_valid, i_lane_mask, i_lane_predicate})) begin
            $fatal(1, "UNKNOWN_CONTROL_DETECTED: active per-lane control");
        end
    end
`endif

    initial begin
        i_operation_valid = 1'b0;
        i_lane_valid      = 'x;
        i_lane_mask       = 'x;
        i_lane_predicate  = 'x;
        #2ns;

`ifdef LANE_MASK_UNKNOWN_GLOBAL
        i_operation_valid = 1'bx;
`elsif LANE_MASK_UNKNOWN_VALID
        i_operation_valid = 1'b1;
        i_lane_valid[0]   = 1'bx;
`elsif LANE_MASK_UNKNOWN_MASK
        i_operation_valid = 1'b1;
        i_lane_valid      = '1;
        i_lane_mask[0]    = 1'bx;
`elsif LANE_MASK_UNKNOWN_PREDICATE
        i_operation_valid   = 1'b1;
        i_lane_valid        = '1;
        i_lane_mask         = '1;
        i_lane_predicate[0] = 1'bx;
`else
        $fatal(1, "No unknown-control scenario selected");
`endif
        #2ns;
        $display("UNKNOWN_CONTROL_ESCAPED");
        $finish;
    end
endmodule
