// Self-checking stimulus and reference model for one DFF parameter profile.
module dff_checker #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit ASYNC_RESET = 1'b0,
    parameter bit HAS_ENABLE = 1'b1,
    parameter int unsigned CHECKER_ID = 0
) (
    input  logic i_clk,
    output logic o_done
);
  timeunit 1ns; timeprecision 1ps;

  localparam int unsigned RANDOM_CYCLES = 64;

  logic             i_rstb;
  logic             i_enable;
  logic [WIDTH-1:0] i_d;
  logic [WIDTH-1:0] o_q;
  logic [WIDTH-1:0] expected_q;

  dff #(
      .WIDTH      (WIDTH),
      .RESET_VALUE(RESET_VALUE),
      .ASYNC_RESET(ASYNC_RESET),
      .HAS_ENABLE (HAS_ENABLE)
  ) dut (
      .*
  );

  // Case equality catches both value mismatches and unexpected unknown states.
  task automatic check_output(input string scenario);
    assert (o_q === expected_q)
    else
      $fatal(
          1,
          "checker %0d (%0d bits, async=%0b, enable=%0b) failed %s: expected %h, got %h",
          CHECKER_ID,
          WIDTH,
          ASYNC_RESET,
          HAS_ENABLE,
          scenario,
          expected_q,
          o_q
      );
  endtask

  initial begin : run_test
    o_done     = 1'b0;
    i_rstb     = 1'b1;
    i_enable   = 1'b0;
    i_d        = '0;
    expected_q = 'x;

    // Drive controls away from the active edge, then sample after NBA updates.
    @(negedge i_clk);
    i_rstb = 1'b0;

    if (ASYNC_RESET) begin
      #1ns;
      expected_q = RESET_VALUE;
      check_output("asynchronous reset assertion");
    end

    @(posedge i_clk);
    #1step;
    expected_q = RESET_VALUE;
    check_output("reset at rising edge");

    @(negedge i_clk);
    i_rstb   = 1'b1;
    i_enable = 1'b1;
    i_d      = {WIDTH{1'b1}};
    @(posedge i_clk);
    #1step;
    expected_q = i_d;
    check_output("enabled capture");

    @(negedge i_clk);
    i_enable = 1'b0;
    i_d      = '0;
    @(posedge i_clk);
    #1step;
    if (!HAS_ENABLE) begin
      expected_q = i_d;
    end
    check_output("disabled behavior");

    @(negedge i_clk);
    i_enable = 1'b1;
    i_d      = ~RESET_VALUE;
    @(posedge i_clk);
    #1step;
    expected_q = i_d;
    check_output("nonreset preload");

    #2ns;
    i_rstb = 1'b0;
    #1ns;
    if (ASYNC_RESET) begin
      expected_q = RESET_VALUE;
    end
    check_output("mid-cycle reset assertion");

    @(posedge i_clk);
    #1step;
    expected_q = RESET_VALUE;
    check_output("reset priority");

    @(negedge i_clk);
    i_rstb = 1'b1;

    // Exercise capture and hold decisions with independent random data bits.
    for (int unsigned cycle = 0; cycle < RANDOM_CYCLES; cycle++) begin
      i_enable = $urandom_range(0, 1) != 0;
      for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
        i_d[bit_index] = $urandom_range(0, 1) != 0;
      end

      @(posedge i_clk);
      #1step;
      if (!HAS_ENABLE || i_enable) begin
        expected_q = i_d;
      end
      check_output("random capture and hold");
      @(negedge i_clk);
    end

    i_rstb = 1'b0;
    #1ns;
    if (ASYNC_RESET) begin
      expected_q = RESET_VALUE;
      check_output("final asynchronous reset");
    end
    @(posedge i_clk);
    #1step;
    expected_q = RESET_VALUE;
    check_output("final clocked reset");

    o_done = 1'b1;
  end
endmodule
