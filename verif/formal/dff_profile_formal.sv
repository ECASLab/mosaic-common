// Focused formal harness whose parameters are supplied by mosaic-flow profiles.
module dff_profile_formal #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit ASYNC_RESET = 1'b0,
    parameter bit HAS_ENABLE = 1'b1
);
    (* gclk *) logic i_clk;
    (* anyseq *) logic i_rstb;
    (* anyseq *) logic i_enable;
    (* anyseq *) logic [WIDTH-1:0] i_d;
    logic [WIDTH-1:0] o_q;
    logic past_valid = 1'b0;

    dff #(
        .WIDTH(WIDTH),
        .RESET_VALUE(RESET_VALUE),
        .ASYNC_RESET(ASYNC_RESET),
        .HAS_ENABLE(HAS_ENABLE)
    ) dut (
        .i_clk,
        .i_rstb,
        .i_enable,
        .i_d,
        .o_q
    );

    always_comb begin
        if (ASYNC_RESET && !i_rstb) begin
            assert (o_q == RESET_VALUE);
        end
    end

    always_ff @(posedge i_clk) begin
        past_valid <= 1'b1;
        if (past_valid && !$past(i_rstb)) begin
            assert (o_q == RESET_VALUE);
        end else if (past_valid && i_rstb && $past(i_rstb)) begin
            if (!HAS_ENABLE || $past(i_enable)) begin
                assert (o_q == $past(i_d));
            end else begin
                assert (o_q == $past(o_q));
            end
        end
        cover (past_valid && i_rstb && $past(i_rstb));
    end
endmodule
