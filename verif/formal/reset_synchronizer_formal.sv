module reset_synchronizer_formal;
    (* gclk   *)logic i_clk;
    (* anyseq *)logic i_async_rstb;
    logic o_rstb_2;
    logic o_rstb_3;
    logic o_rstb_4;
    logic past_valid = 1'b0;

    reset_synchronizer #(
        .STAGES(2)
    ) dut_stages_2 (
        .i_clk,
        .i_async_rstb,
        .o_rstb(o_rstb_2)
    );

    reset_synchronizer #(
        .STAGES(3)
    ) dut_stages_3 (
        .i_clk,
        .i_async_rstb,
        .o_rstb(o_rstb_3)
    );

    reset_synchronizer #(
        .STAGES(4)
    ) dut_stages_4 (
        .i_clk,
        .i_async_rstb,
        .o_rstb(o_rstb_4)
    );

    always @(posedge i_clk) begin
        past_valid <= 1'b1;
        if (!past_valid) assume (!i_async_rstb);
        assert (!(o_rstb_4 && !o_rstb_3));
        assert (!(o_rstb_3 && !o_rstb_2));
        cover (past_valid && o_rstb_2 && o_rstb_3 && o_rstb_4);
    end
endmodule
