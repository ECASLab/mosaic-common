`timescale 1ns / 1ps

// Self-contained stimulus and reference model for one lane-count configuration.
module lane_mask_checker #(
    parameter int unsigned LANES = 4,
    parameter int unsigned CHECKER_ID = 0
) (
    output logic o_done
);
    timeunit 1ns; timeprecision 1ps;

    logic             i_operation_valid;
    logic [LANES-1:0] i_lane_valid;
    logic [LANES-1:0] i_lane_mask;
    logic [LANES-1:0] i_lane_predicate;
    logic [LANES-1:0] o_lane_active;
    logic [LANES-1:0] o_lane_isolate;
    logic [LANES-1:0] o_lane_write_mask;

    lane_mask #(.LANES(LANES)) dut (.*);

    task automatic check_outputs;
        logic [LANES-1:0] expected_active;

        #1ps;
        expected_active = {LANES{i_operation_valid}} & i_lane_valid & i_lane_mask & i_lane_predicate;
        assert (o_lane_active == expected_active)
        else $fatal(1, "checker %0d: active mask mismatch", CHECKER_ID);
        assert (o_lane_isolate == ~expected_active)
        else $fatal(1, "checker %0d: isolation mask mismatch", CHECKER_ID);
        assert (o_lane_write_mask == expected_active)
        else $fatal(1, "checker %0d: write mask mismatch", CHECKER_ID);
    endtask

    task automatic drive_and_check(input logic operation_valid, input logic [LANES-1:0] lane_valid,
                                   input logic [LANES-1:0] architectural_mask,
                                   input logic [LANES-1:0] predicate);
        i_operation_valid = operation_valid;
        i_lane_valid      = lane_valid;
        i_lane_mask       = architectural_mask;
        i_lane_predicate  = predicate;
        check_outputs();
    endtask

    initial begin
        o_done = 1'b0;

        drive_and_check(1'b0, '0, '0, '0);
        drive_and_check(1'b0, '1, '1, '1);
        drive_and_check(1'b1, '1, '1, '1);
        drive_and_check(1'b1, '0, '1, '1);
        drive_and_check(1'b1, '1, '0, '1);
        drive_and_check(1'b1, '1, '1, '0);

        for (int unsigned lane = 0; lane < LANES; lane++) begin
            logic [LANES-1:0] one_hot;
            one_hot       = '0;
            one_hot[lane] = 1'b1;
            drive_and_check(1'b1, '1, one_hot, '1);
            drive_and_check(1'b1, ~one_hot, '1, '1);
            drive_and_check(1'b1, '1, '1, ~one_hot);
        end

        for (int unsigned tail = 0; tail <= LANES; tail++) begin
            logic [LANES-1:0] tail_mask;
            tail_mask = '0;
            for (int unsigned lane = 0; lane < tail; lane++) begin
                tail_mask[lane] = 1'b1;
            end
            drive_and_check(1'b1, '1, tail_mask, '1);
        end

        repeat (256) begin
            drive_and_check(1'($urandom_range(0, 1)), LANES'($urandom()), LANES'($urandom()),
                            LANES'($urandom()));
        end

        o_done = 1'b1;
    end
endmodule
