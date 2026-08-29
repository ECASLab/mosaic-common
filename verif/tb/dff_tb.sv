// Parallel regression across representative widths, reset values, reset styles,
// and enable configurations.
module dff_tb;
  timeunit 1ns; timeprecision 1ps;

  logic i_clk;
  logic [6:0] done;

  always #5ns i_clk = ~i_clk;

  // Initialize the shared free-running clock before checker stimulus starts.
  initial begin
    i_clk = 1'b0;
  end

  dff_checker #(
      .WIDTH(1),
      .ASYNC_RESET(1'b0),
      .HAS_ENABLE(1'b1),
      .CHECKER_ID(0)
  ) checker_sync_bit (
      .i_clk,
      .o_done(done[0])
  );

  dff_checker #(
      .WIDTH(1),
      .ASYNC_RESET(1'b1),
      .HAS_ENABLE(1'b1),
      .CHECKER_ID(1)
  ) checker_async_bit (
      .i_clk,
      .o_done(done[1])
  );

  dff_checker #(
      .WIDTH(8),
      .RESET_VALUE(8'hA5),
      .ASYNC_RESET(1'b0),
      .HAS_ENABLE(1'b1),
      .CHECKER_ID(2)
  ) checker_sync_byte (
      .i_clk,
      .o_done(done[2])
  );

  dff_checker #(
      .WIDTH(32),
      .RESET_VALUE(32'h5A5A_A5A5),
      .ASYNC_RESET(1'b1),
      .HAS_ENABLE(1'b1),
      .CHECKER_ID(3)
  ) checker_async_scalar (
      .i_clk,
      .o_done(done[3])
  );

  dff_checker #(
      .WIDTH(32),
      .ASYNC_RESET(1'b0),
      .HAS_ENABLE(1'b0),
      .CHECKER_ID(4)
  ) checker_sync_always_enabled (
      .i_clk,
      .o_done(done[4])
  );

  dff_checker #(
      .WIDTH(32),
      .RESET_VALUE(32'hC3C3_3C3C),
      .ASYNC_RESET(1'b1),
      .HAS_ENABLE(1'b0),
      .CHECKER_ID(5)
  ) checker_async_always_enabled (
      .i_clk,
      .o_done(done[5])
  );

  dff_checker #(
      .WIDTH(128),
      .RESET_VALUE(128'h0123_4567_89AB_CDEF_FEDC_BA98_7654_3210),
      .ASYNC_RESET(1'b0),
      .HAS_ENABLE(1'b1),
      .CHECKER_ID(6)
  ) checker_sync_vector (
      .i_clk,
      .o_done(done[6])
  );

  // Finish only after every independently running checker completes.
  // Convert a stalled checker or clocking failure into a deterministic failure.
  initial begin
    wait (&done);
    $display("PASS: all dff configurations completed");
    $finish;
  end

  initial begin
    #20us;
    $fatal(1, "dff regression timed out");
  end
endmodule
