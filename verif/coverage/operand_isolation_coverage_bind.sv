/// Stable boundary used to bind functional coverage to every DUT instance.
module operand_isolation_coverage_bind #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0
) (
    input logic [WIDTH-1:0] i_data,
    input logic             i_isolate,
    input logic [WIDTH-1:0] o_data
);

    operand_isolation_coverage #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE)
    ) i_operand_isolation_coverage (
        .*
    );

endmodule

`ifndef MOSAIC_FORMAL
bind operand_isolation operand_isolation_coverage_bind #(
    .WIDTH(WIDTH),
    .CLAMP_VALUE(CLAMP_VALUE)
) i_operand_isolation_coverage_bind (.*);
`endif
