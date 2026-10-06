if {$argc != 4} {
    puts stderr "usage: check_retention_register_constraints.tcl SYNC ASYNC OPENROAD UPF"
    exit 2
}

proc file_text {path} {
    set handle [open $path r]
    set value [read $handle]
    close $handle
    return $value
}

set sync [file_text [lindex $argv 0]]
set async [file_text [lindex $argv 1]]
set physical [file_text [lindex $argv 2]]
set upf [file_text [lindex $argv 3]]

foreach required {
    {create_clock -name i_clk -period 10.0}
    {set_input_delay 1.0 -clock i_clk}
    {set_output_delay 1.0 -clock i_clk}
} {
    if {[string first $required $sync] < 0 || [string first $required $physical] < 0} {
        error "synthesis and physical SDC do not share required timing intent: $required"
    }
}
if {[string first {set_clock_uncertainty 0.2} $sync] < 0} {
    error "synthesis SDC lacks reviewed clock uncertainty"
}
if {[string first {set_false_path -from [get_ports i_rstb]} $async] < 0} {
    error "asynchronous reset false path is missing"
}
foreach required {VDD_MAIN VDD_RETENTION BOTH_ON RETAINED ALL_OFF set_retention i_save i_restore} {
    if {[string first $required $upf] < 0} {
        error "UPF lacks required retention intent: $required"
    }
}
puts "Retention-register SDC and UPF intent passed"
