`timescale 1ns / 1ps

/// Four-state qualification for deterministic unknown-control behavior.
module decoder_four_state_tb;

    logic       i_enable = 1'b1;
    logic [1:0] i_select = 2'b01;
    logic [2:0] o_decoded;
    logic       o_select_valid;

    decoder #(.NUM_OUTPUTS(3)) dut (.*);

    decoder_sva #(.NUM_OUTPUTS(3)) i_decoder_sva (.*);

    initial begin
        #1ns;
`ifdef DECODER_INJECT_ENABLE
`ifdef DECODER_INJECT_Z
        i_enable = 1'bz;
`else
        i_enable = 1'bx;
`endif
`else
`ifdef DECODER_INJECT_Z
        i_select = 'z;
`else
        i_select = 'x;
`endif
`endif
        #1ns;

        assert ((o_decoded === '0) && (o_select_valid === 1'b0))
        else $fatal(1, "DECODER_UNKNOWN_CONTROL_DID_NOT_FAIL_CLOSED");
`ifdef DECODER_DISABLE_UNKNOWN_MONITOR
        $display("DECODER_UNKNOWN_CONTROL_FAIL_CLOSED_CONFIRMED");
        $finish;
`else
        $fatal(1, "DECODER_UNKNOWN_CONTROL_MONITOR_DID_NOT_FIRE");
`endif
    end

endmodule
