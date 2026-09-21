`timescale 1ns / 1ps

/// Reusable self-checking test for one decoder parameter configuration.
module decoder_test_case #(
    parameter int unsigned NUM_OUTPUTS  = 4,
    parameter int unsigned SELECT_WIDTH = (NUM_OUTPUTS > 1) ? $clog2(NUM_OUTPUTS) : 1
) (
    output logic o_done
);

    localparam longint unsigned NumEncodings = 64'(1) << SELECT_WIDTH;

    logic                      i_enable;
    logic   [SELECT_WIDTH-1:0] i_select;
    logic   [ NUM_OUTPUTS-1:0] o_decoded;
    logic                      o_select_valid;
    logic                      coverage_sample;
    integer                    random_seed;

    decoder #(
        .NUM_OUTPUTS (NUM_OUTPUTS),
        .SELECT_WIDTH(SELECT_WIDTH)
    ) dut (
        .*
    );

`ifndef DECODER_DISABLE_COVERAGE
    decoder_transition_coverage #(
        .NUM_OUTPUTS (NUM_OUTPUTS),
        .SELECT_WIDTH(SELECT_WIDTH)
    ) i_transition_coverage (
        .i_sample(coverage_sample),
        .i_enable(i_enable),
        .i_select(i_select)
    );
`endif

    task automatic check_case(input logic enable, input longint unsigned selection);
        logic [NUM_OUTPUTS-1:0] expected_decoded;
        logic expected_valid;

        i_enable = enable;
        i_select = SELECT_WIDTH'(selection);
        #1ns;

        expected_decoded = '0;
        expected_valid   = enable && (selection < longint'(NUM_OUTPUTS));
        if (expected_valid) begin
            expected_decoded[SELECT_WIDTH'(selection)] = 1'b1;
        end

        assert ({o_select_valid, o_decoded} === {expected_valid, expected_decoded})
        else
            $fatal(
                1,
                "NUM_OUTPUTS=%0d enable=%b select=%0d expected=%b_%b actual=%b_%b",
                NUM_OUTPUTS,
                enable,
                selection,
                expected_valid,
                expected_decoded,
                o_select_valid,
                o_decoded
            );
        coverage_sample = 1'b1;
        #1ps;
        coverage_sample = 1'b0;
    endtask

    initial begin
        o_done = 1'b0;
        i_enable = 1'b0;
        i_select = '0;
        coverage_sample = 1'b0;

        // Exhaust every binary encoding in both enabled and disabled modes.
        for (longint unsigned selection = 0; selection < NumEncodings; selection++) begin
            check_case(1'b0, selection);
            check_case(1'b1, selection);
        end

        // Exercise every ordered transition between legal selections.
        for (longint unsigned previous = 0; previous < longint'(NUM_OUTPUTS); previous++) begin
            for (longint unsigned current = 0; current < longint'(NUM_OUTPUTS); current++) begin
                check_case(1'b1, previous);
                check_case(1'b1, current);
            end
        end

        // Directly exercise both boundaries of the invalid-encoding region.
        if (NumEncodings > longint'(NUM_OUTPUTS)) begin
            check_case(1'b1, longint'(NUM_OUTPUTS) - 1);
            check_case(1'b1, longint'(NUM_OUTPUTS));
            check_case(1'b1, 0);
        end

        // Exercise simultaneous enable and selection changes with a fixed seed.
        random_seed = 32'hdec0_de01 ^ NUM_OUTPUTS;
        void'($urandom(random_seed));
        for (int unsigned iteration = 0; iteration < 128; iteration++) begin
            check_case(iteration[0], 64'($urandom()) % NumEncodings);
        end

        o_done = 1'b1;
    end

endmodule
