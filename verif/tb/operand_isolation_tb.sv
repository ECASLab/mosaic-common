/// Top-level regression for one profile-selected operand-isolation configuration.
module operand_isolation_tb #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0
);

    logic [3:0] done;

    operand_isolation_test_case #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE)
    ) u_unit (
        .o_done(done[0])
    );

    for (genvar use_case = 0; use_case < 3; use_case++) begin : g_activity
        operand_isolation_activity_test_case #(
            .WIDTH(WIDTH),
            .CLAMP_VALUE(CLAMP_VALUE),
            .USE_CASE(use_case)
        ) u_activity (
            .o_done(done[use_case+1])
        );
    end

    initial begin
        wait (&done);
        $display("PASS: operand_isolation WIDTH=%0d CLAMP_VALUE=%h regression completed", WIDTH,
                 CLAMP_VALUE);
        $finish;
    end

    initial begin
        #20us;
        $fatal(1, "operand_isolation WIDTH=%0d regression timed out", WIDTH);
    end

endmodule
