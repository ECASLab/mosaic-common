`timescale 1ns / 1ps

/// Combinational mux checks shared by simulation and formal proof.
module mux_sva #(
    parameter int unsigned NUM_INPUTS = 2,
    parameter int unsigned DATA_WIDTH = 32,
    parameter logic [DATA_WIDTH-1:0] DEFAULT_VALUE = '0,
    parameter int unsigned SEL_WIDTH = (NUM_INPUTS > 1) ? $clog2(NUM_INPUTS) : 1
) (
    input logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] i_data,
    input logic [ SEL_WIDTH-1:0]                 i_select,
    input logic [DATA_WIDTH-1:0]                 o_data,
    input logic                                  o_select_valid
);

`ifdef MOSAIC_YOSYS_FORMAL
    always_comb begin
        if ({1'b0, i_select} < (SEL_WIDTH + 1)'(NUM_INPUTS)) begin
            assert (o_data == i_data[i_select]);
            assert (o_select_valid);
        end else begin
            assert (o_data == DEFAULT_VALUE);
            assert (!o_select_valid);
        end
    end
`else
    `include "mux_predicates.svh"

    always @(i_data, i_select, o_data, o_select_valid) begin
        #1ps;
        assert (o_data === mux_expected_f(i_data, i_select))
        else $fatal(1, "mux output equation failed");
        assert (o_select_valid === mux_selection_legal_f(i_select))
        else $fatal(1, "mux validity equation failed");

        if (!mux_select_known_f(i_select)) begin
            assert ((o_data === DEFAULT_VALUE) && (o_select_valid === 1'b0))
            else $fatal(1, "mux did not fail closed for an unknown selection");
        end
`ifndef MUX_DISABLE_UNKNOWN_MONITOR
        assert (mux_select_known_f(i_select))
        else $fatal(1, "mux selection contains an unknown value");
`endif
    end
`endif

endmodule
