`timescale 1ns / 1ps

/// Unconstrained harness proving the N-to-1 mux contract.
module mux_formal #(
    parameter int unsigned NUM_INPUTS = 2,
    parameter int unsigned DATA_WIDTH = 32,
    parameter logic [DATA_WIDTH-1:0] DEFAULT_VALUE = '0,
    parameter int unsigned SEL_WIDTH = (NUM_INPUTS > 1) ? $clog2(NUM_INPUTS) : 1
);

    (* anyseq *)logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] i_data;
    (* anyseq *)logic [ SEL_WIDTH-1:0]                 i_select;
    logic [DATA_WIDTH-1:0]                 o_data;
    logic                                  o_select_valid;

    mux #(
        .NUM_INPUTS   (NUM_INPUTS),
        .DATA_WIDTH   (DATA_WIDTH),
        .DEFAULT_VALUE(DEFAULT_VALUE),
        .SEL_WIDTH    (SEL_WIDTH)
    ) dut (
        .*
    );

`ifdef FORMAL_ASSERTIONS
    mux_bind #(
        .NUM_INPUTS   (NUM_INPUTS),
        .DATA_WIDTH   (DATA_WIDTH),
        .DEFAULT_VALUE(DEFAULT_VALUE),
        .SEL_WIDTH    (SEL_WIDTH)
    ) i_mux_bind (
        .*
    );
`endif

`ifdef FORMAL_COVERAGE
    mux_coverage_bind #(
        .NUM_INPUTS   (NUM_INPUTS),
        .DATA_WIDTH   (DATA_WIDTH),
        .DEFAULT_VALUE(DEFAULT_VALUE),
        .SEL_WIDTH    (SEL_WIDTH)
    ) i_mux_coverage_bind (
        .*
    );
`endif

    always_comb begin
        if ({1'b0, i_select} < (SEL_WIDTH + 1)'(NUM_INPUTS)) begin
            assert (o_select_valid);
            assert (o_data == i_data[i_select]);
        end else begin
            assert (!o_select_valid);
            assert (o_data == DEFAULT_VALUE);
        end
    end

endmodule
