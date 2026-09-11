`timescale 1ns / 1ps

module retention_register_tb;
    logic [11:0] done;

    retention_register_checker #(
        .WIDTH(1),
        .ASYNC_RESET(1'b0),
        .HAS_ENABLE(1'b0)
    ) c00 (
        .done(done[0])
    );
    retention_register_checker #(
        .WIDTH(1),
        .RESET_VALUE(1'b1),
        .ASYNC_RESET(1'b1),
        .HAS_ENABLE(1'b1)
    ) c01 (
        .done(done[1])
    );
    retention_register_checker #(
        .WIDTH(8),
        .RESET_VALUE(8'ha5),
        .ASYNC_RESET(1'b0),
        .HAS_ENABLE(1'b1)
    ) c02 (
        .done(done[2])
    );
    retention_register_checker #(
        .WIDTH(8),
        .RESET_VALUE(8'h5a),
        .ASYNC_RESET(1'b1),
        .HAS_ENABLE(1'b0)
    ) c03 (
        .done(done[3])
    );
    retention_register_checker #(
        .WIDTH(16),
        .ASYNC_RESET(1'b0),
        .HAS_ENABLE(1'b1)
    ) c04 (
        .done(done[4])
    );
    retention_register_checker #(
        .WIDTH(16),
        .RESET_VALUE(16'h55aa),
        .ASYNC_RESET(1'b1),
        .HAS_ENABLE(1'b0)
    ) c05 (
        .done(done[5])
    );
    retention_register_checker #(
        .WIDTH(32),
        .ASYNC_RESET(1'b0),
        .HAS_ENABLE(1'b0)
    ) c06 (
        .done(done[6])
    );
    retention_register_checker #(
        .WIDTH(32),
        .RESET_VALUE(32'ha5a55a5a),
        .ASYNC_RESET(1'b1),
        .HAS_ENABLE(1'b1)
    ) c07 (
        .done(done[7])
    );
    retention_register_checker #(
        .WIDTH(64),
        .ASYNC_RESET(1'b0),
        .HAS_ENABLE(1'b1)
    ) c08 (
        .done(done[8])
    );
    retention_register_checker #(
        .WIDTH(64),
        .RESET_VALUE(64'h55aa55aaaa55aa55),
        .ASYNC_RESET(1'b1),
        .HAS_ENABLE(1'b0)
    ) c09 (
        .done(done[9])
    );
    retention_register_checker #(
        .WIDTH(128),
        .ASYNC_RESET(1'b0),
        .HAS_ENABLE(1'b0)
    ) c10 (
        .done(done[10])
    );
    retention_register_checker #(
        .WIDTH(128),
        .RESET_VALUE({16{8'ha5}}),
        .ASYNC_RESET(1'b1),
        .HAS_ENABLE(1'b1)
    ) c11 (
        .done(done[11])
    );

    initial begin
        wait (&done);
        $display("PASS: retention-register configurations completed");
        $finish;
    end
endmodule
