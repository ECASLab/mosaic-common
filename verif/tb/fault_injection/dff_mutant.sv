`timescale 1ns / 1ps

// Verification-only DFF mutants. DFF_FAULT_MODE selects one deliberately
// incorrect behavior so the normal checker can demonstrate fault detection.
`ifndef DFF_FAULT_MODE
`define DFF_FAULT_MODE 0
`endif

module dff #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit ASYNC_RESET = 1'b0,
    parameter bit HAS_ENABLE = 1'b1
) (
    input  logic             i_clk,
    input  logic             i_rstb,
    input  logic             i_enable,
    input  logic [WIDTH-1:0] i_d,
    output logic [WIDTH-1:0] o_q
);
  localparam int unsigned FAULT_MODE = `DFF_FAULT_MODE;

  if (ASYNC_RESET) begin : gen_async_reset
    if (HAS_ENABLE) begin : gen_enable
      always_ff @(posedge i_clk or negedge i_rstb) begin
        if (!i_rstb) begin
          o_q <= (FAULT_MODE == 1) ? ~RESET_VALUE : RESET_VALUE;
        end else if (FAULT_MODE == 3) begin
          o_q <= o_q;
        end else if (i_enable || (FAULT_MODE == 2)) begin
          o_q <= i_d;
        end
      end
    end else begin : gen_no_enable
      always_ff @(posedge i_clk or negedge i_rstb) begin
        if (!i_rstb) begin
          o_q <= (FAULT_MODE == 1) ? ~RESET_VALUE : RESET_VALUE;
        end else if ((FAULT_MODE != 4) || i_enable) begin
          o_q <= i_d;
        end
      end
    end
  end else begin : gen_sync_reset
    if (HAS_ENABLE) begin : gen_enable
      always_ff @(posedge i_clk) begin
        if (!i_rstb) begin
          o_q <= (FAULT_MODE == 1) ? ~RESET_VALUE : RESET_VALUE;
        end else if (FAULT_MODE == 3) begin
          o_q <= o_q;
        end else if (i_enable || (FAULT_MODE == 2)) begin
          o_q <= i_d;
        end
      end
    end else begin : gen_no_enable
      always_ff @(posedge i_clk) begin
        if (!i_rstb) begin
          o_q <= (FAULT_MODE == 1) ? ~RESET_VALUE : RESET_VALUE;
        end else if ((FAULT_MODE != 4) || i_enable) begin
          o_q <= i_d;
        end
      end
    end
  end
endmodule

`undef DFF_FAULT_MODE
