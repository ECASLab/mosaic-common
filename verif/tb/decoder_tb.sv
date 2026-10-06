`timescale 1ns / 1ps

/// Top-level regression for one profile-selected decoder configuration.
module decoder_tb #(
    parameter int unsigned NUM_OUTPUTS  = 4,
    parameter int unsigned SELECT_WIDTH = (NUM_OUTPUTS > 1) ? $clog2(NUM_OUTPUTS) : 1
);

    logic done;

    decoder_test_case #(
        .NUM_OUTPUTS (NUM_OUTPUTS),
        .SELECT_WIDTH(SELECT_WIDTH)
    ) u_unit (
        .o_done(done)
    );

    initial begin
        wait (done);
        $display("PASS: decoder NUM_OUTPUTS=%0d regression completed", NUM_OUTPUTS);
        $finish;
    end

    initial begin
        #20us;
        $fatal(1, "decoder NUM_OUTPUTS=%0d regression timed out", NUM_OUTPUTS);
    end

endmodule
