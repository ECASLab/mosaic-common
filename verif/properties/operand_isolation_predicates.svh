// Module-scoped predicates shared by operand-isolation checkers.
// This file has no include guard because each wrapper owns its declarations.

function automatic logic [WIDTH-1:0] operand_isolation_expected_f(
    input logic [WIDTH-1:0] data, input logic isolate, input logic [WIDTH-1:0] clamp_value);
    case (isolate)
        1'b0: operand_isolation_expected_f = data;
        1'b1: operand_isolation_expected_f = clamp_value;
        default: operand_isolation_expected_f = 'x;
    endcase
endfunction

function automatic logic operand_isolation_control_known_f(input logic isolate);
    operand_isolation_control_known_f = !$isunknown(isolate);
endfunction

function automatic logic operand_isolation_clamped_f(input logic [WIDTH-1:0] output_data,
                                                     input logic [WIDTH-1:0] clamp_value);
    operand_isolation_clamped_f = (output_data === clamp_value);
endfunction

function automatic logic operand_isolation_transparent_f(input logic [WIDTH-1:0] input_data,
                                                         input logic [WIDTH-1:0] output_data);
    operand_isolation_transparent_f = (output_data === input_data);
endfunction
