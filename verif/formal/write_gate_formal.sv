/// Unconstrained harness for proof and reachability of one write-gate width.
module write_gate_formal #(
    parameter int unsigned WIDTH = 1
);

    (* anyseq *)logic [WIDTH-1:0] i_write_enable;
    (* anyseq *)logic [WIDTH-1:0] i_suppress;
    logic [WIDTH-1:0] o_write_enable;
    logic [WIDTH-1:0] o_write_suppressed;

    write_gate #(.WIDTH(WIDTH)) dut (.*);
    write_gate_integration_formal #(.WIDTH(WIDTH)) i_integration_formal ();

`ifdef FORMAL_ASSERTIONS
    write_gate_bind #(.WIDTH(WIDTH)) i_write_gate_bind (.*);
`endif

`ifdef FORMAL_COVERAGE
    write_gate_coverage_bind #(.WIDTH(WIDTH)) i_write_gate_coverage_bind (.*);
`endif

endmodule
