`timescale 1ns / 1ps

module level_shifter_four_state_tb;
    logic [3:0] i_data;
    wire  [3:0] l2h_data;
    wire  [3:0] h2l_data;

    level_shifter #(
        .WIDTH(4),
        .DIRECTION(0)
    ) l2h_dut (
        .i_data(i_data),
        .o_data(l2h_data)
    );
    level_shifter #(
        .WIDTH(4),
        .DIRECTION(1)
    ) h2l_dut (
        .i_data(i_data),
        .o_data(h2l_data)
    );

    task automatic check_value(input logic [3:0] value);
        i_data = value;
        #1ps;
        assert ((l2h_data === value) && (h2l_data === value))
        else $fatal(1, "four-state value %b was not preserved", value);
    endtask

    initial begin
        check_value(4'b0x01);
        check_value(4'b1z10);
        check_value(4'bxzxz);
        check_value(4'bzzzz);
        $display("PASS: level shifter preserves X and Z values");
        $finish;
    end
endmodule
