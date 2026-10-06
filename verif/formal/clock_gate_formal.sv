module clock_gate_formal;
  (* gclk   *)logic i_clk;
  (* anyseq *)logic i_enable;
  (* anyseq *)logic i_test_enable;
  logic o_gclk;
  logic expected_enable;
  logic reference_valid = 1'b0;

  clock_gate dut (.*);

  always_latch begin
    if (!i_clk) begin
      expected_enable = i_enable | i_test_enable;
      reference_valid = 1'b1;
    end
  end

  always_comb begin
    if (reference_valid) begin
      assert (o_gclk == (i_clk & expected_enable));
    end
  end

  always @(posedge i_clk) begin
    cover (o_gclk);
  end

  always @(negedge i_clk) begin
    cover (!o_gclk && (i_enable || i_test_enable));
  end
endmodule
