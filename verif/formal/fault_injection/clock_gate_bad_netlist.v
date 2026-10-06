// Deliberately incorrect combinational candidate used to qualify EQY detection.
module clock_gate (
    input  wire i_clk,
    input  wire i_enable,
    input  wire i_test_enable,
    output wire o_gclk
);
  assign o_gclk = i_clk & (i_enable | i_test_enable);
endmodule
