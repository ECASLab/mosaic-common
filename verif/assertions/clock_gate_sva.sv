`timescale 1ns / 1ps

module clock_gate_sva (
    input logic i_clk,
    input logic i_enable,
    input logic i_test_enable,
    input logic o_gclk
);
  default clocking cb @(negedge i_clk);
  endclocking

  controls_known_low_phase :
  assert property (!$isunknown({i_enable, i_test_enable}));

  always_comb begin : check_gated_clock_level
    gated_clock_high_requires_source_high : assert (!o_gclk || i_clk);
  end

  always @(posedge o_gclk) begin
    #1step;
    gated_rise_matches_source_rise : assert (i_clk);
  end

  always @(negedge o_gclk) begin
    #1step;
    gated_fall_matches_source_fall : assert (!i_clk);
  end

  functional_enable_covered :
  cover property (i_enable && !i_test_enable);

  test_enable_covered :
  cover property (!i_enable && i_test_enable);

  both_enables_covered :
  cover property (i_enable && i_test_enable);

  disabled_covered :
  cover property (!i_enable && !i_test_enable);
endmodule
