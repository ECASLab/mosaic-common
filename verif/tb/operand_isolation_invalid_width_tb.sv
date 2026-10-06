/// Elaboration-negative fixture for the unsupported WIDTH=0 configuration.
module operand_isolation_invalid_width_tb;

    operand_isolation #(.WIDTH(0)) dut ();

endmodule
