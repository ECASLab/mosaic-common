`timescale 1ns / 1ps

module retention_register_checker #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit ASYNC_RESET = 1'b0,
    parameter bit HAS_ENABLE = 1'b1
) (
    output logic done
);
    logic i_clk;
    logic i_rstb;
    logic i_enable;
    logic i_save;
    logic i_restore;
    logic [WIDTH-1:0] i_d;
    logic [WIDTH-1:0] o_q;
    logic [WIDTH-1:0] expected_q;
    logic [WIDTH-1:0] expected_retained;
    logic [WIDTH-1:0] random_data;

    retention_register #(
        .WIDTH(WIDTH),
        .RESET_VALUE(RESET_VALUE),
        .ASYNC_RESET(ASYNC_RESET),
        .HAS_ENABLE(HAS_ENABLE)
    ) dut (
        .*
    );

    always #5 i_clk = ~i_clk;

    task automatic clock_edge;
        @(posedge i_clk);
        #1;
    endtask

    task automatic check_q(input logic [WIDTH-1:0] expected);
        if (o_q !== expected) begin
            $error("WIDTH=%0d ASYNC=%0d ENABLE=%0d expected=%h actual=%h", WIDTH, ASYNC_RESET,
                   HAS_ENABLE, expected, o_q);
            $fatal(1);
        end
    endtask

    task automatic drive_edge(input logic rstb, input logic restore, input logic save,
                              input logic enable, input logic [WIDTH-1:0] data);
        i_rstb = rstb;
        i_restore = restore;
        i_save = save;
        i_enable = enable;
        i_d = data;
        clock_edge();
        if (!rstb) begin
            expected_q = RESET_VALUE;
            expected_retained = RESET_VALUE;
        end else if (restore) begin
            expected_q = expected_retained;
        end else if (save) begin
            expected_retained = expected_q;
        end else if (!HAS_ENABLE || enable) begin
            expected_q = data;
        end
        check_q(expected_q);
    endtask

    initial begin
        done = 1'b0;
        i_clk = 1'b0;
        i_rstb = 1'b1;
        i_enable = 1'b0;
        i_save = 1'b0;
        i_restore = 1'b0;
        i_d = '0;
        expected_q = RESET_VALUE;
        expected_retained = RESET_VALUE;

        if (ASYNC_RESET) begin
            #2 i_rstb = 1'b0;
            #1 check_q(RESET_VALUE);
            clock_edge();
            i_rstb = 1'b1;
        end else begin
            #1;
            drive_edge(1'b0, 1'b0, 1'b0, 1'b0, '0);
        end

        drive_edge(1'b1, 1'b0, 1'b0, 1'b1, '1);
        drive_edge(1'b1, 1'b0, 1'b1, 1'b0, '0);
        drive_edge(1'b1, 1'b0, 1'b0, 1'b1, '0);
        drive_edge(1'b1, 1'b1, 1'b0, 1'b0, '0);
        drive_edge(1'b1, 1'b0, 1'b0, 1'b0, ~RESET_VALUE);

        for (int iteration = 0; iteration < 24; iteration++) begin
            for (int bit_index = 0; bit_index < WIDTH; bit_index++) begin
                random_data[bit_index] = ($urandom_range(0, 1) != 0);
            end
            drive_edge(1'b1, 1'b0, 1'b0, iteration[0], random_data);
            drive_edge(1'b1, 1'b0, 1'b1, 1'b0, random_data);
            drive_edge(1'b1, 1'b0, 1'b0, 1'b1, ~random_data);
            drive_edge(1'b1, 1'b1, 1'b0, 1'b0, '0);
        end

        done = 1'b1;
    end
endmodule
