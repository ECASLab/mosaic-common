/// Functional coverage for the write-gate combinational contract.
module write_gate_coverage #(
    parameter int unsigned WIDTH = 1
) (
    input logic [WIDTH-1:0] i_write_enable,
    input logic [WIDTH-1:0] i_suppress,
    input logic [WIDTH-1:0] o_write_enable,
    input logic [WIDTH-1:0] o_write_suppressed
);

`ifdef MOSAIC_YOSYS_FORMAL
    always_comb begin
        truth_00 : cover (i_write_enable == '0 && i_suppress == '0);
        truth_01 : cover (i_write_enable == '0 && i_suppress == '1);
        truth_10 : cover (i_write_enable == '1 && i_suppress == '0);
        truth_11 : cover (i_write_enable == '1 && i_suppress == '1);
        every_bit_permitted : cover (o_write_enable == '1);
        every_bit_suppressed : cover (o_write_suppressed == '1);
        zero_suppression_ratio : cover (i_write_enable != '0 && o_write_suppressed == '0);
        complete_suppression_ratio :
        cover (i_write_enable != '0 && o_write_suppressed == i_write_enable);
        partition_observed :
        cover (
            (o_write_enable & o_write_suppressed) == '0 &&
            (o_write_enable | o_write_suppressed) == i_write_enable
        );
    end

    if (WIDTH > 1) begin : g_mixed_write_decision
        always_comb begin
            mixed_write_decision : cover (o_write_enable != '0 && o_write_suppressed != '0);
            partial_suppression_ratio : cover (o_write_suppressed != '0 && o_write_enable != '0);
        end
    end
`else
    always_comb begin
        truth_00 : cover (i_write_enable == '0 && i_suppress == '0);
        truth_01 : cover (i_write_enable == '0 && i_suppress == '1);
        truth_10 : cover (i_write_enable == '1 && i_suppress == '0);
        truth_11 : cover (i_write_enable == '1 && i_suppress == '1);
        every_bit_permitted : cover (o_write_enable == '1);
        every_bit_suppressed : cover (o_write_suppressed == '1);
        zero_suppression_ratio : cover (i_write_enable != '0 && o_write_suppressed == '0);
        complete_suppression_ratio :
        cover (i_write_enable != '0 && o_write_suppressed == i_write_enable);
        partition_observed :
        cover (
            (o_write_enable & o_write_suppressed) == '0 &&
            (o_write_enable | o_write_suppressed) == i_write_enable
        );
    end

    if (WIDTH > 1) begin : g_mixed_write_decision
        always_comb begin
            mixed_write_decision : cover (o_write_enable != '0 && o_write_suppressed != '0);
            partial_suppression_ratio : cover (o_write_suppressed != '0 && o_write_enable != '0);
        end
    end
`endif

endmodule
