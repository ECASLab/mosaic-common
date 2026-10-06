`timescale 1ns / 1ps

// Verification-only mutations used to qualify the reset-synchronizer checker.
`ifndef RESET_SYNCHRONIZER_FAULT_MODE
`define RESET_SYNCHRONIZER_FAULT_MODE 0
`endif

module reset_synchronizer #(
    parameter int unsigned STAGES = 2
) (
    input  logic i_clk,
    input  logic i_async_rstb,
    output logic o_rstb
);
    localparam int unsigned FaultMode = `RESET_SYNCHRONIZER_FAULT_MODE;
    logic [STAGES-1:0] sync_stages;

    if (FaultMode == 1) begin : gen_synchronous_assertion
        // Incorrectly waits for a clock edge before asserting reset.
        always_ff @(posedge i_clk) begin
            if (!i_async_rstb) sync_stages <= '0;
            else sync_stages <= {sync_stages[STAGES-2:0], 1'b1};
        end
        assign o_rstb = sync_stages[STAGES-1];
    end else if (FaultMode == 2) begin : gen_premature_output
        always_ff @(posedge i_clk or negedge i_async_rstb) begin
            if (!i_async_rstb) sync_stages <= '0;
            else sync_stages <= {sync_stages[STAGES-2:0], 1'b1};
        end
        assign o_rstb = sync_stages[STAGES-2];
    end else if (FaultMode == 3) begin : gen_skipped_stages
        always_ff @(posedge i_clk or negedge i_async_rstb) begin
            if (!i_async_rstb) sync_stages <= '0;
            else sync_stages <= '1;
        end
        assign o_rstb = sync_stages[STAGES-1];
    end else begin : gen_incomplete_clear
        always_ff @(posedge i_clk or negedge i_async_rstb) begin
            if (!i_async_rstb) sync_stages <= {1'b1, {(STAGES - 1) {1'b0}}};
            else sync_stages <= {sync_stages[STAGES-2:0], 1'b1};
        end
        assign o_rstb = sync_stages[STAGES-1];
    end
endmodule

`undef RESET_SYNCHRONIZER_FAULT_MODE
