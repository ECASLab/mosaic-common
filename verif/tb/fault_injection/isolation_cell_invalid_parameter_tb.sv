module isolation_cell_invalid_parameter_tb;
    wire o_data;
`ifdef ISOLATION_CELL_INVALID_WIDTH
    isolation_cell #(
        .WIDTH(0)
    ) dut (
        .i_data(),
        .i_isolate(1'b0),
        .o_data(o_data)
    );
`elsif ISOLATION_CELL_INVALID_CLAMP
    isolation_cell #(
        .CLAMP_VALUE(1'bx)
    ) dut (
        .i_data(1'b0),
        .i_isolate(1'b0),
        .o_data(o_data)
    );
`endif
endmodule
