`timescale 1ns / 1ps

/// Four-state qualification for deterministic unknown-selection behavior.
module mux_four_state_tb;

    localparam logic [15:0] DefaultValue = 16'ha55a;

    logic [ 2:0][15:0] i_data = {16'h3333, 16'h2222, 16'h1111};
    logic [ 1:0]       i_select = 2'b01;
    logic [15:0]       o_data;
    logic              o_select_valid;

    mux #(
        .NUM_INPUTS   (3),
        .DATA_WIDTH   (16),
        .DEFAULT_VALUE(DefaultValue)
    ) dut (
        .*
    );

    mux_sva #(
        .NUM_INPUTS   (3),
        .DATA_WIDTH   (16),
        .DEFAULT_VALUE(DefaultValue)
    ) i_mux_sva (
        .*
    );

    initial begin
        #1ns;
`ifdef MUX_INJECT_Z
        i_select = 'z;
`else
        i_select = 'x;
`endif
        #1ns;

        assert ((o_data === DefaultValue) && (o_select_valid === 1'b0))
        else $fatal(1, "MUX_UNKNOWN_SELECTION_DID_NOT_FAIL_CLOSED");
`ifdef MUX_DISABLE_UNKNOWN_MONITOR
        $display("MUX_UNKNOWN_SELECTION_FAIL_CLOSED_CONFIRMED");
        $finish;
`else
        $fatal(1, "MUX_UNKNOWN_SELECTION_MONITOR_DID_NOT_FIRE");
`endif
    end

endmodule
