`timescale 1ns / 1ps

// Self-contained clock/reset stimulus for one synchronization depth.
module reset_synchronizer_checker #(
    parameter int unsigned STAGES = 2,
    parameter int unsigned CHECKER_ID = 0
) (
    output logic o_done
);
    timeunit 1ns; timeprecision 1ps;

    logic i_clk;
    logic i_async_rstb;
    logic o_rstb;
    logic clock_running;

    reset_synchronizer #(.STAGES(STAGES)) dut (.*);

    initial begin
        i_clk = 1'b0;
        forever begin
            wait (clock_running);
            #5ns;
            if (clock_running) i_clk = ~i_clk;
        end
    end

    task automatic assert_reset(input int unsigned hold_cycles);
        i_async_rstb = 1'b0;
        #1ps;
        assert (!o_rstb)
        else $fatal(1, "checker %0d: asynchronous assertion failed", CHECKER_ID);
        repeat (hold_cycles) #1ns;
    endtask

    task automatic release_and_check;
        i_async_rstb = 1'b1;
        for (int unsigned edge_count = 1; edge_count <= STAGES; edge_count++) begin
            @(posedge i_clk);
            #1ps;
            if (edge_count < STAGES) begin
                assert (!o_rstb)
                else $fatal(1, "checker %0d: reset released at edge %0d", CHECKER_ID, edge_count);
            end else begin
                assert (o_rstb)
                else
                    $fatal(
                        1, "checker %0d: reset did not release at edge %0d", CHECKER_ID, edge_count
                    );
            end
        end
    endtask

    initial begin
        o_done = 1'b0;
        clock_running = 1'b1;
        i_async_rstb = 1'b1;

        // Assert in both phases and release at unrelated phase offsets.
        #2ns;
        assert_reset(3);
        release_and_check();
        @(posedge i_clk);
        #2ns;
        assert_reset(7);
        release_and_check();

        // A stopped destination clock must hold release pending.
        @(negedge i_clk);
        assert_reset(1);
        clock_running = 1'b0;
        i_async_rstb  = 1'b1;
        #30ns;
        assert (!o_rstb)
        else $fatal(1, "checker %0d: reset released while clock stopped", CHECKER_ID);
        clock_running = 1'b1;
        for (int unsigned edge_count = 1; edge_count <= STAGES; edge_count++) begin
            @(posedge i_clk);
            #1ps;
            assert (o_rstb == (edge_count == STAGES))
            else $fatal(1, "checker %0d: restart latency mismatch", CHECKER_ID);
        end

        // Reassert reset after every possible intermediate release stage.
        for (int unsigned stage = 1; stage < STAGES; stage++) begin
            @(negedge i_clk);
            assert_reset(1);
            i_async_rstb = 1'b1;
            repeat (stage) @(posedge i_clk);
            #1ns;
            assert (!o_rstb);
            assert_reset(2);
            release_and_check();
        end

        // Repeated random phase relationships exercise assertion priority.
        repeat (24) begin
            repeat ($urandom_range(1, 8)) #1ns;
            assert_reset($urandom_range(1, 4));
            release_and_check();
        end

        o_done = 1'b1;
    end
endmodule
