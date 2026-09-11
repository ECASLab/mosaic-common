`timescale 1ns / 1ps

module isolation_cell #(
    parameter int unsigned WIDTH = 1,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0,
    parameter bit ISOLATE_ACTIVE_HIGH = 1'b1
) (
    input  wire [WIDTH-1:0] i_data,
    input  wire             i_isolate,
    output wire [WIDTH-1:0] o_data
);
    wire isolation_active = ISOLATE_ACTIVE_HIGH ? i_isolate : ~i_isolate;
`ifdef ISOLATION_CELL_FAULT_BYPASS
    assign o_data = i_data;
`elsif ISOLATION_CELL_FAULT_CLAMP
    assign o_data = isolation_active ? ~CLAMP_VALUE : i_data;
`elsif ISOLATION_CELL_FAULT_CONTROL
    assign o_data = isolation_active ? i_data : CLAMP_VALUE;
`elsif ISOLATION_CELL_FAULT_CONSTANT
    assign o_data = '0;
`else
    assign o_data = isolation_active ? CLAMP_VALUE : i_data;
`endif
endmodule
