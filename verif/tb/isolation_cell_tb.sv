`timescale 1ns / 1ps

module isolation_cell_tb;
    logic [15:0] done;

    isolation_cell_checker #(
        .WIDTH(1),
        .CLAMP_VALUE(1'b0),
        .ISOLATE_ACTIVE_HIGH(1'b1)
    ) c00 (
        .done(done[0])
    );

    isolation_cell_checker #(
        .WIDTH(1),
        .CLAMP_VALUE(1'b1),
        .ISOLATE_ACTIVE_HIGH(1'b0)
    ) c01 (
        .done(done[1])
    );

    isolation_cell_checker #(
        .WIDTH(2),
        .CLAMP_VALUE(2'b00),
        .ISOLATE_ACTIVE_HIGH(1'b1)
    ) c02 (
        .done(done[2])
    );

    isolation_cell_checker #(
        .WIDTH(2),
        .CLAMP_VALUE(2'b11),
        .ISOLATE_ACTIVE_HIGH(1'b0)
    ) c03 (
        .done(done[3])
    );

    isolation_cell_checker #(
        .WIDTH(4),
        .CLAMP_VALUE(4'b0101),
        .ISOLATE_ACTIVE_HIGH(1'b1)
    ) c04 (
        .done(done[4])
    );

    isolation_cell_checker #(
        .WIDTH(4),
        .CLAMP_VALUE(4'b1010),
        .ISOLATE_ACTIVE_HIGH(1'b0)
    ) c05 (
        .done(done[5])
    );

    isolation_cell_checker #(
        .WIDTH(8),
        .CLAMP_VALUE(8'h00),
        .ISOLATE_ACTIVE_HIGH(1'b1)
    ) c06 (
        .done(done[6])
    );

    isolation_cell_checker #(
        .WIDTH(8),
        .CLAMP_VALUE(8'hff),
        .ISOLATE_ACTIVE_HIGH(1'b0)
    ) c07 (
        .done(done[7])
    );

    isolation_cell_checker #(
        .WIDTH(16),
        .CLAMP_VALUE(16'ha55a),
        .ISOLATE_ACTIVE_HIGH(1'b1)
    ) c08 (
        .done(done[8])
    );

    isolation_cell_checker #(
        .WIDTH(16),
        .CLAMP_VALUE(16'h5aa5),
        .ISOLATE_ACTIVE_HIGH(1'b0)
    ) c09 (
        .done(done[9])
    );

    isolation_cell_checker #(
        .WIDTH(32),
        .CLAMP_VALUE(32'h00000000),
        .ISOLATE_ACTIVE_HIGH(1'b1)
    ) c10 (
        .done(done[10])
    );

    isolation_cell_checker #(
        .WIDTH(32),
        .CLAMP_VALUE(32'hffffffff),
        .ISOLATE_ACTIVE_HIGH(1'b0)
    ) c11 (
        .done(done[11])
    );

    isolation_cell_checker #(
        .WIDTH(32),
        .CLAMP_VALUE(32'ha5a55a5a),
        .ISOLATE_ACTIVE_HIGH(1'b1)
    ) c12 (
        .done(done[12])
    );

    isolation_cell_checker #(
        .WIDTH(32),
        .CLAMP_VALUE(32'h5a5aa5a5),
        .ISOLATE_ACTIVE_HIGH(1'b0)
    ) c13 (
        .done(done[13])
    );

    isolation_cell_checker #(
        .WIDTH(64),
        .CLAMP_VALUE(64'h0),
        .ISOLATE_ACTIVE_HIGH(1'b1)
    ) c14 (
        .done(done[14])
    );

    isolation_cell_checker #(
        .WIDTH(64),
        .CLAMP_VALUE(64'ha5a55a5af0f00f0f),
        .ISOLATE_ACTIVE_HIGH(1'b0)
    ) c15 (
        .done(done[15])
    );

    initial begin
        wait (&done);
        $display("PASS: isolation-cell configurations completed");
        $finish;
    end
endmodule
