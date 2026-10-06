`timescale 1ns / 1ps

module isolation_cell_four_state_tb;
    logic [3:0] i_data;
    logic       i_isolate;
    wire  [3:0] o_data;

    isolation_cell #(
        .WIDTH(4),
        .CLAMP_VALUE(4'b1010)
    ) dut (
        .*
    );

    task automatic check_expected(input logic [3:0] expected);
        #1;
        if (o_data !== expected) begin
            $error("expected=%b actual=%b", expected, o_data);
            $fatal(1);
        end
    endtask

    initial begin
        i_data = 4'bx1z0;
        i_isolate = 1'b0;
        check_expected(4'bx1z0);

        i_isolate = 1'b1;
        check_expected(4'b1010);

        i_data = 4'b1111;
        i_isolate = 1'bx;
        check_expected(4'b1x1x);

        i_data = 4'b0000;
        i_isolate = 1'bz;
        check_expected(4'bx0x0);

        $display("PASS: isolation cell preserves conservative X/Z semantics");
        $finish;
    end
endmodule
