// Parallel regression across width, reset, arithmetic, and reset-style modes.
module counter_tb;
    timeunit 1ns; timeprecision 1ps;

    logic i_clk;
    logic [7:0] done;

    always #5ns i_clk = ~i_clk;

    initial i_clk = 1'b0;

    counter_checker #(
        .WIDTH(1),
        .SATURATE(1'b1),
        .CHECKER_ID(0)
    ) checker_min_sat (
        .i_clk,
        .o_done(done[0])
    );

    counter_checker #(
        .WIDTH(1),
        .SATURATE(1'b0),
        .CHECKER_ID(1)
    ) checker_min_wrap (
        .i_clk,
        .o_done(done[1])
    );

    counter_checker #(
        .WIDTH(4),
        .SATURATE(1'b0),
        .CHECKER_ID(2)
    ) checker_fifo_wrap (
        .i_clk,
        .o_done(done[2])
    );

    counter_checker #(
        .WIDTH(8),
        .SATURATE(1'b1),
        .CHECKER_ID(3)
    ) checker_event_sat (
        .i_clk,
        .o_done(done[3])
    );

    counter_checker #(
        .WIDTH(16),
        .RESET_VALUE(16'h35A7),
        .SATURATE(1'b1),
        .CHECKER_ID(4)
    ) checker_nonzero_reset (
        .i_clk,
        .o_done(done[4])
    );

    counter_checker #(
        .WIDTH(32),
        .SATURATE(1'b1),
        .ASYNC_RESET(1'b1),
        .CHECKER_ID(5)
    ) checker_async_sat (
        .i_clk,
        .o_done(done[5])
    );

    counter_checker #(
        .WIDTH(32),
        .SATURATE(1'b0),
        .ASYNC_RESET(1'b1),
        .CHECKER_ID(6)
    ) checker_async_wrap (
        .i_clk,
        .o_done(done[6])
    );

    counter_checker #(
        .WIDTH(64),
        .SATURATE(1'b1),
        .CHECKER_ID(7)
    ) checker_wide_sat (
        .i_clk,
        .o_done(done[7])
    );

    initial begin
        wait (&done);
        $display("PASS: all counter configurations completed");
        $finish;
    end

    initial begin
        #50us;
        $fatal(1, "counter regression timed out");
    end
endmodule
