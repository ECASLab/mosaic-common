`timescale 1ns / 1ps

// Qualify illegal unknown reset input behavior with a four-state simulator.
module reset_synchronizer_four_state_tb;
    logic i_clk;
    logic i_async_rstb;
    logic o_rstb;

    reset_synchronizer #(.STAGES(2)) dut (.*);

    always #5ns i_clk = ~i_clk;

`ifndef RESET_SYNCHRONIZER_DISABLE_UNKNOWN_CHECK
    always @(i_async_rstb) begin
        #1ps;
        if ($isunknown(i_async_rstb)) begin
            $fatal(1, "UNKNOWN_RESET_DETECTED: i_async_rstb must be known");
        end
    end
`endif

    initial begin
        i_clk        = 1'b0;
        i_async_rstb = 1'b0;
        #2ns;
        i_async_rstb = 1'b1;
        repeat (2) @(posedge i_clk);
        #1ns;
        assert (o_rstb);

        i_async_rstb = 1'bx;
        #2ns;
        $display("UNKNOWN_RESET_ESCAPED");
        $finish;
    end
endmodule
