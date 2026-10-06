`timescale 1ns / 1ps

module level_shifter_tb;
    logic [13:0] done;

    level_shifter_checker #(
        .WIDTH(1),
        .DIRECTION(0),
        .CHECKER_ID(1)
    ) l2h_1 (
        .o_done(done[0])
    );
    level_shifter_checker #(
        .WIDTH(1),
        .DIRECTION(1),
        .CHECKER_ID(2)
    ) h2l_1 (
        .o_done(done[1])
    );
    level_shifter_checker #(
        .WIDTH(2),
        .DIRECTION(0),
        .CHECKER_ID(3)
    ) l2h_2 (
        .o_done(done[2])
    );
    level_shifter_checker #(
        .WIDTH(2),
        .DIRECTION(1),
        .CHECKER_ID(4)
    ) h2l_2 (
        .o_done(done[3])
    );
    level_shifter_checker #(
        .WIDTH(4),
        .DIRECTION(0),
        .CHECKER_ID(5)
    ) l2h_4 (
        .o_done(done[4])
    );
    level_shifter_checker #(
        .WIDTH(4),
        .DIRECTION(1),
        .CHECKER_ID(6)
    ) h2l_4 (
        .o_done(done[5])
    );
    level_shifter_checker #(
        .WIDTH(8),
        .DIRECTION(0),
        .CHECKER_ID(7)
    ) l2h_8 (
        .o_done(done[6])
    );
    level_shifter_checker #(
        .WIDTH(8),
        .DIRECTION(1),
        .CHECKER_ID(8)
    ) h2l_8 (
        .o_done(done[7])
    );
    level_shifter_checker #(
        .WIDTH(16),
        .DIRECTION(0),
        .CHECKER_ID(9)
    ) l2h_16 (
        .o_done(done[8])
    );
    level_shifter_checker #(
        .WIDTH(16),
        .DIRECTION(1),
        .CHECKER_ID(10)
    ) h2l_16 (
        .o_done(done[9])
    );
    level_shifter_checker #(
        .WIDTH(32),
        .DIRECTION(0),
        .CHECKER_ID(11)
    ) l2h_32 (
        .o_done(done[10])
    );
    level_shifter_checker #(
        .WIDTH(32),
        .DIRECTION(1),
        .CHECKER_ID(12)
    ) h2l_32 (
        .o_done(done[11])
    );
    level_shifter_checker #(
        .WIDTH(64),
        .DIRECTION(0),
        .CHECKER_ID(13)
    ) l2h_64 (
        .o_done(done[12])
    );
    level_shifter_checker #(
        .WIDTH(64),
        .DIRECTION(1),
        .CHECKER_ID(14)
    ) h2l_64 (
        .o_done(done[13])
    );

    initial begin
        wait (&done);
        $display("PASS: level-shifter configurations completed");
        $finish;
    end

    initial begin
        #10us;
        $fatal(1, "level-shifter regression timed out");
    end
endmodule
