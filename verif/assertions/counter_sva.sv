`timescale 1ns / 1ps

// Interface contract shared by simulation and assertion-capable flows.
module counter_sva #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit ASYNC_RESET = 1'b0,
    parameter bit SATURATE = 1'b1
) (
    input logic             i_clk,
    input logic             i_rstb,
    input logic             i_enable,
    input logic             i_clear,
    input logic             i_load,
    input logic             i_direction,
    input logic [WIDTH-1:0] i_load_value,
    input logic [WIDTH-1:0] o_count,
    input logic             o_overflow,
    input logic             o_underflow,
    input logic             o_terminal
);
    localparam logic [WIDTH-1:0] MaxValue = {WIDTH{1'b1}};

    default clocking cb @(posedge i_clk);
    endclocking

    controls_known :
    assert property (!$isunknown({i_rstb, i_clear, i_load, i_enable}));

    active_direction_known :
    assert property (i_rstb && i_enable && !i_clear && !i_load |-> !$isunknown(i_direction));

    reset_wins :
    assert property (!i_rstb |=> o_count == RESET_VALUE && !o_overflow && !o_underflow);

    clear_wins :
    assert property (disable iff (!i_rstb) i_clear
                    |=> o_count == RESET_VALUE && !o_overflow && !o_underflow);

    load_wins :
    assert property (disable iff (!i_rstb) !i_clear && i_load |=> o_count == $past(
        i_load_value
    ) && !o_overflow && !o_underflow);

    hold_preserves_count :
    assert property (disable iff (!i_rstb) !i_clear && !i_load && !i_enable |=> $stable(
        o_count
    ) && !o_overflow && !o_underflow);

    increment_updates :
    assert property (disable iff (!i_rstb)
                    !i_clear && !i_load && i_enable && !i_direction && o_count != MaxValue
                    |=> o_count == $past(
        o_count
    ) + 1'b1 && !o_overflow && !o_underflow);

    decrement_updates :
    assert property (disable iff (!i_rstb)
                    !i_clear && !i_load && i_enable && i_direction && o_count != '0
                    |=> o_count == $past(
        o_count
    ) - 1'b1 && !o_overflow && !o_underflow);

    overflow_behavior :
    assert property (disable iff (!i_rstb)
                    !i_clear && !i_load && i_enable && !i_direction && o_count == MaxValue
                    |=> o_overflow && !o_underflow &&
                        o_count == (SATURATE ? MaxValue : '0));

    underflow_behavior :
    assert property (disable iff (!i_rstb)
                    !i_clear && !i_load && i_enable && i_direction && o_count == '0
                    |=> o_underflow && !o_overflow &&
                        o_count == (SATURATE ? '0 : MaxValue));

    events_are_exclusive :
    assert property (!(o_overflow && o_underflow));

    terminal_matches_direction :
    assert property (!$isunknown(
        i_direction
    ) |-> o_terminal == (i_direction ? (o_count == '0) : (o_count == MaxValue)));

    if (ASYNC_RESET) begin : gen_async_reset_assertion
        always @(negedge i_rstb) begin
            #1step;
            async_reset_updates_immediately :
            assert (o_count == RESET_VALUE && !o_overflow && !o_underflow);
        end
    end

    clear_covered :
    cover property (i_rstb && i_clear);
    load_covered :
    cover property (i_rstb && !i_clear && i_load);
    increment_covered :
    cover property (i_rstb && !i_clear && !i_load && i_enable && !i_direction);
    decrement_covered :
    cover property (i_rstb && !i_clear && !i_load && i_enable && i_direction);
    hold_covered :
    cover property (i_rstb && !i_clear && !i_load && !i_enable);
    overflow_covered :
    cover property (o_overflow);
    underflow_covered :
    cover property (o_underflow);
endmodule
