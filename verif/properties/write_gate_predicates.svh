// Module-scoped combinational predicates shared by write-gate checkers.
// This file has no include guard because each wrapper owns its declarations.

function automatic logic [WIDTH-1:0] write_gate_permitted_f(input logic [WIDTH-1:0] write_enable,
                                                            input logic [WIDTH-1:0] suppress);
    write_gate_permitted_f = write_enable & ~suppress;
endfunction

function automatic logic [WIDTH-1:0] write_gate_suppressed_f(input logic [WIDTH-1:0] write_enable,
                                                             input logic [WIDTH-1:0] suppress);
    write_gate_suppressed_f = write_enable & suppress;
endfunction

function automatic logic write_gate_controls_known_f(input logic [WIDTH-1:0] write_enable,
                                                     input logic [WIDTH-1:0] suppress);
    write_gate_controls_known_f = !$isunknown({write_enable, suppress});
endfunction

function automatic logic write_gate_outputs_partition_f(input logic [WIDTH-1:0] write_enable,
                                                        input logic [WIDTH-1:0] permitted,
                                                        input logic [WIDTH-1:0] suppressed);
    write_gate_outputs_partition_f =
        ((permitted & suppressed) == '0) && ((permitted | suppressed) == write_enable);
endfunction

function automatic logic [WIDTH-1:0] write_gate_next_state_f(input logic [WIDTH-1:0] prior_state,
                                                             input logic [WIDTH-1:0] write_data,
                                                             input logic [WIDTH-1:0] write_enable);
    write_gate_next_state_f = (prior_state & ~write_enable) | (write_data & write_enable);
endfunction

function automatic logic write_gate_suppression_is_redundant_f(
    input logic [WIDTH-1:0] prior_state, input logic [WIDTH-1:0] write_data,
    input logic [WIDTH-1:0] write_enable, input logic [WIDTH-1:0] suppress);
    write_gate_suppression_is_redundant_f =
        ((write_enable & suppress & (write_data ^ prior_state)) == '0);
endfunction
