/// Combinational write-gate checks shared by simulation and formal proof.
module write_gate_sva #(
    parameter int unsigned WIDTH = 1
) (
    input logic [WIDTH-1:0] i_write_enable,
    input logic [WIDTH-1:0] i_suppress,
    input logic [WIDTH-1:0] o_write_enable,
    input logic [WIDTH-1:0] o_write_suppressed
);

`ifdef MOSAIC_YOSYS_FORMAL
    // Formal proves the two-state equation. Four-state campaigns qualify X/Z
    // controls with the same wrapper in an event-driven simulator.
    always_comb begin
        assert (o_write_enable == (i_write_enable & ~i_suppress));
        assert (o_write_suppressed == (i_write_enable & i_suppress));
        assert ((o_write_enable & o_write_suppressed) == '0);
        assert ((o_write_enable | o_write_suppressed) == i_write_enable);
    end
`else
    `include "write_gate_predicates.svh"

    always_comb begin
        if (write_gate_controls_known_f(i_write_enable, i_suppress)) begin
            assert (o_write_enable == write_gate_permitted_f(i_write_enable, i_suppress))
            else $fatal(1, "write_gate permitted-write equation failed");
            assert (o_write_suppressed == write_gate_suppressed_f(i_write_enable, i_suppress))
            else $fatal(1, "write_gate suppressed-write equation failed");
            assert (write_gate_outputs_partition_f(
                i_write_enable, o_write_enable, o_write_suppressed
            ))
            else $fatal(1, "write_gate outputs do not partition requests");
        end

`ifndef WRITE_GATE_DISABLE_UNKNOWN_MONITOR
        assert (!$isunknown(i_write_enable))
        else $fatal(1, "write_gate write-enable control is unknown");
        assert (!$isunknown(i_write_enable & i_suppress))
        else $fatal(1, "write_gate suppression control is unknown for a request");
`endif
    end
`endif

endmodule
