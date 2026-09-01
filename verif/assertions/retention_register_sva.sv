module retention_register_sva #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit ASYNC_RESET = 1'b0,
    parameter bit HAS_ENABLE = 1'b1
) (
    input logic             i_clk,
    input logic             i_rstb,
    input logic             i_enable,
    input logic             i_save,
    input logic             i_restore,
    input logic [WIDTH-1:0] i_d,
    input logic [WIDTH-1:0] o_q,
    input logic [WIDTH-1:0] retained_image
);
    logic past_valid;

    initial past_valid = 1'b0;

    always @(posedge i_clk) begin
        past_valid <= 1'b1;
        assert (!$isunknown({i_rstb, i_enable, i_save, i_restore}));
        assert (!(i_save && i_restore));
        assert (!((i_save || i_restore) && HAS_ENABLE && i_enable));

        if (past_valid && !$past(i_rstb)) begin
            assert (o_q == RESET_VALUE);
            assert (retained_image == RESET_VALUE);
        end else if (past_valid && i_rstb && $past(i_rstb)) begin
            if ($past(i_restore)) begin
                assert (o_q == $past(retained_image));
            end else if ($past(i_save)) begin
                assert (o_q == $past(o_q));
                assert (retained_image == $past(o_q));
            end else if (!HAS_ENABLE || $past(i_enable)) begin
                assert (o_q == $past(i_d));
            end else begin
                assert (o_q == $past(o_q));
            end
        end

        reset_covered : cover (!i_rstb);
        save_covered : cover (i_rstb && i_save && !i_restore && (!HAS_ENABLE || !i_enable));
        restore_covered : cover (i_rstb && i_restore && !i_save && (!HAS_ENABLE || !i_enable));
        update_covered : cover (i_rstb && !i_save && !i_restore && (!HAS_ENABLE || i_enable));
    end

    if (HAS_ENABLE) begin : gen_hold_coverage
        always @(posedge i_clk) begin
            hold_covered : cover (i_rstb && !i_save && !i_restore && !i_enable);
        end
    end

    always @(negedge i_rstb) begin
        if (ASYNC_RESET) begin
            #1;
            assert (o_q == RESET_VALUE);
            assert (retained_image == RESET_VALUE);
        end
    end
endmodule
