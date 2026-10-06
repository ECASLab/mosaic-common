`timescale 1ns / 1ps

module isolation_cell_checker #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0,
    parameter bit ISOLATE_ACTIVE_HIGH = 1'b1,
    parameter int unsigned RANDOM_TESTS = 64
) (
    output logic done
);
    logic [WIDTH-1:0] i_data;
    logic             i_isolate;
    logic [WIDTH-1:0] random_data;
    wire  [WIDTH-1:0] o_data;

    isolation_cell #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE),
        .ISOLATE_ACTIVE_HIGH(ISOLATE_ACTIVE_HIGH)
    ) dut (
        .*
    );

    task automatic check(input logic [WIDTH-1:0] data, input logic isolate);
        logic active;
        logic [WIDTH-1:0] expected;
        begin
            i_data = data;
            i_isolate = isolate;
            #1;
            active   = ISOLATE_ACTIVE_HIGH ? isolate : ~isolate;
            expected = active ? CLAMP_VALUE : data;
            if (o_data !== expected) begin
                $error("WIDTH=%0d CLAMP=%h POLARITY=%0d data=%h isolate=%b expected=%h actual=%h",
                       WIDTH, CLAMP_VALUE, ISOLATE_ACTIVE_HIGH, data, isolate, expected, o_data);
                $fatal(1);
            end
        end
    endtask

    initial begin
        done = 1'b0;
        i_data = '0;
        i_isolate = ISOLATE_ACTIVE_HIGH;

        check('0, ~ISOLATE_ACTIVE_HIGH);
        check('1, ~ISOLATE_ACTIVE_HIGH);
        check('0, ISOLATE_ACTIVE_HIGH);
        check('1, ISOLATE_ACTIVE_HIGH);

        for (int bit_index = 0; bit_index < WIDTH; bit_index++) begin
            check({WIDTH{1'b1}} ^ ({{(WIDTH - 1) {1'b0}}, 1'b1} << bit_index),
                  ~ISOLATE_ACTIVE_HIGH);
            check({{(WIDTH - 1) {1'b0}}, 1'b1} << bit_index, ISOLATE_ACTIVE_HIGH);
        end

        for (int iteration = 0; iteration < RANDOM_TESTS; iteration++) begin
            for (int bit_index = 0; bit_index < WIDTH; bit_index++) begin
                random_data[bit_index] = ($urandom_range(0, 1) != 0);
            end
            check(random_data, iteration[0] ^ ISOLATE_ACTIVE_HIGH);
        end

        done = 1'b1;
    end
endmodule
