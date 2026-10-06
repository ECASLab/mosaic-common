`timescale 1ns / 1ps

module clock_gate_tb;
  timeunit 1ns; timeprecision 1ps;

  logic i_clk;
  logic i_enable;
  logic i_test_enable;
  logic o_gclk;
  logic expected_enable;
  int unsigned propagated_pulses;

  clock_gate dut (.*);

  always #5ns i_clk = ~i_clk;

  initial i_clk = 1'b0;

  always_latch begin
    if (!i_clk) begin
      expected_enable = i_enable | i_test_enable;
    end
  end

  always @(i_clk or o_gclk or expected_enable) begin
    assert (o_gclk === (i_clk & expected_enable))
    else $fatal(1, "gated clock mismatch at %0t", $time);
  end

  always @(posedge o_gclk) begin
    assert (i_clk)
    else $fatal(1, "gated clock rose without source clock");
    propagated_pulses++;
  end

  task automatic set_controls(input logic enable_value, input logic test_value);
    i_enable = enable_value;
    i_test_enable = test_value;
    #1ps;
  endtask

  initial begin
    propagated_pulses = 0;
    i_enable = 1'b0;
    i_test_enable = 1'b0;

    // Disabled startup and low-phase functional enable.
    #2ns;
    set_controls(1'b1, 1'b0);
    repeat (2) @(negedge i_clk);

    // High-phase changes cannot truncate the active pulse.
    @(posedge i_clk);
    #2ns;
    set_controls(1'b0, 1'b0);
    @(negedge i_clk);
    assert (!o_gclk);

    // Test enable forces complete pulses through a functionally closed gate.
    #1ns;
    set_controls(1'b0, 1'b1);
    repeat (2) @(negedge i_clk);
    set_controls(1'b1, 1'b1);
    @(negedge i_clk);
    @(posedge i_clk);
    #2ns;
    set_controls(1'b1, 1'b0);
    @(negedge i_clk);

    // Repeated low- and high-phase transitions exercise both controls.
    repeat (32) begin
      if ($urandom_range(0, 1) != 0) begin
        @(negedge i_clk);
        #1ns;
      end else begin
        @(posedge i_clk);
        #1ns;
      end
      set_controls($urandom_range(0, 1) != 0, $urandom_range(0, 1) != 0);
    end

    @(negedge i_clk);
    set_controls(1'b0, 1'b0);
    repeat (2) @(negedge i_clk);
    assert (propagated_pulses > 4);
    $display("PASS: glitch-free clock-gate regression completed");
    $finish;
  end

  initial begin
    #10us;
    $fatal(1, "clock-gate regression timed out");
  end
endmodule
