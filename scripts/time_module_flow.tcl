# Time the different sections of compilation for a design composed
# of modules
# Args: xpr location {Number of components}

if {$argc < 1} {
	puts "The script requires a path to the project xpr file as input"
	exit
} 

open_project [lindex $argv 0]

update_compile_order -fileset sources_1
# Synth Design
synth_design

# Place
place_design

# Route
route_design

# Gen Bitstream
# TODO Need constraints file first

close_project
