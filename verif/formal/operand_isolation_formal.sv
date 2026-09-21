/// Unconstrained harness proving the operand-isolation contract and input independence.
module operand_isolation_formal #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0
);

    (* anyseq *)logic [WIDTH-1:0] i_data;
    (* anyseq *)logic [WIDTH-1:0] independent_data;
    (* anyseq *)logic             i_isolate;
    logic [WIDTH-1:0] o_data;
    logic [WIDTH-1:0] independent_output;

    operand_isolation #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE)
    ) dut (
        .i_data(i_data),
        .i_isolate(i_isolate),
        .o_data(o_data)
    );

    operand_isolation #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE)
    ) independent_dut (
        .i_data(independent_data),
        .i_isolate(i_isolate),
        .o_data(independent_output)
    );

`ifdef FORMAL_ASSERTIONS
    operand_isolation_bind #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE)
    ) i_operand_isolation_bind (
        .*
    );
`endif

`ifdef FORMAL_COVERAGE
    operand_isolation_coverage_bind #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE)
    ) i_operand_isolation_coverage_bind (
        .*
    );
`endif

    always_comb begin
        if (i_isolate) begin
            assert (o_data == CLAMP_VALUE);
            assert (independent_output == CLAMP_VALUE);
            assert (o_data == independent_output);
        end else begin
            assert (o_data == i_data);
            assert (independent_output == independent_data);
        end
    end

endmodule
