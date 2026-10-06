module level_shifter_formal_checker #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned DIRECTION = 0
);
    (* anyconst *)logic [WIDTH-1:0] i_data;
    logic [WIDTH-1:0] o_data;

    level_shifter #(
        .WIDTH(WIDTH),
        .DIRECTION(DIRECTION)
    ) dut (
        .*
    );

    always_comb assert (o_data == i_data);
endmodule

module level_shifter_formal;
    level_shifter_formal_checker #(
        .WIDTH(1),
        .DIRECTION(0)
    ) l2h_1 ();
    level_shifter_formal_checker #(
        .WIDTH(1),
        .DIRECTION(1)
    ) h2l_1 ();
    level_shifter_formal_checker #(
        .WIDTH(4),
        .DIRECTION(0)
    ) l2h_4 ();
    level_shifter_formal_checker #(
        .WIDTH(4),
        .DIRECTION(1)
    ) h2l_4 ();
    level_shifter_formal_checker #(
        .WIDTH(16),
        .DIRECTION(0)
    ) l2h_16 ();
    level_shifter_formal_checker #(
        .WIDTH(16),
        .DIRECTION(1)
    ) h2l_16 ();
    level_shifter_formal_checker #(
        .WIDTH(64),
        .DIRECTION(0)
    ) l2h_64 ();
    level_shifter_formal_checker #(
        .WIDTH(64),
        .DIRECTION(1)
    ) h2l_64 ();
endmodule
