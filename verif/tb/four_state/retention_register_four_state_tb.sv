`timescale 1ns / 1ps

module retention_register_four_state_tb;
    logic i_clk = 1'b0;
    logic i_rstb = 1'b0;
    logic i_enable = 1'b0;
    logic i_save = 1'b0;
    logic i_restore = 1'b0;
    logic [7:0] i_d = '0;
    logic [7:0] o_q;

    retention_register #(.WIDTH(8)) dut (.*);

    always #5ns i_clk = ~i_clk;

    always @(*) begin
        if ($isunknown({i_rstb, i_enable, i_save, i_restore})) begin
            $fatal(1, "UNKNOWN_CONTROL_DETECTED");
        end
    end

    initial begin
        #2ns i_rstb = 1'b1;
        @(negedge i_clk);
`ifdef UNKNOWN_RESET
        i_rstb = 1'bx;
`elsif UNKNOWN_ENABLE
        i_enable = 1'bx;
`elsif UNKNOWN_SAVE
        i_save = 1'bx;
`else
        i_restore = 1'bx;
`endif
        #2ns $fatal(1, "UNKNOWN_CONTROL_ESCAPED");
    end
endmodule
