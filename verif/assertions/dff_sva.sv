`timescale 1ns / 1ps

// Interface-level safety and reachability properties shared by simulation and
// assertion-capable verification flows.
module dff_sva #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit ASYNC_RESET = 1'b0,
    parameter bit HAS_ENABLE = 1'b1
) (
    input logic             i_clk,
    input logic             i_rstb,
    input logic             i_enable,
    input logic [WIDTH-1:0] i_d,
    input logic [WIDTH-1:0] o_q
);
  // Functional properties sample at the DFF capture edge.
  default clocking cb @(posedge i_clk);
  endclocking

  // Unknown active controls make the sequential behavior ambiguous.
  control_reset_known :
  assert property (!$isunknown(i_rstb));

  control_enable_known :
  assert property (i_rstb && HAS_ENABLE |-> !$isunknown(i_enable));

  // Check the three possible data behaviors after reset is excluded.
  output_updates_when_enabled :
  assert property (disable iff (!i_rstb) (HAS_ENABLE && i_enable) |=> o_q == $past(i_d));

  output_holds_when_disabled :
  assert property (disable iff (!i_rstb) (HAS_ENABLE && !i_enable) |=> $stable(o_q));

  output_updates_without_enable :
  assert property (disable iff (!i_rstb) !HAS_ENABLE |=> o_q == $past(i_d));

  reset_wins_at_clock :
  assert property (!i_rstb |=> o_q == RESET_VALUE);

  // The asynchronous structure must update independently of a capture edge.
  if (ASYNC_RESET) begin : gen_async_reset_assertion
    always @(negedge i_rstb) begin
      #1step;
      async_reset_updates_immediately : assert (o_q == RESET_VALUE);
    end
  end

  // Reachability covers distinguish every functional antecedent used above.
  reset_covered :
  cover property (!i_rstb);

  reset_priority_covered :
  cover property (!i_rstb && i_enable && (i_d != RESET_VALUE));

  if (HAS_ENABLE) begin : gen_hold_cover
    enabled_capture_covered :
    cover property (i_rstb && i_enable);

    hold_covered :
    cover property (i_rstb && !i_enable);
  end else begin : gen_always_capture_cover
    always_capture_covered :
    cover property (i_rstb);
  end

  if (ASYNC_RESET) begin : gen_async_reset_cover
    async_reset_covered :
    cover property (@(negedge i_rstb) 1'b1);
  end
endmodule
