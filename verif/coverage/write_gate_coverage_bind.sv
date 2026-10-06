/// Stable boundary used to bind functional coverage to every write-gate DUT.
module write_gate_coverage_bind #(
    parameter int unsigned WIDTH = 1
) (
    input logic [WIDTH-1:0] i_write_enable,
    input logic [WIDTH-1:0] i_suppress,
    input logic [WIDTH-1:0] o_write_enable,
    input logic [WIDTH-1:0] o_write_suppressed
);

    write_gate_coverage #(.WIDTH(WIDTH)) i_write_gate_coverage (.*);

endmodule

`ifndef MOSAIC_FORMAL
bind write_gate write_gate_coverage_bind #(.WIDTH(WIDTH)) i_write_gate_coverage_bind (.*);
`endif
