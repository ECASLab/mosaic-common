module isolation_cell_sva #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0,
    parameter bit ISOLATE_ACTIVE_HIGH = 1'b1
) (
    input logic [WIDTH-1:0] i_data,
    input logic             i_isolate,
    input logic [WIDTH-1:0] o_data
);
    always_comb begin
        assert (!$isunknown(i_isolate));
        if (!$isunknown(i_isolate)) begin
            assert ((i_isolate == ISOLATE_ACTIVE_HIGH) ?
                    (o_data === CLAMP_VALUE) : (o_data === i_data));
        end
        isolation_active_covered :
        cover (!$isunknown(i_isolate) && (i_isolate == ISOLATE_ACTIVE_HIGH));
        isolation_inactive_covered :
        cover (!$isunknown(i_isolate) && (i_isolate != ISOLATE_ACTIVE_HIGH));
        clamp_differs_covered :
        cover (!$isunknown(
            i_isolate
        ) && (i_isolate == ISOLATE_ACTIVE_HIGH) && (i_data != CLAMP_VALUE));
    end
endmodule
