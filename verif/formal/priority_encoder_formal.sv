module priority_encoder_formal_checker #(
    parameter int unsigned WIDTH = 4,
    parameter bit LSB_HIGH_PRIORITY = 1'b1
);
    localparam int unsigned INDEX_WIDTH = (WIDTH > 1) ? $clog2(WIDTH) : 1;

    (* anyconst *) logic [WIDTH-1:0] i_request;
    logic o_valid;
    logic [INDEX_WIDTH-1:0] o_index;
    logic [WIDTH-1:0] o_onehot;
    logic o_multiple;

    priority_encoder #(
        .WIDTH(WIDTH),
        .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
    ) dut (
        .*
    );

    always_comb begin
        assert (o_valid == (|i_request));
        assert ($onehot0(o_onehot));
        assert ((o_onehot & ~i_request) == '0);
        assert (o_multiple == ($countones(i_request) > 1));
        if (o_valid)
            assert (o_onehot[o_index]);
            else assert ({o_index, o_onehot} == '0);
    end
endmodule

module priority_encoder_formal;
    priority_encoder_formal_checker #(
        .WIDTH(1),
        .LSB_HIGH_PRIORITY(1)
    ) lsb_1 ();
    priority_encoder_formal_checker #(
        .WIDTH(1),
        .LSB_HIGH_PRIORITY(0)
    ) msb_1 ();
    priority_encoder_formal_checker #(
        .WIDTH(3),
        .LSB_HIGH_PRIORITY(1)
    ) lsb_3 ();
    priority_encoder_formal_checker #(
        .WIDTH(3),
        .LSB_HIGH_PRIORITY(0)
    ) msb_3 ();
    priority_encoder_formal_checker #(
        .WIDTH(5),
        .LSB_HIGH_PRIORITY(1)
    ) lsb_5 ();
    priority_encoder_formal_checker #(
        .WIDTH(5),
        .LSB_HIGH_PRIORITY(0)
    ) msb_5 ();
    priority_encoder_formal_checker #(
        .WIDTH(8),
        .LSB_HIGH_PRIORITY(1)
    ) lsb_8 ();
    priority_encoder_formal_checker #(
        .WIDTH(8),
        .LSB_HIGH_PRIORITY(0)
    ) msb_8 ();
endmodule
