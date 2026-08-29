// Exhaustively prove saturating and wrapping counter behavior for both reset
// structures over a small, fully reachable state space.
module counter_formal;
    localparam int unsigned WIDTH = 3;
    localparam logic [WIDTH-1:0] RESET_VALUE = 3'h3;
    localparam logic [WIDTH-1:0] MaxValue = {WIDTH{1'b1}};

    (* gclk   *) logic i_clk;
    (* anyseq *) logic i_rstb;
    (* anyseq *) logic i_enable;
    (* anyseq *) logic i_clear;
    (* anyseq *) logic i_load;
    (* anyseq *) logic i_direction;
    (* anyseq *) logic [WIDTH-1:0] i_load_value;

    logic [WIDTH-1:0] count_sync_sat, count_sync_wrap, count_async_sat, count_async_wrap;
    logic overflow_sync_sat, overflow_sync_wrap, overflow_async_sat, overflow_async_wrap;
    logic underflow_sync_sat, underflow_sync_wrap, underflow_async_sat, underflow_async_wrap;
    logic terminal_sync_sat, terminal_sync_wrap, terminal_async_sat, terminal_async_wrap;
    logic past_valid = 1'b0;

    counter #(
        .WIDTH(WIDTH),
        .RESET_VALUE(RESET_VALUE),
        .ASYNC_RESET(1'b0),
        .SATURATE(1'b1)
    ) dut_sync_sat (
        .o_count(count_sync_sat),
        .o_overflow(overflow_sync_sat),
        .o_underflow(underflow_sync_sat),
        .o_terminal(terminal_sync_sat),
        .*
    );

    counter #(
        .WIDTH(WIDTH),
        .RESET_VALUE(RESET_VALUE),
        .ASYNC_RESET(1'b0),
        .SATURATE(1'b0)
    ) dut_sync_wrap (
        .o_count(count_sync_wrap),
        .o_overflow(overflow_sync_wrap),
        .o_underflow(underflow_sync_wrap),
        .o_terminal(terminal_sync_wrap),
        .*
    );

    counter #(
        .WIDTH(WIDTH),
        .RESET_VALUE(RESET_VALUE),
        .ASYNC_RESET(1'b1),
        .SATURATE(1'b1)
    ) dut_async_sat (
        .o_count(count_async_sat),
        .o_overflow(overflow_async_sat),
        .o_underflow(underflow_async_sat),
        .o_terminal(terminal_async_sat),
        .*
    );

    counter #(
        .WIDTH(WIDTH),
        .RESET_VALUE(RESET_VALUE),
        .ASYNC_RESET(1'b1),
        .SATURATE(1'b0)
    ) dut_async_wrap (
        .o_count(count_async_wrap),
        .o_overflow(overflow_async_wrap),
        .o_underflow(underflow_async_wrap),
        .o_terminal(terminal_async_wrap),
        .*
    );

    function automatic logic [WIDTH+1:0] expected_step(
        input logic [WIDTH-1:0] previous_count,
        input logic previous_rstb,
        input logic previous_clear,
        input logic previous_load,
        input logic previous_enable,
        input logic previous_direction,
        input logic [WIDTH-1:0] previous_load_value,
        input logic saturate_mode
    );
        logic [WIDTH-1:0] next_count;
        logic next_overflow;
        logic next_underflow;
        begin
            next_count = previous_count;
            next_overflow = 1'b0;
            next_underflow = 1'b0;
            if (!previous_rstb || previous_clear) begin
                next_count = RESET_VALUE;
            end else if (previous_load) begin
                next_count = previous_load_value;
            end else if (previous_enable) begin
                if (!previous_direction) begin
                    if (previous_count == MaxValue) begin
                        next_overflow = 1'b1;
                        if (!saturate_mode) next_count = '0;
                    end else next_count = previous_count + 1'b1;
                end else begin
                    if (previous_count == '0) begin
                        next_underflow = 1'b1;
                        if (!saturate_mode) next_count = MaxValue;
                    end else next_count = previous_count - 1'b1;
                end
            end
            expected_step = {next_overflow, next_underflow, next_count};
        end
    endfunction

    always_comb begin
        if (!i_rstb) begin
            assert (count_async_sat == RESET_VALUE && !overflow_async_sat && !underflow_async_sat);
            assert (count_async_wrap == RESET_VALUE && !overflow_async_wrap && !underflow_async_wrap);
        end
        assert (terminal_sync_sat == (i_direction ? count_sync_sat == '0 : count_sync_sat == MaxValue));
        assert (terminal_sync_wrap == (i_direction ? count_sync_wrap == '0 : count_sync_wrap == MaxValue));
        assert (terminal_async_sat == (i_direction ? count_async_sat == '0 : count_async_sat == MaxValue));
        assert (terminal_async_wrap == (i_direction ? count_async_wrap == '0 : count_async_wrap == MaxValue));
    end

    always_ff @(posedge i_clk) begin
        past_valid <= 1'b1;
        if (past_valid) begin
            assert ({overflow_sync_sat, underflow_sync_sat, count_sync_sat} == expected_step(
                $past(count_sync_sat),
                $past(i_rstb),
                $past(i_clear),
                $past(i_load),
                $past(i_enable),
                $past(i_direction),
                $past(i_load_value),
                1'b1
            ));
            assert ({overflow_sync_wrap, underflow_sync_wrap, count_sync_wrap} == expected_step(
                $past(count_sync_wrap),
                $past(i_rstb),
                $past(i_clear),
                $past(i_load),
                $past(i_enable),
                $past(i_direction),
                $past(i_load_value),
                1'b0
            ));
            if (!i_rstb) begin
                assert ({overflow_async_sat, underflow_async_sat, count_async_sat} == {2'b00, RESET_VALUE});
                assert ({overflow_async_wrap, underflow_async_wrap, count_async_wrap} ==
                        {2'b00, RESET_VALUE});
            end else begin
                assert ({overflow_async_sat, underflow_async_sat, count_async_sat} == expected_step(
                    $past(count_async_sat),
                    $past(i_rstb),
                    $past(i_clear),
                    $past(i_load),
                    $past(i_enable),
                    $past(i_direction),
                    $past(i_load_value),
                    1'b1
                ));
                assert ({overflow_async_wrap, underflow_async_wrap, count_async_wrap} == expected_step(
                    $past(count_async_wrap),
                    $past(i_rstb),
                    $past(i_clear),
                    $past(i_load),
                    $past(i_enable),
                    $past(i_direction),
                    $past(i_load_value),
                    1'b0
                ));
            end
            assert (!(overflow_sync_sat && underflow_sync_sat));
            assert (!(overflow_sync_wrap && underflow_sync_wrap));
            assert (!(overflow_async_sat && underflow_async_sat));
            assert (!(overflow_async_wrap && underflow_async_wrap));
        end

        cover (past_valid && overflow_sync_sat);
        cover (past_valid && underflow_sync_wrap);
    end
endmodule
