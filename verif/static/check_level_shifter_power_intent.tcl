if {$argc != 1} {
    puts stderr "usage: check_level_shifter_power_intent.tcl UPF"
    exit 2
}

set observations [dict create]

proc record {name args} {
    global observations
    dict lappend observations $name $args
}
proc set_design_top {args} { record design_top {*}$args }
proc create_power_domain {args} { record power_domain {*}$args }
proc create_supply_port {args} { record supply_port {*}$args }
proc create_supply_net {args} { record supply_net {*}$args }
proc connect_supply_net {args} { record supply_connection {*}$args }
proc set_domain_supply_net {args} { record domain_supply {*}$args }
proc add_port_state {args} { record port_state {*}$args }
proc create_pst {args} { record pst {*}$args }
proc add_pst_state {args} { record pst_state {*}$args }
proc set_port_attributes {args} { record port_attributes {*}$args }
proc set_level_shifter {args} { record level_shifter {*}$args }
proc set_isolation {args} { record forbidden_isolation {*}$args }
proc set_retention {args} { record forbidden_retention {*}$args }

source [lindex $argv 0]

foreach {field expected} {
    design_top {level_shifter}
    power_domain {PD_SOURCE {PD_DESTINATION -include_scope}}
    supply_port {{VDD_SOURCE -domain PD_SOURCE} {VDD_DESTINATION -domain PD_DESTINATION} VSS}
    supply_net {{VDD_SOURCE -domain PD_SOURCE} {VDD_DESTINATION -domain PD_DESTINATION} VSS}
    supply_connection {{VDD_SOURCE -ports VDD_SOURCE} {VDD_DESTINATION -ports VDD_DESTINATION} {VSS -ports VSS}}
    domain_supply {{PD_SOURCE -primary_power_net VDD_SOURCE -primary_ground_net VSS} {PD_DESTINATION -primary_power_net VDD_DESTINATION -primary_ground_net VSS}}
    port_state {{VDD_SOURCE -state {SOURCE_ON 0.8}} {VDD_DESTINATION -state {DESTINATION_ON 1.0}}}
    pst {{PST_LEVEL_SHIFTER -supplies {VDD_SOURCE VDD_DESTINATION}}}
    pst_state {{BOTH_ON -pst PST_LEVEL_SHIFTER -state {SOURCE_ON DESTINATION_ON}}}
    port_attributes {{-ports i_data -receiver_supply VDD_SOURCE} {-ports o_data -driver_supply VDD_DESTINATION}}
    level_shifter {{LS_LEVEL_SHIFTER -domain PD_DESTINATION -applies_to inputs -rule both -location self}}
} {
    if {![dict exists $observations $field]} {
        error "level-shifter UPF does not define $field"
    }
    if {[dict get $observations $field] ne $expected} {
        error "level-shifter UPF $field mismatch: observed=[dict get $observations $field] expected=$expected"
    }
}

foreach forbidden {forbidden_isolation forbidden_retention} {
    if {[dict exists $observations $forbidden]} {
        error "portable always-on level-shifter UPF contains unexpected isolation or retention"
    }
}

puts "Level-shifter portable power intent passed"
