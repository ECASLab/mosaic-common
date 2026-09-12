// Focused parameter-profile testbench. The broad dff_tb regression remains a
// separate unparameterized smoke suite.
module dff_profile_tb #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit ASYNC_RESET = 1'b0,
    parameter bit HAS_ENABLE = 1'b1
);
  timeunit 1ns; timeprecision 1ps;

  logic i_clk;
  logic done;

  initial i_clk = 1'b0;

  always #5ns i_clk = ~i_clk;

  dff_checker #(
      .WIDTH(WIDTH),
      .RESET_VALUE(RESET_VALUE),
      .ASYNC_RESET(ASYNC_RESET),
      .HAS_ENABLE(HAS_ENABLE)
  ) u_checker (
      .i_clk,
      .o_done(done)
  );

  initial begin
    wait (done);
    $display("PASS: dff parameter profile completed");
    $finish;
  end

  initial begin
    #20us;
    $fatal(1, "dff parameter-profile regression timed out");
  end
endmodule
