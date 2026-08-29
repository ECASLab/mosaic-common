// Prove all combinations of reset style and enable support against the same
// unconstrained controls and data.
module dff_formal;
  localparam int unsigned WIDTH = 4;
  localparam logic [WIDTH-1:0] RESET_VALUE = 4'hA;

  // The formal engine advances the global clock while anyseq inputs remain
  // symbolic on every proof step.
  (* gclk   *) logic i_clk;
  (* anyseq *) logic i_rstb;
  (* anyseq *) logic i_enable;
  (* anyseq *) logic [WIDTH-1:0] i_d;

  logic [WIDTH-1:0] q_sync_enable;
  logic [WIDTH-1:0] q_async_enable;
  logic [WIDTH-1:0] q_sync_no_enable;
  logic [WIDTH-1:0] q_async_no_enable;
  logic past_valid = 1'b0;

  // Instantiate the complete structural parameter space.
  dff #(
      .WIDTH(WIDTH),
      .RESET_VALUE(RESET_VALUE),
      .ASYNC_RESET(1'b0),
      .HAS_ENABLE(1'b1)
  ) dut_sync_enable (
      .i_clk,
      .i_rstb,
      .i_enable,
      .i_d,
      .o_q(q_sync_enable)
  );

  dff #(
      .WIDTH(WIDTH),
      .RESET_VALUE(RESET_VALUE),
      .ASYNC_RESET(1'b1),
      .HAS_ENABLE(1'b1)
  ) dut_async_enable (
      .i_clk,
      .i_rstb,
      .i_enable,
      .i_d,
      .o_q(q_async_enable)
  );

  dff #(
      .WIDTH(WIDTH),
      .RESET_VALUE(RESET_VALUE),
      .ASYNC_RESET(1'b0),
      .HAS_ENABLE(1'b0)
  ) dut_sync_no_enable (
      .i_clk,
      .i_rstb,
      .i_enable,
      .i_d,
      .o_q(q_sync_no_enable)
  );

  dff #(
      .WIDTH(WIDTH),
      .RESET_VALUE(RESET_VALUE),
      .ASYNC_RESET(1'b1),
      .HAS_ENABLE(1'b0)
  ) dut_async_no_enable (
      .i_clk,
      .i_rstb,
      .i_enable,
      .i_d,
      .o_q(q_async_no_enable)
  );

  // Asynchronous variants must respond to reset independently of a clock edge.
  always_comb begin
    if (!i_rstb) begin
      assert (q_async_enable == RESET_VALUE);
      assert (q_async_no_enable == RESET_VALUE);
    end
  end

  // Clocked properties compare each variant with the preceding symbolic inputs.
  always_ff @(posedge i_clk) begin
    past_valid <= 1'b1;

    if (past_valid && !$past(i_rstb)) begin
      assert (q_sync_enable == RESET_VALUE);
      assert (q_sync_no_enable == RESET_VALUE);
      assert (q_async_enable == RESET_VALUE);
      assert (q_async_no_enable == RESET_VALUE);
    end

    if (past_valid && i_rstb && $past(i_rstb)) begin
      if ($past(i_enable)) begin
        assert (q_sync_enable == $past(i_d));
        assert (q_async_enable == $past(i_d));
      end else begin
        assert (q_sync_enable == $past(q_sync_enable));
        assert (q_async_enable == $past(q_async_enable));
      end

      assert (q_sync_no_enable == $past(i_d));
      assert (q_async_no_enable == $past(i_d));
    end

    cover (past_valid && i_rstb && $past(i_rstb) && i_enable && !$past(i_enable));
    cover (past_valid && !i_rstb && $past(i_rstb));
  end
endmodule
