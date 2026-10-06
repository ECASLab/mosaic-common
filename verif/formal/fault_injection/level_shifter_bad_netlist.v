module level_shifter (
    input  wire i_data,
    output wire o_data
);
    assign o_data = ~i_data;
endmodule
