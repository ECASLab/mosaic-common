module reset_synchronizer (
    i_clk,
    i_async_rstb,
    o_rstb
);
    input i_clk;
    input i_async_rstb;
    output o_rstb;
    reg [1:0] sync_stages;

    always @(posedge i_clk or negedge i_async_rstb) begin
        if (!i_async_rstb) sync_stages <= 2'b00;
        else sync_stages <= {sync_stages[0], 1'b1};
    end

    assign o_rstb = sync_stages[0];
endmodule
