`timescale 1ns / 1ps

module retention_register_negative_tb;
    logic i_clk = 1'b0;
    logic i_rstb = 1'b0;
    logic i_enable = 1'b0;
    logic i_save = 1'b0;
    logic i_restore = 1'b0;
    logic i_d = 1'b0;
    logic o_q;

    retention_register dut (.*);

    always #5ns i_clk = ~i_clk;

    always @(posedge i_clk) begin
        assert (!(i_save && i_restore))
        else $fatal(1, "ILLEGAL_CONTROL_DETECTED");
    end

    initial begin
        #2ns i_rstb = 1'b1;
        @(negedge i_clk);
        i_save = 1'b1;
        i_restore = 1'b1;
        @(posedge i_clk);
        #1ns $fatal(1, "ILLEGAL_CONTROL_ESCAPED");
    end
endmodule
