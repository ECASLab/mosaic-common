// Module-scoped predicates shared by mux checkers.
// This file has no include guard because each wrapper owns its declarations.

function automatic logic mux_select_known_f(input logic [SEL_WIDTH-1:0] select);
    mux_select_known_f = !$isunknown(select);
endfunction

function automatic logic mux_selection_legal_f(input logic [SEL_WIDTH-1:0] select);
    mux_selection_legal_f = !$isunknown(select) && ({1'b0, select} < (SEL_WIDTH + 1)'(NUM_INPUTS));
endfunction

function automatic logic [DATA_WIDTH-1:0] mux_expected_f(
    input logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] data, input logic [SEL_WIDTH-1:0] select);
    mux_expected_f = DEFAULT_VALUE;
    if (mux_selection_legal_f(select)) begin
        mux_expected_f = data[select];
    end
endfunction
