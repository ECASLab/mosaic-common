`timescale 1ns / 1ps

/// Reusable self-checking test for one mux parameter configuration.
module mux_test_case #(
    parameter int unsigned NUM_INPUTS = 2,
    parameter int unsigned DATA_WIDTH = 32,
    parameter logic [DATA_WIDTH-1:0] DEFAULT_VALUE = '0,
    parameter int unsigned SEL_WIDTH = (NUM_INPUTS > 1) ? $clog2(NUM_INPUTS) : 1
) (
    output logic o_done
);

    localparam longint unsigned NumEncodings = 64'(1) << SEL_WIDTH;

    logic   [NUM_INPUTS-1:0][DATA_WIDTH-1:0] i_data;
    logic   [ SEL_WIDTH-1:0]                 i_select;
    logic   [DATA_WIDTH-1:0]                 o_data;
    logic                                    o_select_valid;
    logic                                    coverage_sample;
    integer                                  random_seed;

    mux #(
        .NUM_INPUTS   (NUM_INPUTS),
        .DATA_WIDTH   (DATA_WIDTH),
        .DEFAULT_VALUE(DEFAULT_VALUE),
        .SEL_WIDTH    (SEL_WIDTH)
    ) dut (
        .*
    );

`ifndef MUX_DISABLE_COVERAGE
    mux_transition_coverage #(
        .NUM_INPUTS(NUM_INPUTS),
        .DATA_WIDTH(DATA_WIDTH),
        .SEL_WIDTH (SEL_WIDTH)
    ) i_transition_coverage (
        .i_sample(coverage_sample),
        .*
    );
`endif

    function automatic logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] distinct_data_f();
        logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] value;

        value = '0;
        for (int unsigned input_index = 0; input_index < NUM_INPUTS; input_index++) begin
            value[input_index] = DATA_WIDTH'(input_index + 1);
        end
        return value;
    endfunction

    function automatic logic [DATA_WIDTH-1:0] random_data_f();
        logic [DATA_WIDTH-1:0] value;

        for (int unsigned bit_index = 0; bit_index < DATA_WIDTH; bit_index++) begin
            value[bit_index] = 1'($urandom_range(0, 1));
        end
        return value;
    endfunction

    task automatic check_case(input logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] data,
                              input longint unsigned selection);
        logic [DATA_WIDTH-1:0] expected_data;
        logic expected_valid;

        i_data   = data;
        i_select = SEL_WIDTH'(selection);
        #1ns;

        expected_valid = selection < longint'(NUM_INPUTS);
        expected_data  = DEFAULT_VALUE;
        if (expected_valid) begin
            expected_data = data[SEL_WIDTH'(selection)];
        end

        assert ({o_select_valid, o_data} === {expected_valid, expected_data})
        else
            $fatal(
                1,
                "NUM_INPUTS=%0d DATA_WIDTH=%0d select=%0d expected=%b_%h actual=%b_%h",
                NUM_INPUTS,
                DATA_WIDTH,
                selection,
                expected_valid,
                expected_data,
                o_select_valid,
                o_data
            );
        coverage_sample = 1'b1;
        #1ps;
        coverage_sample = 1'b0;
    endtask

    initial begin
        logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] test_data;
        logic [SEL_WIDTH-1:0] unselected_index;

        o_done = 1'b0;
        i_data = '0;
        i_select = '0;
        coverage_sample = 1'b0;

        // Exhaust every selection encoding with zero, one, and distinct data.
        for (longint unsigned selection = 0; selection < NumEncodings; selection++) begin
            check_case('0, selection);
            check_case('1, selection);
            check_case(distinct_data_f(), selection);
        end

        // Exercise every ordered transition between legal selections.
        test_data = distinct_data_f();
        for (longint unsigned previous = 0; previous < longint'(NUM_INPUTS); previous++) begin
            for (longint unsigned current = 0; current < longint'(NUM_INPUTS); current++) begin
                check_case(test_data, previous);
                check_case(test_data, current);
            end
        end

        // Prove selected data changes propagate and unselected changes do not.
        test_data = distinct_data_f();
        check_case(test_data, 0);
        test_data[0] = '1;
        check_case(test_data, 0);
        if (NUM_INPUTS > 1) begin
            unselected_index = SEL_WIDTH'(1);
            test_data = distinct_data_f();
            check_case(test_data, 0);
            test_data[unselected_index] = ~test_data[unselected_index];
            check_case(test_data, 0);
        end

        // Directly exercise both boundaries of the invalid-encoding region.
        if (NumEncodings > longint'(NUM_INPUTS)) begin
            check_case(test_data, longint'(NUM_INPUTS) - 1);
            check_case(test_data, longint'(NUM_INPUTS));
            check_case(test_data, 0);
        end

        // Exercise simultaneous data and selection changes with a fixed seed.
        random_seed = 32'h4d55_5801 ^ NUM_INPUTS ^ DATA_WIDTH;
        void'($urandom(random_seed));
        for (int unsigned iteration = 0; iteration < 128; iteration++) begin
            for (int unsigned input_index = 0; input_index < NUM_INPUTS; input_index++) begin
                test_data[input_index] = random_data_f();
            end
            check_case(test_data, 64'($urandom()) % NumEncodings);
        end

        o_done = 1'b1;
    end

endmodule
