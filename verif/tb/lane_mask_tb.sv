`timescale 1ns / 1ps

// Parallel regression for every release-qualified lane count.
module lane_mask_tb;
    timeunit 1ns; timeprecision 1ps;

    logic [4:0] done;

    lane_mask_checker #(
        .LANES(1),
        .CHECKER_ID(1)
    ) checker_lanes_1 (
        .o_done(done[0])
    );
    lane_mask_checker #(
        .LANES(2),
        .CHECKER_ID(2)
    ) checker_lanes_2 (
        .o_done(done[1])
    );
    lane_mask_checker #(
        .LANES(4),
        .CHECKER_ID(4)
    ) checker_lanes_4 (
        .o_done(done[2])
    );
    lane_mask_checker #(
        .LANES(8),
        .CHECKER_ID(8)
    ) checker_lanes_8 (
        .o_done(done[3])
    );
    lane_mask_checker #(
        .LANES(16),
        .CHECKER_ID(16)
    ) checker_lanes_16 (
        .o_done(done[4])
    );

    initial begin
        wait (&done);
        $display("PASS: lane mask configurations 1, 2, 4, 8, and 16 completed");
        $finish;
    end

    initial begin
        #10us;
        $fatal(1, "lane-mask regression timed out");
    end
endmodule
