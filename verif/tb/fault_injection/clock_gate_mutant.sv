`timescale 1ns / 1ps

// Verification-only clock-gate mutants selected by CLOCK_GATE_FAULT_MODE.
`ifndef CLOCK_GATE_FAULT_MODE
`define CLOCK_GATE_FAULT_MODE 0
`endif

module clock_gate (
    input  logic i_clk,
    input  logic i_enable,
    input  logic i_test_enable,
    output logic o_gclk
);
  localparam int unsigned FaultMode = `CLOCK_GATE_FAULT_MODE;

  if (FaultMode == 1) begin : gen_combinational_gate
    assign o_gclk = i_clk & (i_enable | i_test_enable);
  end else begin : gen_latched_gate
    logic enable_latched;

    always_latch begin
      if ((FaultMode == 4) ? i_clk : !i_clk) begin
        if (FaultMode == 2) begin
          enable_latched = i_enable;
        end else if (FaultMode == 3) begin
          enable_latched = ~i_enable | i_test_enable;
        end else begin
          enable_latched = i_enable | i_test_enable;
        end
      end
    end

    assign o_gclk = i_clk & enable_latched;
  end
endmodule

`undef CLOCK_GATE_FAULT_MODE
