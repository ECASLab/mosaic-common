`timescale 1ns / 1ps

module level_shifter_checker #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned DIRECTION = 0,
    parameter int unsigned CHECKER_ID = 0
) (
    output logic o_done
);
    localparam int unsigned ExhaustivePatterns = (WIDTH <= 8) ? (1 << WIDTH) : 0;

    logic [WIDTH-1:0] i_data;
    logic [WIDTH-1:0] o_data;

    level_shifter #(
        .WIDTH(WIDTH),
        .DIRECTION(DIRECTION)
    ) dut (
        .*
    );

    task automatic check_data(input logic [WIDTH-1:0] data);
        i_data = data;
        #1ps;
        assert (o_data === data)
        else $fatal(1, "checker %0d: input %b produced output %b", CHECKER_ID, data, o_data);
    endtask

    task automatic run_directed_patterns;
        o_done = 1'b0;
        check_data('0);
        check_data('1);
        check_data(WIDTH'('hA5A5_A5A5_A5A5_A5A5));
        check_data(WIDTH'('h5A5A_5A5A_5A5A_5A5A));
        for (int unsigned position = 0; position < WIDTH; position++) begin
            check_data(WIDTH'(1'b1) << position);
            check_data(~(WIDTH'(1'b1) << position));
        end
    endtask

    if (WIDTH <= 8) begin : gen_exhaustive_campaign
        initial begin
            run_directed_patterns();
            for (int unsigned pattern = 0; pattern < ExhaustivePatterns; pattern++) begin
                check_data(WIDTH'(pattern));
            end
            o_done = 1'b1;
        end
    end else begin : gen_random_campaign
        initial begin
            run_directed_patterns();
            repeat (1024) check_data(WIDTH'({$urandom(), $urandom()}));
            o_done = 1'b1;
        end
    end
endmodule
