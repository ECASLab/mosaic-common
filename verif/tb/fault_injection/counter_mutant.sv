`timescale 1ns / 1ps

// Verification-only counter mutants. COUNTER_FAULT_MODE selects one incorrect
// behavior so the production checker can demonstrate fault detection.
`ifndef COUNTER_FAULT_MODE
`define COUNTER_FAULT_MODE 0
`endif

module counter #(
    parameter int unsigned             WIDTH       = 32,
    parameter logic        [WIDTH-1:0] RESET_VALUE = '0,
    parameter bit                      ASYNC_RESET = 1'b0,
    parameter bit                      SATURATE    = 1'b1
) (
    input  logic             i_clk,
    input  logic             i_rstb,
    input  logic             i_enable,
    input  logic             i_clear,
    input  logic             i_load,
    input  logic             i_direction,
    input  logic [WIDTH-1:0] i_load_value,
    output logic [WIDTH-1:0] o_count,
    output logic             o_overflow,
    output logic             o_underflow,
    output logic             o_terminal
);
    localparam int unsigned FaultMode = `COUNTER_FAULT_MODE;
    localparam logic [WIDTH-1:0] MaxValue = {WIDTH{1'b1}};
    logic [WIDTH-1:0] next_count;
    logic next_overflow;
    logic next_underflow;

    always_comb begin
        if (FaultMode == 7) begin
            o_terminal = i_direction ? (o_count == MaxValue) : (o_count == '0);
        end else begin
            o_terminal = i_direction ? (o_count == '0) : (o_count == MaxValue);
        end
    end

    always_comb begin
        logic effective_direction;
        effective_direction = (FaultMode == 3) ? ~i_direction : i_direction;
        next_count          = o_count;
        next_overflow       = 1'b0;
        next_underflow      = 1'b0;

        if (i_clear && (FaultMode != 1)) begin
            next_count = RESET_VALUE;
        end else if (i_load && (FaultMode != 2)) begin
            next_count = i_load_value;
        end else if (i_enable) begin
            if (!effective_direction) begin
                if (o_count == MaxValue) begin
                    if (FaultMode != 6) next_overflow = 1'b1;
                    if ((!SATURATE && (FaultMode != 5)) || (SATURATE && (FaultMode == 4))) begin
                        next_count = '0;
                    end
                end else begin
                    next_count = o_count + 1'b1;
                end
            end else begin
                if (o_count == '0) begin
                    if (FaultMode != 6) next_underflow = 1'b1;
                    if ((!SATURATE && (FaultMode != 5)) || (SATURATE && (FaultMode == 4))) begin
                        next_count = MaxValue;
                    end
                end else begin
                    next_count = o_count - 1'b1;
                end
            end
        end
    end

    if (ASYNC_RESET) begin : gen_async_reset
        always_ff @(posedge i_clk or negedge i_rstb) begin
            if (!i_rstb) begin
                o_count     <= (FaultMode == 8) ? ~RESET_VALUE : RESET_VALUE;
                o_overflow  <= 1'b0;
                o_underflow <= 1'b0;
            end else begin
                o_count     <= next_count;
                o_overflow  <= next_overflow;
                o_underflow <= next_underflow;
            end
        end
    end else begin : gen_sync_reset
        always_ff @(posedge i_clk) begin
            if (!i_rstb) begin
                o_count     <= (FaultMode == 8) ? ~RESET_VALUE : RESET_VALUE;
                o_overflow  <= 1'b0;
                o_underflow <= 1'b0;
            end else begin
                o_count     <= next_count;
                o_overflow  <= next_overflow;
                o_underflow <= next_underflow;
            end
        end
    end
endmodule

`undef COUNTER_FAULT_MODE
