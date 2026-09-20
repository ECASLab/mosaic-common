/// Reusable self-checking unit test for one parameterized write-gate instance.
module write_gate_test_case #(
    parameter int unsigned WIDTH = 1
) (
    output logic o_done
);

    logic [WIDTH-1:0] i_write_enable;
    logic [WIDTH-1:0] i_suppress;
    logic [WIDTH-1:0] o_write_enable;
    logic [WIDTH-1:0] o_write_suppressed;
    logic coverage_sample;

    write_gate #(.WIDTH(WIDTH)) dut (.*);

`ifndef WRITE_GATE_DISABLE_COVERAGE
    write_gate_transition_coverage i_transition_coverage (
        .i_sample(coverage_sample),
        .i_write_enable(i_write_enable[0]),
        .i_suppress(i_suppress[0])
    );
`endif

    function automatic logic [WIDTH-1:0] alternating_vector(input bit first_bit);
        for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
            alternating_vector[bit_index] = first_bit ^ bit_index[0];
        end
    endfunction

    function automatic logic [WIDTH-1:0] random_vector();
        for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
            random_vector[bit_index] = ($urandom_range(0, 1) != 0);
        end
    endfunction

    task automatic check_case(input logic [WIDTH-1:0] write_enable,
                              input logic [WIDTH-1:0] suppress);
        {i_write_enable, i_suppress} = {write_enable, suppress};
        #1ns;
        assert (o_write_enable == (write_enable & ~suppress))
        else $fatal(1, "WIDTH=%0d permitted-write mismatch", WIDTH);
        assert (o_write_suppressed == (write_enable & suppress))
        else $fatal(1, "WIDTH=%0d suppressed-write mismatch", WIDTH);
        assert ((o_write_enable & o_write_suppressed) == '0)
        else $fatal(1, "WIDTH=%0d outputs overlap", WIDTH);
        assert ((o_write_enable | o_write_suppressed) == write_enable)
        else $fatal(1, "WIDTH=%0d request partition mismatch", WIDTH);
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

        check_case('0, '0);
        check_case('0, '1);
        check_case('1, '0);
        check_case('1, '1);

        for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
            logic [WIDTH-1:0] one_hot;
            one_hot = '0;
            one_hot[bit_index] = 1'b1;
            check_case(one_hot, '0);
            check_case(one_hot, one_hot);
        end

        check_case(alternating_zero, '0);
        check_case(alternating_zero, alternating_one);
        check_case(alternating_one, alternating_zero);
        check_case(alternating_one, '1);
        check_case('1, alternating_zero);
        check_case('1, alternating_one);

        // Drive every source-to-destination transition of one representative
        // lane. Repeating the scalar value across WIDTH keeps all lanes legal.
        for (int unsigned source_index = 0; source_index < 4; source_index++) begin
            for (
                int unsigned destination_index = 0; destination_index < 4; destination_index++
            ) begin
                logic [1:0] source_control;
                logic [1:0] destination_control;

                source_control = source_index[1:0];
                destination_control = destination_index[1:0];
                check_case({WIDTH{source_control[1]}}, {WIDTH{source_control[0]}});
                check_case({WIDTH{destination_control[1]}}, {WIDTH{destination_control[0]}});
            end
        end

        repeat (16) begin
            check_case('0, random_vector());
        end
        repeat (16) begin
            check_case('1, '1);
        end
        repeat (64) begin
            check_case(random_vector(), random_vector());
        end

        o_done = 1'b1;
    end

endmodule
