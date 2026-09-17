/// Top-level regression for one profile-selected write-gate width.
module write_gate_tb #(
    parameter int unsigned WIDTH = 2
);

    logic unit_done;
    logic integration_done;

    write_gate_test_case #(.WIDTH(WIDTH)) u_unit (.o_done(unit_done));
    write_gate_integration_test_case #(.WIDTH(WIDTH)) u_integration (.o_done(integration_done));

    initial begin
        wait (unit_done && integration_done);
        $display("PASS: write_gate WIDTH=%0d regression completed", WIDTH);
        $finish;
    end

    initial begin
        #10us;
        $fatal(1, "write_gate WIDTH=%0d regression timed out", WIDTH);
    end

endmodule
