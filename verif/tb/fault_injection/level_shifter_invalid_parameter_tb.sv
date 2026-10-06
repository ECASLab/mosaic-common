`timescale 1ns / 1ps

module level_shifter_invalid_width_tb;
    wire [-1:0] i_data;
    wire [-1:0] o_data;

    level_shifter #(.WIDTH(0)) dut (.*);

    initial #1ns $fatal(1, "WIDTH=0 was not rejected");
endmodule

module level_shifter_invalid_direction_tb;
    wire i_data;
    wire o_data;

    level_shifter #(.DIRECTION(2)) dut (.*);

    initial #1ns $fatal(1, "DIRECTION=2 was not rejected");
endmodule
