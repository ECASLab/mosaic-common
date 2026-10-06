/// Combinational operand-isolation checks shared by simulation and formal proof.
module operand_isolation_sva #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0
) (
    input logic [WIDTH-1:0] i_data,
    input logic             i_isolate,
    input logic [WIDTH-1:0] o_data
);

`ifdef MOSAIC_YOSYS_FORMAL
    always_comb begin
        if (i_isolate) begin
            assert (o_data == CLAMP_VALUE);
        end else begin
            assert (o_data == i_data);
        end
    end
`else
    `include "operand_isolation_predicates.svh"

    always_comb begin
        if (operand_isolation_control_known_f(i_isolate)) begin
            assert (o_data === operand_isolation_expected_f(i_data, i_isolate, CLAMP_VALUE))
            else $fatal(1, "operand_isolation output equation failed");
            if (i_isolate) begin
                assert (operand_isolation_clamped_f(o_data, CLAMP_VALUE))
                else $fatal(1, "operand_isolation failed to clamp an inactive operand");
            end else begin
                assert (operand_isolation_transparent_f(i_data, o_data))
                else $fatal(1, "operand_isolation changed an active operand");
            end
        end

`ifndef OPERAND_ISOLATION_DISABLE_UNKNOWN_MONITOR
        assert (!$isunknown(i_isolate))
        else $fatal(1, "operand_isolation isolation control is unknown");
`endif
    end
`endif

endmodule
