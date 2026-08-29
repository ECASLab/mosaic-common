// Verification-only candidate netlist with inverted data behavior. EQY must
// reject this implementation when it is compared with the default DFF RTL.
module dff (
    input  wire i_clk,
    input  wire i_rstb,
    input  wire i_enable,
    input  wire i_d,
    output wire o_q
);
  wire unused_controls = i_clk | i_rstb | i_enable;

  assign o_q = ~i_d;
endmodule
