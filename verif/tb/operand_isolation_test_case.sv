/// Reusable self-checking unit test for one operand-isolation configuration.
module operand_isolation_test_case #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0
) (
    output logic o_done
);

    logic [WIDTH-1:0] i_data;
    logic             i_isolate;
    logic [WIDTH-1:0] o_data;
    logic             coverage_sample;

    operand_isolation #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE)
    ) dut (
        .*
    );

`ifndef OPERAND_ISOLATION_DISABLE_COVERAGE
    operand_isolation_transition_coverage #(
        .WIDTH(WIDTH)
    ) i_transition_coverage (
        .i_sample(coverage_sample),
        .i_data(i_data),
        .i_isolate(i_isolate)
    );
`endif

    function automatic logic [WIDTH-1:0] alternating_vector(input bit first_bit);
        for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
            alternating_vector[bit_index] = first_bit ^ bit_index[0];
        end
    endfunction

    function automatic logic [WIDTH-1:0] deterministic_vector(input int unsigned index);
        for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
            deterministic_vector[bit_index] = index[(bit_index+(bit_index/7))%32] ^ bit_index[0];
        end
    endfunction

    task automatic check_case(input logic [WIDTH-1:0] data, input logic isolate);
        logic [WIDTH-1:0] expected;

        i_data = data;
        i_isolate = isolate;
        #1ns;
        expected = isolate ? CLAMP_VALUE : data;
        assert (o_data === expected)
        else
            $fatal(
                1,
                "WIDTH=%0d CLAMP=%h data=%h isolate=%b expected=%h actual=%h",
                WIDTH,
                CLAMP_VALUE,
                data,
                isolate,
                expected,
                o_data
            );
        coverage_sample = 1'b1;
        #1ps;
        coverage_sample = 1'b0;
    endtask

    initial begin
        logic [WIDTH-1:0] alternating_zero;
        logic [WIDTH-1:0] alternating_one;

        o_done = 1'b0;
        coverage_sample = 1'b0;
        alternating_zero = alternating_vector(1'b0);
        alternating_one = alternating_vector(1'b1);

        check_case('0, 1'b0);
        check_case('1, 1'b0);
        check_case('0, 1'b1);
        check_case('1, 1'b1);
        check_case(CLAMP_VALUE, 1'b1);
        check_case(alternating_zero, 1'b0);
        check_case(alternating_one, 1'b0);
        check_case(alternating_zero, 1'b1);
        check_case(alternating_one, 1'b1);

        for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
            logic [WIDTH-1:0] one_hot;

            one_hot = '0;
            one_hot[bit_index] = 1'b1;
            check_case(one_hot, 1'b0);
            check_case(~one_hot, 1'b0);
            check_case(one_hot, 1'b1);
            check_case(~one_hot, 1'b1);
        end

        // Exercise control transitions with both stable and changing operands.
        check_case(alternating_zero, 1'b0);
        check_case(alternating_zero, 1'b1);
        check_case(alternating_one, 1'b0);
        check_case(alternating_zero, 1'b1);
        check_case(alternating_one, 1'b1);
        check_case(alternating_one, 1'b0);

        repeat (4) begin
            check_case(CLAMP_VALUE, 1'b1);
        end
        for (int unsigned iteration = 0; iteration < 128; iteration++) begin
            check_case(deterministic_vector(iteration), iteration[0]);
        end

        o_done = 1'b1;
    end

endmodule
