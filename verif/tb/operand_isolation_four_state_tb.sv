/// Four-state qualification fixture for an illegal isolation control.
module operand_isolation_four_state_tb;

    logic [3:0] i_data = 4'ha;
    logic       i_isolate = 1'b0;
    logic [3:0] o_data;

    operand_isolation #(
        .WIDTH(4),
        .CLAMP_VALUE(4'h5)
    ) dut (
        .*
    );

    operand_isolation_sva #(
        .WIDTH(4),
        .CLAMP_VALUE(4'h5)
    ) i_operand_isolation_sva (
        .*
    );

    initial begin
        #1ns;
`ifdef OPERAND_ISOLATION_INJECT_Z
        i_isolate = 1'bz;
`else
        i_isolate = 1'bx;
`endif
        #1ns;

`ifdef OPERAND_ISOLATION_DISABLE_UNKNOWN_MONITOR
        if (o_data !== 'x) begin
            $fatal(1, "OPERAND_ISOLATION_UNKNOWN_OUTPUT_NOT_PROPAGATED");
        end
        $display("OPERAND_ISOLATION_UNKNOWN_CONTROL_STIMULUS_REACHED");
        $finish;
`else
        $fatal(1, "OPERAND_ISOLATION_UNKNOWN_CONTROL_MONITOR_DID_NOT_FIRE");
`endif
    end

endmodule
