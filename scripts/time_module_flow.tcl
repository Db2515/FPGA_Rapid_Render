# Time the different sections of compilation for a design composed
# of modules
# Args: xpr location {Number of components}

if {$argc < 1} {
	puts "The script requires a path to the project xpr file as input"
	exit
} 

set fp [open "out/module_timings.txt" a]
if {$argc == 2} {
	puts $fp "Component instances: [lindex $argv 1]"
}

open_project [lindex $argv 0]

set full_start [clock milliseconds]

# Synth Design
reset_run synth_1 
set synth_start [clock milliseconds]
launch_runs synth_1
wait_on_run synth_1
set synth_end [clock milliseconds]
set synth_time [expr $synth_end-$synth_start]
puts $fp "$synth_time Milliseconds to run synth"

open_run synth_1 -name synth_1;

# Place
place_design -unplace
set place_start [clock milliseconds]
place_design
set place_end [clock milliseconds]
set place_time [expr $place_end-$place_start]
puts $fp "$place_time Milliseconds to place"

# Route
set route_start [clock milliseconds]
route_design
set route_end [clock milliseconds]
set route_time [expr $route_end-$route_start]
puts $fp "$route_time Milliseconds to route"

# Gen Bitstream
# TODO Need constraints file first

set full_end [clock milliseconds]
set full_time [expr $full_end-$full_start]
puts $fp "$full_time Milliseconds in total"
puts $fp ""

close $fp
