/// Compares downstream combinational activity with and without operand isolation.
module operand_isolation_activity_test_case #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0,
    parameter int unsigned USE_CASE = 0
) (
    output logic o_done
);

    logic            [WIDTH-1:0] i_data;
    logic                        i_isolate;
    logic            [WIDTH-1:0] o_data;
    logic            [WIDTH-1:0] baseline_cone;
    logic            [WIDTH-1:0] isolated_cone;
    logic            [WIDTH-1:0] previous_data;
    logic            [WIDTH-1:0] previous_baseline_cone;
    logic            [WIDTH-1:0] previous_isolated_cone;
    logic                        coverage_sample;
    logic                        previous_valid;
    longint unsigned             baseline_toggles;
    longint unsigned             isolated_toggles;

    operand_isolation #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE)
    ) dut (
        .*
    );

    function automatic logic [WIDTH-1:0] datapath_model(input logic [WIDTH-1:0] data);
        case (USE_CASE)
            0: datapath_model = ~data;
            1: datapath_model = data ^ (data << 1);
            default: datapath_model = data + WIDTH'(1);
        endcase
    endfunction

    function automatic longint unsigned count_set_bits(input logic [WIDTH-1:0] value);
        count_set_bits = 0;
        for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
            count_set_bits += value[bit_index];
        end
    endfunction

    assign baseline_cone = datapath_model(i_data);
    assign isolated_cone = datapath_model(o_data);

`ifndef OPERAND_ISOLATION_DISABLE_COVERAGE
    operand_isolation_integration_coverage #(
        .USE_CASE(USE_CASE)
    ) i_integration_coverage (
        .i_sample(coverage_sample),
        .i_isolate(i_isolate),
        .i_input_changes(previous_valid && previous_data != i_data)
    );
`endif

    task automatic apply_operand(input logic [WIDTH-1:0] data, input logic isolate);
        i_data = data;
        i_isolate = isolate;
        #1ns;

        if (isolate) begin
            assert (o_data == CLAMP_VALUE)
            else $fatal(1, "USE_CASE=%0d isolated operand did not clamp", USE_CASE);
        end else begin
            assert (isolated_cone == baseline_cone)
            else $fatal(1, "USE_CASE=%0d active datapath changed", USE_CASE);
        end

        if (previous_valid) begin
            baseline_toggles += count_set_bits(baseline_cone ^ previous_baseline_cone);
            isolated_toggles += count_set_bits(isolated_cone ^ previous_isolated_cone);
        end
        coverage_sample = 1'b1;
        #1ps;
        coverage_sample = 1'b0;
        previous_data = i_data;
        previous_baseline_cone = baseline_cone;
        previous_isolated_cone = isolated_cone;
        previous_valid = 1'b1;
    endtask

    initial begin
        o_done = 1'b0;
        i_data = '0;
        i_isolate = 1'b0;
        previous_data = '0;
        previous_baseline_cone = '0;
        previous_isolated_cone = '0;
        coverage_sample = 1'b0;
        previous_valid = 1'b0;
        baseline_toggles = 0;
        isolated_toggles = 0;

        apply_operand('0, 1'b0);
        apply_operand('1, 1'b0);
        apply_operand(CLAMP_VALUE, 1'b1);
        repeat (32) begin
            apply_operand('0, 1'b1);
            apply_operand('1, 1'b1);
        end
        apply_operand('1, 1'b0);
        apply_operand('0, 1'b0);

        assert (isolated_toggles < baseline_toggles)
        else
            $fatal(
                1,
                "USE_CASE=%0d isolation did not reduce downstream activity: baseline=%0d isolated=%0d",
                USE_CASE,
                baseline_toggles,
                isolated_toggles
            );

        $display(
            "OPERAND_ISOLATION_ACTIVITY use_case=%0d width=%0d baseline_toggles=%0d isolated_toggles=%0d",
            USE_CASE, WIDTH, baseline_toggles, isolated_toggles);
        o_done = 1'b1;
    end

endmodule
