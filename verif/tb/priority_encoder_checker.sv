`timescale 1ns / 1ps

module priority_encoder_checker #(
    parameter int unsigned WIDTH = 4,
    parameter bit LSB_HIGH_PRIORITY = 1'b1,
    parameter int unsigned CHECKER_ID = 0
) (
    output logic o_done
);
    localparam int unsigned INDEX_WIDTH = (WIDTH > 1) ? $clog2(WIDTH) : 1;

    logic [WIDTH-1:0] i_request;
    logic o_valid;
    logic [INDEX_WIDTH-1:0] o_index;
    logic [WIDTH-1:0] o_onehot;
    logic o_multiple;

    priority_encoder #(
        .WIDTH(WIDTH),
        .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
    ) dut (
        .*
    );

    task automatic check_request(input logic [WIDTH-1:0] request);
        logic expected_valid;
        logic [INDEX_WIDTH-1:0] expected_index;
        logic [WIDTH-1:0] expected_onehot;
        logic expected_multiple;
        logic found;
        int unsigned population;

        i_request = request;
        #1ps;
        expected_valid = |request;
        expected_index = '0;
        expected_onehot = '0;
        found = 1'b0;
        population = 0;
        for (int unsigned position = 0; position < WIDTH; position++) begin
            population += request[position];
            if (LSB_HIGH_PRIORITY && request[position] && !found) begin
                expected_index = INDEX_WIDTH'(position);
                expected_onehot[position] = 1'b1;
                found = 1'b1;
            end
        end
        if (!LSB_HIGH_PRIORITY) begin
            for (int unsigned position = WIDTH; position > 0; position--) begin
                if (request[position-1] && !found) begin
                    expected_index = INDEX_WIDTH'(position - 1);
                    expected_onehot[position-1] = 1'b1;
                    found = 1'b1;
                end
            end
        end
        expected_multiple = population > 1;

        assert ({o_valid, o_index, o_onehot, o_multiple} ==
                {expected_valid, expected_index, expected_onehot, expected_multiple})
        else
            $fatal(
                1, "checker %0d: request %b produced an incorrect encoding", CHECKER_ID, request
            );
    endtask

    initial begin
        o_done = 1'b0;
        check_request('0);
        check_request('1);
        for (int unsigned position = 0; position < WIDTH; position++) begin
            check_request(WIDTH'(1'b1) << position);
        end
        if (WIDTH <= 8) begin
            for (longint unsigned pattern = 0; pattern < (64'(1) << WIDTH); pattern++) begin
                check_request(WIDTH'(pattern));
            end
        end else begin
            repeat (1024) check_request(WIDTH'($urandom()));
        end
        o_done = 1'b1;
    end
endmodule
