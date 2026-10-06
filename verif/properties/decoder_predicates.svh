// Module-scoped predicates shared by decoder checkers.
// This file has no include guard because each wrapper owns its declarations.

function automatic logic decoder_controls_known_f(input logic enable,
                                                  input logic [SELECT_WIDTH-1:0] select);
    decoder_controls_known_f = !$isunknown(enable) && !$isunknown(select);
endfunction

function automatic logic decoder_selection_legal_f(input logic [SELECT_WIDTH-1:0] select);
    decoder_selection_legal_f = !$isunknown(select) &&
        ({1'b0, select} < (SELECT_WIDTH + 1)'(NUM_OUTPUTS));
endfunction

function automatic logic [NUM_OUTPUTS-1:0] decoder_expected_f(
    input logic enable, input logic [SELECT_WIDTH-1:0] select);
    decoder_expected_f = '0;
    if ((enable === 1'b1) && decoder_selection_legal_f(select)) begin
        decoder_expected_f[select] = 1'b1;
    end
endfunction
