/// Samples every scalar control-state transition independently of DUT timing.
module write_gate_transition_coverage (
    input logic i_sample,
    input logic i_write_enable,
    input logic i_suppress
);

    logic previous_valid;
    logic [1:0] previous_control;
    logic [1:0] current_control;

    assign current_control = {i_write_enable, i_suppress};

    initial begin
        previous_valid   = 1'b0;
        previous_control = 2'b00;
    end

    always @(posedge i_sample) begin
        if (previous_valid) begin
            transition_00_00 : cover (previous_control == 2'b00 && current_control == 2'b00);
            transition_00_01 : cover (previous_control == 2'b00 && current_control == 2'b01);
            transition_00_10 : cover (previous_control == 2'b00 && current_control == 2'b10);
            transition_00_11 : cover (previous_control == 2'b00 && current_control == 2'b11);
            transition_01_00 : cover (previous_control == 2'b01 && current_control == 2'b00);
            transition_01_01 : cover (previous_control == 2'b01 && current_control == 2'b01);
            transition_01_10 : cover (previous_control == 2'b01 && current_control == 2'b10);
            transition_01_11 : cover (previous_control == 2'b01 && current_control == 2'b11);
            transition_10_00 : cover (previous_control == 2'b10 && current_control == 2'b00);
            transition_10_01 : cover (previous_control == 2'b10 && current_control == 2'b01);
            transition_10_10 : cover (previous_control == 2'b10 && current_control == 2'b10);
            transition_10_11 : cover (previous_control == 2'b10 && current_control == 2'b11);
            transition_11_00 : cover (previous_control == 2'b11 && current_control == 2'b00);
            transition_11_01 : cover (previous_control == 2'b11 && current_control == 2'b01);
            transition_11_10 : cover (previous_control == 2'b11 && current_control == 2'b10);
            transition_11_11 : cover (previous_control == 2'b11 && current_control == 2'b11);
        end
        previous_control = current_control;
        previous_valid   = 1'b1;
    end

endmodule
