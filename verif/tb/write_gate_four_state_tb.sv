/// Four-state qualification fixture for illegal write-gate controls.
module write_gate_four_state_tb;

    logic i_write_enable = 1'b0;
    logic i_suppress = 1'b0;
    logic o_write_enable;
    logic o_write_suppressed;

    write_gate #(.WIDTH(1)) dut (.*);
    write_gate_sva #(.WIDTH(1)) i_write_gate_sva (.*);

    initial begin
`ifdef WRITE_GATE_INJECT_SUPPRESS
        i_write_enable = 1'b1;
`else
        i_write_enable = 1'b0;
`endif
        i_suppress = 1'b0;
        #1;

`ifdef WRITE_GATE_INJECT_Z
`ifdef WRITE_GATE_INJECT_SUPPRESS
        i_suppress = 1'bz;
`else
        i_write_enable = 1'bz;
`endif
`else
`ifdef WRITE_GATE_INJECT_SUPPRESS
        i_suppress = 1'bx;
`else
        i_write_enable = 1'bx;
`endif
`endif
        #1;

`ifdef WRITE_GATE_DISABLE_UNKNOWN_MONITOR
        if (!$isunknown({i_write_enable, i_suppress, o_write_enable, o_write_suppressed})) begin
            $fatal(1, "WRITE_GATE_FOUR_STATE_STIMULUS_BROKEN");
        end
        $display("WRITE_GATE_UNKNOWN_CONTROL_STIMULUS_REACHED");
        $finish;
`else
        $fatal(1, "WRITE_GATE_UNKNOWN_CONTROL_MONITOR_DID_NOT_FIRE");
`endif
    end

endmodule
