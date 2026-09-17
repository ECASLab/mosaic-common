/// Stable boundary used to bind write-gate assertions to every DUT instance.
module write_gate_bind #(
    parameter int unsigned WIDTH = 1
) (
    input logic [WIDTH-1:0] i_write_enable,
    input logic [WIDTH-1:0] i_suppress,
    input logic [WIDTH-1:0] o_write_enable,
    input logic [WIDTH-1:0] o_write_suppressed
);

    write_gate_sva #(.WIDTH(WIDTH)) i_write_gate_sva (.*);

endmodule

`ifndef MOSAIC_FORMAL
bind write_gate write_gate_bind #(.WIDTH(WIDTH)) i_write_gate_bind (.*);
`endif
