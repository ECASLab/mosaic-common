/// Stable boundary used to bind checks to every operand-isolation instance.
module operand_isolation_bind #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0
) (
    input logic [WIDTH-1:0] i_data,
    input logic             i_isolate,
    input logic [WIDTH-1:0] o_data
);

    operand_isolation_sva #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE)
    ) i_operand_isolation_sva (
        .*
    );

endmodule

`ifndef MOSAIC_FORMAL
bind operand_isolation operand_isolation_bind #(
    .WIDTH(WIDTH),
    .CLAMP_VALUE(CLAMP_VALUE)
) i_operand_isolation_bind (.*);
`endif
