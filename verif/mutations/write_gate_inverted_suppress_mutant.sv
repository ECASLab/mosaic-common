// Verification-only mutation: suppression is deliberately inverted.
module write_gate #(
    parameter int unsigned WIDTH = 1
) (
    input  logic [WIDTH-1:0] i_write_enable,
    input  logic [WIDTH-1:0] i_suppress,
    output logic [WIDTH-1:0] o_write_enable,
    output logic [WIDTH-1:0] o_write_suppressed
);

    assign o_write_enable = i_write_enable & i_suppress;
    assign o_write_suppressed = i_write_enable & ~i_suppress;

endmodule
