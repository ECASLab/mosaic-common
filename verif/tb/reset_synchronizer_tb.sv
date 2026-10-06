// Parallel regression for every release-qualified synchronization depth.
module reset_synchronizer_tb;
    timeunit 1ns; timeprecision 1ps;

    logic [2:0] done;

    reset_synchronizer_checker #(
        .STAGES(2),
        .CHECKER_ID(2)
    ) checker_stages_2 (
        .o_done(done[0])
    );
    reset_synchronizer_checker #(
        .STAGES(3),
        .CHECKER_ID(3)
    ) checker_stages_3 (
        .o_done(done[1])
    );
    reset_synchronizer_checker #(
        .STAGES(4),
        .CHECKER_ID(4)
    ) checker_stages_4 (
        .o_done(done[2])
    );

    initial begin
        wait (&done);
        $display("PASS: reset synchronizer depths 2, 3, and 4 completed");
        $finish;
    end

    initial begin
        #100us;
        $fatal(1, "reset-synchronizer regression timed out");
    end
endmodule
