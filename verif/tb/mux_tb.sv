`timescale 1ns / 1ps

/// Top-level regression for one profile-selected mux configuration.
module mux_tb #(
    parameter int unsigned NUM_INPUTS = 2,
    parameter int unsigned DATA_WIDTH = 32,
    parameter logic [DATA_WIDTH-1:0] DEFAULT_VALUE = '0,
    parameter int unsigned SEL_WIDTH = (NUM_INPUTS > 1) ? $clog2(NUM_INPUTS) : 1
);

    logic done;

    mux_test_case #(
        .NUM_INPUTS   (NUM_INPUTS),
        .DATA_WIDTH   (DATA_WIDTH),
        .DEFAULT_VALUE(DEFAULT_VALUE),
        .SEL_WIDTH    (SEL_WIDTH)
    ) u_unit (
        .o_done(done)
    );

    initial begin
        wait (done);
        $display("PASS: mux NUM_INPUTS=%0d DATA_WIDTH=%0d DEFAULT_VALUE=%h regression completed",
                 NUM_INPUTS, DATA_WIDTH, DEFAULT_VALUE);
        $finish;
    end

    initial begin
        #100us;
        $fatal(1, "mux NUM_INPUTS=%0d DATA_WIDTH=%0d regression timed out", NUM_INPUTS, DATA_WIDTH);
    end

endmodule
