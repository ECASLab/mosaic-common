# Execute the combinational SDC against a small command model and reject clocks
# or broad timing exceptions that would hide priority-encoder interface paths.
if {$argc != 1} {
    puts stderr "usage: check_priority_encoder_constraints.tcl SDC"
    exit 2
}

set observations [dict create]

proc all_inputs {} { return "all_inputs" }
proc all_outputs {} { return "all_outputs" }
proc record_singleton {name value} {
    global observations
    if {[dict exists $observations $name]} {
        error "$name appears more than once"
    }
    dict set observations $name $value
}
proc set_max_delay {args} { record_singleton max_delay $args }
proc set_input_transition {args} { record_singleton input_transition $args }
proc set_load {args} { record_singleton output_load $args }
proc create_clock {args} { record_singleton forbidden_clock $args }
proc set_false_path {args} { record_singleton forbidden_false_path $args }
proc set_clock_groups {args} { record_singleton forbidden_clock_groups $args }

source [lindex $argv 0]

foreach {field expected} {
    max_delay {5.0 -from all_inputs -to all_outputs}
    input_transition {0.1 all_inputs}
    output_load {0.01 all_outputs}
} {
    if {![dict exists $observations $field]} {
        error "priority-encoder SDC does not define $field"
    }
    if {[dict get $observations $field] ne $expected} {
        error "priority-encoder SDC $field does not match the reviewed interface intent"
    }
}

foreach forbidden {forbidden_clock forbidden_false_path forbidden_clock_groups} {
    if {[dict exists $observations $forbidden]} {
        error "priority-encoder SDC contains forbidden clock or exception intent"
    }
}

puts "Priority-encoder combinational constraint intent passed"
