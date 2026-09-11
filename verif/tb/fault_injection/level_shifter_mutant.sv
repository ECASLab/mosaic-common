`timescale 1ns / 1ps

`ifndef LEVEL_SHIFTER_FAULT_MODE
`define LEVEL_SHIFTER_FAULT_MODE 0
`endif

module level_shifter #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned DIRECTION = 0
) (
    input  wire [WIDTH-1:0] i_data,
    output wire [WIDTH-1:0] o_data
);
    localparam int unsigned FaultMode = `LEVEL_SHIFTER_FAULT_MODE;

    if (WIDTH < 1) begin : gen_invalid_width
        initial $fatal(1, "WIDTH must be greater than or equal to one");
    end
    if (DIRECTION > 1) begin : gen_invalid_direction
        initial $fatal(1, "DIRECTION must be zero or one");
    end

    if (FaultMode == 1) begin : gen_inverted_output
        assign o_data = ~i_data;
    end else if (FaultMode == 2) begin : gen_constant_output
        assign o_data = '0;
    end else if (FaultMode == 3) begin : gen_reversed_output
        for (genvar bit_index = 0; bit_index < WIDTH; bit_index++) begin : gen_reversed_bits
            assign o_data[bit_index] = i_data[WIDTH-1-bit_index];
        end
    end else if (FaultMode == 4) begin : gen_corrupted_bit
        assign o_data = i_data ^ WIDTH'(1'b1);
    end else begin : gen_correct_output
        assign o_data = i_data;
    end
endmodule

`undef LEVEL_SHIFTER_FAULT_MODE
