module isolation_cell_profile_formal #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0,
    parameter bit ISOLATE_ACTIVE_HIGH = 1'b1
);
    (* anyconst *) logic [WIDTH-1:0] i_data;
    (* anyconst *) logic i_isolate;
    logic [WIDTH-1:0] o_data;

    isolation_cell #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE),
        .ISOLATE_ACTIVE_HIGH(ISOLATE_ACTIVE_HIGH)
    ) dut (
        .i_data,
        .i_isolate,
        .o_data
    );

    always_comb begin
        assert (o_data == ((ISOLATE_ACTIVE_HIGH ? i_isolate : !i_isolate) ? CLAMP_VALUE : i_data));
    end
endmodule
