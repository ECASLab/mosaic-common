// Verification-only mutation: isolation-control behavior is deliberately inverted.
module operand_isolation #(
    parameter int unsigned WIDTH = 32,
    parameter logic [WIDTH-1:0] CLAMP_VALUE = '0
) (
    input  logic [WIDTH-1:0] i_data,
    input  logic             i_isolate,
    output logic [WIDTH-1:0] o_data
);

    always_comb begin
        case (i_isolate)
            1'b0: o_data = CLAMP_VALUE;
            1'b1: o_data = i_data;
            default: o_data = 'x;
        endcase
    end

endmodule
