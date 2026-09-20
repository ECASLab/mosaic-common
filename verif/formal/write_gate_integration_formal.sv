/// Proves one-step state equivalence for a timing-safe redundant-write decision.
module write_gate_integration_formal #(
    parameter int unsigned WIDTH = 1
);

    (* anyseq *)logic [WIDTH-1:0] prior_state;
    (* anyseq *)logic [WIDTH-1:0] write_data;
    (* anyseq *)logic [WIDTH-1:0] i_write_enable;
    (* anyseq *)logic [WIDTH-1:0] i_suppress;
    logic [WIDTH-1:0] o_write_enable;
    logic [WIDTH-1:0] o_write_suppressed;
    logic [WIDTH-1:0] reference_next_state;
    logic [WIDTH-1:0] gated_next_state;

    write_gate #(
        .WIDTH(WIDTH)
    ) dut (
        .i_write_enable(i_write_enable),
        .i_suppress(i_suppress),
        .o_write_enable(o_write_enable),
        .o_write_suppressed(o_write_suppressed)
    );

    `include "write_gate_predicates.svh"

    always_comb begin
        // Integration owns this assumption: only a write of the value already
        // held by the destination may be classified as redundant here.
        assume (write_gate_suppression_is_redundant_f(
            prior_state, write_data, i_write_enable, i_suppress
        ));

        reference_next_state = write_gate_next_state_f(prior_state, write_data, i_write_enable);
        gated_next_state = write_gate_next_state_f(prior_state, write_data, o_write_enable);

        assert (gated_next_state == reference_next_state);
        assert ((o_write_suppressed & (write_data ^ prior_state)) == '0);
    end

endmodule
