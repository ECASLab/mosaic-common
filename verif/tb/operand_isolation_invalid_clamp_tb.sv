/// Elaboration-negative fixture for a clamp containing an unknown bit.
module operand_isolation_invalid_clamp_tb;

    operand_isolation #(
        .WIDTH(4),
`ifdef OPERAND_ISOLATION_INVALID_CLAMP_Z
        .CLAMP_VALUE(4'b0z01)
`else
        .CLAMP_VALUE(4'b0x01)
`endif
    ) dut ();

endmodule
