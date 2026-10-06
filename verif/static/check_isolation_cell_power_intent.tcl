if {$argc != 1} {
    puts stderr "usage: check_isolation_cell_power_intent.tcl UPF"
    exit 2
}

set channel [open [lindex $argv 0] r]
set upf [read $channel]
close $channel

foreach required {
    {set_design_top isolation_cell}
    {create_power_domain PD_SOURCE}
    {create_power_domain PD_DESTINATION}
    {SOURCE_OFF off}
    {add_pst_state SOURCE_OFF}
    {set_port_attributes -ports i_isolate}
    {set_isolation ISO_SOURCE_OUTPUT}
    {-clamp_value 0}
    {-isolation_signal i_isolate}
    {-isolation_sense high}
    {-location parent}
} {
    if {[string first $required $upf] < 0} {
        error "isolation-cell UPF is missing required intent: $required"
    }
}

if {[regexp {set_retention|set_level_shifter} $upf]} {
    error "portable isolation profile must not infer retention or level shifting"
}
puts "Isolation-cell portable power intent passed"
