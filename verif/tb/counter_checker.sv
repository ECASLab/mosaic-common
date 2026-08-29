// Self-checking stimulus and reference model for one counter configuration.
module counter_checker #(
    parameter int unsigned WIDTH = 4,
    parameter logic [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit ASYNC_RESET = 1'b0,
    parameter bit SATURATE = 1'b1,
    parameter int unsigned CHECKER_ID = 0
) (
    input  logic i_clk,
    output logic o_done
);
    timeunit 1ns; timeprecision 1ps;

    localparam int unsigned RANDOM_CYCLES = 96;
    localparam logic [WIDTH-1:0] MaxValue = {WIDTH{1'b1}};

    logic i_rstb;
    logic i_enable;
    logic i_clear;
    logic i_load;
    logic i_direction;
    logic [WIDTH-1:0] i_load_value;
    logic [WIDTH-1:0] o_count;
    logic o_overflow;
    logic o_underflow;
    logic o_terminal;
    logic [WIDTH-1:0] expected_count;
    logic expected_overflow;
    logic expected_underflow;

    counter #(
        .WIDTH(WIDTH),
        .RESET_VALUE(RESET_VALUE),
        .ASYNC_RESET(ASYNC_RESET),
        .SATURATE(SATURATE)
    ) dut (
        .*
    );

    task automatic check_outputs(input string scenario);
        logic expected_terminal;
        expected_terminal = i_direction ? (expected_count == '0) : (expected_count == MaxValue);
        assert (o_count === expected_count && o_overflow === expected_overflow &&
                o_underflow === expected_underflow && o_terminal === expected_terminal)
        else
            $fatal(
                1,
                "counter checker %0d failed %s: count=%h/%h overflow=%b/%b underflow=%b/%b terminal=%b/%b",
                CHECKER_ID,
                scenario,
                o_count,
                expected_count,
                o_overflow,
                expected_overflow,
                o_underflow,
                expected_underflow,
                o_terminal,
                expected_terminal
            );
    endtask

    task automatic update_model;
        expected_overflow  = 1'b0;
        expected_underflow = 1'b0;
        if (!i_rstb || i_clear) begin
            expected_count = RESET_VALUE;
        end else if (i_load) begin
            expected_count = i_load_value;
        end else if (i_enable) begin
            if (!i_direction) begin
                if (expected_count == MaxValue) begin
                    expected_overflow = 1'b1;
                    if (!SATURATE) expected_count = '0;
                end else begin
                    expected_count = expected_count + 1'b1;
                end
            end else begin
                if (expected_count == '0) begin
                    expected_underflow = 1'b1;
                    if (!SATURATE) expected_count = MaxValue;
                end else begin
                    expected_count = expected_count - 1'b1;
                end
            end
        end
    endtask

    task automatic clock_and_check(input string scenario);
        @(posedge i_clk);
        update_model();
        #1step;
        check_outputs(scenario);
        @(negedge i_clk);
    endtask

    task automatic load_value(input logic [WIDTH-1:0] value);
        i_clear      = 1'b0;
        i_load       = 1'b1;
        i_enable     = 1'b0;
        i_load_value = value;
        clock_and_check("load");
        i_load = 1'b0;
    endtask

    initial begin : run_test
        o_done             = 1'b0;
        i_rstb             = 1'b1;
        i_enable           = 1'b0;
        i_clear            = 1'b0;
        i_load             = 1'b0;
        i_direction        = 1'b0;
        i_load_value       = '0;
        expected_count     = 'x;
        expected_overflow  = 1'bx;
        expected_underflow = 1'bx;

        @(negedge i_clk);
        i_rstb = 1'b0;
        if (ASYNC_RESET) begin
            #1ns;
            expected_count     = RESET_VALUE;
            expected_overflow  = 1'b0;
            expected_underflow = 1'b0;
            check_outputs("asynchronous reset assertion");
        end
        clock_and_check("clocked reset");
        i_rstb       = 1'b1;

        // Clear wins over load and enable.
        i_clear      = 1'b1;
        i_load       = 1'b1;
        i_enable     = 1'b1;
        i_direction  = 1'b1;
        i_load_value = ~RESET_VALUE;
        clock_and_check("clear priority");

        // Load wins over an enabled arithmetic operation.
        i_clear      = 1'b0;
        i_load       = 1'b1;
        i_enable     = 1'b1;
        i_direction  = 1'b0;
        i_load_value = MaxValue - 1'b1;
        clock_and_check("load priority");
        i_load = 1'b0;

        // Reach maximum, attempt overflow, and confirm the event clears on hold.
        i_enable    = 1'b1;
        i_direction = 1'b0;
        clock_and_check("increment to maximum");
        clock_and_check("overflow boundary attempt");
        i_enable = 1'b0;
        clock_and_check("overflow pulse clears on hold");

        // Reach zero, attempt underflow, and confirm the event clears on hold.
        load_value({{(WIDTH - 1) {1'b0}}, 1'b1});
        i_enable    = 1'b1;
        i_direction = 1'b1;
        clock_and_check("decrement to zero");
        clock_and_check("underflow boundary attempt");
        i_enable = 1'b0;
        clock_and_check("underflow pulse clears on hold");

        // Randomized commands exercise priority and long mixed sequences.
        for (int unsigned cycle = 0; cycle < RANDOM_CYCLES; cycle++) begin
            i_clear     = ($urandom_range(0, 31) == 0);
            i_load      = ($urandom_range(0, 15) == 0);
            i_enable    = ($urandom_range(0, 1) != 0);
            i_direction = ($urandom_range(0, 1) != 0);
            for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
                i_load_value[bit_index] = ($urandom_range(0, 1) != 0);
            end
            clock_and_check("random command sequence");
        end

        // Mid-cycle assertion distinguishes asynchronous from synchronous reset.
        i_clear  = 1'b0;
        i_load   = 1'b0;
        i_enable = 1'b0;
        #2ns;
        i_rstb = 1'b0;
        #1ns;
        if (ASYNC_RESET) begin
            expected_count     = RESET_VALUE;
            expected_overflow  = 1'b0;
            expected_underflow = 1'b0;
        end
        check_outputs("mid-cycle reset assertion");
        clock_and_check("final reset edge");

        o_done = 1'b1;
    end
endmodule
