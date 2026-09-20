/// Compares gated register and memory destinations with ungated references.
module write_gate_integration_test_case #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned MEMORY_DEPTH = 4,
    parameter int unsigned ADDRESS_WIDTH = $clog2(MEMORY_DEPTH)
) (
    output logic o_done
);

    logic clock;

    logic [WIDTH-1:0] register_write_enable;
    logic [WIDTH-1:0] register_suppress;
    logic [WIDTH-1:0] register_write_data;
    logic [WIDTH-1:0] register_gated_enable;
    logic [WIDTH-1:0] register_suppressed;
    logic [WIDTH-1:0] register_gated_state;
    logic [WIDTH-1:0] register_reference_state;
    logic register_coverage_sample;
    logic register_transaction_accepted;
    logic register_redundant_value_reason;

    logic [WIDTH-1:0] memory_write_enable;
    logic [WIDTH-1:0] memory_suppress;
    logic [WIDTH-1:0] memory_write_data;
    logic [WIDTH-1:0] memory_gated_enable;
    logic [WIDTH-1:0] memory_suppressed;
    logic [ADDRESS_WIDTH-1:0] memory_address;
    logic [WIDTH-1:0] memory_gated_state[0:MEMORY_DEPTH-1];
    logic [WIDTH-1:0] memory_reference_state[0:MEMORY_DEPTH-1];
    logic memory_coverage_sample;
    logic memory_transaction_accepted;
    logic memory_redundant_value_reason;

    longint unsigned register_reference_write_events;
    longint unsigned register_gated_write_events;
    longint unsigned register_reference_state_toggles;
    longint unsigned register_gated_state_toggles;
    longint unsigned memory_reference_write_events;
    longint unsigned memory_gated_write_events;
    longint unsigned memory_reference_state_toggles;
    longint unsigned memory_gated_state_toggles;

    write_gate #(
        .WIDTH(WIDTH)
    ) u_register_gate (
        .i_write_enable(register_write_enable),
        .i_suppress(register_suppress),
        .o_write_enable(register_gated_enable),
        .o_write_suppressed(register_suppressed)
    );

    write_gate #(
        .WIDTH(WIDTH)
    ) u_memory_gate (
        .i_write_enable(memory_write_enable),
        .i_suppress(memory_suppress),
        .o_write_enable(memory_gated_enable),
        .o_write_suppressed(memory_suppressed)
    );

`ifndef WRITE_GATE_DISABLE_COVERAGE
    write_gate_integration_coverage #(
        .WIDTH(WIDTH),
        .DESTINATION_IS_MEMORY(1'b0)
    ) i_register_coverage (
        .i_sample(register_coverage_sample),
        .i_transaction_accepted(register_transaction_accepted),
        .i_redundant_value_reason(register_redundant_value_reason),
        .i_write_enable(register_write_enable),
        .i_suppress(register_suppress),
        .o_write_enable(register_gated_enable),
        .o_write_suppressed(register_suppressed)
    );

    write_gate_integration_coverage #(
        .WIDTH(WIDTH),
        .DESTINATION_IS_MEMORY(1'b1)
    ) i_memory_coverage (
        .i_sample(memory_coverage_sample),
        .i_transaction_accepted(memory_transaction_accepted),
        .i_redundant_value_reason(memory_redundant_value_reason),
        .i_write_enable(memory_write_enable),
        .i_suppress(memory_suppress),
        .o_write_enable(memory_gated_enable),
        .o_write_suppressed(memory_suppressed)
    );
`endif

    always #5ns clock = ~clock;

    function automatic logic [WIDTH-1:0] random_vector();
        for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
            random_vector[bit_index] = ($urandom_range(0, 1) != 0);
        end
    endfunction

    function automatic longint unsigned count_set_bits(input logic [WIDTH-1:0] value);
        count_set_bits = 0;
        for (int unsigned bit_index = 0; bit_index < WIDTH; bit_index++) begin
            count_set_bits += value[bit_index];
        end
    endfunction

    function automatic logic [WIDTH-1:0] redundant_mask(input logic [WIDTH-1:0] prior_state,
                                                        input logic [WIDTH-1:0] write_data,
                                                        input logic [WIDTH-1:0] write_enable);
        return write_enable & ~(write_data ^ prior_state);
    endfunction

    always @(posedge clock) begin
        register_reference_write_events <= register_reference_write_events + count_set_bits(
            register_write_enable
        );
        register_gated_write_events <= register_gated_write_events + count_set_bits(
            register_gated_enable
        );
        register_reference_state_toggles <= register_reference_state_toggles + count_set_bits(
            register_write_enable & (register_reference_state ^ register_write_data)
        );
        register_gated_state_toggles <= register_gated_state_toggles + count_set_bits(
            register_gated_enable & (register_gated_state ^ register_write_data)
        );

        register_reference_state <= (
            register_reference_state & ~register_write_enable
        ) | (register_write_data & register_write_enable);
        register_gated_state <= (
            register_gated_state & ~register_gated_enable
        ) | (register_write_data & register_gated_enable);

        memory_reference_write_events <= memory_reference_write_events + count_set_bits(
            memory_write_enable
        );
        memory_gated_write_events <= memory_gated_write_events + count_set_bits(
            memory_gated_enable
        );
        memory_reference_state_toggles <= memory_reference_state_toggles + count_set_bits(
            memory_write_enable & (memory_reference_state[memory_address] ^ memory_write_data)
        );
        memory_gated_state_toggles <= memory_gated_state_toggles + count_set_bits(
            memory_gated_enable & (memory_gated_state[memory_address] ^ memory_write_data)
        );

        memory_reference_state[memory_address] <= (
            memory_reference_state[memory_address] & ~memory_write_enable
        ) | (memory_write_data & memory_write_enable);
        memory_gated_state[memory_address] <= (
            memory_gated_state[memory_address] & ~memory_gated_enable
        ) | (memory_write_data & memory_gated_enable);
    end

    task automatic apply_register_write(input logic [WIDTH-1:0] write_enable,
                                        input logic [WIDTH-1:0] write_data,
                                        input bit suppress_redundant);
        @(negedge clock);
        register_write_enable = write_enable;
        register_write_data = write_data;
        register_suppress = suppress_redundant ?
            redundant_mask(register_reference_state, write_data, write_enable) : '0;
        register_transaction_accepted = (write_enable != '0);
        register_redundant_value_reason = suppress_redundant;

        assert ((write_enable & register_suppress & (write_data ^ register_reference_state)) == '0)
        else $fatal(1, "WIDTH=%0d unsafe register suppression requested", WIDTH);

        @(posedge clock);
        #1ps;
        assert (register_gated_state == register_reference_state)
        else $fatal(1, "WIDTH=%0d gated register diverged from ungated reference", WIDTH);
        assert (register_suppressed == (write_enable & register_suppress))
        else $fatal(1, "WIDTH=%0d register suppression observation diverged", WIDTH);
        register_coverage_sample = 1'b1;
        #1ps;
        register_coverage_sample = 1'b0;
    endtask

    task automatic apply_memory_write(
        input logic [ADDRESS_WIDTH-1:0] address, input logic [WIDTH-1:0] write_enable,
        input logic [WIDTH-1:0] write_data, input bit suppress_redundant);
        @(negedge clock);
        memory_address = address;
        memory_write_enable = write_enable;
        memory_write_data = write_data;
        memory_suppress = suppress_redundant ?
            redundant_mask(memory_reference_state[address], write_data, write_enable) : '0;
        memory_transaction_accepted = (write_enable != '0);
        memory_redundant_value_reason = suppress_redundant;

        assert ((write_enable & memory_suppress &
                 (write_data ^ memory_reference_state[address])) == '0)
        else $fatal(1, "WIDTH=%0d unsafe memory suppression requested", WIDTH);

        @(posedge clock);
        #1ps;
        for (int unsigned word_index = 0; word_index < MEMORY_DEPTH; word_index++) begin
            assert (memory_gated_state[word_index] == memory_reference_state[word_index])
            else
                $fatal(
                    1,
                    "WIDTH=%0d gated memory word %0d diverged from ungated reference",
                    WIDTH,
                    word_index
                );
        end
        assert (memory_suppressed == (write_enable & memory_suppress))
        else $fatal(1, "WIDTH=%0d memory suppression observation diverged", WIDTH);
        memory_coverage_sample = 1'b1;
        #1ps;
        memory_coverage_sample = 1'b0;
    endtask

    initial begin
        logic [WIDTH-1:0] partial_data;
        logic [ADDRESS_WIDTH-1:0] random_address;

        o_done = 1'b0;
        clock = 1'b0;
        register_write_enable = '0;
        register_suppress = '0;
        register_write_data = '0;
        register_gated_state = '0;
        register_reference_state = '0;
        register_coverage_sample = 1'b0;
        register_transaction_accepted = 1'b0;
        register_redundant_value_reason = 1'b0;
        memory_write_enable = '0;
        memory_suppress = '0;
        memory_write_data = '0;
        memory_address = '0;
        memory_coverage_sample = 1'b0;
        memory_transaction_accepted = 1'b0;
        memory_redundant_value_reason = 1'b0;
        register_reference_write_events = 0;
        register_gated_write_events = 0;
        register_reference_state_toggles = 0;
        register_gated_state_toggles = 0;
        memory_reference_write_events = 0;
        memory_gated_write_events = 0;
        memory_reference_state_toggles = 0;
        memory_gated_state_toggles = 0;
        for (int unsigned word_index = 0; word_index < MEMORY_DEPTH; word_index++) begin
            memory_gated_state[word_index] = '0;
            memory_reference_state[word_index] = '0;
        end

        // Idle, ungated, fully suppressed, and partially suppressed intervals.
        apply_register_write('0, '0, 1'b1);
        apply_register_write('1, '1, 1'b0);
        apply_register_write('1, register_reference_state, 1'b1);
        partial_data = register_reference_state;
        partial_data[0] = ~partial_data[0];
        apply_register_write('1, partial_data, 1'b1);

        repeat (8) begin
            apply_register_write('1, random_vector(), 1'b0);
        end
        repeat (16) begin
            apply_register_write('1, register_reference_state, 1'b1);
        end
        repeat (32) begin
            apply_register_write(random_vector(), random_vector(), 1'b1);
        end

        register_write_enable = '0;
        register_suppress = '0;
        apply_memory_write('0, '0, '0, 1'b1);
        for (int unsigned word_index = 0; word_index < MEMORY_DEPTH; word_index++) begin
            apply_memory_write(word_index[ADDRESS_WIDTH-1:0], '1, '1, 1'b0);
            apply_memory_write(word_index[ADDRESS_WIDTH-1:0], '1,
                               memory_reference_state[word_index], 1'b1);
        end
        repeat (8) begin
            random_address = ADDRESS_WIDTH'($urandom_range(0, MEMORY_DEPTH - 1));
            apply_memory_write(random_address, '1, random_vector(), 1'b0);
        end
        repeat (16) begin
            apply_memory_write('0, '1, memory_reference_state[0], 1'b1);
        end
        repeat (32) begin
            random_address = ADDRESS_WIDTH'($urandom_range(0, MEMORY_DEPTH - 1));
            apply_memory_write(random_address, random_vector(), random_vector(), 1'b1);
        end

        assert (register_gated_write_events < register_reference_write_events)
        else $fatal(1, "WIDTH=%0d register destination activity was not reduced", WIDTH);
        assert (memory_gated_write_events < memory_reference_write_events)
        else $fatal(1, "WIDTH=%0d memory destination activity was not reduced", WIDTH);
        assert (register_gated_state_toggles == register_reference_state_toggles)
        else $fatal(1, "WIDTH=%0d register architectural toggles changed", WIDTH);
        assert (memory_gated_state_toggles == memory_reference_state_toggles)
        else $fatal(1, "WIDTH=%0d memory architectural toggles changed", WIDTH);

        $display(
            "WRITE_GATE_ACTIVITY destination=register width=%0d baseline_writes=%0d gated_writes=%0d state_toggles=%0d",
            WIDTH, register_reference_write_events, register_gated_write_events,
            register_gated_state_toggles);
        $display(
            "WRITE_GATE_ACTIVITY destination=memory width=%0d baseline_writes=%0d gated_writes=%0d state_toggles=%0d",
            WIDTH, memory_reference_write_events, memory_gated_write_events,
            memory_gated_state_toggles);

        o_done = 1'b1;
    end

endmodule
