// Verification-only candidate netlist with a deliberately invalid combinational
// count output. EQY must reject it against the default counter RTL.
module counter (
    input  wire        i_clk,
    input  wire        i_rstb,
    input  wire        i_enable,
    input  wire        i_clear,
    input  wire        i_load,
    input  wire        i_direction,
    input  wire [31:0] i_load_value,
    output wire [31:0] o_count,
    output wire        o_overflow,
    output wire        o_underflow,
    output wire        o_terminal
);
    wire unused_controls = i_clk | i_rstb | i_enable | i_clear | i_load |
                           i_direction;

    assign o_count     = i_load_value;
    assign o_overflow  = 1'b0;
    assign o_underflow = 1'b0;
    assign o_terminal  = unused_controls & 1'b0;
endmodule
