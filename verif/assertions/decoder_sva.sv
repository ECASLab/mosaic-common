`timescale 1ns / 1ps

/// Combinational decoder checks shared by simulation and formal proof.
module decoder_sva #(
    parameter int unsigned NUM_OUTPUTS  = 4,
    parameter int unsigned SELECT_WIDTH = (NUM_OUTPUTS > 1) ? $clog2(NUM_OUTPUTS) : 1
) (
    input logic                    i_enable,
    input logic [SELECT_WIDTH-1:0] i_select,
    input logic [ NUM_OUTPUTS-1:0] o_decoded,
    input logic                    o_select_valid
);

`ifdef MOSAIC_YOSYS_FORMAL
    always_comb begin
        assert ($onehot0(o_decoded));
        if (i_enable && ({1'b0, i_select} < (SELECT_WIDTH + 1)'(NUM_OUTPUTS))) begin
            assert (o_decoded == (NUM_OUTPUTS'(1'b1) << i_select));
            assert (o_select_valid);
        end else begin
            assert (o_decoded == '0);
            assert (!o_select_valid);
        end
    end
`else
    `include "decoder_predicates.svh"

    always @(i_enable, i_select, o_decoded, o_select_valid) begin
        #1ps;
        assert ($onehot0(o_decoded))
        else $fatal(1, "decoder produced a multi-hot output");
        assert (o_decoded === decoder_expected_f(i_enable, i_select))
        else $fatal(1, "decoder output equation failed");
        assert (o_select_valid === ((i_enable === 1'b1) && decoder_selection_legal_f(i_select)))
        else $fatal(1, "decoder validity equation failed");

        if (!decoder_controls_known_f(i_enable, i_select)) begin
            assert ((o_decoded === '0) && (o_select_valid === 1'b0))
            else $fatal(1, "decoder did not fail closed for an unknown control");
        end
`ifndef DECODER_DISABLE_UNKNOWN_MONITOR
        assert (decoder_controls_known_f(i_enable, i_select))
        else $fatal(1, "decoder control contains an unknown value");
`endif
    end
`endif

endmodule
