# Script to generate checkpoint, edf and metadata files for the components
# listed in the component_list file, must have made a pblock within the project prior

if {$argc != 1} {
	puts "The script requires a path to a component list file as input"
	exit
} else {
	set fileLoc [lindex $argv 0]
}

set rw_path $::env(RAPIDWRIGHT_PATH)
source "${rw_path}/tcl/rapidwright.tcl"

set components_list_fd [open $fileLoc]
set lines [split [read $components_list_fd] "\n"]
close $components_list_fd
foreach line $lines {
	set stripped [string map {" " ""} $line]
	if {![string match "#*" $stripped] && $stripped ne ""} {
		set component_info [split $stripped ";"]
		set shape_name [lindex $component_info 0]
		set project_loc [lindex $component_info 1]
		set output_dir [lindex $component_info 2]
		puts "Creating files for $shape_name component"
		open_project $project_loc
		update_compile_order -fileset sources_1
		reset_run synth_1; launch_runs synth_1; wait_on_run synth_1
		open_run synth_1 -name synth_1
		place_design -unplace; place_design	
		set_property CONTAIN_ROUTING 1 [get_pblocks pblock_1]
		route_design
		write_checkpoint -force "$output_dir/$shape_name.dcp"
		write_edif -force "$output_dir/$shape_name.edf"
		generate_metadata "$output_dir/$shape_name.dcp" false 0
		close_project
	}
}
