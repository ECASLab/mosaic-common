`timescale 1ns / 1ps

// Interface and implementation-aware properties for the portable synchronizer.
module reset_synchronizer_sva #(
    parameter int unsigned STAGES = 2
) (
    input logic              i_clk,
    input logic              i_async_rstb,
    input logic              o_rstb,
    input logic [STAGES-1:0] sync_stages
);
    default clocking cb @(posedge i_clk);
    endclocking

    reset_input_known :
    assert property (!$isunknown(i_async_rstb));

    output_tracks_final_stage :
    assert property (o_rstb == sync_stages[STAGES-1]);

    output_requires_released_input :
    assert property (o_rstb |-> i_async_rstb);

    release_cannot_skip_a_stage :
    assert property ((sync_stages[STAGES-1:1] & ~sync_stages[STAGES-2:0]) == '0);

    always @(negedge i_async_rstb) begin
        #1step;
        asynchronous_assertion_clears_chain : assert (sync_stages == '0 && !o_rstb);
    end

    reset_asserted_covered :
    cover property (!i_async_rstb);
    release_progress_covered :
    cover property (i_async_rstb && !o_rstb && sync_stages != '0);
    release_complete_covered :
    cover property ($rose(o_rstb));
    reassert_during_release_covered :
    cover property (i_async_rstb && !o_rstb && sync_stages != '0 ##1 !i_async_rstb);
endmodule
