module isolation_cell_formal;
    localparam int unsigned WIDTH = 8;
    localparam logic [WIDTH-1:0] CLAMP_VALUE = 8'ha5;

    (* anyconst *)logic [WIDTH-1:0] i_data;
    (* anyconst *)logic             i_isolate;
    wire  [WIDTH-1:0] o_active_high;
    wire  [WIDTH-1:0] o_active_low;

    isolation_cell #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE),
        .ISOLATE_ACTIVE_HIGH(1'b1)
    ) dut_active_high (
        .i_data(i_data),
        .i_isolate(i_isolate),
        .o_data(o_active_high)
    );

    isolation_cell #(
        .WIDTH(WIDTH),
        .CLAMP_VALUE(CLAMP_VALUE),
        .ISOLATE_ACTIVE_HIGH(1'b0)
    ) dut_active_low (
        .i_data(i_data),
        .i_isolate(i_isolate),
        .o_data(o_active_low)
    );

    always_comb begin
        assert (o_active_high == (i_isolate ? CLAMP_VALUE : i_data));
        assert (o_active_low == (i_isolate ? i_data : CLAMP_VALUE));
        assert (i_isolate ? (o_active_high == CLAMP_VALUE) : (o_active_low == CLAMP_VALUE));
    end
endmodule
