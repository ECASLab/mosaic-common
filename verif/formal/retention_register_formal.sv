module retention_register_formal;
    localparam int unsigned WIDTH = 8;
    (* gclk *) logic i_clk;
    (* anyseq *) logic i_rstb;
    (* anyseq *) logic i_enable;
    (* anyseq *) logic i_save;
    (* anyseq *) logic i_restore;
    (* anyseq *) logic [WIDTH-1:0] i_d;
    logic [WIDTH-1:0] o_q;
    logic [WIDTH-1:0] model_q;
    logic [WIDTH-1:0] model_retained;
    logic f_past_valid;

    retention_register #(.WIDTH(WIDTH)) dut (.*);

    initial begin
        assume (!i_rstb);
        f_past_valid = 1'b0;
    end

    always_ff @(posedge i_clk) begin
        if (!i_rstb) begin
            model_q <= '0;
            model_retained <= '0;
        end else if (i_restore) begin
            model_q <= model_retained;
        end else if (i_save) begin
            model_retained <= model_q;
        end else if (i_enable) begin
            model_q <= i_d;
        end
    end

    always_ff @(posedge i_clk) begin
        f_past_valid <= 1'b1;
        if (f_past_valid) begin
            assert (o_q == model_q);
        end
        assume (!(i_save && i_restore));
        assume (!((i_save || i_restore) && i_enable));
    end
endmodule
