`timescale 1ns / 1ps

module priority_encoder_tb;
    logic [15:0] done;

    priority_encoder_checker #(
        .WIDTH(1),
        .LSB_HIGH_PRIORITY(1),
        .CHECKER_ID(1)
    ) lsb_1 (
        .o_done(done[0])
    );
    priority_encoder_checker #(
        .WIDTH(1),
        .LSB_HIGH_PRIORITY(0),
        .CHECKER_ID(2)
    ) msb_1 (
        .o_done(done[1])
    );
    priority_encoder_checker #(
        .WIDTH(2),
        .LSB_HIGH_PRIORITY(1),
        .CHECKER_ID(3)
    ) lsb_2 (
        .o_done(done[2])
    );
    priority_encoder_checker #(
        .WIDTH(2),
        .LSB_HIGH_PRIORITY(0),
        .CHECKER_ID(4)
    ) msb_2 (
        .o_done(done[3])
    );
    priority_encoder_checker #(
        .WIDTH(3),
        .LSB_HIGH_PRIORITY(1),
        .CHECKER_ID(5)
    ) lsb_3 (
        .o_done(done[4])
    );
    priority_encoder_checker #(
        .WIDTH(3),
        .LSB_HIGH_PRIORITY(0),
        .CHECKER_ID(6)
    ) msb_3 (
        .o_done(done[5])
    );
    priority_encoder_checker #(
        .WIDTH(4),
        .LSB_HIGH_PRIORITY(1),
        .CHECKER_ID(7)
    ) lsb_4 (
        .o_done(done[6])
    );
    priority_encoder_checker #(
        .WIDTH(4),
        .LSB_HIGH_PRIORITY(0),
        .CHECKER_ID(8)
    ) msb_4 (
        .o_done(done[7])
    );
    priority_encoder_checker #(
        .WIDTH(5),
        .LSB_HIGH_PRIORITY(1),
        .CHECKER_ID(9)
    ) lsb_5 (
        .o_done(done[8])
    );
    priority_encoder_checker #(
        .WIDTH(5),
        .LSB_HIGH_PRIORITY(0),
        .CHECKER_ID(10)
    ) msb_5 (
        .o_done(done[9])
    );
    priority_encoder_checker #(
        .WIDTH(8),
        .LSB_HIGH_PRIORITY(1),
        .CHECKER_ID(11)
    ) lsb_8 (
        .o_done(done[10])
    );
    priority_encoder_checker #(
        .WIDTH(8),
        .LSB_HIGH_PRIORITY(0),
        .CHECKER_ID(12)
    ) msb_8 (
        .o_done(done[11])
    );
    priority_encoder_checker #(
        .WIDTH(16),
        .LSB_HIGH_PRIORITY(1),
        .CHECKER_ID(13)
    ) lsb_16 (
        .o_done(done[12])
    );
    priority_encoder_checker #(
        .WIDTH(16),
        .LSB_HIGH_PRIORITY(0),
        .CHECKER_ID(14)
    ) msb_16 (
        .o_done(done[13])
    );
    priority_encoder_checker #(
        .WIDTH(32),
        .LSB_HIGH_PRIORITY(1),
        .CHECKER_ID(15)
    ) lsb_32 (
        .o_done(done[14])
    );
    priority_encoder_checker #(
        .WIDTH(32),
        .LSB_HIGH_PRIORITY(0),
        .CHECKER_ID(16)
    ) msb_32 (
        .o_done(done[15])
    );

    initial begin
        wait (&done);
        $display("PASS: priority encoder configurations completed");
        $finish;
    end

    initial begin
        #10us;
        $fatal(1, "priority-encoder regression timed out");
    end
endmodule
