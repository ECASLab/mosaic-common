/// Elaboration-negative fixture for the unsupported WIDTH=0 configuration.
module write_gate_invalid_width_tb;

    write_gate #(.WIDTH(0)) dut ();

endmodule
