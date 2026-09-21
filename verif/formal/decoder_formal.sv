`timescale 1ns / 1ps

/// Unconstrained harness proving the binary-to-one-hot decoder contract.
module decoder_formal #(
    parameter int unsigned NUM_OUTPUTS  = 4,
    parameter int unsigned SELECT_WIDTH = (NUM_OUTPUTS > 1) ? $clog2(NUM_OUTPUTS) : 1
);

    (* anyseq *)logic                    i_enable;
    (* anyseq *)logic [SELECT_WIDTH-1:0] i_select;
    logic [ NUM_OUTPUTS-1:0] o_decoded;
    logic                    o_select_valid;

    decoder #(
        .NUM_OUTPUTS (NUM_OUTPUTS),
        .SELECT_WIDTH(SELECT_WIDTH)
    ) dut (
        .*
    );

`ifdef FORMAL_ASSERTIONS
    decoder_bind #(
        .NUM_OUTPUTS (NUM_OUTPUTS),
        .SELECT_WIDTH(SELECT_WIDTH)
    ) i_decoder_bind (
        .*
    );
`endif

`ifdef FORMAL_COVERAGE
    decoder_coverage_bind #(
        .NUM_OUTPUTS (NUM_OUTPUTS),
        .SELECT_WIDTH(SELECT_WIDTH)
    ) i_decoder_coverage_bind (
        .*
    );
`endif

    always_comb begin
        assert ($onehot0(o_decoded));
        if (i_enable && ({1'b0, i_select} < (SELECT_WIDTH + 1)'(NUM_OUTPUTS))) begin
            assert (o_select_valid);
            assert (o_decoded == (NUM_OUTPUTS'(1'b1) << i_select));
            assert (o_decoded[i_select]);
        end else begin
            assert (!o_select_valid);
            assert (o_decoded == '0);
        end
    end

endmodule
