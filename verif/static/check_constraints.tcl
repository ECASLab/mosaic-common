# Execute the committed SDC profiles against a small command model and verify
# their interface intent without requiring a technology library or STA license.
if {$argc != 4} {
  puts stderr "usage: check_constraints.tcl DEFAULT_SDC ASYNC_SDC OPENROAD_SDC DESIGN_TOP"
  exit 2
}

proc reset_observations {} {
  global observations
  set observations [dict create]
}

proc record_singleton {name value} {
  global observations
  if {[dict exists $observations $name]} {
    error "$name appears more than once"
  }
  dict set observations $name $value
}

proc get_ports {name} { return "ports:$name" }
proc get_clocks {name} { return "clocks:$name" }
proc all_inputs {} { return "all_inputs" }
proc all_outputs {} { return "all_outputs" }
proc remove_from_collection {collection removed} {
  return "$collection-minus:$removed"
}

proc create_clock {args} { record_singleton create_clock $args }
proc set_clock_uncertainty {args} { record_singleton clock_uncertainty $args }
proc set_input_delay {args} { record_singleton input_delay $args }
proc set_output_delay {args} { record_singleton output_delay $args }
proc set_false_path {args} { record_singleton false_path $args }

proc require_equal {profile field expected} {
  global observations
  if {![dict exists $observations $field]} {
    error "$profile does not define $field"
  }
  set actual [dict get $observations $field]
  if {$actual ne $expected} {
    error "$profile $field: expected '$expected', got '$actual'"
  }
}

proc check_profile {profile path} {
  global observations
  reset_observations
  source $path

  require_equal $profile create_clock \
    {-name i_clk -period 10.000 ports:i_clk}
  require_equal $profile clock_uncertainty \
    {0.100 clocks:i_clk}
  require_equal $profile input_delay \
    {0.500 -clock i_clk all_inputs-minus:ports:i_clk}
  require_equal $profile output_delay \
    {0.500 -clock i_clk all_outputs}

  if {[dict exists $observations false_path]} {
    error "$profile contains a blanket false path that can hide reset timing"
  }
}

check_profile synchronous [lindex $argv 0]
check_profile asynchronous [lindex $argv 1]
check_profile openroad_synchronous [lindex $argv 2]
puts "All [lindex $argv 3] constraint profiles passed static intent checks"
